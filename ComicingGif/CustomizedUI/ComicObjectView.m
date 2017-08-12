
//
//  ComicObjectView.m
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicObjectView.h"
#import "ObjectHeader.h"
#import <ImageIO/ImageIO.h>
#import "CMCBubbleView.h"
#import "CMCCaptionView.h"


#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif


@interface ComicObjectView() <CMCBubbleTextViewDelegate, CMCCaptionTextViewDelegate>
{
    UIPanGestureRecognizer *panGesture;
    UIRotationGestureRecognizer *rotateGesture;
    UIPinchGestureRecognizer *pinchGesture;
    
    NSMutableArray *arrayImages;
}
@end


// MARK: -
@implementation ComicObjectView

- (id)initWithComicObject:(BaseObject *)obj {
    self = [super init];
    if (!self) {
        return nil;
    }
    if (self.timerImageViews == nil) {
        self.timerImageViews = [NSMutableArray array];
    }
    
    self.delayTimeInSeconds = obj.delayTimeInSeconds;
    
    self.comicObject = obj;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    if (obj.objType == ObjectBaseImage) {
        UIImageView *imageView = [self createBaseImageView];
        [self.timerImageViews addObject:[[TimerImageViewStruct alloc]initWithImageView:imageView delayTime:self.delayTimeInSeconds andObjectType:obj.objType]];
        
    } else if (obj.objType == ObjectAnimateGIF) {
        [self createAnimationGIFView];
        [self addGestures];
        
    } else if (obj.objType == ObjectSticker) {
        UIImageView *imageView = [self createStickerView];
        [self.timerImageViews addObject:[[TimerImageViewStruct alloc]initWithImageView:imageView delayTime:self.delayTimeInSeconds andObjectType:obj.objType]];
        [self addGestures];
        
    } else if (obj.objType == ObjectBubble) {
        CMCBubbleView *bubbleView = [self createBubbleView];
        [self addGestures];
        
        TimerImageViewStruct *timerObject = [[TimerImageViewStruct alloc]initWithImageView:nil
                                                                                 delayTime:self.delayTimeInSeconds
                                                                             andObjectType:obj.objType];
        timerObject.view = bubbleView;
        [self.timerImageViews addObject:timerObject];
        
    } else if (obj.objType == ObjectCaption) {
        CMCCaptionView *captionView = [self createCaptionView];
        [self addGestures];
        
        TimerImageViewStruct *timerObject = [[TimerImageViewStruct alloc]initWithImageView:nil
                                                                                 delayTime:self.delayTimeInSeconds
                                                                             andObjectType:obj.objType];
        timerObject.view = captionView;
        [self.timerImageViews addObject:timerObject];
        
        
    } else if (obj.objType == ObjectPen) {
        UIImageView *penView = [self createPenView];
        
        TimerImageViewStruct *timerObject = [[TimerImageViewStruct alloc]initWithImageView:penView
                                                                                 delayTime:self.delayTimeInSeconds
                                                                             andObjectType:obj.objType];
        //        timerObject.view = penView;
        [self.timerImageViews addObject:timerObject];
    }
    
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.comicObject.scale, self.comicObject.scale);
    self.transform = CGAffineTransformRotate(self.transform, self.comicObject.angle);
    
    
    return self;
}

+ (UIImageView *)createListViewComicPenObjectViewsWithArray:(inout NSMutableArray<ComicObjectView *> *)penObjectViewsArray {
    UIImageView *allDrawingsImageView = [self createSingleImageViewFromDrawingsArray:penObjectViewsArray];
    return allDrawingsImageView;
}

+ (ComicObjectView *)createListViewComicCaptionObjectViewWithObject:(CaptionObject *)captionObject {
    ComicObjectView *captionObjectView = [[ComicObjectView alloc] initWithComicObject:captionObject];
    
    CMCCaptionView *captionView = (CMCCaptionView *) captionObjectView.subviews.firstObject;
    [captionView hidePlusIcon];
    [captionView hideCaptionSubicons];
    [captionView stopShowingCaptionTypeIcons];
    
    return captionObjectView;
}

+ (ComicObjectView *)createListViewComicBubbleObjectViewWithObject:(BubbleObject *)bubbleObject {
    BubbleObject *initialBubbleObject = [[BubbleObject alloc] initWithText:@""
                                                                  bubbleID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 1]
                                                             withDirection:BubbleDirectionUpperLeft];
    [initialBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 0]
                          forDirection:BubbleDirectionBottomRight];
    [initialBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 2]
                          forDirection:BubbleDirectionUpperRight];
    [initialBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 3]
                          forDirection:BubbleDirectionBottomLeft];
    [initialBubbleObject changeBubbleTypeTo:BubbleTypeStar];
    
    ComicObjectView *bubbleObjectView = [[ComicObjectView alloc] initWithComicObject:initialBubbleObject];
    bubbleObjectView.comicObject = bubbleObject;
    
    [bubbleObjectView setFrame:CGRectMake(bubbleObject.frame.origin.x,
                                          bubbleObject.frame.origin.y,
                                          bubbleObjectView.frame.size.width,
                                          bubbleObjectView.frame.size.height)];
    
    if (bubbleObject.scale != 1) {
        bubbleObjectView.transform = CGAffineTransformMakeScale(bubbleObject.scale, bubbleObject.scale);
    }
    
    [bubbleObjectView adjustBubbleDirectionWithBubbleViewCenter:bubbleObjectView.center
                                      withForceBubbleViewReload:YES];
    
    CMCBubbleView *bubbleView = (CMCBubbleView *) bubbleObjectView.subviews.firstObject;
    [bubbleView hidePlusIcon];
    [bubbleView hideBubbleSubicons];
    [bubbleView stopShowingBubbleTypesIcons];
    
    return bubbleObjectView;
}

