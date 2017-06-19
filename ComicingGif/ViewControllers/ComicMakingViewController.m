//
//  ComicMakingViewController.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicMakingViewController.h"
#import "ComicMakingViewModel.h"
#import "./../Objects/ObjectHeader.h"
#import "./../CustomizedUI/ComicObjectView.h"

#import <Messages/Messages.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ComicItem.h"
#import "ComicObjectSerialize.h"
#import "CBComicPreviewVC.h"
#import "UIView+CBConstraints.h"
#import "ScrollBarSlider.h"
#import <ImageIO/ImageIO.h>
#import "TimerImageViewStruct.h"

#define TOOLCELLID	@"ToolCollectionViewCell"
#define CATEGORYCELLID	@"CategoryCollectionViewCell"

#define DRAWING_DEFAULT_BRUSH 5
#define DRAWING_BIG_BRUSH 10
#define DRAWING_DEFAULT_COLOR [UIColor whiteColor]

#define discreteValueOfSeconds 0.01

#define enhancementsBaseTag 9090

#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)

@interface ComicMakingViewController () <ZoomTransitionProtocol, ScrollBarSliderDelegate>
{
	ComicMakingViewModel *viewModel;
	
	ComicObjectView *backgroundView;
	
	UICollectionView *collectionCategoryView;
	UICollectionView *collectionToolView;
	NSInteger nCategory;
    
    // Drawing properties
    BOOL _isDrawing; // Flag to determine if pen drawing is enable right now
    UIColor *_drawingColor; // Color which user has chosen for pen drawing.
    CGPoint _lastPoint; // last point of drawing based on user touch events
    CGFloat _brush; // Brush size for drawing pen
    BOOL _mouseSwiped;
    
    // Keyboard appearance status property
    BOOL _isKeyboardVisible;

    NSTimer *scrollBarTimer;
    NSInteger discreteCount;
    CGFloat maxSeconds;
    NSInteger enhancementsBaseTagCount;
    
    NSTimer *autoScrollSliderTimer;
    CGFloat autoScrollSliderDeltaValue;
    
    BOOL haveAddedIconsOnce;
}

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

@property (weak, nonatomic) IBOutlet UIButton *btnToolAnimateGIF;
@property (weak, nonatomic) IBOutlet UIButton *btnToolBubble;
@property (weak, nonatomic) IBOutlet UIButton *btnToolSticker;
@property (weak, nonatomic) IBOutlet UIImageView *buttonToolStickerImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnToolText;
@property (weak, nonatomic) IBOutlet UIImageView *buttonToolTextImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnToolPen;
@property (weak, nonatomic) IBOutlet UIImageView *drawingImageView;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (strong, nonatomic) IBOutlet UIView *baseLayerView;
@property (assign, nonatomic) CGFloat ratioDecreasing;
@property (assign, nonatomic) CGRect baseLayerInitialFrame;
@property (weak, nonatomic) IBOutlet UIImageView *buttonBookViewImageView;
@property (weak, nonatomic) IBOutlet UIImageView *buttonPlayPauseViewImageView;
@property (weak, nonatomic) IBOutlet UIImageView *buttonCloseImageView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonPenUndo;
@property (weak, nonatomic) IBOutlet UIButton *bookViewButton;
@property (weak, nonatomic) IBOutlet UIView *penUndoView;
@property (weak, nonatomic) IBOutlet UIImageView *penUndoImageView;
@property (weak, nonatomic) IBOutlet UIStackView *penColorStackView;
@property (weak, nonatomic) IBOutlet UIImageView *penToolImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderContainerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *sliderContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderBlackViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *sliderBlackView;
@property (weak, nonatomic) IBOutlet ScrollBarSlider *scrollBarSlider;
@property (strong, nonatomic) NSMutableArray<TimerImageViewStruct *> *timerImageViews;
@property (strong, nonatomic) NSMutableArray *scrollBarIconViews;

/**
 Use this mutable array to store all drawings made during active drawing mode. Each drawing has its own ImageView this will enable undo function for drawing because we can just remove last ImageView from this array
 */
@property (nonatomic) NSMutableArray<UIImageView *> *drawingImageViewStackArray;

/**
 drawingCoordinateArray stores all coordinate made during active drawing mode. We need this to use those coordinates in saving system and save coordinates (with selected color and brush size) into slides.plist file. So based on this data we can restore all drawings later
 */
@property (nonatomic) NSMutableArray<NSMutableArray<NSValue *> *> *drawingCoordinateArray;

/**
 drawingBrushSizeArray stores all brush size values made during active drawing mode. We need to use those values in saving process. (saving into slides.plist)
 */
@property (nonatomic) NSMutableArray<NSNumber *> *drawingBrushSizeArray;

/**
 drawingColorArray stores all selected colors values made during active drawing mode. We need to use those values in saving process. (saving into slides.plist)
 */
@property (nonatomic) NSMutableArray<UIColor *> *drawingColorArray;

@property (assign, nonatomic) BOOL isTall;

@end



// MARK: -

@implementation ComicMakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	nCategory = 1;

    _ratioDecreasing = 1;
    _baseLayerView.clipsToBounds = YES;
    
    // Set default drawing values.
    _isDrawing = NO;
    _brush = DRAWING_DEFAULT_BRUSH;
    _drawingColor = DRAWING_DEFAULT_COLOR;
    // Initi drawing helpers arrays and color stack view
    _drawingImageViewStackArray = [NSMutableArray new];
    _drawingCoordinateArray = [NSMutableArray new];
    _drawingBrushSizeArray = [NSMutableArray new];
    _drawingColorArray = [NSMutableArray new];
    [self setupPenColorsContainerView];
    
    _isKeyboardVisible = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowWithNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHideWithNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}
#pragma mark - Slider methods
- (UIImage *)getSliderPlayOrPauseButtonWithImageName:(NSString *)imageName
{
    CGSize sliderSize = self.scrollBarSlider.frame.size;
    CGSize newSize = CGSizeMake(sliderSize.height, sliderSize.height);
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)initialiseScrollBar {
    self.scrollBarSlider.scrollBarSliderDelegate = self;
    
    if (!self.scrollBarIconViews) {
        self.scrollBarIconViews = [NSMutableArray array];
    }
    
    if (!self.timerImageViews) {
        self.timerImageViews = [NSMutableArray array];
    }
    [self refreshStateOfEnhancementsWithSlideValue:0];
}

