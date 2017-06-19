//
//  CMCBubbleView.m
//  ComicingGif
//
//  Created by Ahmed Sulaiman on 6/5/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CMCBubbleView.h"

#define TEXT_INNER_PADDING 90
#define TEXT_INNER_CENTER_OFFSET 30
#define TEXT_CHARACTER_LIMIT 28
#define TEXT_CHARACTER_LIMIT_FOR_BIG_FONT 7

#define PLUS_OFFSET 50
#define SUBICON_OFFSET 50

@interface CMCBubbleView() <UITextViewDelegate>

typedef NS_ENUM(NSInteger, CMCBubbleSubiconTag) {
    CMCBubbleStarTag,
    CMCBubbleSleepTag,
    CMCBubbleThinkTag,
    CMCBubbleScaryTag,
    CMCBubbleHeartTag,
    CMCBubbleAngryTag
};

@property (nonatomic) UIImageView *bubbleImageView;
@property (nonatomic) UITextView *bubbleTextView;

@property (nonatomic) UIImageView *plusImageView;

@property (nonatomic) UIImageView *starBubbleTypeIcon;
@property (nonatomic) UIImageView *sleepBubbleTypeIcon;
@property (nonatomic) UIImageView *thinkBubbleTypeIcon;
@property (nonatomic) UIImageView *scaryBubbleTypeIcon;
@property (nonatomic) UIImageView *heartBubbleTypeIcon;
@property (nonatomic) UIImageView *angryBubbleTypeIcon;

@property (nonatomic) NSTimer *subiconsAppearanceTimer;

@end

@implementation CMCBubbleView

- (instancetype)initWithFrame:(CGRect)frame andBubbleDirection:(BubbleObjectDirection)bubbleDirection {
    CGRect newFrame = CGRectMake(frame.origin.x,
                                 frame.origin.y,
                                 frame.size.width + BUBBLE_ROOT_VIEW_OFFSET,
                                 frame.size.height + BUBBLE_ROOT_VIEW_OFFSET);
    
    self = [super initWithFrame:newFrame];
    if (!self) {
        return nil;
    }
    self.currentBubbleDirection = bubbleDirection;
    
    [self setupBubbleImageViewWithFrame:frame];
    [self setupBubbleTextViewWithFrame:frame];
    [self setupSubiconsImageViewsWithFrame:frame];
    
    [self addSubview:_bubbleImageView];
    [self addSubview:_bubbleTextView];
    [self addSubview:_plusImageView];
    
    // Add bubble's subicons as a subviews
    for (UIView *view in @[_starBubbleTypeIcon, _sleepBubbleTypeIcon,
                           _thinkBubbleTypeIcon, _scaryBubbleTypeIcon,
                           _heartBubbleTypeIcon, _angryBubbleTypeIcon]) {
        [self addSubview:view];
        [self bringSubviewToFront:view];
    }
    return self;
}

#pragma mark - View setup methods

- (void)setupBubbleImageViewWithFrame:(CGRect)frame {
    _bubbleImageView = [[UIImageView alloc] initWithFrame:frame];
    CGPoint bubbleImageViewOrigin = [self bubbleImageViewOriginPointForDirection:_currentBubbleDirection forType:_currentBubbleType];
    [_bubbleImageView setFrame:CGRectMake(bubbleImageViewOrigin.x, bubbleImageViewOrigin.y, frame.size.width, frame.size.height)];
    
    _bubbleImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bubbleImageView.userInteractionEnabled = YES;
    
    _bubbleImageView.backgroundColor = [UIColor clearColor];    
}

- (void)setupBubbleTextViewWithFrame:(CGRect)frame {
    CGSize bubbleTextViewSize = [self bubbleTextViewSizeForBubbleType:_currentBubbleType];
    _bubbleTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   bubbleTextViewSize.width,
                                                                   bubbleTextViewSize.height)];
    _bubbleTextView.center = [self bubbleTextViewCenterPointForDirection:_currentBubbleDirection
                                                           andBubbleType:_currentBubbleType];
    
    _bubbleTextView.backgroundColor = [UIColor clearColor];
    
    _bubbleTextView.text = @"";
    _bubbleTextView.editable = YES;
    _bubbleTextView.scrollEnabled = NO;
    _bubbleTextView.textColor = [UIColor blackColor];
    _bubbleTextView.textAlignment = NSTextAlignmentCenter;
    _bubbleTextView.font = [self defaultBigFont];
    _bubbleTextView.delegate = self;
}