+ (ComicObjectView *)createComicViewWith:(NSArray *)array delegate:(id)userInfo timerImageViews:(NSMutableArray *)timerImageViews {
    if (!array || !array.count) {
        NSLog(@"There is nothing comic objects");
        return nil;
    }
    
    // create background GIF from first object of comic object array
    ComicObjectView *backgroundView = [[ComicObjectView alloc] initWithComicObject:array.firstObject];
    
    NSMutableArray<ComicObjectView *> *penObjectsViewArray = [NSMutableArray new];
    
    NSMutableDictionary<NSNumber *, NSMutableArray<ComicObjectView *> *> *multiplePenObjecsDevidedByTimeDelay = [NSMutableDictionary new];
    
    if (backgroundView.timerImageViews != nil) {
        [timerImageViews addObjectsFromArray:backgroundView.timerImageViews];
    }
    
    for (NSInteger i = 1; i < array.count; i ++) {
        BaseObject *obj = array[i];
        ComicObjectView *comicView = [[ComicObjectView alloc] initWithComicObject:obj];
        comicView.parentView = backgroundView;
        comicView.delegate = userInfo;
        
        if (obj.objType == ObjectAnimateGIF) {
            comicView.animatedStickerStateDelegate = userInfo;
        }
        
        if (obj.objType == ObjectBubble) {
            BubbleObject *initialBubbleObject = [[BubbleObject alloc] initWithText:@""
                                                                          bubbleID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 1]
                                                                     withDirection:BubbleDirectionUpperLeft];
            [initialBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 0]
                                  forDirection:BubbleDirectionBottomRight];
            [initialBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 2]
                                  forDirection:BubbleDirectionUpperRight];
            [initialBubbleObject setResourceID:[NSString stringWithFormat:@"theme_bubble_%d_%d.png", 0, 3]
                                  forDirection:BubbleDirectionBottomLeft];
            [initialBubbleObject changeBubbleTypeTo:BubbleTypeStar];
            
            initialBubbleObject.delayTimeInSeconds = obj.delayTimeInSeconds;
            
            comicView = [[ComicObjectView alloc] initWithComicObject:initialBubbleObject];
            comicView.parentView = backgroundView;
            comicView.delegate = userInfo;
            comicView.comicObject = obj;
            
            [comicView setFrame:CGRectMake(obj.frame.origin.x,
                                           obj.frame.origin.y,
                                           comicView.frame.size.width,
                                           comicView.frame.size.height)];
            
            if (obj.scale != 1) {
                comicView.transform = CGAffineTransformMakeScale(obj.scale, obj.scale);
            }
            
            [comicView adjustBubbleDirectionWithBubbleViewCenter:comicView.center
                                       withForceBubbleViewReload:YES];
        }
        
        if (obj.objType == ObjectCaption) {
            CMCCaptionView *captionView = (CMCCaptionView *) comicView.subviews.firstObject;
            [captionView deactivateTextField];
        }
        if (obj.objType == ObjectBubble) {
            CMCBubbleView *bubbleView = (CMCBubbleView *) comicView.subviews.firstObject;
            [bubbleView deactivateTextField];
        }
        
        // For performance reasons it will be better to combine all drawings into single image view and add only this image view to the background
        if (obj.objType == ObjectPen) {
            [penObjectsViewArray addObject:comicView];
            // We don't need to add each drawing as a subview right away.
            
            
            NSNumber *currentKey = @(obj.delayTimeInSeconds);
            NSMutableArray<ComicObjectView *> *arrayForCurrentTimeDelay = [multiplePenObjecsDevidedByTimeDelay objectForKey:currentKey];
            if (!arrayForCurrentTimeDelay) {
                arrayForCurrentTimeDelay = [NSMutableArray new];
            }
            [arrayForCurrentTimeDelay addObject:comicView];
            [multiplePenObjecsDevidedByTimeDelay setObject:arrayForCurrentTimeDelay
                                                    forKey:currentKey];
            
            
            continue;
        }
        [backgroundView addSubview:comicView];
        
        
        if (comicView.timerImageViews != nil) {
            [timerImageViews addObjectsFromArray:comicView.timerImageViews];
        }
    }
    
    if (multiplePenObjecsDevidedByTimeDelay.count > 0) {
        
        for (NSNumber *timeDelayKey in multiplePenObjecsDevidedByTimeDelay.allKeys) {
            NSMutableArray *penViewForTimeDelayArray = [multiplePenObjecsDevidedByTimeDelay objectForKey:timeDelayKey];
            
            ComicObjectView *drawingObjectView = [self createSingleImageViewFromDrawingsArrayofPenViews:penViewForTimeDelayArray];
            
            if (backgroundView.subviews.count > 1) {
                [backgroundView insertSubview:drawingObjectView atIndex:1];
            } else {
                [backgroundView addSubview:drawingObjectView];
            }
            
            if (drawingObjectView.timerImageViews != nil) {
                [timerImageViews addObjectsFromArray:drawingObjectView.timerImageViews];
            }
        }
        
    }
    
    /*
     // Generate single image view with all drawings. Nil – if there is no drawings in current comics item
     UIImageView *allDrawingsImageView = [self createSingleImageViewFromDrawingsArray:penObjectsViewArray];
     if (allDrawingsImageView) {
     // The drawings should be under any other enhensment (like Stickers)
     // If there is any subview available – insert drawing at first index.
     // If there are no subviews – just add drawing in a regular way
     if (backgroundView.subviews.count > 1) {
     [backgroundView insertSubview:allDrawingsImageView atIndex:1];
     } else {
     [backgroundView addSubview:allDrawingsImageView];
     }
     }
     */
    
    return backgroundView;
}