//ScrollBarSlider delegate method
- (void)refreshSliderStateWithCurrentSelectionState {
    if (self.scrollBarSlider.selected) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)play {
    scrollBarTimer = [NSTimer scheduledTimerWithTimeInterval:discreteValueOfSeconds target:self selector:@selector(scrollBarTimer:) userInfo:nil repeats:YES];
}

- (void)pause {
//    [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    [self stopTimer];
    for (TimerImageViewStruct *timerImageView in self.timerImageViews) {
        [timerImageView.imageView stopAnimating];
        [self setImageOnTimerImageView:timerImageView withCurrentSliderValue:self.scrollBarSlider.value];
    }
}

- (void)scrollBarTimer:(NSTimer *)timer {
    self.scrollBarSlider.value = discreteCount*(discreteValueOfSeconds);
//    self.currentTimeLabel.text = [NSString stringWithFormat:@"%.2f",self.scrollBarSlider.value];
    [self refreshStateOfEnhancementsWithSlideValue:self.scrollBarSlider.value];
    
//    backgroundView.currentTimerValue = self.scrollBarSlider.value;
    
    discreteCount++;
    if (self.scrollBarSlider.value >= maxSeconds) {
        [self pause];
//        self.playPauseButton.selected = !self.playPauseButton.selected;
    }
}

- (void)refreshStateOfEnhancementsWithSlideValue:(CGFloat)value {
    for (TimerImageViewStruct *timerImageView in self.timerImageViews) {
        [timerImageView.imageView stopAnimating]; // stopanimation is added because the gifs shouldnt play at 0 slider value
        [self refreshStateOfTimerImageView:timerImageView withSliderValue:value];
    }
}

- (void)stopTimer {
    [scrollBarTimer invalidate];
    scrollBarTimer = nil;
}

- (IBAction)slideChanged:(UISlider *)slider {
    NSLog(@"Slider value actual: %f",slider.value);
    slider.value = ((NSInteger)(slider.value / discreteValueOfSeconds)) * discreteValueOfSeconds;
    NSLog(@"Slider value: %f",slider.value);
    discreteCount = slider.value / discreteValueOfSeconds;
    
//    backgroundView.currentTimerValue = slider.value;
    
    [self setFrameOfGifsToPercentOfFrameToShow:(slider.value/slider.maximumValue)];
//    self.currentTimeLabel.text = [NSString stringWithFormat:@"%.2f",self.scrollBarSlider.value];
}

- (void)setFrameOfGifsToPercentOfFrameToShow:(float)percent {
    
    NSLog(@"%ld",(long)percent);
    for (TimerImageViewStruct *timerImageView in self.timerImageViews) {
        [timerImageView.imageView stopAnimating];
        NSLog(@"Images count: %lu", timerImageView.imageView.animationImages.count);
        
        [self setImageOnTimerImageView:timerImageView withCurrentSliderValue:self.scrollBarSlider.value];
        
    }
}

- (UIImageView *)createImageViewWith:(NSData *)data frame:(CGRect)rect bAnimate:(BOOL)flag {
    CGImageSourceRef srcImage = CGImageSourceCreateWithData(toCF data, nil);
    if (!srcImage) {
        NSLog(@"loading image failed");
    }
    
    size_t imgCount = CGImageSourceGetCount(srcImage);
    NSTimeInterval totalDuration = 0;
    NSNumber *frameDuration;
    NSMutableArray *arrayImages;
    
    arrayImages = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < imgCount; i ++) {
        CGImageRef cgImg = CGImageSourceCreateImageAtIndex(srcImage, i, nil);
        if (!cgImg) {
            NSLog(@"loading %ldth image failed from the source", (long)i);
            continue;
        }
        
        UIImage *img = [self scaledImage:[UIImage imageWithCGImage:cgImg] size:rect.size];
        [arrayImages addObject:img];
        
        NSDictionary *property = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(srcImage, i, nil));
        NSDictionary *gifDict = property[fromCF kCGImagePropertyGIFDictionary];
        
        frameDuration = gifDict[fromCF kCGImagePropertyGIFUnclampedDelayTime];
        if (!frameDuration) {
            frameDuration = gifDict[fromCF kCGImagePropertyGIFDelayTime];
        }
        
        totalDuration += frameDuration.floatValue;
        
        CGImageRelease(cgImg);
    }
    
    CFRelease(srcImage);
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = arrayImages.firstObject;
    imgView.autoresizingMask = 0B11111;
    imgView.userInteractionEnabled = YES;
    
    imgView.animationImages = arrayImages;
    imgView.animationDuration = totalDuration;
    imgView.animationRepeatCount = (flag == YES? 0 : 1);
    //    [imgView startAnimating];
    
    return imgView;
    
}

