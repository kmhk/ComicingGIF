//
//  CMCCaptionView.m
//  ComicingGif
//
//  Created by Ahmed Sulaiman on 6/24/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CMCCaptionView.h"

@interface CMCCaptionView() <UITextViewDelegate>

@property (nonatomic) UITextView *captionTextView;
@property (nonatomic) UIImageView *backgroundImageView;

@property (nonatomic) UIImageView *plusImageView;
@property (nonatomic) UIImageView *captionDefaultTypeImageView;
@property (nonatomic) UIImageView *captionWithoutBackgroundTypeImageView;
@property (nonatomic) UIImageView *captionYellowBoxTypeImageView;

@property (nonatomic) NSTimer *subiconsAppearanceTimer;

@end

@implementation CMCCaptionView

- (instancetype)initWithFrame:(CGRect)frame
               andCaptionType:(CaptionObjectType)captionType {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.currentCaptionType = captionType;
    
    [self setupCaptionBackgroundImageViewWithCaptionType:captionType];
    [self setupCaptionTextViewForType:captionType];
    [self setupSubiconsImageViews];
    
    [self addSubview:_backgroundImageView];
    [self addSubview:_captionTextView];
    [self addSubview:_plusImageView];
    
    [self.captionTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    for (UIView *view in @[_captionDefaultTypeImageView,
                           _captionWithoutBackgroundTypeImageView,
                           _captionYellowBoxTypeImageView]) {
        [self addSubview:view];
        [self bringSubviewToFront:view];
    }
    
    return self;
}

// c0mrade: calculate textview center for text
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)setupSubiconsImageViews {
    [self setupCaptionTypesSubiconImageViews];
    [self prepareForYellowBoxInside];
}

- (void) prepareForYellowBoxInside {
    if (self.currentCaptionType != CaptionTypeYellowBox) {
        return;
    }
    
    
    // set frames inside Yellow Box
    self.backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, 81);
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.captionTextView.backgroundColor = [UIColor clearColor];
    self.captionTextView.frame = self.backgroundImageView.frame;
    
    [self setTextViewMarginsForYellowBoxInside];
}

- (void) setTextViewMarginsForYellowBoxInside {
    self.captionTextView.textContainerInset = UIEdgeInsetsMake(10, 14, 0, 14);
}