- (void)setupSubiconsImageViewsWithFrame:(CGRect)frame {
    [self setupPlusSubiconImageView];
    [self setupBubbleTypesSubiconImageViewsWithFrame:frame];
}

- (void)setupPlusSubiconImageView {
    UIImage *plusImage = [UIImage imageNamed:@"plus-subicon"];
    CGPoint plusIconOriginPoint = [self plusImageViewOriginPointForDirection:_currentBubbleDirection
                                                               andBubbleType:_currentBubbleType
                                                               withImageSize:plusImage.size];
    _plusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(plusIconOriginPoint.x,
                                                                   plusIconOriginPoint.y,
                                                                   plusImage.size.width / 7,
                                                                   plusImage.size.height / 7)];
    _plusImageView.image = plusImage;
    _plusImageView.userInteractionEnabled = YES;
    _plusImageView.alpha = 0.0;
    _plusImageView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *plusTapgestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(plusIconDidClickWithGestureRecognizer:)];
    [_plusImageView addGestureRecognizer:plusTapgestureRecognizer];
}

- (void)setupBubbleTypesSubiconImageViewsWithFrame:(CGRect)rootFrame {
    UIImage *starImage = [UIImage imageNamed:@"star-subicon"];
    UIImage *sleepImage = [UIImage imageNamed:@"zzz-subicon"];
    UIImage *thinkImage = [UIImage imageNamed:@"thinking-subicon"];
    UIImage *scaryImage = [UIImage imageNamed:@"scary-subicon"];
    UIImage *heartImage = [UIImage imageNamed:@"heart-subicon"];
    UIImage *angryImage = [UIImage imageNamed:@"angry-subicon"];
    NSArray<UIImage *> *bubbleTypesImagesArray = @[starImage, sleepImage,
                                                   thinkImage, scaryImage,
                                                   heartImage, angryImage];
    
    _starBubbleTypeIcon = [[UIImageView alloc] initWithImage:starImage];
    _sleepBubbleTypeIcon = [[UIImageView alloc] initWithImage:sleepImage];
    _thinkBubbleTypeIcon = [[UIImageView alloc] initWithImage:thinkImage];
    _scaryBubbleTypeIcon = [[UIImageView alloc] initWithImage:scaryImage];
    _heartBubbleTypeIcon = [[UIImageView alloc] initWithImage:heartImage];
    _angryBubbleTypeIcon = [[UIImageView alloc] initWithImage:angryImage];
    
    NSArray<NSNumber *> *bubbleTypeTagsArray = @[@(CMCBubbleStarTag), @(CMCBubbleSleepTag),
                                                 @(CMCBubbleThinkTag), @(CMCBubbleScaryTag),
                                                 @(CMCBubbleHeartTag), @(CMCBubbleAngryTag)];
    
    NSArray<NSValue *> *subiconsCenterPointsArray = [self subiconsImageViewCenterPointsArrayForDirection:_currentBubbleDirection
                                                                                           andBubbleType:_currentBubbleType];
    CGFloat imageScaleFactor = 9;
    NSInteger arrayItemCounter = 0;
    for (UIView *view in @[_starBubbleTypeIcon, _sleepBubbleTypeIcon,
                            _thinkBubbleTypeIcon, _scaryBubbleTypeIcon,
                            _heartBubbleTypeIcon, _angryBubbleTypeIcon]) {
        UIImage *image = bubbleTypesImagesArray[arrayItemCounter];
        view.alpha = 0.0;
        [view setUserInteractionEnabled:YES];
        
        CGFloat viewWidth = image.size.width / imageScaleFactor;
        CGFloat viewHeight = image.size.height / imageScaleFactor;
        [view setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        view.tag = (CMCBubbleSubiconTag) [bubbleTypeTagsArray[arrayItemCounter] integerValue];
        view.center = [subiconsCenterPointsArray[arrayItemCounter] CGPointValue];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(bubbleTypeSubiconDidClickWithGestureRecognizer:)];
        [view addGestureRecognizer:tapGestureRecognizer];
        
        arrayItemCounter++;
    }
}

#pragma mark - View helpers methods