- (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setImageOnTimerImageView:(TimerImageViewStruct *)timerImageView withCurrentSliderValue:(CGFloat)currentSliderValue {
    timerImageView.imageView.hidden = currentSliderValue < timerImageView.delayTimeOfImageView;
    
    if (timerImageView.imageView.animationImages.count > 1) { // This will only execute for GIFs not images
        if (timerImageView.imageView.hidden && timerImageView.imageView.isAnimating) {
            [timerImageView.imageView stopAnimating];
            return;
        }
        if (timerImageView.imageView.hidden) {
            return;
        }
        CGFloat modifiedActionValue = currentSliderValue - timerImageView.delayTimeOfImageView;
        if (modifiedActionValue < 0) {
            modifiedActionValue = 0;
        }
        CGFloat fullLoopsTotalDuration = timerImageView.imageView.animationDuration * ((NSInteger)((modifiedActionValue)/timerImageView.imageView.animationDuration));
        NSInteger actualPercent = (NSInteger)(((modifiedActionValue - fullLoopsTotalDuration) / timerImageView.imageView.animationDuration) * 100);
        NSLog(@"...Actual percent: %lu,,,,,hidden: %d", actualPercent, timerImageView.imageView.hidden);
        timerImageView.imageView.image = [timerImageView.imageView.animationImages objectAtIndex:((NSInteger)[timerImageView.imageView.animationImages count] * actualPercent/100)];
    }
}

- (void)refreshStateOfTimerImageView:(TimerImageViewStruct *)timerImageView withSliderValue:(CGFloat)currentSliderValue {
    timerImageView.imageView.hidden = currentSliderValue < timerImageView.delayTimeOfImageView;
    
    if (timerImageView.imageView.animationImages.count > 1) { // This will executed only for GIFs not images
        if (timerImageView.imageView.hidden && timerImageView.imageView.isAnimating) {
            [timerImageView.imageView stopAnimating];
        } else {
            [self setImageOnTimerImageView:timerImageView withCurrentSliderValue:currentSliderValue];
        }
    }
}

- (UIView *)getScrollBarIconWithTag:(NSInteger)iconTag {
    UIButton *iconButton = [[self.scrollBarSlider superview]viewWithTag:iconTag];
    return iconButton;
}

#pragma mark -

- (void)setAlpha:(BOOL)alpha {
    self.btnToolAnimateGIF.alpha = self.btnToolBubble.alpha = self.btnToolSticker.alpha = self.btnToolText.alpha = self.btnToolPen.alpha = alpha;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isKeyboardVisible) {
        [self.view endEditing:YES];
        return;
    }
    if (!_isDrawing) {
        UIView *touchView = [touches anyObject].view;
        if ([touchView.superview.superview isEqual:self.baseLayerView]) {
            _ratioDecreasing = 1;
            [self.baseLayerView saveFrameOfAllSubviewsWithTreeCount:1];
        }
        return;
    }

    _mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    _lastPoint = [touch locationInView:self.view];
    
    if (!_drawingImageViewStackArray) {
        // Return if ImageView stack is invalid
        return;
    }
    // Create new imageView for new drawing object
    UIImageView *drawingImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_drawingImageViewStackArray addObject:drawingImageView];
    [self.view addSubview:drawingImageView];
    
    if (!_drawingCoordinateArray) {
        // Return if coordinate array is invalid
        return;
    }
    NSMutableArray<NSValue *> *coordinatesArray = [NSMutableArray new];
    [coordinatesArray addObject:[NSValue valueWithCGPoint:_lastPoint]];
    [_drawingCoordinateArray addObject:coordinatesArray];
    
    if (!_drawingColorArray || !_drawingBrushSizeArray) {
        return;
    }
    // Add selected color and brush size to appropriate arrays
    [_drawingColorArray addObject:_drawingColor];
    [_drawingBrushSizeArray addObject:@(_brush)];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_isDrawing) {
        UIView *touchView = [touches anyObject].view;
        if ([touchView.superview.superview isEqual:self.baseLayerView]) {
            if (_ratioDecreasing >= 0.6) {
                _ratioDecreasing -= 0.01;
                
                NSLog(@"............RATIO DECREASING: %f",_ratioDecreasing);
                CGFloat newWidth = _baseLayerInitialFrame.size.width * _ratioDecreasing;
                CGFloat newHeight = _baseLayerInitialFrame.size.height * _ratioDecreasing;
                
                _baseLayerView.frame = CGRectMake(_baseLayerInitialFrame.origin.x, _baseLayerInitialFrame.origin.y, newWidth, newHeight);
                _baseLayerView.center = self.view.center;
                NSLog(@"............RESULTANT FRAME: %@",NSStringFromCGRect(_baseLayerView.frame));
                [self.baseLayerView setSubViewWithWithDimensionAsPerRatio:_ratioDecreasing treeCount:1];
            }
        }
        return;
    }
    // if imageView stack is empty – return from drawing
    if (_drawingImageViewStackArray.count == 0) {
        return;
    }
    // Get last added imageView to draw on
    UIImageView *currentDrawingImageView = [_drawingImageViewStackArray lastObject];
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [_drawingColor getRed:&red green:&green blue:&blue alpha:&alpha];
    _mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:currentDrawingImageView];
    // if coordinates array is empty – return from drawing
    if (_drawingCoordinateArray.count == 0) {
        return;
    }
    // Get last coordinates array to add new currentPoint
    NSMutableArray<NSValue *> *currentCoordinatesArray = [_drawingCoordinateArray lastObject];
    [currentCoordinatesArray addObject:[NSValue valueWithCGPoint:currentPoint]];
    [_drawingCoordinateArray removeLastObject];
    [_drawingCoordinateArray addObject:currentCoordinatesArray];
    
    UIGraphicsBeginImageContext(currentDrawingImageView.frame.size);
    [currentDrawingImageView.image drawInRect:CGRectMake(0, 0,
                                                         currentDrawingImageView.frame.size.width,
                                                         currentDrawingImageView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    currentDrawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [currentDrawingImageView setAlpha:1.0];
    UIGraphicsEndImageContext();
    _lastPoint = currentPoint;
    [_drawingImageViewStackArray removeLastObject];
    [_drawingImageViewStackArray addObject:currentDrawingImageView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_isDrawing) {
        UIView *touchView = [touches anyObject].view;
        if ([touchView.superview.superview isEqual:self.baseLayerView]) {
            if (_ratioDecreasing >= 0.7){
                [self.baseLayerView restoreSavedRect];
                [self.baseLayerView restoreFrameOfAllSubviews];
                [UIView animateWithDuration:0.1 + 0.2*(1-_ratioDecreasing) animations:^{
                    [self.view setNeedsLayout];
                    [self.view layoutIfNeeded];
                }];
            } else {
                //Save
                [self btnNextTapped:nil];
            }
        }
        return;
    }
    
    // if imageView stack is empty – return from drawing
    if (_drawingImageViewStackArray.count == 0) {
        return;
    }
    // Get last added imageView to draw on
    UIImageView *currentDrawingImageView = [_drawingImageViewStackArray lastObject];
    if(!_mouseSwiped) {
        // if coordinates array is empty – return from drawing
        if (_drawingCoordinateArray.count == 0) {
            return;
        }
        // Get last coordinates array to add new currentPoint
        NSMutableArray<NSValue *> *currentCoordinatesArray = [_drawingCoordinateArray lastObject];
        [currentCoordinatesArray addObject:[NSValue valueWithCGPoint:_lastPoint]];
        [_drawingCoordinateArray removeLastObject];
        [_drawingCoordinateArray addObject:currentCoordinatesArray];
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [_drawingColor getRed:&red green:&green blue:&blue alpha:&alpha];
        UIGraphicsBeginImageContext(currentDrawingImageView.frame.size);
        [currentDrawingImageView.image drawInRect:CGRectMake(0, 0,
                                                             currentDrawingImageView.frame.size.width,
                                                             currentDrawingImageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        currentDrawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(currentDrawingImageView.frame.size);
    [currentDrawingImageView.image drawInRect:CGRectMake(0, 0,
                                                         currentDrawingImageView.frame.size.width,
                                                         currentDrawingImageView.frame.size.height)
                                    blendMode:kCGBlendModeNormal
                                        alpha:1.0];
    currentDrawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_drawingImageViewStackArray removeLastObject];
    [_drawingImageViewStackArray addObject:currentDrawingImageView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self createComicViews];
	
	if ([viewModel isContainedAnimatedSticker] == true) {
		self.btnPlay.hidden = false;
	} else {
		self.btnPlay.hidden = true;
	}
    
    if ([self.timerImageViews firstObject].imageView.animationImages.count != 1) {
        [self initialiseScrollBar];
        
        [self.scrollBarSlider setMinimumTrackImage:[self.scrollBarSlider getSliderBackView] forState:UIControlStateNormal];
        [self.scrollBarSlider setMaximumTrackImage:[self.scrollBarSlider getSliderBackView] forState:UIControlStateNormal];
        
        [self.scrollBarSlider setThumbImage:[self getSliderPlayOrPauseButtonWithImageName:@"play"] forState:UIControlStateNormal];
        [self.scrollBarSlider setThumbImage:[self getSliderPlayOrPauseButtonWithImageName:@"pause"] forState:UIControlStateSelected];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self.scrollBarSlider action:@selector(sliderTapGesture:)];
        [self.scrollBarSlider addGestureRecognizer:tapGesture];
    } else {
        self.sliderContainerViewBottomConstraint.constant = -self.sliderContainerView.frame.size.height;
        self.sliderBlackViewBottomConstraint.constant = -self.sliderBlackView.frame.size.height;
        self.sliderContainerView.hidden = self.sliderBlackView.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _baseLayerInitialFrame = _baseLayerView.frame;
    
    [self setAlpha:NO];
    [UIView animateWithDuration:0.2f animations:^{
        [self setAlpha:YES];
    }];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Add icons after slider layout-------
    if (!haveAddedIconsOnce) {
        haveAddedIconsOnce = !haveAddedIconsOnce;
        NSArray *noBaseLayerComicObjectViews = [backgroundView subviews];
        if (noBaseLayerComicObjectViews.count >= 1) {
            //By removing first object base layer fix the issue where the icon for base layer appears at start always
            for (int i = 1; i < noBaseLayerComicObjectViews.count; i++) {
                ComicObjectView *comicObjectView = noBaseLayerComicObjectViews[i];
                [self addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:comicObjectView.tag andBaseObjectType:comicObjectView.comicObject.objType andSliderValue:comicObjectView.delayTimeInSeconds];
            }
        }
    }
    //>> Add icons after slider layout------
}

- (UIView *)viewForZoomTransition:(BOOL)isSource {
    return self.baseLayerView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)setupPenColorsContainerView {
    for (int i = 0; i < _penColorStackView.arrangedSubviews.count; i++) {
        UITapGestureRecognizer *colorPinTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                       action:@selector(handleColorPinGestureTap:)];
        [_penColorStackView.arrangedSubviews[i] addGestureRecognizer:colorPinTapGestureRecognizer];
    }
    // Change alpha to 0 to hide color stack view because appearance animation based on alpha value of color stack view.
    [_penColorStackView setHidden:NO];
    _penColorStackView.alpha = 0.0;
}

- (void)changePenToolImageWithColor:(UIColor *)color {
    _penToolImageView.image = [_penToolImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_penToolImageView setTintColor:color];
}

// MARK: - public initialize methods

- (void)initWithBaseImage:(NSURL *)url frame:(CGRect)rect andSubviewArray:(NSMutableArray *)arrSubviews isTall:(BOOL)isTall index:(NSInteger)index {
	BkImageObject *obj = [[BkImageObject alloc] initWithURL:url isTall:isTall];
	obj.frame = rect;
    obj.isTall = isTall;
    self.isTall = isTall;
	
	if (!viewModel) {
		viewModel = [[ComicMakingViewModel alloc] init];
	}
	[viewModel.arrayObjects removeAllObjects];
	
	[viewModel addObject:obj];
	
	if (arrSubviews != nil) {
		for (NSDictionary *subObj in arrSubviews) {
			BaseObject *obj = [[BaseObject alloc] initFromDict:subObj];
			[viewModel.arrayObjects addObject:obj];
		}
	}
	
	[ComicObjectSerialize setSavedIndex:index];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// MARK: - button action implementations
- (IBAction)btnPlayTapped:(id)sender {
	[backgroundView playAnimate];
	
	for (UIView *view in backgroundView.subviews) {
		if (view.class == ComicObjectView.class) {
			[((ComicObjectView *)view) playAnimate];
		}
	}
}


- (IBAction)btnToolAnimateGifTapped:(id)sender {
	UIView *toolView = [self createToolView:ObjectAnimateGIF];
	toolView.frame = CGRectOffset(toolView.frame, self.baseLayerView.frame.size.width, 0);
	toolView.alpha = 0.0;
	[self.baseLayerView addSubview:toolView];
	
	[UIView animateWithDuration:0.5 animations:^{
		[self setToolButtonAlpah:0.0];
		
		toolView.frame = CGRectOffset(toolView.frame, -self.baseLayerView.frame.size.width, 0);
		toolView.alpha = 1.0;
		
	} completion:^(BOOL finished) {

	}];
}


- (IBAction)btnToolBubbleTapped:(id)sender {
    BubbleObject *bubbleObject = [[BubbleObject alloc] initWithText:@""
                                                           bubbleID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 1]
                                                      withDirection:BubbleDirectionUpperLeft];
    [bubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 0]
                   forDirection:BubbleDirectionBottomRight];
    [bubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 2]
                   forDirection:BubbleDirectionUpperRight];
    [bubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 3]
                   forDirection:BubbleDirectionBottomLeft];
    
    [bubbleObject changeBubbleTypeTo:BubbleTypeStar];
    
    [viewModel addObject:bubbleObject];
    
    ComicObjectView *bubbleComicObjectView = [[ComicObjectView alloc] initWithComicObject:bubbleObject];
    bubbleComicObjectView.parentView = backgroundView;
    bubbleComicObjectView.delegate = self;
    
    [backgroundView addSubview:bubbleComicObjectView];
    
    [viewModel saveObject];
}