- (void)playAnimate {
    UIView *view = [self viewWithTag:0x1000];
    if (view) {
        UIImageView *imgView = (UIImageView *)view;
        [imgView startAnimating];
    }
}

- (void)setDelegate:(id<ComicObjectViewDelegate>)delegate {
    _delegate = delegate;
    // Only for bubble objects we need to setup BubbleDelegate
    if (self.comicObject.objType == ObjectBubble) {
        if (self.subviews.count == 0) {
            return;
        }
        CMCBubbleView *bubbleView = (CMCBubbleView *) self.subviews.firstObject;
        if (_delegate && [_delegate conformsToProtocol:@protocol(CMCBubbleViewDelegate)]) {
            bubbleView.bubbleDelegate = (id<CMCBubbleViewDelegate>) _delegate;
        }
        return;
    }
    
    if (self.comicObject.objType == ObjectCaption) {
        if (self.subviews.count == 0) {
            return;
        }
        CMCCaptionView *captionView = (CMCCaptionView *) self.subviews.firstObject;
        
        if (_delegate && [_delegate conformsToProtocol:@protocol(CMCCaptionViewDelegate)]) {
            captionView.captionDelegate = (id<CMCCaptionViewDelegate>) _delegate;
        }
        //        if (_delegate && [_delegate conformsToProtocol:@protocol(CMCCaptionSecondaryTextDelegate)]) {
        //            captionView.captionSecondaryTextDelegate = (id<CMCCaptionSecondaryTextDelegate>) _delegate;
        //        }
        
        return;
    }
    
}

- (void)setComicObject:(BaseObject *)comicObject {
    _comicObject = comicObject;
    
    if (self.comicObject.objType == ObjectBubble) {
        // Only for bubble objects we need to change bubble image
        if (self.subviews.count == 0) {
            return;
        }
        CMCBubbleView *bubbleView = (CMCBubbleView *) self.subviews.firstObject;
        BubbleObject *bubbleObject = (BubbleObject *) comicObject;
        bubbleView.currentBubbleType = bubbleObject.currentType;
        [bubbleView setBubbleImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:bubbleObject.bubbleURL]]];
        [bubbleView setBubbleText: bubbleObject.text];
        return;
    }
    
    if (self.comicObject.objType == ObjectCaption) {
        if (self.subviews.count == 0) {
            return;
        }
        CMCCaptionView *captionView = (CMCCaptionView *) self.subviews.firstObject;
        CaptionObject *captionObject = (CaptionObject *) comicObject;
        
        CGFloat captionViewOffset = CAPTION_INNER_OFFSET;
        self.frame = CGRectMake(captionObject.frame.origin.x,
                                captionObject.frame.origin.y - captionViewOffset,
                                captionObject.frame.size.width,
                                captionObject.frame.size.height + captionViewOffset);
        captionView.frame = CGRectMake(0,
                                       captionViewOffset,
                                       captionObject.frame.size.width,
                                       captionObject.frame.size.height);
        
        captionView.currentCaptionType = captionObject.type;
        [captionView setCaptionText:captionObject.text];
        
        [captionView activateTextField];
        
        return;
    }
}

// MARK: - priviate create methods
- (UIImageView *)createBaseImageView {
    BkImageObject *obj = (BkImageObject *)self.comicObject;
    self.frame = obj.frame;
    
    NSString *fileName1 = [NSString stringWithFormat:@"%@",[obj.fileURL lastPathComponent]];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName1]];
    
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    UIImageView *imageView = [self createImageViewWith:data frame:self.bounds bAnimate:YES];
    
    return imageView;
}