- (void)setupCaptionTypesSubiconImageViews {
    UIImage *defaultIcon = [UIImage imageNamed:@"default-caption-icon"];
    UIImage *bigTextIcon = [UIImage imageNamed:@"big-text-caption-icon"];
    UIImage *yelloxBoxIcon = [UIImage imageNamed:@"yellow-box-caption-icon"];
    NSArray<UIImage *> *captionTypesImagesArray = @[defaultIcon, bigTextIcon, yelloxBoxIcon];
    
    if (!_captionDefaultTypeImageView &&
        !_captionWithoutBackgroundTypeImageView &&
        !_captionYellowBoxTypeImageView) {
        NSArray<NSNumber *> *captionTypeTagsArray = @[@(CaptionTypeDefault),
                                                      @(CaptionTypeTextWithoutBackgroun),
                                                      @(CaptionTypeYellowBox)];
        
        NSArray<NSValue *> *subiconsCenterPointsArray = [self subiconsImageViewCenterPointsArray];
        
        _captionDefaultTypeImageView = [[UIImageView alloc] initWithImage:defaultIcon];
        _captionWithoutBackgroundTypeImageView = [[UIImageView alloc] initWithImage:bigTextIcon];
        _captionYellowBoxTypeImageView = [[UIImageView alloc] initWithImage:yelloxBoxIcon];
        
        CGFloat imageScaleFactor = 5;
        NSInteger arrayItemCounter = 0;
        for (UIView *view in @[_captionDefaultTypeImageView,
                               _captionWithoutBackgroundTypeImageView,
                               _captionYellowBoxTypeImageView]) {
            
            UIImage *image = captionTypesImagesArray[arrayItemCounter];
            view.alpha = 0.0;
            [view setUserInteractionEnabled:YES];
            
            CGFloat viewWidth = image.size.width / imageScaleFactor;
            CGFloat viewHeight = image.size.height / imageScaleFactor;
            [view setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
            
            view.tag = (CaptionObjectType) [captionTypeTagsArray[arrayItemCounter] integerValue];
            // CGFloat centerX = ([UIScreen mainScreen].bounds.size.width - view.frame.size.width)*0.5;
            
            CGFloat centerX = [subiconsCenterPointsArray[arrayItemCounter] CGPointValue].x / 2;
            view.center = CGPointMake(centerX, [subiconsCenterPointsArray[arrayItemCounter] CGPointValue].y);
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                            initWithTarget:self
                                                            action:@selector(captionTypeSubiconDidClickWithGestureRecognizer:)];
            [view addGestureRecognizer:tapGestureRecognizer];
            
            arrayItemCounter++;
        }
    } else {
        NSArray<NSValue *> *subiconsCenterPointsArray = [self subiconsImageViewCenterPointsArray];
        NSInteger arrayItemCounter = 0;
        for (UIView *view in @[_captionDefaultTypeImageView,
                               _captionWithoutBackgroundTypeImageView,
                               _captionYellowBoxTypeImageView]) {
            view.center = [subiconsCenterPointsArray[arrayItemCounter] CGPointValue];
            arrayItemCounter++;
        }
        
        CGFloat sumCalc = _captionDefaultTypeImageView.frame.size.width +
        _captionWithoutBackgroundTypeImageView.frame.size.width +
        _captionYellowBoxTypeImageView.frame.size.width;
        
        CGRect fr = CGRectMake((self.frame.size.width - (sumCalc + 20))/2,
                               _captionDefaultTypeImageView.frame.origin.y,
                               _captionDefaultTypeImageView.frame.size.width, 55);
        
        _captionDefaultTypeImageView.frame = CGRectMake(fr.origin.x,
                                                        fr.origin.y + 5,
                                                        75,
                                                        40);
        
        CGFloat padding = 20;
        CGFloat viewW = self.captionDefaultTypeImageView.frame.size.width + padding;
        _captionWithoutBackgroundTypeImageView.frame = CGRectMake(fr.origin.x + viewW,
                                                                  fr.origin.y - 10,
                                                                  31,
                                                                  73);
        
        CGFloat xPos = fr.origin.x + viewW + _captionYellowBoxTypeImageView.frame.size.width + padding;
        
        _captionYellowBoxTypeImageView.frame = CGRectMake(xPos,
                                                          fr.origin.y + 2,
                                                          45,
                                                          45);
        
        if (self.currentCaptionType == CaptionTypeYellowBox) {
            CGRect fr = _captionDefaultTypeImageView.frame;
            fr.origin.y = self.frame.size.height - fr.size.height;
            fr.origin.x -= padding;
            _captionDefaultTypeImageView.frame = fr;
            
            fr = _captionWithoutBackgroundTypeImageView.frame;
            fr.origin.y = self.frame.size.height - (fr.size.height - 18);
            fr.origin.x -= padding;
            _captionWithoutBackgroundTypeImageView.frame = fr;
            
            fr = _captionYellowBoxTypeImageView.frame;
            fr.origin.y = self.frame.size.height - fr.size.height;
            fr.origin.x -= padding;
            _captionYellowBoxTypeImageView.frame = fr;
        }
        
    }
    
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    pressGesture.minimumPressDuration = 0.2;
    
    [_captionWithoutBackgroundTypeImageView addGestureRecognizer:pressGesture];
}

- (void) handleLongPress :(UILongPressGestureRecognizer *) gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openFontsView" object:self.captionTextView.text];
    }
}

