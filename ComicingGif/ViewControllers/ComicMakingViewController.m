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
#import "Global.h"
#import <Messages/Messages.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ComicItem.h"
#import "ComicObjectSerialize.h"
#import "CBComicPreviewVC.h"
#import "UIView+CBConstraints.h"
#import "ScrollBarSlider.h"
#import <ImageIO/ImageIO.h>
#import "TimerImageViewStruct.h"
#import "CMCExpandableCollectionView.h"
#import "CMCExpandableCollectionViewFlowLayout.h"
#import "CBComicTitleFontDropdownViewController.h"
#import "UINavigationController+Transition.h"

#define TOOLCELLID	@"ToolCollectionViewCell"
#define CATEGORYCELLID	@"CategoryCollectionViewCell"

#import "PassthroughBackgroundView.h"

#define DRAWING_DEFAULT_BRUSH 5
#define DRAWING_BIG_BRUSH 10
#define DRAWING_DEFAULT_COLOR [UIColor whiteColor]

#define discreteValueOfSeconds 0.01

#define enhancementsBaseTag 9090

#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)

@interface ComicMakingViewController () <ZoomTransitionProtocol,
ScrollBarSliderDelegate,
CMCExpandableCollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
ComicObjectViewAnimatedStickerStateDelegate,
TitleFontDelegate>
{
    ComicMakingViewModel *viewModel;
    ComicObjectView *backgroundView;
    UICollectionView *collectionCategoryView;
    CMCExpandableCollectionView *collectionToolView;
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
    
    UIImageView *shrinkingView;
    CGPoint previousTouchPoint;
    CGPoint newTouchPoint;
}

// Constrait Helpers For Later Animations
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerConstraint; // - .size.height
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gifAnimateConstraint; // - 50

@property (nonatomic) BOOL shouldContinueGif;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIView *penView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIView *stickerView;
@property (weak, nonatomic) IBOutlet UIView *lockView;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UIView *closeView;

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
@property (assign, nonatomic) CGFloat ratioMinimumValue;
@property (assign, nonatomic) CGRect baseLayerInitialFrame;
@property (assign, nonatomic) CGRect backgroundInitialFrame;
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

@property (nonatomic) UITapGestureRecognizer *collectionViewTapGestureRecognizer;

@property (assign, nonatomic) BOOL didLayoutSubviewsOnce;

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

//- (void) animateAppereance {
//    //    if (!self.isFromCamera) {
//    //        return;
//    //    }
//    
//    //     c0mrade: Should Be Refactored
//    
//    //     store real positions
//    CGRect oldBottomFr = self.sliderContainerView.frame;
//    CGRect oldAnimGifFr = self.btnToolAnimateGIF.frame;
//    CGRect oldBubbleFr = self.btnToolBubble.frame;
//    CGRect oldStickerFr = self.stickerView.frame;
//    CGRect oldPenFr = self.penView.frame;
//    CGRect oldTextFr = self.textView.frame;
//    CGRect oldCloseFr = self.closeView.frame;
//    CGRect oldLockFr = self.lockView.frame;
//    CGRect oldPlayFr = self.playView.frame;
//    
//    //     temp frame
//    CGRect tempFr = self.sliderContainerView.frame;
//    tempFr.origin.y = [UIScreen mainScreen].bounds.size.height;
//    
//    //     unlock autolayout from current objects
//    self.sliderContainerView.translatesAutoresizingMaskIntoConstraints = true;
//    self.btnToolAnimateGIF.translatesAutoresizingMaskIntoConstraints = true;
//    self.btnToolBubble.translatesAutoresizingMaskIntoConstraints = true;
//    self.stickerView.translatesAutoresizingMaskIntoConstraints = true;
//    self.textView.translatesAutoresizingMaskIntoConstraints = true;
//    self.penView.translatesAutoresizingMaskIntoConstraints = true;
//    
//    //     hide objects outside of superview bounds
//    self.sliderContainerView.frame = CGRectOffset(self.sliderContainerView.frame, 0, 100); // footer view
//    self.btnToolAnimateGIF.frame = CGRectOffset(self.btnToolAnimateGIF.frame, 0, 100); // heart button footer
//    self.btnToolBubble.frame = CGRectOffset(self.btnToolBubble.frame, 0, 100); // bubble button footer
//    self.stickerView.frame = CGRectOffset(self.stickerView.frame, 0, 100); // sticker view footer
//    self.textView.frame = CGRectOffset(self.textView.frame, 0, 150); // textview footer
//    self.penView.frame = CGRectOffset(self.penView.frame, 0, 100); // penview footer
//    
//    
//    self.closeView.frame = CGRectOffset(self.closeView.frame, 0, -100);
//    self.playView.frame = CGRectOffset(self.playView.frame, 0, -100);
//    self.lockView.frame = CGRectOffset(self.lockView.frame, 0, -100);
//    
//    
//    [self.view layoutIfNeeded];
//    self.footerConstraint.constant = -(self.sliderContainerView.frame.size.height);
//    self.gifAnimateConstraint.constant = -(self.btnToolAnimateGIF.frame.size.height);
//    
//    //     animate appereance of objects
//    __weak typeof(self) wSelf = self;
//    
//    
//    [self.view layoutIfNeeded];
//    [UIView animateWithDuration: 1.0 animations:^{
//        self.footerConstraint.constant = 0;
//        self.gifAnimateConstraint.constant = 0;
//        [self.view layoutIfNeeded];
//        
//        
//        
//        wSelf.sliderContainerView.frame = oldBottomFr;
//        wSelf.btnToolAnimateGIF.frame = oldAnimGifFr;
//        wSelf.btnToolBubble.frame = oldBubbleFr;
//        wSelf.stickerView.frame = oldStickerFr;
//        wSelf.textView.frame = oldPenFr;
//        wSelf.penView.frame = oldTextFr;
//        wSelf.closeView.frame = oldCloseFr;
//        wSelf.playView.frame = oldPlayFr;
//        wSelf.lockView.frame = oldLockFr;
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self animateAppereance];
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
                                             selector:@selector(openDropDownMenu:)
                                                 name:@"openFontsView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHideWithNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
	
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)];
	pinchGesture.delegate = self;
	[self.view addGestureRecognizer:pinchGesture];
}

-(void)getSelectedFontName:(NSString *)fontName andTitle:(NSString *)title {
    NSLog(@"%@, %@",fontName,title);
}