- (void)createAnimationGIFView {
    StickerObject *obj = (StickerObject *)self.comicObject;
    self.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y, obj.frame.size.width+150, obj.frame.size.height+150);
    
    NSData *data = [NSData dataWithContentsOfURL:obj.stickerURL];
    /*
     real inside content view's size is less (40, 40) than object view. because it needs to show tool bar of all comic objects
     */
    CGRect stickerRect = CGRectMake(0, 0, obj.frame.size.width - W_PADDING +150, obj.frame.size.height - H_PADDING +150);
    [self createImageViewWith:data
                        frame:stickerRect
                     bAnimate:YES
                withAnimation:YES
                 isBackground:NO
          backgroundSuperview:nil
                 topLayerView:self];
}

- (UIImageView *)createStickerView {
    StickerObject *obj = (StickerObject *)self.comicObject;
    self.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y, obj.frame.size.width, obj.frame.size.height);
    
    NSData *data = [NSData dataWithContentsOfURL:obj.stickerURL];
    /*
     real inside content view's size is less (40, 40) than object view. because it needs to show tool bar of all comic objects
     */
    UIImageView *imageView = [self createImageViewWith:data frame:CGRectMake(0, 0, obj.frame.size.width - W_PADDING, obj.frame.size.height - H_PADDING) bAnimate:NO];
    
    return imageView;
}

- (CMCBubbleView *)createBubbleView {
    BubbleObject *bubbleObject = (BubbleObject *) self.comicObject;
    NSData *bubbleImageData = [NSData dataWithContentsOfURL:bubbleObject.bubbleURL];
    
    CGFloat bubbleWidth = (bubbleObject.frame.size.width / 2) - W_PADDING;
    CGFloat bubbleHeight = (bubbleObject.frame.size.height / 2) - H_PADDING;
    
    NSInteger bubbleInnerRootViewOffset = BUBBLE_ROOT_VIEW_OFFSET;
    self.frame = CGRectMake(bubbleObject.frame.origin.x,
                            bubbleObject.frame.origin.y,
                            bubbleWidth + bubbleInnerRootViewOffset,
                            bubbleHeight + bubbleInnerRootViewOffset);
    
    CMCBubbleView *bubbleView = [self createBubbleImageViewWithData:bubbleImageData
                                                         bubbleText:bubbleObject.text
                                                              frame:CGRectMake(0, 0, bubbleWidth, bubbleHeight)];
    return bubbleView;
}

- (CMCCaptionView *)createCaptionView {
    CaptionObject *captionObject = (CaptionObject *) self.comicObject;
    CGFloat captionViewOffset = CAPTION_INNER_OFFSET;
    self.frame = CGRectMake(captionObject.frame.origin.x,
                            captionObject.frame.origin.y - captionViewOffset,
                            captionObject.frame.size.width,
                            captionObject.frame.size.height + captionViewOffset);
    CMCCaptionView *captionView = [self createCaptionViewWithText:captionObject.text
                                                             type:captionObject.type
                                                         andFrame:CGRectMake(0, captionViewOffset,
                                                                             captionObject.frame.size.width,
                                                                             captionObject.frame.size.height)];
    if (captionObject.type == CaptionTypeTextWithoutBackgroun) {
        //        captionView.secondaryTextActivationTimeOffset = captionObject.secondaryTextActivationTimeOffset;
        //        captionView.primaryText = captionObject.primaryText;
        //        captionView.secondaryText = captionObject.secondaryText;
    }
    return captionView;
}

- (UIImageView *)createPenView {
    PenObject *penObject = (PenObject *) self.comicObject;
    self.frame = CGRectMake(penObject.frame.origin.x,
                            penObject.frame.origin.y,
                            penObject.frame.size.width,
                            penObject.frame.size.height);
    UIColor *color = penObject.color;
    CGFloat brushSize = penObject.brushSize;
    NSArray<NSValue *> *coordinates = penObject.coordinates;
    UIImageView *imageView = [self createDrawingWithCoordinates:coordinates
                                                          color:color
                                                   andBrushSize:brushSize];
    return imageView;
}


// MARK: - private methods
- (void)addGestures {
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    [self addGestureRecognizer:panGesture];
    
    if (self.comicObject.objType == ObjectCaption) {
        // We don't need pinch to zoom or rotatation gestures for Caption
        return;
    }
    
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)];
    [self addGestureRecognizer:pinchGesture];
    
    if (self.comicObject.objType == ObjectBubble) {
        // There is no need in rotation for bubbles.
        // Because bubble has it's own positioning system (bubble directions. See `BubbleObjectDirection` ENUM)
        return;
    }
    
    rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGestureHandler:)];
    [self addGestureRecognizer:rotateGesture];
}