- (void)setupPlusSubiconsImageView {
    //    CGRect rootFrame = self.frame;
    //    UIImage *plusImage = [UIImage imageNamed:@"plus-subicon"];
    //    if (!_plusImageView) {
    //        _plusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rootFrame.size.width - 20,
    //                                                                       -CAPTION_INNER_OFFSET + 10,
    //                                                                       plusImage.size.width / 10,
    //                                                                       plusImage.size.height / 10)];
    //        _plusImageView.image = plusImage;
    //        _plusImageView.userInteractionEnabled = YES;
    //        _plusImageView.alpha = 0.0;
    //        _plusImageView.backgroundColor = [UIColor clearColor];
    //
    //        UITapGestureRecognizer *plusTapgestureRecognizer = [[UITapGestureRecognizer alloc]
    //                                                            initWithTarget:self
    //                                                            action:@selector(plusIconDidClickWithGestureRecognizer:)];
    //        [_plusImageView addGestureRecognizer:plusTapgestureRecognizer];
    //    } else {
    //        _plusImageView.frame = CGRectMake(rootFrame.size.width - 20,
    //                                          -CAPTION_INNER_OFFSET + 10,
    //                                          plusImage.size.width / 10,
    //                                          plusImage.size.height / 10);
    //    }
}

- (void)setupCaptionBackgroundImageViewWithCaptionType:(CaptionObjectType)captionType {
    CGRect rootFrame = self.frame;
    rootFrame.size.height = 50;
    rootFrame.origin.y = self.frame.size.height - rootFrame.size.height;
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:rootFrame];
    } else {
        _backgroundImageView.frame = rootFrame;
    }
    _backgroundImageView.image = nil;
    switch (captionType) {
        case CaptionTypeDefault:
            _backgroundImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            break;
            
        case CaptionTypeTextWithoutBackgroun:
            _backgroundImageView.backgroundColor = [UIColor clearColor];
            break;
            
        case CaptionTypeYellowBox:
            _backgroundImageView.image = [UIImage imageNamed:@"yellow-box-background"];
            _backgroundImageView.backgroundColor = [UIColor clearColor];
            break;
    }
}

- (void)setupCaptionTextViewForType:(CaptionObjectType)captionType {
    CGRect textViewRectForType = [self captionTextViewRectForType:captionType];
    if (!_captionTextView) {
        _captionTextView = [[UITextView alloc] initWithFrame:textViewRectForType];
        _captionTextView.backgroundColor = [UIColor clearColor];
        _captionTextView.text = @"";
        _captionTextView.editable = YES;
        _captionTextView.scrollEnabled = NO;
        _captionTextView.delegate = self;
    } else {
        [_captionTextView setFrame:textViewRectForType];
    }
    
    _captionTextView.font = [self captionTextViewFontForType:captionType];
    _captionTextView.textColor = [self captiontextViewTextColorForType:captionType];
    
    if (captionType == CaptionTypeYellowBox) {
        _captionTextView.textContainer.maximumNumberOfLines = 2;
        _captionTextView.textAlignment = NSTextAlignmentLeft;
    } else {
        _captionTextView.textContainer.maximumNumberOfLines = 1;
        _captionTextView.textAlignment = NSTextAlignmentCenter;
    }
}

#pragma mark - UI utils methods

- (UIColor *)captiontextViewTextColorForType:(CaptionObjectType)captionType {
    UIColor *textColor = [UIColor blackColor];
    if (captionType == CaptionTypeTextWithoutBackgroun) {
        textColor = [UIColor whiteColor];
    } else if (captionType == CaptionTypeYellowBox) {
        textColor = [UIColor blackColor];
    }
    return textColor;
}