- (IBAction)btnToolStickerTapped:(id)sender {
	UIView *toolView = [self createToolView:ObjectSticker];
	toolView.frame = CGRectOffset(toolView.frame, self.baseLayerView.frame.size.width, 0);
	toolView.alpha = 0.0;
	[self.baseLayerView addSubview:toolView];
	
	[UIView animateWithDuration:0.5 animations:^{
		[self setToolButtonAlpah:0.0];
		
		toolView.frame = CGRectOffset(toolView.frame, -self.baseLayerView.frame.size.width, 0);
		toolView.alpha = 1.0;
		
	} completion:^(BOOL finished) {

	}];
}


- (IBAction)btnToolTextTapped:(id)sender {
}

- (IBAction)buttonPenUndoTapped:(id)sender {
    if (!_isDrawing) {
        return;
    }
    if (_drawingImageViewStackArray.count == 0) {
        return;
    }
    UIImageView *lastDrawingImageView = [_drawingImageViewStackArray lastObject];
    [lastDrawingImageView removeFromSuperview];
    [_drawingImageViewStackArray removeLastObject];
    if (_drawingColorArray.count == 0 ||
        _drawingCoordinateArray.count == 0 ||
        _drawingBrushSizeArray.count == 0) {
        return;
    }
    [_drawingColorArray removeLastObject];
    [_drawingCoordinateArray removeLastObject];
    [_drawingBrushSizeArray removeLastObject];
}