- (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImageView *)createSingleImageViewFromDrawingsArray:(inout NSMutableArray<ComicObjectView *> *)penObjectsViewArray {
    
    if (!penObjectsViewArray || penObjectsViewArray.count == 0) {
        return nil;
    }
    
    ComicObjectView *firstComicObjectView = penObjectsViewArray.firstObject;
    
    UIImageView *finalDrawingImageView = [[UIImageView alloc] initWithFrame:firstComicObjectView.frame];
    
    UIGraphicsBeginImageContext(finalDrawingImageView.frame.size);
    [finalDrawingImageView.image drawInRect:CGRectMake(0, 0,
                                                       finalDrawingImageView.frame.size.width,
                                                       finalDrawingImageView.frame.size.height)
                                  blendMode:kCGBlendModeNormal
                                      alpha:1.0];
    for (ComicObjectView *drawingComicObjectView in penObjectsViewArray) {
        if (!drawingComicObjectView ||
            drawingComicObjectView.subviews.count != 1 ||
            ![drawingComicObjectView.subviews.firstObject isMemberOfClass:[UIImageView class]]) {
            continue;
        }
        UIImageView *drawingImageView = (UIImageView *) drawingComicObjectView.subviews.firstObject;
        
        [drawingImageView.image drawInRect:CGRectMake(0, 0,
                                                      drawingImageView.frame.size.width,
                                                      drawingImageView.frame.size.height)
                                 blendMode:kCGBlendModeNormal
                                     alpha:1.0];
        [drawingImageView removeFromSuperview];
    }
    finalDrawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [penObjectsViewArray removeAllObjects];
    
    return finalDrawingImageView;
}

+ (ComicObjectView *)createSingleImageViewFromDrawingsArrayofPenViews:(inout NSMutableArray<ComicObjectView *> *)penObjectsViewArray {
    
    if (!penObjectsViewArray || penObjectsViewArray.count == 0) {
        return nil;
    }
    
    ComicObjectView *firstComicObjectView = penObjectsViewArray.firstObject;
    
    UIImageView *finalDrawingImageView = [[UIImageView alloc] initWithFrame:firstComicObjectView.frame];
    
    UIGraphicsBeginImageContext(finalDrawingImageView.frame.size);
    [finalDrawingImageView.image drawInRect:CGRectMake(0, 0,
                                                       finalDrawingImageView.frame.size.width,
                                                       finalDrawingImageView.frame.size.height)
                                  blendMode:kCGBlendModeNormal
                                      alpha:1.0];
    for (ComicObjectView *drawingComicObjectView in penObjectsViewArray) {
        if (!drawingComicObjectView ||
            drawingComicObjectView.subviews.count != 1 ||
            ![drawingComicObjectView.subviews.firstObject isMemberOfClass:[UIImageView class]]) {
            continue;
        }
        UIImageView *drawingImageView = (UIImageView *) drawingComicObjectView.subviews.firstObject;
        
        [drawingImageView.image drawInRect:CGRectMake(0, 0,
                                                      drawingImageView.frame.size.width,
                                                      drawingImageView.frame.size.height)
                                 blendMode:kCGBlendModeNormal
                                     alpha:1.0];
        [drawingImageView removeFromSuperview];
    }
    finalDrawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [penObjectsViewArray removeAllObjects];
    
    
    //((UIImageView *)firstComicObjectView.subviews.firstObject).image = finalDrawingImageView.image;
    ComicObjectView *finalComicObjectView = [[ComicObjectView alloc]
                                             initWithComicObject:((PenObject *)firstComicObjectView.comicObject)]; //  objectAtIndex:penObjectsViewArray.count - 1
    if (finalComicObjectView.subviews > 0 && [finalComicObjectView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
        [finalComicObjectView.subviews.firstObject removeFromSuperview];
    }
    //    [finalComicObjectView addSubview:finalDrawingImageView];
    [finalComicObjectView addImageViewSubview:finalDrawingImageView withTimeDelay:firstComicObjectView.delayTimeInSeconds];
    
    
    return finalComicObjectView;
}

- (void)addImageViewSubview:(UIImageView *)view withTimeDelay:(CGFloat)timeDelay {
    [self addSubview:view];
    self.delayTimeInSeconds = timeDelay;
    TimerImageViewStruct *timerObject = [[TimerImageViewStruct alloc]initWithImageView:view
                                                                             delayTime:self.delayTimeInSeconds
                                                                         andObjectType:self.comicObject.objType];
    [self.timerImageViews addObject:timerObject];
}

- (UIImageView *)createDrawingWithCoordinates:(NSArray<NSValue *> *)coordinates
                                        color:(UIColor *)color
                                 andBrushSize:(CGFloat)brushSize {
    UIImageView *drawingImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:drawingImageView];
    
    if (coordinates.count < 2) {
        // There Should be at least 2 points in a single drawing object
        return nil;
    }
    
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    CGPoint lastPoint = [coordinates.firstObject CGPointValue];
    
    for (int i = 1; i < coordinates.count; i++) {
        CGPoint currentPoint = [coordinates[i] CGPointValue];
        
        UIGraphicsBeginImageContext(drawingImageView.frame.size);
        [drawingImageView.image drawInRect:CGRectMake(0, 0, drawingImageView.frame.size.width, drawingImageView.frame.size.height)];
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brushSize);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [drawingImageView setAlpha:1.0];
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
    
    UIGraphicsBeginImageContext(drawingImageView.frame.size);
    
    [drawingImageView.image drawInRect:CGRectMake(0, 0, drawingImageView.frame.size.width, drawingImageView.frame.size.height)
                             blendMode:kCGBlendModeNormal
                                 alpha:1.0];
    drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return drawingImageView;
}