- (UIFont *)captionTextViewFontForType:(CaptionObjectType)captionType {
    UIFont *resultFont = [UIFont systemFontOfSize:12];
    switch (captionType) {
        case CaptionTypeDefault:
            resultFont = [UIFont fontWithName:@"AvenirNext-Regular" size:21];
            break;
            
        case CaptionTypeYellowBox:
            resultFont = [UIFont fontWithName:@"AvenirNext-Medium" size:21];
            break;
            
        case CaptionTypeTextWithoutBackgroun:
            resultFont = [UIFont fontWithName:@"AvenirNext-Bold" size:40];
            break;
    }
    
    return resultFont;
}

- (CGRect)captionTextViewRectForType:(CaptionObjectType)captionType {
    return _backgroundImageView.frame;
}

- (NSInteger)textCharacterForType:(CaptionObjectType)captionType {
    NSInteger characterLimit = 0;
    switch (captionType) {
        case CaptionTypeDefault:
        case CaptionTypeYellowBox:
            characterLimit = 40;
            break;
            
        case CaptionTypeTextWithoutBackgroun:
            characterLimit = 17;
            break;
    }
    return characterLimit;
}

- (void)showPlusIcon {
    [self animatePlusIconsFromAlpha:0
                          fromScale:CGAffineTransformMakeScale(0.4, 0.4)
                            toAlpha:1
                            toScale:CGAffineTransformMakeScale(1, 1)];
}

- (void)hidePlusIcon {
    [self animatePlusIconsFromAlpha:1
                          fromScale:CGAffineTransformMakeScale(0.4, 0.4)
                            toAlpha:0
                            toScale:CGAffineTransformMakeScale(1, 1)];
}

- (void)animatePlusIconsFromAlpha:(CGFloat)fromAlpha
                        fromScale:(CGAffineTransform)fromScale
                          toAlpha:(CGFloat)toAlpha
                          toScale:(CGAffineTransform)toScale {
    dispatch_async(dispatch_get_main_queue(), ^{
        _plusImageView.alpha = fromAlpha;
        _plusImageView.transform = fromScale;
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             _plusImageView.alpha = toAlpha;
                             _plusImageView.transform = toScale;
                         }
                         completion:nil];
    });
}

- (NSArray<NSValue *> *)subiconsImageViewCenterPointsArray {
    CGFloat iconsOffset = 35;
    
    CGPoint yellowBoxImageViewCenterPoint = CGPointMake(([UIScreen mainScreen].bounds.size.width / 2.0) + iconsOffset, 5);
    CGPoint withoutBackgroundImageViewCenterPoint = CGPointMake(yellowBoxImageViewCenterPoint.x - iconsOffset, yellowBoxImageViewCenterPoint.y);
    CGPoint defaultImageViewCenterPoint = CGPointMake(withoutBackgroundImageViewCenterPoint.x - iconsOffset - 5, withoutBackgroundImageViewCenterPoint.y);
    
    return @[[NSValue valueWithCGPoint:defaultImageViewCenterPoint],
             [NSValue valueWithCGPoint:withoutBackgroundImageViewCenterPoint],
             [NSValue valueWithCGPoint:yellowBoxImageViewCenterPoint]];
}

- (void)showCaptionSubicons {
    [self animateCaptionSubiconsFromAlpha:0
                                fromScale:CGAffineTransformMakeScale(0.2, 0.2)
                                  toAlpha:1
                                  toScale:CGAffineTransformMakeScale(1, 1)];
}

- (void)hideCaptionSubicons {
    [self animateCaptionSubiconsFromAlpha:1
                                fromScale:CGAffineTransformMakeScale(1, 1)
                                  toAlpha:0
                                  toScale:CGAffineTransformMakeScale(0.2, 0.2)];
}