- (IBAction)btnToolPenTapped:(id)sender {
    // Swift drawing mode status
    _isDrawing = !_isDrawing;

    // Hide unneded elements if drawing mode is active
    for(UIView *viewToHide in @[_btnToolAnimateGIF, _btnToolBubble, _btnToolSticker,
                                _btnToolText, _buttonPlayPauseViewImageView, _buttonCloseImageView,
                                _playPauseButton, _buttonToolStickerImageView,
                                _buttonToolTextImageView, _btnClose]) {
        [viewToHide setHidden:_isDrawing];
    }
    
    // Show needed elements in drawing mode
    [_penUndoView setHidden:!_isDrawing];
    [_penUndoImageView setHidden:!_isDrawing];
    
    [UIView animateWithDuration:0.15 animations:^{
        _penColorStackView.alpha = _penColorStackView.alpha == 1.0 ? 0.0 : 1.0;
    }];
    
    // Change pen tool icon color back to white
    [self changePenToolImageWithColor:[UIColor whiteColor]];
    
    // If drawing mode is no longer active – save all drawing from all ImageViews from stack onto single image layer
    if (!_isDrawing) {
        if (!_drawingImageViewStackArray || _drawingImageViewStackArray.count == 0) {
            return;
        }
        UIGraphicsBeginImageContext(self.view.frame.size);
        if (_drawingImageView.image) {
            [_drawingImageView.image drawInRect:CGRectMake(0, 0,
                                                           _drawingImageView.frame.size.width,
                                                           _drawingImageView.frame.size.height)
                                      blendMode:kCGBlendModeNormal
                                          alpha:1.0];
        }
        for (UIImageView *drawingImageView in _drawingImageViewStackArray) {
            [drawingImageView.image drawInRect:CGRectMake(0, 0,
                                                          drawingImageView.frame.size.width,
                                                          drawingImageView.frame.size.height)
                                     blendMode:kCGBlendModeNormal
                                         alpha:1.0];
            [drawingImageView removeFromSuperview];
        }
        _drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_drawingImageViewStackArray removeAllObjects];
        
        if (_drawingCoordinateArray.count != _drawingColorArray.count ||
            _drawingCoordinateArray.count != _drawingBrushSizeArray.count) {
            return;
        }
        CGRect drawingFrame = CGRectMake(0, 0,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
        for (int i = 0; i < _drawingCoordinateArray.count; i++) {
            NSMutableArray<NSValue *> *signleDrawingCoordinates = _drawingCoordinateArray[i];
            UIColor *selectedColor = _drawingColorArray[i];
            CGFloat selectedBrushSize = [_drawingBrushSizeArray[i] floatValue];
            // Create new PenObject to save it into slides.plist file in the file system
            PenObject *penObject = [[PenObject alloc] initWithDrawingCoordintaes:signleDrawingCoordinates
                                                                  selectedColor:selectedColor
                                                                       brushSize:selectedBrushSize
                                                                        andFrame:drawingFrame];
            // Add new PenObject to viewModel objects array
            [viewModel addObject:penObject];
        }
        // Save all objects into the slides.plist file
        [viewModel saveObject];
        
        // Clear all coordinates, brush sizes and selected colors because drawing is no longer active.
        [_drawingCoordinateArray removeAllObjects];
        [_drawingBrushSizeArray removeAllObjects];
        [_drawingColorArray removeAllObjects];
    }
}


- (IBAction)btnNextTapped:(id)sender {
	[viewModel saveObject];
	
	// for testing
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slides.plist"];
//	
//	if([MFMailComposeViewController canSendMail]) {
//		MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
//		mailCont.mailComposeDelegate = self;
//		
//		[mailCont setSubject:@"created GIF"];
//		[mailCont setMessageBody:@"Please take a look attached GIF file." isHTML:NO];
//		
//		NSData *data = [NSData dataWithContentsOfFile:filePath];
//		[mailCont addAttachmentData:data mimeType:@"plist" fileName:@"slides.plist"];
//		
//		[self presentViewController:mailCont animated:YES completion:nil];
//	}
    
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[CBComicPreviewVC class]]) {
        CBComicPreviewVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CBComicPreviewVC"];
        vc.shouldntRefreshAfterDidLayoutSubviews = YES;
        vc.shouldFetchAndReload = NO;
        NSMutableArray *controllers = [[NSArray arrayWithObject:vc] mutableCopy];
        [controllers addObjectsFromArray:self.navigationController.viewControllers];
        [self.navigationController setViewControllers:controllers];
        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CBComicPreviewVC *vc = [self.navigationController.viewControllers firstObject];
        vc.shouldntRefreshAfterDidLayoutSubviews = _indexSaved == -1? NO:YES;
        vc.indexForSlideToRefresh = _indexSaved;
        [vc refreshSlideAtIndex:_indexSaved isTall:self.isTall completionBlock:^(BOOL isComplete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
        
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        self.btnToolAnimateGIF.alpha = 0;
        self.btnToolBubble.alpha = 0;
        self.btnToolSticker.alpha = 0;
        self.btnToolText.alpha = 0;
        self.btnToolPen.alpha = 0;
    }];
}


- (IBAction)btnToolCloseTapped:(id)sender {
//    if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[CBComicPreviewVC class]]) {
//        CBComicPreviewVC *vc = [self.navigationController.viewControllers firstObject];
//        vc.shouldntRefreshAfterDidLayoutSubviews = NO;
//    }
	[self.navigationController popViewControllerAnimated:YES];
}