- (CMCBubbleView *)createBubbleImageViewWithData:(NSData *)imageData bubbleText:(NSString *)text frame:(CGRect)frame {
    CMCBubbleView *bubbleView = [self createBubbleImageViewWithData:imageData
                                                         bubbleText:text
                                                              frame:frame
                                    shouldReloadBubbleViewDirection:NO];
    return bubbleView;
}

- (CMCBubbleView *)createBubbleImageViewWithData:(NSData *)imageData
                                      bubbleText:(NSString *)text
                                           frame:(CGRect)frame
                 shouldReloadBubbleViewDirection:(BOOL)shouldReloadBubbleViewDirection {
    
    BOOL shouldAddBubbleViewAsSubview = YES;
    CMCBubbleView *bubbleView;
    BubbleObjectDirection bubbleDirection = ((BubbleObject *) self.comicObject).currentDirection;
    if (self.subviews.count == 0) {
        bubbleView = [[CMCBubbleView alloc] initWithFrame:frame andBubbleDirection:bubbleDirection];
        bubbleView.bubbleTextDelegate = self;
    } else {
        bubbleView = (CMCBubbleView *) self.subviews.firstObject;
        shouldAddBubbleViewAsSubview = NO;
    }
    
    [bubbleView setBubbleImage:[UIImage imageWithData:imageData]];
    [bubbleView setBubbleText:text];
    
    if (bubbleView.currentBubbleDirection != bubbleDirection || shouldReloadBubbleViewDirection) {
        bubbleView.currentBubbleDirection = bubbleDirection;
    }
    
    if (shouldAddBubbleViewAsSubview) {
        [bubbleView removeFromSuperview];
        [self addSubview:bubbleView];
        [bubbleView showBubbleTypesIcons];
        [bubbleView activateTextField];
    }
    return bubbleView;
}

- (CMCCaptionView *)createCaptionViewWithText:(NSString *)text
                                         type:(CaptionObjectType)type
                                     andFrame:(CGRect)frame {
    BOOL shouldAddBubbleViewAsSubview = YES;
    CMCCaptionView *captionView;
    if (self.subviews.count == 0) {
        captionView = [[CMCCaptionView alloc] initWithFrame:frame andCaptionType:type];
        captionView.captionTextDelegate = self;
    } else {
        captionView = (CMCCaptionView *) self.subviews.firstObject;
        shouldAddBubbleViewAsSubview = NO;
    }
    [captionView setCaptionText:text];
    if (shouldAddBubbleViewAsSubview) {
        [captionView removeFromSuperview];
        [self addSubview:captionView];
        [captionView showCaptionTypeIcons];
        [captionView activateTextField];
    }
    return captionView;
}