- (NSArray<NSValue *> *)subiconsImageViewCenterPointsArrayForDirection:(BubbleObjectDirection)direction
                                                         andBubbleType:(BubbleObjectType)type {
    CGRect rootFrame = _bubbleImageView.frame;
    CGPoint starImageViewCenterPoint = CGPointZero;
    CGPoint sleepImageViewCenterPoint = CGPointZero;
    CGPoint thinkImageViewCenterPoint = CGPointZero;
    CGPoint scaryImageViewCenterPoint = CGPointZero;
    CGPoint heartImageViewCenterPoint = CGPointZero;
    CGPoint angryIageViewCenterPoint = CGPointZero;
    
    switch (type) {
        case BubbleTypeStar:
            switch (direction) {
                case BubbleDirectionUpperLeft:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2, 0);
                    break;
                    
                case BubbleDirectionBottomLeft:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width - SUBICON_OFFSET / 8, rootFrame.size.height / 2);
                    break;
                    
                case BubbleDirectionUpperRight:
                    starImageViewCenterPoint = CGPointMake(BUBBLE_ROOT_VIEW_OFFSET + rootFrame.size.width / 2 - SUBICON_OFFSET * 1.2, 0);
                    break;
                    
                case BubbleDirectionBottomRight:
                    starImageViewCenterPoint = CGPointMake(BUBBLE_ROOT_VIEW_OFFSET / 4 + rootFrame.size.width, rootFrame.size.height / 2);
                    break;
            }
            
            if (direction == BubbleDirectionUpperLeft || direction == BubbleDirectionUpperRight) {
                sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x + SUBICON_OFFSET,
                                                        SUBICON_OFFSET / 4);
                thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x + SUBICON_OFFSET,
                                                        SUBICON_OFFSET / 3);
                
                if (direction == BubbleDirectionUpperLeft) {
                    scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x + SUBICON_OFFSET,
                                                            SUBICON_OFFSET);
                } else {
                    scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x + SUBICON_OFFSET / 1.3,
                                                            SUBICON_OFFSET);
                }
                
                heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x,
                                                        SUBICON_OFFSET * 2);
                angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET/4,
                                                       SUBICON_OFFSET * 3);
            } else {
                sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x,
                                                        starImageViewCenterPoint.y + SUBICON_OFFSET);
                thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x - SUBICON_OFFSET / 4,
                                                        sleepImageViewCenterPoint.y + SUBICON_OFFSET);
                scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x - SUBICON_OFFSET,
                                                        thinkImageViewCenterPoint.y + SUBICON_OFFSET / 4);
                heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET,
                                                        scaryImageViewCenterPoint.y);
                angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET,
                                                       heartImageViewCenterPoint.y);
            }
            break;
            
        case BubbleTypeSleep:
        case BubbleTypeThink:
            switch (direction) {
                case BubbleDirectionUpperLeft:
                case BubbleDirectionUpperRight:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2 + SUBICON_OFFSET / 4,
                                                           SUBICON_OFFSET / 3);
                    break;
                    
                case BubbleDirectionBottomLeft:
                case BubbleDirectionBottomRight:
                    if (type == BubbleTypeThink) {
                        starImageViewCenterPoint = CGPointMake(rootFrame.size.width - SUBICON_OFFSET / 2,
                                                               rootFrame.size.height / 2 - SUBICON_OFFSET / 3);
                    } else {
                        starImageViewCenterPoint = CGPointMake(rootFrame.size.width - SUBICON_OFFSET / 1.5,
                                                               rootFrame.size.height / 2 - SUBICON_OFFSET / 3);
                    }
                    break;
            }
            
            if (direction == BubbleDirectionUpperLeft ||
                direction == BubbleDirectionUpperRight) {
                sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x + SUBICON_OFFSET,
                                                        SUBICON_OFFSET / 1.6);
                thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x + SUBICON_OFFSET / 1.5,
                                                        sleepImageViewCenterPoint.y + SUBICON_OFFSET / 1.4);
                if (type == BubbleTypeThink) {
                    scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x + SUBICON_OFFSET / 4,
                                                            thinkImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET / 14,
                                                            scaryImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                } else {
                    scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x,
                                                            thinkImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET / 8,
                                                            scaryImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                }
                angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET / 2,
                                                       heartImageViewCenterPoint.y + SUBICON_OFFSET / 1.4);
            } else {
                sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x,
                                                        starImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x - SUBICON_OFFSET / 6,
                                                        sleepImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x - SUBICON_OFFSET / 1.5,
                                                        thinkImageViewCenterPoint.y + SUBICON_OFFSET / 1.4);
                heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET / 1.2,
                                                        scaryImageViewCenterPoint.y + SUBICON_OFFSET / 6);
                if (type == BubbleTypeThink) {
                    angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET / 1.2,
                                                           heartImageViewCenterPoint.y - SUBICON_OFFSET / 14);
                } else {
                    angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET / 1.2,
                                                           heartImageViewCenterPoint.y - SUBICON_OFFSET / 8);
                }
            }
            break;
            
        case BubbleTypeScary:
            starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2 + SUBICON_OFFSET / 1.5,
                                                   SUBICON_OFFSET / 1.5);
            sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x + SUBICON_OFFSET / 1.4,
                                                    starImageViewCenterPoint.y + SUBICON_OFFSET / 1.5);
            thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x + SUBICON_OFFSET / 1.5,
                                                    sleepImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
            scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x,
                                                    thinkImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
            heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET / 3,
                                                    scaryImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
            
            angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET / 1.2,
                                                   heartImageViewCenterPoint.y + SUBICON_OFFSET / 3);
            break;
            
        case BubbleTypeHeart:
            switch (direction) {
                case BubbleDirectionUpperLeft:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2 + SUBICON_OFFSET / 2,
                                                           rootFrame.origin.y + SUBICON_OFFSET / 4);
                    sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x + SUBICON_OFFSET * 1.1,
                                                            starImageViewCenterPoint.y + SUBICON_OFFSET / 3.5);
                    thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x + SUBICON_OFFSET / 1.5,
                                                            sleepImageViewCenterPoint.y + SUBICON_OFFSET / 1.4);
                    scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x + SUBICON_OFFSET / 10,
                                                            thinkImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET / 2,
                                                            scaryImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET / 1.2,
                                                           heartImageViewCenterPoint.y + SUBICON_OFFSET / 2);
                    break;
                    
                case BubbleDirectionUpperRight:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2 - SUBICON_OFFSET / 4,
                                                           rootFrame.origin.y + SUBICON_OFFSET / 4);
                    sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x + SUBICON_OFFSET * 1.1,
                                                            starImageViewCenterPoint.y - SUBICON_OFFSET / 3);
                    thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x + SUBICON_OFFSET * 1.2,
                                                            sleepImageViewCenterPoint.y + SUBICON_OFFSET / 2);
                    scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x + SUBICON_OFFSET / 6,
                                                            thinkImageViewCenterPoint.y + SUBICON_OFFSET);
                    heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET / 6,
                                                            scaryImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    
                    angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET / 1.2,
                                                           heartImageViewCenterPoint.y + SUBICON_OFFSET / 1.5);
                    break;
                    
                case BubbleDirectionBottomLeft:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2 + SUBICON_OFFSET / 1.4,
                                                           rootFrame.origin.y + SUBICON_OFFSET / 3);
                    sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x + SUBICON_OFFSET,
                                                            starImageViewCenterPoint.y + SUBICON_OFFSET / 2);
                    thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x + SUBICON_OFFSET / 2,
                                                            sleepImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x - SUBICON_OFFSET / 8,
                                                            thinkImageViewCenterPoint.y + SUBICON_OFFSET / 1.1);
                    heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET / 1.6,
                                                            scaryImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET,
                                                           heartImageViewCenterPoint.y - SUBICON_OFFSET / 14);
                    break;
                    
                case BubbleDirectionBottomRight:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2 + SUBICON_OFFSET, rootFrame.origin.y + SUBICON_OFFSET / 2);
                    sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x + SUBICON_OFFSET,
                                                            starImageViewCenterPoint.y + SUBICON_OFFSET / 2);
                    thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x + SUBICON_OFFSET / 6,
                                                            sleepImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x,
                                                            thinkImageViewCenterPoint.y + SUBICON_OFFSET / 1.1);
                    heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET / 1.6,
                                                            scaryImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                    angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET,
                                                           heartImageViewCenterPoint.y + SUBICON_OFFSET / 14);
                    break;
            }
            break;
            
        case BubbleTypeAngry:
            switch (direction) {
                case BubbleDirectionUpperLeft:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2 + SUBICON_OFFSET / 6, rootFrame.origin.y - SUBICON_OFFSET / 6);
                    break;
                    
                case BubbleDirectionBottomLeft:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width - SUBICON_OFFSET / 8, rootFrame.size.height / 2);
                    break;
                    
                case BubbleDirectionUpperRight:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width / 2, rootFrame.origin.y - SUBICON_OFFSET / 6);
                    break;
                    
                case BubbleDirectionBottomRight:
                    starImageViewCenterPoint = CGPointMake(rootFrame.size.width - SUBICON_OFFSET / 8, rootFrame.size.height / 2);
                    break;
            }
            if (direction == BubbleDirectionUpperLeft || direction == BubbleDirectionUpperRight) {
                sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x + SUBICON_OFFSET,
                                                        starImageViewCenterPoint.y);
                thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x + SUBICON_OFFSET,
                                                        starImageViewCenterPoint.y + SUBICON_OFFSET / 6);
                
                scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x + SUBICON_OFFSET / 6,
                                                        thinkImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                
                heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x,
                                                        scaryImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
                angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x,
                                                       heartImageViewCenterPoint.y + SUBICON_OFFSET / 1.2);
            } else {
                sleepImageViewCenterPoint = CGPointMake(starImageViewCenterPoint.x,
                                                        starImageViewCenterPoint.y + SUBICON_OFFSET);
                thinkImageViewCenterPoint = CGPointMake(sleepImageViewCenterPoint.x - SUBICON_OFFSET / 6,
                                                        sleepImageViewCenterPoint.y + SUBICON_OFFSET);
                scaryImageViewCenterPoint = CGPointMake(thinkImageViewCenterPoint.x - SUBICON_OFFSET,
                                                        thinkImageViewCenterPoint.y + SUBICON_OFFSET / 4);
                heartImageViewCenterPoint = CGPointMake(scaryImageViewCenterPoint.x - SUBICON_OFFSET,
                                                        scaryImageViewCenterPoint.y);
                angryIageViewCenterPoint = CGPointMake(heartImageViewCenterPoint.x - SUBICON_OFFSET,
                                                       heartImageViewCenterPoint.y);
            }
            break;
    }
    
    return @[[NSValue valueWithCGPoint:starImageViewCenterPoint],
             [NSValue valueWithCGPoint:sleepImageViewCenterPoint],
             [NSValue valueWithCGPoint:thinkImageViewCenterPoint],
             [NSValue valueWithCGPoint:scaryImageViewCenterPoint],
             [NSValue valueWithCGPoint:heartImageViewCenterPoint],
             [NSValue valueWithCGPoint:angryIageViewCenterPoint]];
}