// MARK: - gesture handler
- (void)tapGestureHandlerForToolContainerView:(UITapGestureRecognizer *)gesture {
	[UIView animateWithDuration:0.5 animations:^{
		if (gesture.view.tag == ObjectAnimateGIF) {
			gesture.view.frame = CGRectOffset(gesture.view.frame, self.baseLayerView.frame.size.width, 0);
			gesture.view.alpha = 0.0;
			
		} else if (gesture.view.tag == ObjectSticker) {
			gesture.view.frame = CGRectOffset(gesture.view.frame, self.baseLayerView.frame.size.width, 0);
			gesture.view.alpha = 0.0;
			
		} else if (gesture.view.tag == ObjectBubble) {
			
		} else if (gesture.view.tag == ObjectCaption) {
			
		} else if (gesture.view.tag == ObjectPen) {
			
		}
		
		[self setToolButtonAlpah:1.0];
		
	} completion:^(BOOL finished) {
		[gesture.view removeFromSuperview];
		
	}];
}

- (void)handleColorPinGestureTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (!_isDrawing) {
        return;
    }
    
    UIView *currentView = gestureRecognizer.view;
    CGFloat defaultViewWidth = 15;
    CGAffineTransform scaleTransformation = CGAffineTransformMakeScale(1, 1);
    
    if (CGColorEqualToColor(_drawingColor.CGColor, currentView.backgroundColor.CGColor)
                                    && currentView.frame.size.width == defaultViewWidth) {
        scaleTransformation = CGAffineTransformMakeScale(2, 2);
        _brush = DRAWING_BIG_BRUSH;
    } else if (CGColorEqualToColor(_drawingColor.CGColor, currentView.backgroundColor.CGColor)
                                            && currentView.frame.size.width > defaultViewWidth) {
        _brush = DRAWING_DEFAULT_BRUSH;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        gestureRecognizer.view.transform = scaleTransformation;
    }];
    
    // Reset transformation for all other unselected color pins. Just like radio button should work.
    if (!CGColorEqualToColor(_drawingColor.CGColor, currentView.backgroundColor.CGColor)) {
        _brush = DRAWING_DEFAULT_BRUSH;
        for (int i = 0; i < _penColorStackView.arrangedSubviews.count; i++) {
            if (_penColorStackView.arrangedSubviews[i].frame.size.width == defaultViewWidth) {
                // We don't need to scale down already scaled element. So we just continue in that case.
                continue;
            }
            [UIView animateWithDuration:0.1 animations:^{
                _penColorStackView.arrangedSubviews[i].transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
    }
    // Change selected drawing color based on background color of the color pin view
    _drawingColor = gestureRecognizer.view.backgroundColor;
    
    // Change color of the pen icon based on selected color
    [self changePenToolImageWithColor:_drawingColor];
}

// MARK: - notification handlers

- (void)keyboardDidShowWithNotification:(NSNotification *)notification {
    _isKeyboardVisible = YES;
}

- (void)keyboardDidHideWithNotification:(NSNotification *)notification {
    _isKeyboardVisible = NO;
}

// MARK: - private methods
- (BaseObject *)createComicObject:(ComicObjectType)type index:(NSInteger)index category:(NSInteger)category delayTimeInSeconds:(CGFloat)delayTime {
	BaseObject *obj;
	NSString *rcID;
	
	if (type == ObjectSticker) {
		rcID = [NSString stringWithFormat:@"theme_sticker%ld_%ld.png", (long)category, (long)index];
		obj = [BaseObject comicObjectWith:ObjectSticker userInfo:rcID];
		
	} else if (type == ObjectAnimateGIF) {
		rcID = [NSString stringWithFormat:@"theme_GIF%ld_%ld.gif", (long)category, (long)index];
		obj = [BaseObject comicObjectWith:ObjectAnimateGIF userInfo:rcID];
		
		self.btnPlay.hidden = false;
	}
    
    obj.delayTimeInSeconds = delayTime;
	
	[viewModel addRecentObject:@{@"type":		@(type),
								 @"id":			@(index),
								 @"category":	@(category),
                                 @"delayTime":   @(delayTime)}];
	
	return obj;
}

- (void)createComicViews {
	if (!viewModel || !viewModel.arrayObjects || !viewModel.arrayObjects.count) {
		NSLog(@"There is nothing comic objects");
		return;
	}
    _timerImageViews = [NSMutableArray array];
	backgroundView = [ComicObjectView createComicViewWith:viewModel.arrayObjects delegate:self timerImageViews:_timerImageViews];
	[self.baseLayerView insertSubview:backgroundView atIndex:0];
    
    //Set tags----------
    if (_timerImageViews.count != 0) {
        UIImageView *baseLayer = [_timerImageViews firstObject].imageView;
        maxSeconds = baseLayer.animationDuration;
        self.scrollBarSlider.maximumValue = baseLayer.animationDuration;
    }
    
    NSArray *noBaseLayerComicObjectViews = [backgroundView subviews];
    if (noBaseLayerComicObjectViews.count >= 1) {
        //By removing first object base layer fix the issue where the icon for base layer appears at start always
        for (int i = 1; i < noBaseLayerComicObjectViews.count; i++) {
            ComicObjectView *comicObjectView = noBaseLayerComicObjectViews[i];
            
            //Setting the tag here helps in further calculation of frame of icons
            comicObjectView.tag = (enhancementsBaseTag) + enhancementsBaseTagCount++;
        }
    }
    //>>Set tags---------
}

- (void)createComicViewWith:(BaseObject *)obj {
	[viewModel addObject:obj];
	
	ComicObjectView *comicView = [[ComicObjectView alloc] initWithComicObject:obj];
    comicView.parentView = backgroundView;
	comicView.delegate = self;
//    // TODO: Remove! This is for debug only
//    [comicView setFrame:CGRectMake(100, 100, comicView.frame.size.width, comicView.frame.size.height)];
	[backgroundView addSubview:comicView];
    comicView.tag = (enhancementsBaseTag) + enhancementsBaseTagCount++;
    
    [self.timerImageViews addObjectsFromArray:comicView.timerImageViews];
    
    [self addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:comicView.tag andBaseObjectType:obj.objType andSliderValue:self.scrollBarSlider.value];
}

- (void)addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:(NSInteger)tag andBaseObjectType:(ComicObjectType)type andSliderValue:(CGFloat)sliderValue {
    UIButton *iconButton = [[UIButton alloc] initWithFrame:[self.scrollBarSlider getCurrentRectForScollBarIconWithSliderValue:sliderValue]];
    iconButton.tag = tag;
    
//    if (obj.objType == ObjectAnimateGIF) {
        [iconButton setImage:[UIImage imageNamed:@"Bubble"] forState:UIControlStateNormal];
//    }
    
    [[self.scrollBarSlider superview] addSubview:iconButton];
    [iconButton addTarget:self action:@selector(iconTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)iconTapped:(UIButton *)iconButton {
    [self stopTimer];
    [self pause];
    ComicObjectView *comicObjectView = [self.baseLayerView viewWithTag:iconButton.tag];
    CGFloat scrollToThisDelayTime = comicObjectView.delayTimeInSeconds;
    
    autoScrollSliderDeltaValue = (scrollToThisDelayTime-self.scrollBarSlider.value)*0.05;
    
    [autoScrollSliderTimer invalidate];
    autoScrollSliderTimer = nil;
    autoScrollSliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                     target:self
                                   selector:@selector(scrollSliderWithTimer:)
                                   userInfo:@{@"SliderValueToSet":[NSNumber numberWithFloat:scrollToThisDelayTime]}
                                    repeats:YES];
}

- (void)scrollSliderWithTimer:(NSTimer *)timer {
    CGFloat scrollToThisDelayTime = [[timer.userInfo valueForKey:@"SliderValueToSet"] floatValue];
    if (autoScrollSliderDeltaValue < 0 && (self.scrollBarSlider.value + autoScrollSliderDeltaValue < scrollToThisDelayTime)) {
        [timer invalidate];
        timer = nil;
        return;
    } else if (autoScrollSliderDeltaValue >= 0 && (self.scrollBarSlider.value >= scrollToThisDelayTime)) {
        [timer invalidate];
        timer = nil;
        return;
    }
    self.scrollBarSlider.value+=autoScrollSliderDeltaValue;
    [self refreshStateOfEnhancementsWithSlideValue:self.scrollBarSlider.value];
}

- (UIView *)createToolView:(ComicObjectType)type {
	nCategory = 1;
	
	UIView *toolContainerView = [[UIView alloc] initWithFrame:self.baseLayerView.bounds];

	toolContainerView.backgroundColor = [UIColor clearColor];
	toolContainerView.tag = type;
	
	UITapGestureRecognizer *gesture;
	gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
													  action:@selector(tapGestureHandlerForToolContainerView:)];
	gesture.delegate = self;
	[toolContainerView addGestureRecognizer:gesture];
	
	// sticker collection view
	CGRect rt = CGRectMake(0, toolContainerView.frame.size.height - 140, toolContainerView.frame.size.width, 90);
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	layout.minimumInteritemSpacing = 30;
	layout.minimumLineSpacing = 30;
	
	collectionToolView = [[UICollectionView alloc] initWithFrame:rt collectionViewLayout:layout];
	collectionToolView.tag = type;
	collectionToolView.delegate = self;
	collectionToolView.dataSource = self;
	collectionToolView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
	collectionToolView.pagingEnabled = YES;
	[collectionToolView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:TOOLCELLID];
	
	[toolContainerView addSubview:collectionToolView];
	[collectionToolView reloadData];
	
	// category collection view
	rt = CGRectMake(0, toolContainerView.frame.size.height - 50, toolContainerView.frame.size.width, 50);
	
	layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	collectionCategoryView = [[UICollectionView alloc] initWithFrame:rt collectionViewLayout:layout];
	collectionCategoryView.delegate = self;
	collectionCategoryView.dataSource = self;
	collectionCategoryView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
	collectionCategoryView.pagingEnabled = YES;
	[collectionCategoryView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CATEGORYCELLID];
	
	[toolContainerView addSubview:collectionCategoryView];
	[collectionCategoryView reloadData];
	
	return toolContainerView;
}

- (void)setToolButtonAlpah:(CGFloat)alpha {
	self.btnToolAnimateGIF.alpha = alpha;
	self.btnToolPen.alpha = alpha;
	self.btnToolText.alpha = alpha;
	self.btnToolBubble.alpha = alpha;
	self.btnToolSticker.alpha = alpha;
	self.btnNext.alpha = alpha;
}


// MARK: - UIGesture delegate impelementation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	CGPoint translation = [touch locationInView:gestureRecognizer.view];
	BOOL flag = NO;
	
	UICollectionView *collectionView;
	for (UIView *view in gestureRecognizer.view.subviews) {
		if ([view class] == [UICollectionView class]) {
			collectionView = (UICollectionView *)view;
			flag = flag | CGRectContainsPoint(collectionView.frame, translation);
		}
	}
	
	return !flag;
}


// MARK: - UICollectionView delegate & data source implementation
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (collectionView == collectionCategoryView) { // for category view
		return COUNT_CATEGORY;
	}
	
	// for recent section of each tool view
	if (nCategory == 0) {
		return [viewModel getRecentObjects:(ComicObjectType)collectionView.tag].count;
	}
	
	// for sticker tool view
	if (collectionView.tag == ObjectSticker) {
		return [COUNT_STICKERS[nCategory - 1] integerValue];
		
	} else if (collectionView.tag == ObjectAnimateGIF) {
		return [COUNT_GIFS[nCategory - 1] integerValue];
	}
	
	return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	// for category view
	if (collectionView == collectionCategoryView) {
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CATEGORYCELLID forIndexPath:indexPath];
		if (!cell) {
			cell = [[UICollectionViewCell alloc] init];
		}
		
		NSString *rcID = [NSString stringWithFormat:@"category%ld.png", (long)indexPath.row];
		
		UIImageView *imgView = [cell viewWithTag:0x100];
		if (!imgView) {
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width / 4, 0, cell.bounds.size.width / 2, cell.bounds.size.height / 2)];
			imgView.tag = 0x100;
			imgView.userInteractionEnabled = YES;
			imgView.contentMode = UIViewContentModeScaleAspectFit;
			[cell addSubview:imgView];
		}
		imgView.image = [UIImage imageNamed:rcID];
		
		UIView *chosenView = [cell viewWithTag:0x101];
		if (nCategory == indexPath.row) {
			if (!chosenView) {
				chosenView = [[UIView alloc] initWithFrame:CGRectMake((cell.bounds.size.width - 8) / 2, cell.bounds.size.height - 10, 8, 8)];
				chosenView.layer.cornerRadius = chosenView.frame.size.width / 2;
				chosenView.backgroundColor = [UIColor whiteColor];
				chosenView.clipsToBounds = YES;
				chosenView.tag = 0x101;
				[cell addSubview:chosenView];
			}
			
		} else {
			if (chosenView) {
				[chosenView removeFromSuperview];
			}
		}
		
		return cell;
	}
	
	// for tool view
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TOOLCELLID forIndexPath:indexPath];
	if (!cell) {
		cell = [[UICollectionViewCell alloc] init];
	}
	//cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	
	NSString *rcID;
	NSInteger type, index, category;
	
	if (nCategory == 0) { // for recent section
		NSDictionary *dict = [viewModel getRecentObjects:(ComicObjectType)collectionView.tag][indexPath.row];
		type = [dict[@"type"] integerValue];
		index = [dict[@"id"] integerValue];
		category = [dict[@"category"] integerValue];
		
	} else {
		type = collectionView.tag;
		index = indexPath.row;
		category = nCategory - 1;
	}
	
	if (type == ObjectSticker) {
		rcID = [NSString stringWithFormat:@"theme_sticker%ld_%ld.png", (long)category, (long)index];
		
	} else if (type == ObjectAnimateGIF) {
		rcID = [NSString stringWithFormat:@"theme_GIF%ld_%ld.gif", (long)category, (long)index];
	}
	
	UIImageView *imgView = [cell viewWithTag:0x100];
	if (!imgView) {
		imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
		imgView.tag = 0x100;
		imgView.userInteractionEnabled = YES;
		imgView.contentMode = UIViewContentModeScaleAspectFit;
		[cell addSubview:imgView];
	}
	
	imgView.image = [UIImage imageNamed:rcID];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView == collectionCategoryView) { // for category colleciton view
		if (nCategory == indexPath.row) {
			return;
		}
		
		nCategory = indexPath.row;
		[collectionToolView reloadData];
		[collectionCategoryView reloadData];
		
		collectionToolView.frame = CGRectOffset(collectionToolView.frame, self.view.frame.size.width, 0);
		collectionToolView.alpha = 0.0;
		[UIView animateWithDuration:0.5 animations:^{
			collectionToolView.frame = CGRectOffset(collectionToolView.frame, -self.view.frame.size.width, 0);
			collectionToolView.alpha = 1.0;
		}];
		
		return;
	}
	
	// for tool category view
	NSInteger type, index, category;
	
	if (nCategory == 0) { // for recent object
		NSDictionary *dict = [viewModel getRecentObjects:(ComicObjectType)collectionView.tag][indexPath.row];
		type = [dict[@"type"] integerValue];
		index = [dict[@"id"] integerValue];
		category = [dict[@"category"] integerValue];
		
	} else {
		type = collectionView.tag;
		index = indexPath.row;
		category = nCategory - 1;
	}
	
	BaseObject *obj = [self createComicObject:(ComicObjectType)type index:index category:category delayTimeInSeconds:self.scrollBarSlider.value];
	
	if (obj) {
		[self createComicViewWith:obj];
		[viewModel saveObject];
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView == collectionCategoryView) {
		return CGSizeMake(40, 40);
	}
	
	return CGSizeMake(80, 80);
	//return CGSizeMake((collectionView.frame.size.width - 40) / 3, collectionView.frame.size.height - 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	if (collectionView == collectionCategoryView) {
		return UIEdgeInsetsMake(3, 10, 3, 10);
	}
	
	return UIEdgeInsetsMake(3, 15, 3, 30);
}