- (void)createImageViewWith:(NSData *)data
                      frame:(CGRect)rect
                   bAnimate:(BOOL)flag
              withAnimation:(BOOL)shouldAnimate
               isBackground:(BOOL)isBackground
        backgroundSuperview:(__weak UIImageView *)backgroundSuperview
               topLayerView:(__weak UIView *)topLayerView {
    
    dispatch_queue_t const preloadQueue = dispatch_queue_create("preload-queue", DISPATCH_QUEUE_SERIAL);
    __weak ComicObjectView *weakSelf = self;
    
    dispatch_async(preloadQueue, ^{
        NSLog(@"Start new queue for image processing");
        CGImageSourceRef srcImage = CGImageSourceCreateWithData(toCF data, nil);
        if (!srcImage) {
            NSLog(@"loading image failed");
        }
        NSNumber *frameDuration;
        NSTimeInterval totalDuration = 0;
        size_t imgCount = CGImageSourceGetCount(srcImage);
        NSMutableArray *arrayImagesL = [NSMutableArray new];
        
        UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:rect];
        dispatch_async(dispatch_get_main_queue(), ^{
            resultImageView.autoresizingMask = 0B11111;
            resultImageView.userInteractionEnabled = YES;
            if (isBackground) {
                [backgroundSuperview insertSubview:resultImageView atIndex:0];
            } else {
                [weakSelf addSubview:resultImageView];
            }
        });
        
        for (NSInteger i = 0; i < imgCount; i += 2) {
            CGImageRef cgImg = CGImageSourceCreateImageAtIndex(srcImage, i, nil);
            if (!cgImg) {
                NSLog(@"loading %ldth image failed from the source", (long)i);
                continue;
            }
            
            UIImage *img = [[Global global] scaledImage:[UIImage imageWithCGImage:cgImg]
                                                   size:rect.size
                               withInterpolationQuality:kCGInterpolationDefault];
            
            if (!resultImageView.image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultImageView.image = img;
                });
            }
            
            [arrayImagesL addObject:img];
            NSDictionary *property = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(srcImage, i, nil));
            NSDictionary *gifDict = property[fromCF kCGImagePropertyGIFDictionary];
            frameDuration = gifDict[fromCF kCGImagePropertyGIFUnclampedDelayTime];
            if (!frameDuration) {
                frameDuration = gifDict[fromCF kCGImagePropertyGIFDelayTime];
            }
            totalDuration += frameDuration.floatValue * 2;
            CGImageRelease(cgImg);
        }
        
        if (srcImage != nil) {
            CFRelease(srcImage);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            resultImageView.image = arrayImages.firstObject;
            resultImageView.animationImages = arrayImagesL;
            resultImageView.animationDuration = totalDuration;
            resultImageView.animationRepeatCount = (flag == YES? 0 : 1);
            if (shouldAnimate) {
                [resultImageView startAnimating];
            }
            
            TimerImageViewStruct *timerImageView = [[TimerImageViewStruct alloc] initWithImageView:resultImageView
                                                                                         delayTime:weakSelf.delayTimeInSeconds
                                                                                     andObjectType:weakSelf.comicObject.objType];
            [weakSelf.timerImageViews addObject:timerImageView];
            
            [weakSelf executeAnimatedStickerStateDelegateForComicObjectView:weakSelf
                                                              withTimeDelay:weakSelf.delayTimeInSeconds
                                                              andBaseObject:weakSelf.comicObject];
        });
    });
}

- (UIImageView *)createImageViewWith:(NSData *)data frame:(CGRect)rect bAnimate:(BOOL)flag {
    CGImageSourceRef srcImage = CGImageSourceCreateWithData(toCF data, nil);
    if (!srcImage) {
        NSLog(@"loading image failed");
    }
    
    size_t imgCount = CGImageSourceGetCount(srcImage);
    NSTimeInterval totalDuration = 0;
    NSNumber *frameDuration;
    
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
    imgView.tag = 0x1000;
    [self addSubview:imgView];
    
    imgView.animationImages = arrayImages;
    imgView.animationDuration = totalDuration;
    imgView.animationRepeatCount = 1;//(flag == YES? 0 : 1);
    [imgView startAnimating];
    
    return imgView;
}

- (void)adjustBubbleDirectionWithBubbleViewCenter:(CGPoint)centerPoint {
    [self adjustBubbleDirectionWithBubbleViewCenter:centerPoint
                          withForceBubbleViewReload:NO];
}

- (void)adjustBubbleDirectionWithBubbleViewCenter:(CGPoint)centerPoint withForceBubbleViewReload:(BOOL)shouldReloadBubble {
    if (self.comicObject.objType != ObjectBubble) {
        return;
    }
    
    // TODO: Move those calculation to the initialization method.
    // We don't need to do them every time we need to determiine bubble direction
    UIScreen *currentScreen = [UIScreen mainScreen];
    CGRect screenBounds = currentScreen.bounds;
    CGFloat screenHalfWidth = screenBounds.size.width / 2;
    CGFloat screenHalfHeight = screenBounds.size.height / 2;
    CGRect upperLeftScreenSectionRect = CGRectMake(0, 0, screenHalfWidth, screenHalfHeight);
    CGRect upperRightScreenSectionRect = CGRectMake(screenHalfWidth, 0, screenHalfWidth, screenHalfHeight);
    CGRect bottomLeftScreenSectionRect = CGRectMake(0, screenHalfHeight, screenHalfWidth, screenHalfHeight);
    CGRect bottomRightScreenSectionRect = CGRectMake(screenHalfWidth, screenHalfHeight, screenHalfWidth, screenHalfHeight);
    
    BubbleObjectDirection currentBubbleDirection = ((BubbleObject *) self.comicObject).currentDirection;
    BubbleObjectDirection actualBubbleDirection = currentBubbleDirection;
    
    if (CGRectContainsPoint(upperLeftScreenSectionRect, centerPoint)) {
        actualBubbleDirection = BubbleDirectionUpperLeft;
    } else if (CGRectContainsPoint(upperRightScreenSectionRect, centerPoint)) {
        actualBubbleDirection = BubbleDirectionUpperRight;
    } else if (CGRectContainsPoint(bottomLeftScreenSectionRect, centerPoint)) {
        actualBubbleDirection = BubbleDirectionBottomLeft;
    } else if (CGRectContainsPoint(bottomRightScreenSectionRect, centerPoint)) {
        actualBubbleDirection = BubbleDirectionBottomRight;
    }
    
    if (actualBubbleDirection != currentBubbleDirection || shouldReloadBubble) {
        [((BubbleObject *) self.comicObject) switchBubbleURLToDirection:actualBubbleDirection];
        BubbleObject *bubbleObject = (BubbleObject *) self.comicObject;
        NSData *bubbleImageData = [NSData dataWithContentsOfURL:bubbleObject.bubbleURL];
        [self createBubbleImageViewWithData:bubbleImageData
                                 bubbleText:bubbleObject.text
                                      frame:bubbleObject.frame
            shouldReloadBubbleViewDirection:shouldReloadBubble];
    }
}