- (CGPoint)bubbleImageViewOriginPointForDirection:(BubbleObjectDirection)direction forType:(BubbleObjectType)type {
    CGRect rootFrame = self.frame;
    CGPoint bubbleImageViewOrigin = CGPointZero;
    switch (type) {
        case BubbleTypeStar:
            if (direction == BubbleDirectionUpperRight ||
                direction == BubbleDirectionBottomRight) {
                bubbleImageViewOrigin = CGPointMake(rootFrame.origin.x + PLUS_OFFSET / 1.4, rootFrame.origin.y);
            }
            break;
            
        case BubbleTypeSleep:
        case BubbleTypeThink:
        case BubbleTypeHeart:
        case BubbleTypeAngry:
            if (direction == BubbleDirectionUpperLeft ||
                direction == BubbleDirectionUpperRight) {
                bubbleImageViewOrigin = CGPointMake(rootFrame.origin.x, rootFrame.origin.y + PLUS_OFFSET / 1.4);
            }
            break;
            
        case BubbleTypeScary:
            bubbleImageViewOrigin = CGPointMake(rootFrame.origin.x, rootFrame.origin.y + PLUS_OFFSET / 1.4);
            break;
    }
    
    return bubbleImageViewOrigin;
}

- (CGPoint)plusImageViewOriginPointForDirection:(BubbleObjectDirection)direction
                                  andBubbleType:(BubbleObjectType)type
                                  withImageSize:(CGSize)imageSize {
    CGRect rootFrame = _bubbleImageView.frame;
    CGPoint plusImageViewOrigin = CGPointZero;
    switch (type) {
        case BubbleTypeStar:
            switch (direction) {
                case BubbleDirectionUpperLeft:
                    plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 1.4, rootFrame.size.height / 2 - imageSize.height / 14);
                    break;
                    
                case BubbleDirectionBottomLeft:
                    plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 2, rootFrame.size.height / 2 - imageSize.height / 14);
                    break;
                    
                case BubbleDirectionUpperRight:
                    plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 6, rootFrame.size.height / 2 - imageSize.height / 14);
                    break;
                    
                case BubbleDirectionBottomRight:
                    plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 1.5, rootFrame.size.height / 2 - imageSize.height / 14);
                    break;
            }
            break;
            
        case BubbleTypeSleep:
            if (direction == BubbleDirectionUpperLeft ||
                direction == BubbleDirectionUpperRight) {
                plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 2, rootFrame.origin.y + PLUS_OFFSET);
            } else {
                plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 2, rootFrame.origin.y + rootFrame.size.height / 2 + PLUS_OFFSET / 4);
            }
            break;
            
        case BubbleTypeThink:
            plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 3, rootFrame.origin.y + rootFrame.size.height / 2 - PLUS_OFFSET / 4);
            break;
            
        case BubbleTypeScary:
        case BubbleTypeHeart:
            plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 4, rootFrame.origin.y + rootFrame.size.height / 2 - PLUS_OFFSET / 3);
            break;
            
        case BubbleTypeAngry:
            plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 4, rootFrame.origin.y + rootFrame.size.height / 2 - PLUS_OFFSET / 4);
            switch (direction) {
                case BubbleDirectionUpperLeft:
                    plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 4, rootFrame.origin.y + rootFrame.size.height / 2 - PLUS_OFFSET / 4);
                    break;
                    
                case BubbleDirectionUpperRight:
                    plusImageViewOrigin = CGPointMake(0, rootFrame.origin.y + rootFrame.size.height / 2 - PLUS_OFFSET / 4);
                    break;
                    
                case BubbleDirectionBottomLeft:
                    plusImageViewOrigin = CGPointMake(PLUS_OFFSET / 6, rootFrame.origin.y + rootFrame.size.height / 2 + PLUS_OFFSET / 4);
                    break;
                    
                case BubbleDirectionBottomRight:
                    plusImageViewOrigin = CGPointMake(0, rootFrame.origin.y + rootFrame.size.height / 2 + PLUS_OFFSET / 4);
                    break;
            }
            break;
    }
    
    return plusImageViewOrigin;
}