// MARK: - ComicObjectView delegate implementations
- (void)saveObject {
	[viewModel saveObject];
}

- (void)removeObject:(ComicObjectView *)view {
	[viewModel.arrayObjects removeObject:view.comicObject];
    UIView *icon = [self getScrollBarIconWithTag:view.tag];
    
	[UIView animateWithDuration:0.3 animations:^{
		view.alpha = 0.0;
        icon.alpha = 0.0;
	} completion:^(BOOL finished) {
		[view removeFromSuperview];
        [icon removeFromSuperview];
        
		[self saveObject];
	}];
}

- (void) addSubviewsOnImageWithSubviews:(NSMutableArray *)arrSubviews {
    //Handle top layer that is sticker gif
    int i=0;
    for (NSDictionary* subview in arrSubviews) {
        if ([[[subview objectForKey:@"baseInfo"] objectForKey:@"type"]intValue]==17) {
            ComicItemAnimatedSticker *sticker = [ComicItemAnimatedSticker new];
            sticker.objFrame = CGRectFromString([[subview objectForKey:@"baseInfo"] objectForKey:@"frame"]);
            sticker.combineAnimationFileName = [subview objectForKey:@"url"];
            
            NSBundle *bundle = [NSBundle mainBundle] ;
            NSString *strFileName = [[subview objectForKey:@"url"] lastPathComponent];
            NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".gif" withString:@""] ofType:@"gif"];
            NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
            
            sticker.image =  [UIImage sd_animatedGIFWithData:gifData];
            
            
            sticker.frame = CGRectMake(sticker.objFrame.origin.x, sticker.objFrame.origin.y, sticker.objFrame.size.width, sticker.objFrame.size.height);
            i ++;
            
            [self.baseLayerView addSubview:sticker];
        }
    }
}