- (void)animateCaptionSubiconsFromAlpha:(CGFloat)fromAlpha
                              fromScale:(CGAffineTransform)fromScale
                                toAlpha:(CGFloat)toAlpha
                                toScale:(CGAffineTransform)toScale {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        CGFloat padding = 0;
        for (UIView *view in @[_captionDefaultTypeImageView, _captionWithoutBackgroundTypeImageView,
                               _captionYellowBoxTypeImageView]) {
            view.alpha = fromAlpha;
            view.transform = fromScale;
            
            //            CGRect fr = view.frame;
            //            fr.origin.x = padding + (([UIScreen mainScreen].bounds.size.width - view.frame.size.width) / 2.0);
            //            padding = fr.size.width + 15;
            //
            //            view.frame = fr;
        }
        
        [UIView animateWithDuration:0.4
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             for (UIView *view in @[_captionDefaultTypeImageView, _captionWithoutBackgroundTypeImageView,
                                                    _captionYellowBoxTypeImageView]) {
                                 view.alpha = toAlpha;
                                 view.transform = toScale;
                             }
                         }
                         completion:nil];
    });
}

#pragma mark -

- (void)startPlusIconAppearanceTimerWithDuration:(NSTimeInterval)duration {
    if (_subiconsAppearanceTimer && _subiconsAppearanceTimer.valid) {
        [_subiconsAppearanceTimer invalidate];
    }
    _subiconsAppearanceTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                                target:self
                                                              selector:@selector(plusIconWillShow:)
                                                              userInfo:nil
                                                               repeats:NO];
}

#pragma mark - Public Interface

- (void)setCurrentCaptionType:(CaptionObjectType)currentCaptionType {
    if (currentCaptionType != _currentCaptionType) {
        _currentCaptionType = currentCaptionType;
    }
    
    [self setupCaptionBackgroundImageViewWithCaptionType:_currentCaptionType];
    [self setupCaptionTextViewForType:_currentCaptionType];
    [self setupSubiconsImageViews];
}

- (void)setCaptionText:(NSString *)text {
    if (!_captionTextView) {
        return;
    }
    _captionTextView.text = text;
}

- (void)showCaptionTypeIcons {
    [self startPlusIconAppearanceTimerWithDuration:6];
    [self showCaptionSubicons];
}

- (void)activateTextField {
    if (!_captionTextView) {
        return;
    }
    [_captionTextView becomeFirstResponder];
}

- (void)deactivateTextField {
    if (!_captionTextView) {
        return;
    }
    [_captionTextView resignFirstResponder];
}

- (void)stopShowingCaptionTypeIcons {
    if (_subiconsAppearanceTimer && _subiconsAppearanceTimer.valid) {
        [_subiconsAppearanceTimer invalidate];
    }
    [_captionTextView resignFirstResponder];
}

#pragma mark - Actions Handlers

- (void)plusIconDidClickWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    //    [self showCaptionTypeIcons];
    //    [self hidePlusIcon];
    [self hideCaptionSubicons];
}

- (void)captionTypeSubiconDidClickWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognier {
    if (!_captionDelegate) {
        return;
    }
    CaptionObjectType selectedType = (CaptionObjectType) gestureRecognier.view.tag;
    NSString *currentText = @"";
    if (_captionTextView && _captionTextView.text.length > 0) {
        currentText = _captionTextView.text;
    }
    [_captionDelegate captionTypeSubiconDidClickWithSelectedCaptionType:selectedType
                                                         andCurrentText:currentText
                                                  forCurrentCaptionView:self
                                                            andRootView:self.superview];
    
}

- (void)plusIconWillShow:(id)sender {
    [self showCaptionSubicons];
    //    [self showPlusIcon];
}

#pragma mark - UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger textCharacterLimitForCurrentType = [self textCharacterForType:_currentCaptionType];
    if ([[text lastPathComponent] isEqualToString:@"\n"]) { // tapped return key
        [textView resignFirstResponder];
    }
    
    return !(textView.text.length > textCharacterLimitForCurrentType && text.length > range.length);
}

- (void)textViewDidChange:(UITextView *)textView {
    if (_captionTextDelegate) {
        [_captionTextDelegate captionTextDidChange:textView.text];
    }
}

@end