- (CGSize)bubbleTextViewSizeForBubbleType:(BubbleObjectType)type {
    CGRect rootViewFrame = _bubbleImageView.frame;
    CGSize bubbleTextViewSize = CGSizeZero;
    
    switch (type) {
        case BubbleTypeStar:
            bubbleTextViewSize = CGSizeMake(rootViewFrame.size.width - TEXT_INNER_PADDING,
                                            rootViewFrame.size.height - TEXT_INNER_PADDING);
            break;
            
        case BubbleTypeSleep:
        case BubbleTypeThink:
        case BubbleTypeScary:
        case BubbleTypeHeart:            
            bubbleTextViewSize = CGSizeMake(rootViewFrame.size.width - TEXT_INNER_PADDING * 1.5,
                                            rootViewFrame.size.height - TEXT_INNER_PADDING);
            break;
            
        case BubbleTypeAngry:
            bubbleTextViewSize = CGSizeMake(rootViewFrame.size.width - TEXT_INNER_PADDING * 1.1,
                                            rootViewFrame.size.height - TEXT_INNER_PADDING);
            break;
    }
    
    return bubbleTextViewSize;
}

- (CGPoint)bubbleTextViewCenterPointForDirection:(BubbleObjectDirection)direction andBubbleType:(BubbleObjectType)type {
    CGPoint rootViewCenterPoint = _bubbleImageView.center;
    CGPoint bubbleTextViewCenterPoint = rootViewCenterPoint;
    switch (type) {
        case BubbleTypeStar:
            switch (direction) {
                case BubbleDirectionUpperLeft:
                    bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x + TEXT_INNER_CENTER_OFFSET,
                                                            rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET / 2);
                    break;
                    
                case BubbleDirectionBottomLeft:
                    bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x + TEXT_INNER_CENTER_OFFSET / 2,
                                                            rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET);
                    break;
                    
                case BubbleDirectionUpperRight:
                    bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x - TEXT_INNER_CENTER_OFFSET,
                                                            rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET / 2);
                    break;
                    
                case BubbleDirectionBottomRight:
                    bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x - TEXT_INNER_CENTER_OFFSET / 2,
                                                            rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET);
                    break;
            }
            break;
            
        case BubbleTypeSleep:
        case BubbleTypeThink:
            if (direction == BubbleDirectionUpperLeft ||
                direction == BubbleDirectionUpperRight) {
                bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x,
                                                        rootViewCenterPoint.y - TEXT_INNER_CENTER_OFFSET / 2.5);
            } else {
                bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x,
                                                        rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET / 1.5);
            }
            break;
            
        case BubbleTypeScary:
            bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x,
                                                    rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET / 3);
            break;
            
        case BubbleTypeHeart:
            if (direction == BubbleDirectionUpperLeft ||
                direction == BubbleDirectionUpperRight) {
                bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x,
                                                        rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET / 2.5);
            } else {
                bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x,
                                                        rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET / 3.5);
            }
            break;
            
        case BubbleTypeAngry:
            switch (direction) {
                case BubbleDirectionUpperLeft:
                    bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x + TEXT_INNER_CENTER_OFFSET / 6,
                                                            rootViewCenterPoint.y);
                    break;
                    
                case BubbleDirectionUpperRight:
                    bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x - TEXT_INNER_CENTER_OFFSET / 6,
                                                            rootViewCenterPoint.y);
                    break;
                    
                case BubbleDirectionBottomLeft:
                    bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x + TEXT_INNER_CENTER_OFFSET / 6,
                                                            rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET);
                    break;
                    
                case BubbleDirectionBottomRight:
                    bubbleTextViewCenterPoint = CGPointMake(rootViewCenterPoint.x - TEXT_INNER_CENTER_OFFSET / 4,
                                                            rootViewCenterPoint.y + TEXT_INNER_CENTER_OFFSET);
                    break;
            }
            break;
    }
    
    return bubbleTextViewCenterPoint;
}