#pragma mark - CMCBubbleView Delegate Methods

- (void)bubbleTypeSubiconDidClickWithSelectedBubbleType:(BubbleObjectType)bubbleType
                                         andCurrentText:(NSString *)bubbleText
                                   forCurrentBubbleView:(CMCBubbleView *)bubbleView
                                            andRootView:(ComicObjectView *)comicObjectView {
    
    BubbleObjectDirection bubbleDirection = bubbleView.currentBubbleDirection;
    
    [viewModel.arrayObjects removeObject:comicObjectView.comicObject];
    
    BubbleObject *newBubbleObject = [[BubbleObject alloc] initWithText:bubbleText
                                                              bubbleID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 0]
                                                         withDirection:bubbleDirection];
    int bubbleTypeIndex;
    switch(bubbleType) {
        case BubbleTypeStar:
            bubbleTypeIndex = 0;
            break;
            
        case BubbleTypeSleep:
            bubbleTypeIndex = 4;
            break;
            
        case BubbleTypeThink:
            bubbleTypeIndex = 1;
            break;
            
        case BubbleTypeScary:
            bubbleTypeIndex = 5;
            break;
            
        case BubbleTypeHeart:
            bubbleTypeIndex = 3;
            break;
            
        case BubbleTypeAngry:
            bubbleTypeIndex = 2;
            break;
    }
    [newBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", bubbleTypeIndex, 0]
                        forDirection:BubbleDirectionBottomRight];
    [newBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", bubbleTypeIndex, 3]
                        forDirection:BubbleDirectionBottomLeft];
    [newBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", bubbleTypeIndex, 1]
                        forDirection:BubbleDirectionUpperLeft];
    [newBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", bubbleTypeIndex, 2]
                        forDirection:BubbleDirectionUpperRight];
    
    [newBubbleObject changeBubbleTypeTo:bubbleType];
    [newBubbleObject switchBubbleURLToDirection:bubbleDirection];
    
    comicObjectView.comicObject = newBubbleObject;
    
    [viewModel addObject:newBubbleObject];
    [viewModel saveObject];
}

@end