- (void) openDropDownMenu: (NSNotification *) data {
    UIStoryboard *mainPageStoryBoard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil];
    CBComicTitleFontDropdownViewController *vc = [mainPageStoryBoard instantiateViewControllerWithIdentifier:@"CBComicTitleFontDropdownViewController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.delegate = self;
    
    NSString *str = (NSString *)[data object];
    if ([str length] > 0) {
        vc.titleText = str;
    } else {
        vc.titleText = @"You Test Title";
    }
    
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - Slider methods
- (UIImage *)getSliderPlayOrPauseButtonWithImageName:(NSString *)imageName
{
    CGSize sliderSize = CGSizeMake(30, 60);
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
    if (_isDrawing) {
        // disable scrollbar in drawing mode. To keep track of the drawing PenObject time delay property
        return;
    }
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
    
    if (value == 0) {
        self.penToolImageView.alpha = 1;
        self.btnToolPen.alpha = 1;
    } else {
        self.penToolImageView.alpha = 0;
        self.btnToolPen.alpha = 0;
    }
    
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
    //    NSLog(@"Slider value actual: %f",slider.value);
    slider.value = ((NSInteger)(slider.value / discreteValueOfSeconds)) * discreteValueOfSeconds;
    //    NSLog(@"Slider value: %f",slider.value);
    discreteCount = slider.value / discreteValueOfSeconds;
    
    if (slider.value == 0) {
        self.penToolImageView.alpha = 1;
        self.btnToolPen.alpha = 1;
    } else {
        self.penToolImageView.alpha = 0;
        self.btnToolPen.alpha = 0;
    }
    
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
        
        UIImage *img = [[Global global] scaledImage:[UIImage imageWithCGImage:cgImg] size:rect.size];
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

- (void)setImageOnTimerImageView:(TimerImageViewStruct *)timerImageView withCurrentSliderValue:(CGFloat)currentSliderValue {
    //    if (currentSliderValue > 0 && self.shouldContinueGif == false && timerImageView.objType == ObjectAnimateGIF) {
    //        [timerImageView.imageView stopAnimating];
    //        return;
    //    }
    
    timerImageView.imageView.hidden = currentSliderValue < timerImageView.delayTimeOfImageView;
    timerImageView.view.hidden = currentSliderValue < timerImageView.delayTimeOfImageView;
    
    [timerImageView adjustViewAppearanceWithDelay:currentSliderValue];
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
        
        //        if (actualPercent == 99 && timerImageView.objType == ObjectAnimateGIF)  {
        //            self.shouldContinueGif = false;
        //            [timerImageView.imageView stopAnimating];
        //            return;
        //        } else if (actualPercent == 0 && timerImageView.objType == ObjectAnimateGIF) {
        //            if (self.shouldContinueGif == false) {
        //                [timerImageView.imageView startAnimating];
        //            }
        //            self.shouldContinueGif = true;
        //        }
        
        UIImage *img = [timerImageView.imageView.animationImages objectAtIndex:((NSInteger)[timerImageView.imageView.animationImages count] * actualPercent/100)];
        timerImageView.imageView.image = img;
    }
}

- (void)refreshStateOfTimerImageView:(TimerImageViewStruct *)timerImageView withSliderValue:(CGFloat)currentSliderValue {
    timerImageView.imageView.hidden = currentSliderValue < timerImageView.delayTimeOfImageView;
    
    timerImageView.view.hidden = currentSliderValue < timerImageView.delayTimeOfImageView;
    [timerImageView adjustViewAppearanceWithDelay:currentSliderValue];
    
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
    //self.btnToolAnimateGIF.alpha = self.btnToolBubble.alpha = self.btnToolSticker.alpha = self.btnToolText.alpha = self.btnToolPen.alpha = alpha;
    [self setToolButtonAlpah:alpha];
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
    
    if (_collectionViewTapGestureRecognizer) {
        return;
    }
    
    if (!_isDrawing) {
        UIView *touchView = [touches anyObject].view;
        if ([touchView.superview.superview isEqual:self.baseLayerView]) {
            _ratioDecreasing = 1;
            //            [self.baseLayerView saveCurrentRect];
            //            [self.baseLayerView saveFrameOfAllSubviewsWithTreeCount:1];
            
            
            UIImage *resultingImage;
            if (_isTall) {
                UIGraphicsBeginImageContextWithOptions(backgroundView.bounds.size, NO, [UIScreen mainScreen].scale);
                
                [backgroundView drawViewHierarchyInRect:backgroundView.bounds afterScreenUpdates:YES];
                
                // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
                
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                CGPoint point = [backgroundView.superview convertPoint:backgroundView.frame.origin toView:nil];
                
                shrinkingView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, backgroundView.frame.size.width, backgroundView.frame.size.height)];
                
                resultingImage = image;
            } else {
                UIGraphicsBeginImageContextWithOptions(backgroundView.frame.size, YES, 1.0);
                [backgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
                resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                shrinkingView = [[UIImageView alloc] initWithFrame:backgroundView.frame];
                resultingImage = [[Global global] scaledImage:resultingImage size:backgroundView.frame.size];
                
            }
            
            shrinkingView.contentMode = UIViewContentModeScaleAspectFit;
            shrinkingView.image =  resultingImage;
            [self.view addSubview:shrinkingView];
            
            [self.view sendSubviewToBack:shrinkingView];
            [self.view sendSubviewToBack:_baseLayerView];
            //            [self.view bringSubviewToFront:shrinkingView];
            self.baseLayerView.hidden = YES;
            
            
            CGSize size = self.isTall?[Global getTallBigSlideSize]:[Global getWideSlideSize];
            self.ratioMinimumValue = size.width/_baseLayerView.frame.size.width;
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
#warning temporarily disabled old glide implementation
        //        UIView *touchView = [touches anyObject].view;
        //        if ([touchView.superview.superview isEqual:self.baseLayerView]) {
        //            newTouchPoint = [[touches anyObject] locationInView:self.view];
        //            if (!([Global positive:(newTouchPoint.x - previousTouchPoint.x)] < 10 &&
        //                  [Global positive:(newTouchPoint.y - previousTouchPoint.y)] < 10)) {
        //                if (_ratioDecreasing >= _ratioMinimumValue) {
        //                    _ratioDecreasing -= 0.01;
        //
        //                    NSLog(@"............RATIO DECREASING: %f",_ratioDecreasing);
        //                    CGFloat newWidth,newHeight,newX,newY;
        //                    if (_isTall) {
        //                        newWidth = _baseLayerInitialFrame.size.width * _ratioDecreasing;
        //                        newHeight = _baseLayerInitialFrame.size.height * _ratioDecreasing;
        //                        newX = _baseLayerInitialFrame.origin.x + (_baseLayerInitialFrame.size.width - newWidth)/2;
        //                        newY = _baseLayerInitialFrame.origin.y + (_baseLayerInitialFrame.size.height - newHeight)/2;
        //                    } else {
        //                        newWidth = _baseLayerInitialFrame.size.width * _ratioDecreasing;
        //                        newHeight = _backgroundInitialFrame.size.height * _ratioDecreasing;
        //                        newX = _backgroundInitialFrame.origin.x + (_backgroundInitialFrame.size.width - newWidth)/2;
        //                        newY = _backgroundInitialFrame.origin.y + (_backgroundInitialFrame.size.height - newHeight)/2;
        //                    }
        //
        //                    CGRect newFrame = CGRectMake(newX, newY, newWidth, newHeight);
        //                    //                _baseLayerView.frame = newFrame;
        //                    ////                _baseLayerView.center = self.view.center;
        //                    //                NSLog(@"............RESULTANT FRAME: %@",NSStringFromCGRect(_baseLayerView.frame));
        //                    //                [self.baseLayerView setSubViewWithWithDimensionAsPerRatio:_ratioDecreasing treeCount:1];
        //                    NSLog(@"%@",NSStringFromCGRect(newFrame));
        //
        //                    shrinkingView.frame = newFrame;
        //                }
        //            }
        //            previousTouchPoint = newTouchPoint;
        //        }
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
        if ([touchView.superview.superview isEqual:self.baseLayerView] || [touchView isEqual:self.view]) {
            if (_ratioDecreasing >= _ratioMinimumValue){
                [UIView animateWithDuration:0.1 + 0.2*(1-_ratioDecreasing) animations:^{
                    //                    [self.baseLayerView restoreSavedRect];
                    //                    [self.baseLayerView restoreFrameOfAllSubviews];
                    if (_isTall) {
                        CGPoint point = [backgroundView.superview convertPoint:backgroundView.frame.origin toView:nil];
                        CGRect frame = shrinkingView.frame;
                        frame.origin = point;
                        shrinkingView.frame = frame;
                    } else {
                        shrinkingView.frame = backgroundView.frame;
                    }
                } completion:^(BOOL finished) {
                    shrinkingView.hidden = YES;
                    [shrinkingView removeFromSuperview];
                    self.baseLayerView.hidden = NO;
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
        
        
        
        //        self.scrollBarSlider.layer.cornerRadius = self.scrollBarSlider.frame.size.height / 2.0;
        //        self.scrollBarSlider.layer.borderWidth = 2.0;
        //        self.scrollBarSlider.layer.masksToBounds = true;
        //        self.scrollBarSlider.clipsToBounds = true;
        //        self.scrollBarSlider.layer.borderColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:239/255.0 alpha:1.0].CGColor;
        
        [self.scrollBarSlider setMinimumTrackImage:[self.scrollBarSlider getSliderBackView] forState:UIControlStateNormal];
        [self.scrollBarSlider setThumbImage:[self getSliderPlayOrPauseButtonWithImageName:@"SliderImage"] forState:UIControlStateNormal];
        [self.scrollBarSlider setMaximumTrackImage:[self.scrollBarSlider getSliderBackView] forState:UIControlStateNormal];
        
        
        //                [self.scrollBarSlider setThumbImage:[self getSliderPlayOrPauseButtonWithImageName:@"SliderImage"] forState:UIControlStateSelected];
        
        [self.scrollBarSlider enableTapOnSlider:YES];
    } else {
        //        self.sliderContainerViewBottomConstraint.constant = -self.sliderContainerView.frame.size.height;
        //        self.sliderBlackViewBottomConstraint.constant = -self.sliderBlackView.frame.size.height;
        self.sliderContainerView.hidden = self.sliderBlackView.hidden = YES;
        [self.scrollBarSlider enableTapOnSlider:NO];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!_didLayoutSubviewsOnce) {
        _didLayoutSubviewsOnce = !_didLayoutSubviewsOnce;
        _baseLayerInitialFrame = _baseLayerView.frame;
        _backgroundInitialFrame = backgroundView.frame;
    }
    
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
                if (![noBaseLayerComicObjectViews[i] isKindOfClass:[ComicObjectView class]]) {
                    continue;
                }
                ComicObjectView *comicObjectView = noBaseLayerComicObjectViews[i];
                [self addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:comicObjectView.tag
                                                            andBaseObjectType:comicObjectView.comicObject.objType
                                                               andSliderValue:comicObjectView.delayTimeInSeconds];
            }
        }
    }
    //>> Add icons after slider layout------
}

- (UIView *)viewForZoomTransition:(BOOL)isSource {
    NSLog(@"zzzzzzzzzzzzzzzzzz..............................xx %@",shrinkingView != nil ? shrinkingView : backgroundView);
    return shrinkingView != nil ? shrinkingView : backgroundView;
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
    
    //    [backgroundView insertSubview:toolView atIndex:backgroundView.subviews.count >= 1 ? 1 : 0];
    //    toolView.backgroundColor = [UIColor greenColor];
    
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
    
    CGFloat timeDelay = self.scrollBarSlider.value;
    bubbleObject.delayTimeInSeconds = timeDelay;
    
    ComicObjectView *bubbleComicObjectView = [[ComicObjectView alloc] initWithComicObject:bubbleObject];
    bubbleComicObjectView.parentView = backgroundView;
    bubbleComicObjectView.delegate = self;
    
    [backgroundView addSubview:bubbleComicObjectView];
    
    [viewModel saveObject];
    
    bubbleComicObjectView.tag = (enhancementsBaseTag) + enhancementsBaseTagCount++;
    [self.timerImageViews addObjectsFromArray:bubbleComicObjectView.timerImageViews];
    
    [self addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:bubbleComicObjectView.tag
                                                andBaseObjectType:bubbleObject.objType
                                                   andSliderValue:timeDelay];
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
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CaptionObject *captionObject = [[CaptionObject alloc] initWithText:@""
                                                           captionType:CaptionTypeDefault
                                                              andFrame:CGRectMake(5, 200, screenBounds.size.width - 20, 100)];
    CGFloat timeDelay = self.scrollBarSlider.value;
    captionObject.delayTimeInSeconds = timeDelay;
    
    [viewModel addObject:captionObject];
    
    ComicObjectView *captionComicObjectView = [[ComicObjectView alloc] initWithComicObject:captionObject];
    captionComicObjectView.parentView = backgroundView;
    captionComicObjectView.delegate = self;
    [backgroundView addSubview:captionComicObjectView];
    
    // TODO : test is everything is fine
    captionComicObjectView.tag = (enhancementsBaseTag) + enhancementsBaseTagCount++;
    //    [self.timerImageViews addObjectsFromArray:captionComicObjectView.timerImageViews];
    [self addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:captionComicObjectView.tag
                                                andBaseObjectType:captionObject.objType
                                                   andSliderValue:self.scrollBarSlider.value];
    
    
    [viewModel saveObject];
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
        
        // suppose to be _drawingImageView before scrollbar drawing support
        //        UIImageView *mainDrawingImageView = [[UIImageView alloc] initWithFrame:_drawingImageView.frame];
        UIImageView *mainDrawingImageView = _drawingImageView;
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        if (mainDrawingImageView.image) {
            [mainDrawingImageView.image drawInRect:CGRectMake(0, 0,
                                                              mainDrawingImageView.frame.size.width,
                                                              mainDrawingImageView.frame.size.height)
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
        mainDrawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_drawingImageViewStackArray removeAllObjects];
        
        if (_drawingCoordinateArray.count != _drawingColorArray.count ||
            _drawingCoordinateArray.count != _drawingBrushSizeArray.count) {
            return;
        }
        CGRect drawingFrame = CGRectMake(0, 0,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
        
        PenObject *firstPenObject;
        
        for (int i = 0; i < _drawingCoordinateArray.count; i++) {
            NSMutableArray<NSValue *> *signleDrawingCoordinates = _drawingCoordinateArray[i];
            UIColor *selectedColor = _drawingColorArray[i];
            CGFloat selectedBrushSize = [_drawingBrushSizeArray[i] floatValue];
            // Create new PenObject to save it into slides.plist file in the file system
            PenObject *penObject = [[PenObject alloc] initWithDrawingCoordintaes:signleDrawingCoordinates
                                                                   selectedColor:selectedColor
                                                                       brushSize:selectedBrushSize
                                                                        andFrame:drawingFrame];
            // Set surrect time delay for pen object
            penObject.delayTimeInSeconds = self.scrollBarSlider.value;
            
            if (!firstPenObject) {
                firstPenObject = penObject;
            }
            
            // Add new PenObject to viewModel objects array
            [viewModel addObject:penObject];
        }
        // Save all objects into the slides.plist file
        [viewModel saveObject];
        
        // Clear all coordinates, brush sizes and selected colors because drawing is no longer active.
        [_drawingCoordinateArray removeAllObjects];
        [_drawingBrushSizeArray removeAllObjects];
        [_drawingColorArray removeAllObjects];
        
        
        
        // If first object is invalid – don't show anything
        if (!firstPenObject) {
            return;
        }
        ComicObjectView *drawingComicObject = [[ComicObjectView alloc] initWithComicObject:firstPenObject];
        if (!drawingComicObject ||
            drawingComicObject.subviews.count != 1 ||
            ![drawingComicObject.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            return;
        }
        // Set correct image from aggregated pen object
        //        ((UIImageView *)drawingComicObject.subviews.firstObject).image = mainDrawingImageView.image;
        
        
        
        if (drawingComicObject.subviews > 0 && [drawingComicObject.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [drawingComicObject.subviews.firstObject removeFromSuperview];
        }
        [drawingComicObject addImageViewSubview:mainDrawingImageView
                                  withTimeDelay:firstPenObject.delayTimeInSeconds];
        
        
        
        [backgroundView insertSubview:drawingComicObject atIndex:1];
        
        // TODO : test is everything is fine
        drawingComicObject.tag = (enhancementsBaseTag) + enhancementsBaseTagCount++;
        [self.timerImageViews addObjectsFromArray:drawingComicObject.timerImageViews];
        [self addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:drawingComicObject.tag
                                                    andBaseObjectType:firstPenObject.objType
                                                       andSliderValue:self.scrollBarSlider.value];
    }
}


- (IBAction)btnNextTapped:(id)sender {
    [viewModel saveObject];
    
    // for testing
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slides.plist"];
    //
    //    if([MFMailComposeViewController canSendMail]) {
    //        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    //        mailCont.mailComposeDelegate = self;
    //
    //        [mailCont setSubject:@"created GIF"];
    //        [mailCont setMessageBody:@"Please take a look attached GIF file." isHTML:NO];
    //
    //        NSData *data = [NSData dataWithContentsOfFile:filePath];
    //        [mailCont addAttachmentData:data mimeType:@"plist" fileName:@"slides.plist"];
    //
    //        [self presentViewController:mailCont animated:YES completion:nil];
    //    }
    
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
        //        vc.shouldntRefreshAfterDidLayoutSubviews = _indexSaved == -1? NO:YES;
        vc.indexForSlideToRefresh = _indexSaved;
        [vc refreshSlideAtIndex:_indexSaved isTall:self.isTall completionBlock:^(BOOL isComplete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                vc.transitionView.hidden = NO;
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning"
                                                                   message:@" are you sure you want to delete this slide?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
        shrinkingView = nil;
        
        [ComicObjectSerialize deleteObjectAtIndex:self.indexSaved];
        [self.navigationController presentCameraViewWithMode:NO
                                                indexOfSlide:self.indexSaved
                                                  completion:nil];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [alert addAction:okAction];
    [alert addAction:otherAction];
    [self presentViewController:alert animated:YES completion:nil];
}


// MARK: - gesture handler
- (void)tapGestureHandlerForToolContainerView:(UITapGestureRecognizer *)gesture {
	if (collectionToolView == nil) {
		return;
	}
	
    [UIView animateWithDuration:0.5 animations:^{
        //		if (gesture.view.tag == ObjectAnimateGIF) {
        //			gesture.view.frame = CGRectOffset(gesture.view.frame, self.baseLayerView.frame.size.width, 0);
        //			gesture.view.alpha = 0.0;
        //
        //		} else if (gesture.view.tag == ObjectSticker) {
        //			gesture.view.frame = CGRectOffset(gesture.view.frame, self.baseLayerView.frame.size.width, 0);
        //			gesture.view.alpha = 0.0;
        //
        //		} else if (gesture.view.tag == ObjectBubble) {
        //
        //		} else if (gesture.view.tag == ObjectCaption) {
        //
        //		} else if (gesture.view.tag == ObjectPen) {
        //
        //		}
        
        [collectionToolView superview].frame = CGRectOffset(gesture.view.frame, self.baseLayerView.frame.size.width, 0);
        [collectionToolView superview].alpha = 0.0;
        
        [self setToolButtonAlpah:1.0];
        
    } completion:^(BOOL finished) {
        [[collectionToolView superview] removeFromSuperview];
		collectionToolView = nil;
        [backgroundView removeGestureRecognizer:_collectionViewTapGestureRecognizer];
        _collectionViewTapGestureRecognizer = nil;
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

- (void)pinchGestureHandler:(UIPinchGestureRecognizer *)gesture {
	
	[self btnNextTapped:nil];
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
    
    [viewModel addRecentObject:@{kTypeKey:        @(type),
                                 @"id":            @(index),
                                 @"category":    @(category),
                                 kDelayTimeKey:   @(delayTime)}];
    
    return obj;
}

- (void)createComicViews {
    if (!viewModel || !viewModel.arrayObjects || !viewModel.arrayObjects.count) {
        NSLog(@"There is nothing comic objects");
        return;
    }
    [self.view layoutIfNeeded];
    _timerImageViews = [NSMutableArray array];
    backgroundView = [ComicObjectView createComicViewWith:viewModel.arrayObjects delegate:self timerImageViews:_timerImageViews];
    backgroundView.frame = CGRectMake(0, 20, self.baseLayerView.frame.size.width, self.baseLayerView.frame.size.height-20);
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
            
            if (comicObjectView.comicObject.objType == ObjectAnimateGIF) {
                comicObjectView.hidden = YES;
            }
			
            //Setting the tag here helps in further calculation of frame of icons
            comicObjectView.tag = (enhancementsBaseTag) + enhancementsBaseTagCount++;
        }
    }
    //>>Set tags---------
}

- (void)createComicViewWith:(BaseObject *)obj {
    [viewModel addObject:obj];
    
    // c0mrade: calculate sticker frame dynamically
//    StickerObject *stk = (StickerObject *)obj;
//    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:stk.stickerURL]];
    
    
    ComicObjectView *comicView = [[ComicObjectView alloc] initWithComicObject:obj];
    comicView.parentView = backgroundView;
    comicView.delegate = self;
    
    if (obj.objType == ObjectAnimateGIF) {
        comicView.animatedStickerStateDelegate = self;
    }
    
    //    // TODO: Remove! This is for debug only
    [comicView setFrame:CGRectMake(100, 100, comicView.frame.size.width, comicView.frame.size.height)];
    
    [backgroundView addSubview:comicView];
    //    [backgroundView insertSubview:comicView atIndex:backgroundView.subviews.count >= 1 ? 1 : 0];
    //    comicView.backgroundColor = [UIColor redColor];
    
    comicView.tag = (enhancementsBaseTag) + enhancementsBaseTagCount++;
    
    if (obj.objType != ObjectAnimateGIF) {
        [self.timerImageViews addObjectsFromArray:comicView.timerImageViews];
    }
    
    [self addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:comicView.tag andBaseObjectType:obj.objType andSliderValue:self.scrollBarSlider.value];
}

- (void)comicObjectView:(ComicObjectView *)comicObjectView didFinishRenderingWithDelayTime:(CGFloat)delayTime andBaseObject:(BaseObject *)baseObject {
    [self.timerImageViews addObjectsFromArray:comicObjectView.timerImageViews];
    [self refreshStateOfEnhancementsWithSlideValue:self.scrollBarSlider.value];
    comicObjectView.hidden = NO;
}

- (void)addIconToScrollBarAfterAdditionOfComicObjectViewWithTag:(NSInteger)tag andBaseObjectType:(ComicObjectType)type andSliderValue:(CGFloat)sliderValue {
    UIButton *iconButton = [[UIButton alloc] initWithFrame:[self.scrollBarSlider getCurrentRectForScollBarIconWithSliderValue:sliderValue]];
    iconButton.tag = tag;
    
    if (type == ObjectCaption) {
        [iconButton setImage:[UIImage imageNamed:@"caption-slider-icon"] forState:UIControlStateNormal];
    } else {
        [iconButton setImage:[UIImage imageNamed:@"Bubble"] forState:UIControlStateNormal];
    }
    
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
    
    PassthroughBackgroundView *toolContainerView = [[PassthroughBackgroundView alloc] initWithFrame:self.baseLayerView.bounds];
    
    toolContainerView.backgroundColor = [UIColor clearColor];
    toolContainerView.tag = type;
    
    _collectionViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapGestureHandlerForToolContainerView:)];
    _collectionViewTapGestureRecognizer.delegate = self;
    
    [backgroundView addGestureRecognizer:_collectionViewTapGestureRecognizer];
    
    
    //[toolContainerView addGestureRecognizer:gesture];
    
    // sticker collection view
    CGRect rt = CGRectMake(0, toolContainerView.frame.size.height - 140, toolContainerView.frame.size.width, 120);
    
    //	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //	layout.minimumInteritemSpacing = 20;
    //	layout.minimumLineSpacing = 20;
    
    CMCExpandableCollectionViewFlowLayout *customLayout = [[CMCExpandableCollectionViewFlowLayout alloc] init];
    customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    customLayout.minimumInteritemSpacing = 10;
    customLayout.minimumLineSpacing = 20;
    customLayout.footerReferenceSize = CGSizeMake(30, 20);
    customLayout.sectionFootersPinToVisibleBounds = YES;
    
    collectionToolView = [[CMCExpandableCollectionView alloc] initWithFrame:rt collectionViewLayout:customLayout/*layout*/];
    collectionToolView.tag = type;
    collectionToolView.delegate = self;
    collectionToolView.dataSource = self;
    collectionToolView.backgroundColor = [UIColor clearColor];
    collectionToolView.pagingEnabled = NO;
    [collectionToolView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:TOOLCELLID];
    
    //    collectionToolView.backgroundColor = [UIColor yellowColor];
    
    [collectionToolView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterIndetifyer"];
    [collectionToolView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FooterIndetifyer"];
    
    [collectionToolView setShowsHorizontalScrollIndicator:NO];
    
    [toolContainerView addSubview:collectionToolView];
    [collectionToolView reloadData];
    
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [collectionToolView addGestureRecognizer:pinchGesture];
    
    
    // category collection view
    rt = CGRectMake(0, toolContainerView.frame.size.height - 50, toolContainerView.frame.size.width, 50);
    
    //	layout = [[UICollectionViewFlowLayout alloc] init];
    //	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //
    //	collectionCategoryView = [[UICollectionView alloc] initWithFrame:rt collectionViewLayout:layout];
    
    //	collectionCategoryView.delegate = self;
    //	collectionCategoryView.dataSource = self;
    //	collectionCategoryView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    //	collectionCategoryView.pagingEnabled = YES;
    //	[collectionCategoryView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CATEGORYCELLID];
    //	[toolContainerView addSubview:collectionCategoryView];
    //	[collectionCategoryView reloadData];
    
    return toolContainerView;
}

- (void)setToolButtonAlpah:(CGFloat)alpha {
    self.btnToolAnimateGIF.alpha = alpha;
//    self.btnToolPen.alpha = alpha;
    self.btnToolText.alpha = alpha;
    self.btnToolBubble.alpha = alpha;
    self.btnToolSticker.alpha = alpha;
    self.btnNext.alpha = alpha;
    
    self.buttonToolTextImageView.alpha = alpha;
    self.buttonToolStickerImageView.alpha = alpha;
//    self.penToolImageView.alpha = alpha;
    
    if (alpha == 1) {
        if (self.scrollBarSlider.value == 0) {
            self.btnToolPen.alpha = alpha;
            self.penToolImageView.alpha = alpha;
        }
    } else {
        self.btnToolPen.alpha = alpha;
        self.penToolImageView.alpha = alpha;
    }
}


// MARK: - UIGesture delegate impelementation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //	CGPoint translation = [touch locationInView:gestureRecognizer.view];
    //	BOOL flag = NO;
    //
    //	UICollectionView *collectionView;
    //	for (UIView *view in gestureRecognizer.view.subviews) {
    //		if ([view class] == [UICollectionView class]) {
    //			collectionView = (UICollectionView *)view;
    //			flag = flag | CGRectContainsPoint(collectionView.frame, translation);
    //		}
    //	}
    //
    //	return !flag;
    CGPoint tapPoint = [touch locationInView:gestureRecognizer.view];
    BOOL shouldReceiveTouch = YES;
    if (CGRectContainsPoint(collectionToolView.frame, tapPoint)) {
        shouldReceiveTouch = NO;
        return shouldReceiveTouch;
    }
    
    int subviewIndex;
    for (subviewIndex = 0; subviewIndex < backgroundView.subviews.count; subviewIndex++) {
        id subview = backgroundView.subviews[subviewIndex];
        if (![subview isKindOfClass:[ComicObjectView class]]) {
            continue;
        }
		
		if (subviewIndex >= self.timerImageViews.count) {
			break;
		}
		
        TimerImageViewStruct *timerStruct = self.timerImageViews[subviewIndex];
        if (timerStruct.imageView) {
            if (timerStruct.imageView.hidden) {
                continue;
            }
        } else if (timerStruct.view) {
            if (timerStruct.view.hidden) {
                continue;
            }
        }
        ComicObjectView *comicObjectView = (ComicObjectView *) subview;
        if (comicObjectView.comicObject.objType == ObjectPen) {
            continue;
        }
        if (CGRectContainsPoint(comicObjectView.frame, tapPoint)) {
            shouldReceiveTouch = NO;
			
            break;
        }
    }
	
//	if (collectionToolView != nil) {
//		[self tapGestureHandlerForToolContainerView:gestureRecognizer];
//	}
	
    return shouldReceiveTouch;
}


float scale = 1;
- (void)didReceivePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
    static CGFloat scaleStart;
    //    NSLog(@"CMC4: receive pinch gesture with state %ld", (long)gestureRecognizer.state);
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        scaleStart = scale;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        scale = scaleStart * gestureRecognizer.scale;
        
        NSLog(@"CMC4: velocity %f | scale %f", gestureRecognizer.velocity, gestureRecognizer.scale);
        [collectionToolView.collectionViewLayout invalidateLayout];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [collectionToolView collapseActiveSection];
        scale = 1;
    }
}

// MARK: - UICollectionView delegate & data source implementation

//- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
//
//    return proposedContentOffset;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //	if (collectionView == collectionCategoryView) { // for category view
    //		return COUNT_CATEGORY;
    //	}
    
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //COUNT_CATEGORY
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView firstItemDidSelectedWithIndexPath:(NSIndexPath *)indexPath {
    [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)collectionView:(CMCExpandableCollectionView *)collectionView didExpandItemAtIndexPath:(NSIndexPath *)indexPath {
    //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    cell.hidden = YES;
    //    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    //    [collectionView reloadData];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *groupBackgroundImageView = [cell viewWithTag:0x001];
    //groupBackgroundImageView.center = CGPointMake(groupBackgroundImageView.center.x + 10, groupBackgroundImageView.center.y);
    groupBackgroundImageView.hidden = NO;
    groupBackgroundImageView.alpha = 1;
    [UIView animateWithDuration:0.1
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionNone animations:^{
                            //                            groupBackgroundImageView.center = CGPointMake(groupBackgroundImageView.center.x - 10, groupBackgroundImageView.center.y);
                            groupBackgroundImageView.alpha = 0;
                        } completion:nil];
    
    
    CGFloat newWidth = 80 * 6 + 7 * 3;
    UICollectionReusableView *footer = [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionFooter
                                                                           atIndexPath:indexPath];
    [UIView animateWithDuration:0.3 animations:^{
        //        footer.frame = CGRectMake(footer.frame.origin.x, footer.frame.origin.y, newWidth, footer.frame.size.height);
        
        footer.center = CGPointMake(footer.center.x + newWidth/2, footer.center.y);
        
        //        footer.subviews.firstObject.center = CGPointMake(footer.subviews.firstObject.center.x - newWidth/2, footer.subviews.firstObject.center.y);
    }];
}

- (void)collectionView:(CMCExpandableCollectionView *)collectionView didCollapseItemAtIndexPath:(NSIndexPath *)indexPath {
    //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    cell.hidden = NO;
    //    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    //    [collectionView reloadData];
    
    if (!indexPath) {
        return;
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView *groupBackgroundImageView = [cell viewWithTag:0x001];
    
    groupBackgroundImageView.center = CGPointMake(groupBackgroundImageView.center.x - 10, groupBackgroundImageView.center.y);
    //    [UIView animateWithDuration:0.2 animations:^{
    //        groupBackgroundImageView.center = CGPointMake(groupBackgroundImageView.center.x + 10, groupBackgroundImageView.center.y);
    //        groupBackgroundImageView.hidden = NO;
    //    }];
    groupBackgroundImageView.hidden = NO;
    groupBackgroundImageView.alpha = 0;
    [UIView animateWithDuration:0.6
                          delay:0.2
         usingSpringWithDamping:0.4
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionNone animations:^{
                            groupBackgroundImageView.center = CGPointMake(groupBackgroundImageView.center.x + 10, groupBackgroundImageView.center.y);
                            //                            groupBackgroundImageView.hidden = NO;
                            groupBackgroundImageView.alpha = 1;
                        } completion:nil];
    
    
    CGFloat newWidth = 80 * 6 + 7 * 3;
    UICollectionReusableView *footer = [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
    [UIView animateWithDuration:0.3 animations:^{
        //        footer.frame = CGRectMake(footer.frame.origin.x, footer.frame.origin.y, cell.frame.size.width, footer.frame.size.height);
        
        footer.center = CGPointMake(footer.center.x - newWidth/2, footer.center.y);
        
        //        footer.subviews.firstObject.center = CGPointMake(footer.subviews.firstObject.center.x - newWidth/2, footer.subviews.firstObject.center.y);
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(CMCExpandableCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // for category view
    /*
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
     */
    
    // for tool view
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TOOLCELLID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    //cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    NSString *rcID;
    NSInteger type, index, category;
    
    // for recent section
    if (nCategory == 0) {
        NSDictionary *dict = [viewModel getRecentObjects:(ComicObjectType)collectionView.tag][indexPath.row];
        type = [dict[kTypeKey] integerValue];
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
        //		rcID = [NSString stringWithFormat:@"theme_GIF%ld_%ld.gif", (long)category, (long)index];
        rcID = [NSString stringWithFormat:@"image-%ld-%ld.png", (long)category, (long)index];
    }
    
    //    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stickers-pile-background"]];
    //    backgroundImageView.userInteractionEnabled = YES;
    //    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView *groupBackgroundImageView = [cell viewWithTag:0x001];
    if (!groupBackgroundImageView) {
        UIImage *image = [UIImage imageNamed:@"stickers-pile-group-background"];
        groupBackgroundImageView = [[UIImageView alloc] initWithImage:image];
        groupBackgroundImageView.frame = CGRectMake(0, 0, cell.bounds.size.width + 30, cell.bounds.size.height);
        groupBackgroundImageView.userInteractionEnabled = YES;
        groupBackgroundImageView.tag = 0x001;
        groupBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    UIImageView *backgroundImageView = [cell viewWithTag:0x010];
    if (!backgroundImageView) {
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stickers-pile-background"]];
        backgroundImageView.frame = cell.bounds;
        backgroundImageView.userInteractionEnabled = YES;
        backgroundImageView.tag = 0x010;
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    UIImageView *imgView = [cell viewWithTag:0x100];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imgView.tag = 0x100;
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell addSubview:groupBackgroundImageView];
        [cell addSubview:backgroundImageView];
        [cell addSubview:imgView];
    }
    
    imgView.image = [UIImage imageNamed:rcID];
    
    groupBackgroundImageView.hidden = indexPath.item != 0;
    if (indexPath.item == 0 && [collectionView isExpandedSection:indexPath.section]) {
        groupBackgroundImageView.hidden = YES;
        
        [cell.superview bringSubviewToFront:cell];
        
    } else if (indexPath.item == 0 && ![collectionView isExpandedSection:indexPath.section]) {
        groupBackgroundImageView.hidden = NO;
        
        //        groupBackgroundImageView.hidden = YES;
        
        //        [cell.superview bringSubviewToFront:cell];
        //        groupBackgroundImageView.center = CGPointMake(groupBackgroundImageView.center.x - 10, groupBackgroundImageView.center.y);
        //        [UIView animateWithDuration:3 animations:^{
        //            groupBackgroundImageView.center = CGPointMake(groupBackgroundImageView.center.x + 10, groupBackgroundImageView.center.y);
        //            groupBackgroundImageView.hidden = NO;
        //        }];
        
    } else if (indexPath.item != 0) {
        groupBackgroundImageView.hidden = YES;
    }
    
    /*
     if (indexPath.item == 0 && ![collectionView isExpandedSection:indexPath.section]) {
     UIImageView *backgroundImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stickers-pile-background"]];
     backgroundImageView3.userInteractionEnabled = YES;
     backgroundImageView3.contentMode = UIViewContentModeScaleAspectFit;
     backgroundImageView3.frame = CGRectMake(imgView.frame.origin.x + 20, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height);
     [cell insertSubview:backgroundImageView3 atIndex:0];
     
     UIImageView *backgroundImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stickers-pile-background"]];
     backgroundImageView2.userInteractionEnabled = YES;
     backgroundImageView2.contentMode = UIViewContentModeScaleAspectFit;
     backgroundImageView2.frame = CGRectMake(imgView.frame.origin.x + 10, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height);
     [cell insertSubview:backgroundImageView2 atIndex:1];
     }
     
     backgroundImageView.frame = imgView.frame;
     [cell insertSubview:backgroundImageView atIndex:2];
     
     [cell addSubview:imgView];
     */
    return cell;
}

- (UICollectionReusableView *)collectionView:(CMCExpandableCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"CMC3: new supplementaryv view for kind %@ at indexPath %@", kind, indexPath);
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                          withReuseIdentifier:@"FooterIndetifyer"
                                                                                 forIndexPath:indexPath];
    
    if (kind == UICollectionElementKindSectionFooter) {
        UILabel *label = [footer viewWithTag:0x010];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, footer.bounds.size.width, 14)];
            label.tag = 0x010;
            label.text = @"Tired";
            label.textColor = [UIColor whiteColor];
            [label setFont:[UIFont fontWithName:@"arial rounded mt bold" size:14]];
            label.textAlignment = NSTextAlignmentCenter;
            
            label.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin   |
                                      UIViewAutoresizingFlexibleRightMargin  |
                                      UIViewAutoresizingFlexibleTopMargin    |
                                      UIViewAutoresizingFlexibleBottomMargin);
            
            //            label.backgroundColor = [UIColor greenColor];
            
            
            [footer addSubview:label];
        }
        //        footer.backgroundColor = [UIColor redColor];
        
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        NSLog(@"CMC2: footer frame : %@", NSStringFromCGRect(footer.frame));
        NSLog(@"CMC2: cell frame   : %@\n\n", NSStringFromCGRect(cell.frame));
        
        if ([collectionView isExpandedSection:indexPath.section] && footer.frame.origin.x - 30 < cell.frame.origin.x) {
            NSLog(@"CMC2: cell we need!!!");
            
            CGFloat newWidth = 80 * 6 + 7 * 3;
            footer.center = CGPointMake(footer.center.x + newWidth/2, footer.center.y);
        }
        
        // TODO: get correct max sectionwidth
        /*
         CGFloat newWidth = 60 * 6 + 7 * 3;
         if ([collectionView isExpandedSection:indexPath.section]) {
         if (footer.frame.origin.x == 0 && footer.frame.origin.y == 2){
         footer.center = CGPointMake(footer.center.x + newWidth/2, footer.center.y);
         }
         //            label.center = CGPointMake(footer.center.x + newWidth/2, footer.center.y);
         } else {
         //            label.center = CGPointMake(footer.frame.size.width/2, footer.center.y);
         footer.frame = CGRectMake(0, 2, footer.frame.size.width, footer.frame.size.height);
         }
         */
    }
    
    return footer;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //    return 7.0;
    return 7.0 * scale;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(1, 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //	if (collectionView == collectionCategoryView) { // for category colleciton view
    //		if (nCategory == indexPath.row) {
    //			return;
    //		}
    //
    //		nCategory = indexPath.row;
    //		[collectionToolView reloadData];
    //		[collectionCategoryView reloadData];
    //
    //		collectionToolView.frame = CGRectOffset(collectionToolView.frame, self.view.frame.size.width, 0);
    //		collectionToolView.alpha = 0.0;
    //		[UIView animateWithDuration:0.5 animations:^{
    //			collectionToolView.frame = CGRectOffset(collectionToolView.frame, -self.view.frame.size.width, 0);
    //			collectionToolView.alpha = 1.0;
    //		}];
    //
    //		return;
    //	}
    
    // for tool category view
    NSInteger type, index, category;
    
    if (nCategory == 0) { // for recent object
        NSDictionary *dict = [viewModel getRecentObjects:(ComicObjectType)collectionView.tag][indexPath.row];
        type = [dict[kTypeKey] integerValue];
        index = [dict[@"id"] integerValue];
        category = [dict[@"category"] integerValue];
        
    } else {
        type = collectionView.tag;
        index = indexPath.item;

        //		category = nCategory - 1;
        category = indexPath.section;//indexPath.item;
    }
    
    BaseObject *obj = [self createComicObject:(ComicObjectType)type index:index category:category delayTimeInSeconds:self.scrollBarSlider.value];
    
    if (obj) {
        [self createComicViewWith:obj];
        [viewModel saveObject];
    }
}

- (CGSize)collectionView:(CMCExpandableCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //	if (collectionView == collectionCategoryView) {
    //		return CGSizeMake(40, 40);
    //	}
    
    //	return CGSizeMake(80, 80);
    
    
    //    NSLog(@"CMC: new size for item: %@", indexPath);
    //    if (indexPath.item == 0 && [collectionView isExpandedSection:indexPath.section]) {
    //        return CGSizeMake(0, 0);
    //    }
    
    //	return CGSizeMake(60, 60);
    
    return CGSizeMake(80.1, 80.172);
}

- (UIEdgeInsets)collectionView:(CMCExpandableCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //	if (collectionView == collectionCategoryView) {
    //		return UIEdgeInsetsMake(3, 10, 3, 10);
    //	}
    
    //	return UIEdgeInsetsMake(3, 15, 3, 15);
    if ([collectionView isExpandedSection:section]) {
        return UIEdgeInsetsMake(3, 15, 3, 0);
    } else {
        return UIEdgeInsetsMake(3, 15, 3, 8);
    }
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
        if ([[[subview objectForKey:kBaseInfoKey] objectForKey:kTypeKey]intValue]==17) {
            ComicItemAnimatedSticker *sticker = [ComicItemAnimatedSticker new];
            sticker.objFrame = CGRectFromString([[subview objectForKey:kBaseInfoKey] objectForKey:kFrameKey]);
            sticker.combineAnimationFileName = [subview objectForKey:kURLKey];
            
            NSBundle *bundle = [NSBundle mainBundle] ;
            NSString *strFileName = [[subview objectForKey:kURLKey] lastPathComponent];
            NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".gif" withString:@""] ofType:@"gif"];
            NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
            
            sticker.image =  [UIImage sd_animatedGIFWithData:gifData];
            
            
            sticker.frame = CGRectMake(sticker.objFrame.origin.x, sticker.objFrame.origin.y, sticker.objFrame.size.width, sticker.objFrame.size.height);
            i ++;
            
            [self.baseLayerView addSubview:sticker];
        }
    }
}

#pragma mark - CMCCaptionView Delegate Methods

- (void)captionTypeSubiconDidClickWithSelectedCaptionType:(CaptionObjectType)type
                                           andCurrentText:(NSString *)text
                                    forCurrentCaptionView:(CMCCaptionView *)sender
                                              andRootView:(ComicObjectView *)comicObjectView {
    [viewModel.arrayObjects removeObject:comicObjectView.comicObject];
    
    CaptionObject *oldCaptionObject = (CaptionObject *) comicObjectView.comicObject;
    CaptionObject *newCaptionObject = [[CaptionObject alloc] initWithText:text captionType:type];
    
    
    CGRect fr = oldCaptionObject.frame;
    if (type == CaptionTypeYellowBox) {
        fr = CGRectMake(self.view.frame.size.width - 281, 0, 281, 125);
    } else {
        CGFloat width = self.view.frame.size.width - 20;
        fr = CGRectMake((self.view.frame.size.width - width)/2, 200, width, 100);
    }
    newCaptionObject.delayTimeInSeconds = oldCaptionObject.delayTimeInSeconds;
    
    // c0mrade
    newCaptionObject.frame = fr;
    [UIView animateWithDuration:0.5 animations:^{
        comicObjectView.comicObject = newCaptionObject;
    }];
    
    
    [viewModel addObject:newCaptionObject];
    [viewModel saveObject];
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
    newBubbleObject.delayTimeInSeconds = comicObjectView.comicObject.delayTimeInSeconds;
    
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