- (UIFont *)defaultSmallFont {
    return [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
}

- (UIFont *)defaultBigFont {
    return [UIFont fontWithName:@"Arial Rounded MT Bold" size:35];
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

- (void)showBubbleSubicons {
    [self animateBubbleSubiconsFromAlpha:0
                               fromScale:CGAffineTransformMakeScale(0.2, 0.2)
                                 toAlpha:1
                                 toScale:CGAffineTransformMakeScale(1, 1)];
}

- (void)hideBubbleSubicons {
    [self animateBubbleSubiconsFromAlpha:1
                               fromScale:CGAffineTransformMakeScale(1, 1)
                                 toAlpha:0
                                 toScale:CGAffineTransformMakeScale(0.2, 0.2)];
}

- (void)animateBubbleSubiconsFromAlpha:(CGFloat)fromAlpha
                             fromScale:(CGAffineTransform)fromScale
                               toAlpha:(CGFloat)toAlpha
                               toScale:(CGAffineTransform)toScale {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *view in @[_starBubbleTypeIcon, _sleepBubbleTypeIcon,
                               _thinkBubbleTypeIcon, _scaryBubbleTypeIcon,
                               _heartBubbleTypeIcon, _angryBubbleTypeIcon]) {
            view.alpha = fromAlpha;
            view.transform = fromScale;
        }
        
        [UIView animateWithDuration:0.4
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             for (UIView *view in @[_starBubbleTypeIcon, _sleepBubbleTypeIcon,
                                                    _thinkBubbleTypeIcon, _scaryBubbleTypeIcon,
                                                    _heartBubbleTypeIcon, _angryBubbleTypeIcon]) {
                                 view.alpha = toAlpha;
                                 view.transform = toScale;
                             }
                         }
                         completion:nil];
    });
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