#pragma mark - Animated Sticker State Delegate Executor

- (void)executeAnimatedStickerStateDelegateForComicObjectView:(ComicObjectView *)comicObjectView
                                                withTimeDelay:(CGFloat)delay
                                                andBaseObject:(BaseObject *)object {
    if (!_animatedStickerStateDelegate) {
        return;
    }
    if (![_animatedStickerStateDelegate respondsToSelector:@selector(comicObjectView:didFinishRenderingWithDelayTime:andBaseObject:)]) {
        return;
    }
    [_animatedStickerStateDelegate comicObjectView:comicObjectView
                   didFinishRenderingWithDelayTime:delay
                                     andBaseObject:object];
}

// MARK: - gesture handler implementations
- (void)panGestureHandler:(UIPanGestureRecognizer *)gesture {
    UIGestureRecognizerState state = [gesture state];
    CGPoint point = [gesture locationInView:self.parentView];
    
    if (CGRectContainsRect(self.parentView.bounds, CGRectMake(point.x - 10, point.y - 10, 20, 20)) == true) {
        
        if (gesture.state == UIGestureRecognizerStateEnded) {
            CGPoint newCenter = CGPointMake(gesture.view.center.x + gesture.view.transform.tx,
                                            gesture.view.center.y + gesture.view.transform.ty);
            gesture.view.center = newCenter;
            
            CGAffineTransform theTransform = gesture.view.transform;
            theTransform.tx = 0.0f;
            theTransform.ty = 0.0f;
            gesture.view.transform = theTransform;
            return;
        }
        CGPoint translation = [gesture translationInView:gesture.view.superview];
        CGAffineTransform theTransform = gesture.view.transform;
        theTransform.tx = translation.x;
        theTransform.ty = translation.y;
        gesture.view.transform = theTransform;
        
        
        
        if (self.comicObject.objType == ObjectBubble) {
            self.comicObject.frame = CGRectMake(self.frame.origin.x,
                                                self.frame.origin.y,
                                                self.comicObject.frame.size.width,
                                                self.comicObject.frame.size.height);
        } else if (self.comicObject.objType == ObjectCaption) {
            self.comicObject.frame = CGRectMake(self.frame.origin.x,
                                                self.frame.origin.y,
                                                self.comicObject.frame.size.width,
                                                self.comicObject.frame.size.height);
        } else {
            self.comicObject.frame = self.frame;
        }
        [self.delegate saveObject];
        
    } else {
        if (state == UIGestureRecognizerStateEnded) {
            NSLog(@"removing object");
            [self.delegate removeObject:self];
        }
    }
    
    if (self.comicObject.objType != ObjectBubble) {
        // Only for bubble objects we need to adjust final resource image.
        // Depends on bubble position on the screen
        // Otherwise – return from this gesture handler
        return;
    }
    
    [self adjustBubbleDirectionWithBubbleViewCenter:gesture.view.center];
}

- (void)pinchGestureHandler:(UIPinchGestureRecognizer *)gesture {
    
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    [gesture setScale:1.0];
    
    self.comicObject.scale = gesture.view.transform.a;
    
    [self.delegate saveObject];
}

- (void)rotateGestureHandler:(UIRotationGestureRecognizer *)gesture {
    //    UIGestureRecognizerState state = [gesture state];
    
    //    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat rotation = [gesture rotation];
        [gesture.view setTransform:CGAffineTransformRotate(gesture.view.transform, rotation)];
        [gesture setRotation:0];
        
        self.comicObject.angle = atan2f(gesture.view.transform.b, gesture.view.transform.a);
        
        [self.delegate saveObject];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - CMCBubbleView Text Delegate

- (void)bubbleTextDidChange:(NSString *)text {
    if (self.comicObject.objType != ObjectBubble) {
        return;
    }
    BubbleObject *bubbleObject = (BubbleObject *) self.comicObject;
    bubbleObject.text = text;
    
    if (_delegate) {
        [_delegate saveObject];
    }
}

#pragma mark - CMCCaptionView Text Delegate

- (void)captionTextDidChange:(NSString *)text {
    if (self.comicObject.objType != ObjectCaption) {
        return;
    }
    CaptionObject *captionObject = (CaptionObject *) self.comicObject;
    captionObject.text = text;
    if (_delegate) {
        [_delegate saveObject];
    }
}

@end