- (void)repositionSubviewsWithBubbleDirection:(BubbleObjectDirection)direction forBubbleType:(BubbleObjectType)bubbleType {
    if (!_bubbleImageView || !_bubbleTextView || !_plusImageView) {
        return;
    }
    
    CGPoint bubbleImageViewOrigin = [self bubbleImageViewOriginPointForDirection:direction
                                                                         forType:bubbleType];
    [_bubbleImageView setFrame:CGRectMake(bubbleImageViewOrigin.x, bubbleImageViewOrigin.y,
                                          _bubbleImageView.frame.size.width, _bubbleImageView.frame.size.height)];
    
    CGSize bubbleTextViewSize = [self bubbleTextViewSizeForBubbleType:_currentBubbleType];
    [_bubbleTextView setFrame:CGRectMake(0, 0, bubbleTextViewSize.width, bubbleTextViewSize.height)];
    _bubbleTextView.center = [self bubbleTextViewCenterPointForDirection:direction andBubbleType:bubbleType];
    
    CGPoint plusImageViewOriginPoint = [self plusImageViewOriginPointForDirection:direction
                                                                    andBubbleType:bubbleType
                                                                    withImageSize:_plusImageView.image.size];
    [_plusImageView setFrame:CGRectMake(plusImageViewOriginPoint.x,
                                        plusImageViewOriginPoint.y,
                                        _plusImageView.frame.size.width,
                                        _plusImageView.frame.size.height)];
    
    NSArray<NSValue *> *subiconsCenterPointsArray = [self subiconsImageViewCenterPointsArrayForDirection:direction
                                                                                           andBubbleType:bubbleType];
    int subiconCenterPointsCounter = 0;
    for (UIView *view in @[_starBubbleTypeIcon, _sleepBubbleTypeIcon,
                           _thinkBubbleTypeIcon, _scaryBubbleTypeIcon,
                           _heartBubbleTypeIcon, _angryBubbleTypeIcon]) {
        view.center = [subiconsCenterPointsArray[subiconCenterPointsCounter] CGPointValue];
        subiconCenterPointsCounter++;
    }
}

#pragma mark -

- (void)plusIconWillShow:(id)sender {
    [self hideBubbleSubicons];
    [self showPlusIcon];
}

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

#pragma mark - Gesture Handler

- (void)plusIconDidClickWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBubbleTypesIcons];
    [self hidePlusIcon];
}

- (void)bubbleTypeSubiconDidClickWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    if (!_bubbleDelegate) {
        return;
    }

    BubbleObjectType selectedBubbleObjectType = BubbleTypeAngry;
    CMCBubbleSubiconTag selectedViewTag = gestureRecognizer.view.tag;
    switch (selectedViewTag) {
        case CMCBubbleStarTag:
            selectedBubbleObjectType = BubbleTypeStar;
            break;
            
        case CMCBubbleSleepTag:
            selectedBubbleObjectType = BubbleTypeSleep;
            break;
            
        case CMCBubbleThinkTag:
            selectedBubbleObjectType = BubbleTypeThink;
            break;
            
        case CMCBubbleScaryTag:
            selectedBubbleObjectType = BubbleTypeScary;
            break;
            
        case CMCBubbleHeartTag:
            selectedBubbleObjectType = BubbleTypeHeart;
            break;
            
        case CMCBubbleAngryTag:
            selectedBubbleObjectType = BubbleTypeAngry;
            break;
    }
    
//    [_bubbleDelegate bubbleTypeSubiconDidClickWithSenderView:gestureRecognizer.view
//                                               andBubbleType:selectedBubbleObjectType];
    NSString *currentBubbleText = @"";
    if (_bubbleTextView) {
        currentBubbleText = _bubbleTextView.text;
    }
    [_bubbleDelegate bubbleTypeSubiconDidClickWithSelectedBubbleType:selectedBubbleObjectType
                                                      andCurrentText:currentBubbleText
                                                forCurrentBubbleView:self
                                                         andRootView:self.superview];
}

#pragma mark - Public Interface

- (void)activateTextField {
    if (!_bubbleTextView) {
        return;
    }
    
    [_bubbleTextView becomeFirstResponder];
}

- (void)stopShowingBubbleTypesIcons {
    if (_subiconsAppearanceTimer && _subiconsAppearanceTimer.valid) {
        [_subiconsAppearanceTimer invalidate];
    }
}

- (void)showBubbleTypesIcons {
    [self startPlusIconAppearanceTimerWithDuration:5];
    [self showBubbleSubicons];
}

- (void)setBubbleImage:(UIImage *)bubbleImage {
    [_bubbleImageView setImage:bubbleImage];
    [self repositionSubviewsWithBubbleDirection:_currentBubbleDirection
                                  forBubbleType:_currentBubbleType];
}

- (void)setBubbleText:(NSString *)bubbleText {
    [_bubbleTextView setText:bubbleText];
    [self textViewDidChange:_bubbleTextView];
}

- (void)setCurrentBubbleDirection:(BubbleObjectDirection)currentBubbleDirection {
    if (currentBubbleDirection == _currentBubbleDirection) {
        return;
    }
    _currentBubbleDirection = currentBubbleDirection;
    [self repositionSubviewsWithBubbleDirection:currentBubbleDirection
                                  forBubbleType:_currentBubbleType];
}

#pragma mark - UITextView Delegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return !(textView.text.length > TEXT_CHARACTER_LIMIT && text.length > range.length);
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length <= TEXT_CHARACTER_LIMIT_FOR_BIG_FONT) {
        textView.font = [self defaultBigFont];
    } else {
        textView.font = [self defaultSmallFont];
    }
    if (_bubbleTextDelegate) {
        [_bubbleTextDelegate bubbleTextDidChange:textView.text];
    }
}

@end
