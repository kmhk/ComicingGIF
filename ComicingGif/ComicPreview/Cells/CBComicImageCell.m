//
//  CBComicImageCell.m
//  ComicBook
//
//  Created by Atul Khatri on 04/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBComicImageCell.h"
#import <ImageIO/ImageIO.h>

#import "BaseObject.h"
#import "BubbleObject.h"
#import "PenObject.h"
#import "ComicObjectView.h"
#import "CMCBubbleView.h"

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

#define discreteValueOfSeconds 0.01

#define W_H 45


@interface CBComicImageCell ()
{
	NSTimeInterval			bkGifDuration;
}
@end


@implementation CBComicImageCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 5.0f;
    
    if (_maxTimeOfFullAnimation < 3) {
        _maxTimeOfFullAnimation = 3;
    }
	
	bkGifDuration = 0;
}

- (void)createUIForCell:(CBComicImageCell *)cell withIndex:(NSInteger)index andFrame : (CGRect ) rect {
    _index = index;
    NSLog(@"\n\n\nCELLLLLLLLLLLLLLLLL B: %lu %@, CollFrame: %@", index, _comicItemModel.comicPage.subviews, NSStringFromCGRect(rect));
    for (UIView *view in [cell.topLayerView subviews]) {
        [view removeFromSuperview];
    }
    
    int kVerticalMargin = 10;
    NSMutableArray<ComicObjectView *> *penObjectsViewsArray = [NSMutableArray new];
    NSMutableDictionary<NSNumber *, NSMutableArray<ComicObjectView *> *> *multiplePenObjecsDevidedByTimeDelay = [NSMutableDictionary new];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGSize scales = CGSizeMake(cell.bounds.size.width / screenRect.size.width,
                               cell.bounds.size.height / screenRect.size.height);
    
    NSData *gifData = [self getGifDataFromFileName:_comicItemModel.comicPage.gifLayerPath];
    
    UIImageView *baseImageView = [self createImageViewWith:gifData frame:cell.baseLayerImageView.frame bAnimate:YES withAnimation:NO];
    [self setGifPropertiesOfImageView:baseImageView toNewImageView:cell.baseLayerImageView];
    
    if (baseImageView.animationImages.count > 1)//_comicItemModel.isBaseLayerGif)
    {
        // NEED to handle 3 layer
        
        TimerImageViewStruct *timerImageViewStruct = [[TimerImageViewStruct alloc]initWithImageView:cell.baseLayerImageView delayTime:0 andObjectType:ObjectAnimateGIF];
        [self.timerImageViews addObject:timerImageViewStruct];
        [self reCalculateMaxTimeWithDelay:timerImageViewStruct.delayTimeOfImageView andGifPlayTime:timerImageViewStruct.imageView.animationDuration];
        
//        cell.staticImageView.image = [AppHelper getImageFile:_comicItemModel.comicPage.printScreenPath];
        //-> Loop subviews and get animation sticker and static image.
        //animation sticker you can check like …
        int i = 0;
        for (NSDictionary* subview in _comicItemModel.comicPage.subviews) {
            
            NSLog(@"Subviews - %@",subview);
            if ([[[subview objectForKey:@"baseInfo"] objectForKey:@"type"]intValue]==17) {
                //Handle top layer that is sticker gif
                //                                ComicItemAnimatedSticker *sticker = [ComicItemAnimatedSticker new];
                CGRect frameOfObject = CGRectFromString([[subview objectForKey:@"baseInfo"] objectForKey:@"frame"]);
                
                //                sticker.combineAnimationFileName = [subview objectForKey:@"url"];
                
                NSBundle *bundle = [NSBundle mainBundle] ;
                NSString *strFileName = [[subview objectForKey:@"url"] lastPathComponent];
                NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".gif" withString:@""] ofType:@"gif"];;
                NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
                CGRect rectOfGif;
                //                sticker.image =  [UIImage sd_animatedGIFWithData:gifData];
                CGFloat ratioWidth; //ratio SlideView To ScreenSize
                CGFloat ratioHeight; //ratio SlideView To ScreenSize
                if (IS_IPHONE_5) {
                    ratioWidth = rect.size.width / 305;
                    ratioHeight = rect.size.height / 495.5;
                } else if (IS_IPHONE_6) {
                    ratioWidth = rect.size.width / 358;
                    ratioHeight = rect.size.height / 585;
                } else {
                    ratioWidth = rect.size.width / 395.333;
                    ratioHeight = rect.size.height / 648.333;
                }


                //                CGFloat ratioHeight = rect.size.height / SCREEN_HEIGHT;
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth) +5 , (frameOfObject.origin.y * ratioHeight) + 5, (frameOfObject.size.width * ratioWidth) - W_H /2, (frameOfObject.size.height * ratioHeight) - W_H/2);
                } else {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth) +5 , (frameOfObject.origin.y * ratioHeight) + 5, (frameOfObject.size.width * ratioWidth) - W_H, (frameOfObject.size.height * ratioHeight) - W_H);
                }
                i ++;
                
                CGFloat timerDelay = [[[subview objectForKey:@"baseInfo"] objectForKey:@"delayTime"] floatValue];
				CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"] floatValue];
                [self createImageViewWith:gifData
                                    frame:rectOfGif
                                 bAnimate:YES
                            withAnimation:NO
                             isBackground:NO
                      backgroundSuperview:nil
                             topLayerView:cell.topLayerView
                                withDelay:timerDelay
								withAngle:rotationAngle];
            }
            
            //18 is for static stickers
            if ([[[subview objectForKey:@"baseInfo"] objectForKey:@"type"]intValue] == 18) {
                CGRect frameOfObject = CGRectFromString([[subview objectForKey:@"baseInfo"] objectForKey:@"frame"]);
                
                NSBundle *bundle = [NSBundle mainBundle] ;
                NSString *strFileName = [[subview objectForKey:@"url"] lastPathComponent];
                NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".png" withString:@""] ofType:@"png"];
                NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
                CGRect rectOfGif;
                
                CGFloat ratioWidth; //ratio SlideView To ScreenSize
                CGFloat ratioHeight; //ratio SlideView To ScreenSize
                if (IS_IPHONE_5) {
                    ratioWidth = rect.size.width / 305;
                    ratioHeight = rect.size.height / 495.5;
                } else if (IS_IPHONE_6) {
                    ratioWidth = rect.size.width / 358;
                    ratioHeight = rect.size.height / 585;
                } else {
                    ratioWidth = rect.size.width / 395.333;
                    ratioHeight = rect.size.height / 648.333;
                }
                
                //                CGFloat ratioHeight = rect.size.height / SCREEN_HEIGHT;
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth) +5 , (frameOfObject.origin.y * ratioHeight) + 5, (frameOfObject.size.width * ratioWidth) - W_H /2, (frameOfObject.size.height * ratioHeight) - W_H/2);
                } else {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth) +5 , (frameOfObject.origin.y * ratioHeight) + 5, (frameOfObject.size.width * ratioWidth) - W_H, (frameOfObject.size.height * ratioHeight) - W_H);
                }
                i ++;
                
                UIImageView *stickerImageView = [[UIImageView alloc]initWithFrame:rectOfGif];
                stickerImageView.image = [UIImage imageWithData:gifData];
                
                CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"] floatValue];
                stickerImageView.transform = CGAffineTransformMakeRotation(rotationAngle);
                stickerImageView.hidden = YES;
                [cell.topLayerView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                [cell.topLayerView addSubview:stickerImageView];
                
                [self.timerImageViews addObject:[[TimerImageViewStruct alloc]initWithImageView:stickerImageView delayTime:[[[subview objectForKey:@"baseInfo"] objectForKey:@"delayTime"] floatValue] andObjectType:ObjectSticker]];
            }
            
            int objectTypeIndex = [[[subview objectForKey:@"baseInfo"] objectForKey:@"type"] intValue];

            if (objectTypeIndex == ObjectBubble) {
                BubbleObject *bubbleObject = [[BubbleObject alloc] initFromDict:subview];
                ComicObjectView *bubbleObjectView = [ComicObjectView createListViewComicBubbleObjectViewWithObject:bubbleObject];
                
                CGPoint scaledOriginPoint = CGPointMake(bubbleObjectView.frame.origin.x * scales.width,
                                                        bubbleObjectView.frame.origin.y * scales.height);
                
                bubbleObjectView.transform = CGAffineTransformScale(bubbleObjectView.transform, scales.width, scales.height);
                
                [bubbleObjectView setFrame:CGRectMake(scaledOriginPoint.x, scaledOriginPoint.y,
                                                      bubbleObjectView.frame.size.width,
                                                      bubbleObjectView.frame.size.height)];
                
                CMCBubbleView *bubbleView = (CMCBubbleView *)bubbleObjectView.subviews.firstObject;
                [bubbleView deactivateTextField];
                
                cell.topLayerView.bounds = CGRectInset(cell.topLayerView.frame, kVerticalMargin, kVerticalMargin);
                [cell.topLayerView setFrame:cell.frame];
                [cell.topLayerView addSubview:bubbleObjectView];
                
                TimerImageViewStruct *timerViewStruct = [[TimerImageViewStruct alloc]initWithImageView:nil
                                                                                             delayTime:[[[subview objectForKey:@"baseInfo"] objectForKey:@"delayTime"] floatValue]
                                                                                         andObjectType:ObjectBubble];
                timerViewStruct.view = bubbleObjectView;
                [self.timerImageViews addObject:timerViewStruct];
                
            } else if (objectTypeIndex == ObjectPen) {
                PenObject *penObject = [[PenObject alloc] initFromDict:subview];
                ComicObjectView *drawingObjectView = [[ComicObjectView alloc] initWithComicObject:penObject];
                [penObjectsViewsArray addObject:drawingObjectView];
                
                
                NSNumber *currentKey = @(penObject.delayTimeInSeconds);
                NSMutableArray<ComicObjectView *> *arrayForCurrentTimeDelay = [multiplePenObjecsDevidedByTimeDelay objectForKey:currentKey];
                if (!arrayForCurrentTimeDelay) {
                    arrayForCurrentTimeDelay = [NSMutableArray new];
                }
                [arrayForCurrentTimeDelay addObject:drawingObjectView];
                [multiplePenObjecsDevidedByTimeDelay setObject:arrayForCurrentTimeDelay
                                                        forKey:currentKey];
                
                
            } else if (objectTypeIndex == ObjectCaption) {
                
                CaptionObject *captionObject = [[CaptionObject alloc] initFromDict:subview];
                ComicObjectView *captionObjectView = [ComicObjectView createListViewComicCaptionObjectViewWithObject:captionObject];
                CGPoint scaledOriginPoint = CGPointMake(captionObjectView.frame.origin.x * scales.width,
                                                        captionObjectView.frame.origin.y * scales.height);
                captionObjectView.transform = CGAffineTransformScale(captionObjectView.transform, scales.width, scales.height);
                [captionObjectView setFrame:CGRectMake(scaledOriginPoint.x, scaledOriginPoint.y,
                                                       captionObjectView.frame.size.width,
                                                       captionObjectView.frame.size.height)];
                cell.topLayerView.bounds = CGRectInset(cell.topLayerView.frame, kVerticalMargin, kVerticalMargin);
                [cell.topLayerView setFrame:cell.frame];
                [cell.topLayerView addSubview:captionObjectView];
                
                TimerImageViewStruct *timerViewStruct = [[TimerImageViewStruct alloc]initWithImageView:nil
                                                                                             delayTime:[[[subview objectForKey:@"baseInfo"] objectForKey:@"delayTime"] floatValue]
                                                                                         andObjectType:ObjectCaption];
                timerViewStruct.view = captionObjectView;
                [self.timerImageViews addObject:timerViewStruct];
            }
        
            
            if (multiplePenObjecsDevidedByTimeDelay.count > 0) {
                for (NSNumber *timeDelayKey in multiplePenObjecsDevidedByTimeDelay.allKeys) {
                    NSMutableArray *penViewForTimeDelayArray = [multiplePenObjecsDevidedByTimeDelay objectForKey:timeDelayKey];
                    
                    ComicObjectView *drawingObjectView = [ComicObjectView createSingleImageViewFromDrawingsArrayofPenViews:penViewForTimeDelayArray];
                    
                    if (cell.topLayerView.subviews.count > 0) {
                        [cell.topLayerView insertSubview:drawingObjectView atIndex:0];
                    } else {
                        [cell.topLayerView addSubview:drawingObjectView];
                    }
                    
                    TimerImageViewStruct *timerViewStruct = [[TimerImageViewStruct alloc] initWithImageView:nil
                                                                                                  delayTime:timeDelayKey.floatValue
                                                                                              andObjectType:ObjectPen];
                    timerViewStruct.view = drawingObjectView;
                    [self.timerImageViews addObject:timerViewStruct];
                }
                
            }
            
            /*
            UIImageView *allDrawingsImageView = [ComicObjectView createListViewComicPenObjectViewsWithArray:penObjectsViewsArray];
            if (allDrawingsImageView) {
                
                allDrawingsImageView.transform = CGAffineTransformMakeScale(scales.width, scales.height);
                [allDrawingsImageView setFrame:CGRectMake(0,
                                                          0,
                                                          allDrawingsImageView.frame.size.width,
                                                          allDrawingsImageView.frame.size.height)];
                [cell.topLayerView setFrame:cell.frame];
                cell.topLayerView.bounds = CGRectInset(cell.topLayerView.frame, kVerticalMargin, kVerticalMargin);
                if (cell.topLayerView.subviews.count > 0) {
                    [cell.topLayerView insertSubview:allDrawingsImageView atIndex:0];
                } else {
                    [cell.topLayerView addSubview:allDrawingsImageView];
                }
            }
            */
        }
    } else {
        // This can be 2 layer or single layer
        
        //        cell.baseLayerImageView.image = [AppHelper getImageFile:_comicItemModel.comicPage.printScreenPath];
        //-> Loop subviews
        int i = 0;
        for (id subview in _comicItemModel.comicPage.subviews) {
            NSLog(@"Subviews - %@",subview);
            if ([[[subview objectForKey:@"baseInfo"] objectForKey:@"type"]intValue]==17) {
                //Handle top layer that is sticker gif
                //                                ComicItemAnimatedSticker *sticker = [ComicItemAnimatedSticker new];
                CGRect frameOfObject = CGRectFromString([[subview objectForKey:@"baseInfo"] objectForKey:@"frame"]);
                
                //                sticker.combineAnimationFileName = [subview objectForKey:@"url"];
                
                NSBundle *bundle = [NSBundle mainBundle] ;
                NSString *strFileName = [[subview objectForKey:@"url"] lastPathComponent];
                NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".gif" withString:@""] ofType:@"gif"];
                NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
                CGRect rectOfGif;
                //                sticker.image =  [UIImage sd_animatedGIFWithData:gifData];
                
                CGFloat ratioWidth; //ratio SlideView To ScreenSize
                CGFloat ratioHeight; //ratio SlideView To ScreenSize
                if (IS_IPHONE_5) {
                    ratioWidth = rect.size.width / 305;
                    ratioHeight = rect.size.height / 495.5;
                } else if (IS_IPHONE_6) {
                    ratioWidth = rect.size.width / 358;
                    ratioHeight = rect.size.height / 585;
                } else {
                    ratioWidth = rect.size.width / 395.333;
                    ratioHeight = rect.size.height / 648.333;
                }
                
                //                CGFloat ratioHeight = rect.size.height / SCREEN_HEIGHT;
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth) +5 , (frameOfObject.origin.y * ratioHeight) + 5, (frameOfObject.size.width * ratioWidth) - W_H /2, (frameOfObject.size.height * ratioHeight) - W_H/2);
                } else {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth) +5 , (frameOfObject.origin.y * ratioHeight) + 5, (frameOfObject.size.width * ratioWidth) - W_H, (frameOfObject.size.height * ratioHeight) - W_H);
                }
                i ++;
                
                
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImageView *stickerImageView = [self createImageViewWith:gifData frame:rectOfGif bAnimate:YES withAnimation:YES];
                
                
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"] floatValue];
                stickerImageView.transform = CGAffineTransformMakeRotation(rotationAngle);
                [cell.topLayerView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                [cell.topLayerView addSubview:stickerImageView];
                //                    });
                //                } );
                
                //                NSLog(@".............IF ADDED STICKER: %@",sticker);
                //                    sticker.backgroundColor = [UIColor brownColor];
                //                    [cell.topLayerView setBackgroundColor:[UIColor greenColor]];
                //                    cell.topLayerView.alpha = 0.4;
            }
            
            //18 is for static stickers
            if ([[[subview objectForKey:@"baseInfo"] objectForKey:@"type"]intValue] == 18) {
                CGRect frameOfObject = CGRectFromString([[subview objectForKey:@"baseInfo"] objectForKey:@"frame"]);
                
                NSBundle *bundle = [NSBundle mainBundle] ;
                NSString *strFileName = [[subview objectForKey:@"url"] lastPathComponent];
                NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".png" withString:@""] ofType:@"png"];
                NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
                CGRect rectOfGif;
                
                CGFloat ratioWidth; //ratio SlideView To ScreenSize
                CGFloat ratioHeight; //ratio SlideView To ScreenSize
                if (IS_IPHONE_5) {
                    ratioWidth = rect.size.width / 305;
                    ratioHeight = rect.size.height / 495.5;
                } else if (IS_IPHONE_6) {
                    ratioWidth = rect.size.width / 358;
                    ratioHeight = rect.size.height / 585;
                } else {
                    ratioWidth = rect.size.width / 395.333;
                    ratioHeight = rect.size.height / 648.333;
                }
                
                //                CGFloat ratioHeight = rect.size.height / SCREEN_HEIGHT;
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth) +5 , (frameOfObject.origin.y * ratioHeight) + 5, (frameOfObject.size.width * ratioWidth) - W_H /2, (frameOfObject.size.height * ratioHeight) - W_H/2);
                } else {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth) +5 , (frameOfObject.origin.y * ratioHeight) + 5, (frameOfObject.size.width * ratioWidth) - W_H, (frameOfObject.size.height * ratioHeight) - W_H);
                }
                i ++;
                
                UIImageView *stickerImageView = [[UIImageView alloc]initWithFrame:rectOfGif];
                stickerImageView.image = [UIImage imageWithData:gifData];
                
                CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"] floatValue];
                stickerImageView.transform = CGAffineTransformMakeRotation(rotationAngle);
                [cell.topLayerView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                [cell.topLayerView addSubview:stickerImageView];
            }
        }
    }
    NSLog(@"\n\n\nCELLLLLLLLLLLLLLLLL A: %lu %@",index, _comicItemModel.comicPage.subviews);
    cell.userInteractionEnabled = NO;
}

- (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size {
	UIImage *newImage;
	
	@autoreleasepool {
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	}
	
    return newImage;
}


- (void)createImageViewWith:(NSData *)data
                      frame:(CGRect)rect
                   bAnimate:(BOOL)flag
              withAnimation:(BOOL)shouldAnimate
               isBackground:(BOOL)isBackground
        backgroundSuperview:(__weak UIImageView *)backgroundSuperview
               topLayerView:(__weak UIView *)topLayerView
                  withDelay:(CGFloat)delay
				  withAngle:(CGFloat)angle{
    
    dispatch_queue_t const preloadQueue = dispatch_queue_create("preload-queue", DISPATCH_QUEUE_SERIAL);
    __weak CBComicImageCell *weakSelf = self;
    dispatch_async(preloadQueue, ^{
        NSLog(@"Start new queue for image processing");
        CGImageSourceRef srcImage = CGImageSourceCreateWithData(toCF data, nil);
        if (!srcImage) {
            NSLog(@"loading image failed");
        }
        NSNumber *frameDuration;
        NSTimeInterval totalDuration = 0;
        size_t imgCount = CGImageSourceGetCount(srcImage);
        NSMutableArray *arrayImages = [NSMutableArray new];
        
        UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:rect];
        dispatch_async(dispatch_get_main_queue(), ^{
            resultImageView.autoresizingMask = 0B11111;
            resultImageView.userInteractionEnabled = YES;
            if (isBackground) {
                [backgroundSuperview insertSubview:resultImageView atIndex:0];
				resultImageView.transform = CGAffineTransformMakeRotation(angle);
            } else {
                [topLayerView addSubview:resultImageView];
				resultImageView.transform = CGAffineTransformMakeRotation(angle);
            }
        });
        
        for (NSInteger i = 0; i < imgCount; i += 2) {
            CGImageRef cgImg = CGImageSourceCreateImageAtIndex(srcImage, i, nil);
            if (!cgImg) {
                NSLog(@"loading %ldth image failed from the source", (long)i);
                continue;
            }
            
            UIImage *img = [[Global global] scaledImage:[UIImage imageWithCGImage:cgImg] size:rect.size withInterpolationQuality:kCGInterpolationMedium];
            if (!resultImageView.image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultImageView.image = img;
                });
            }
            
            [arrayImages addObject:img];
            NSDictionary *property = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(srcImage, i, nil));
            NSDictionary *gifDict = property[fromCF kCGImagePropertyGIFDictionary];
            frameDuration = gifDict[fromCF kCGImagePropertyGIFUnclampedDelayTime];
            if (!frameDuration) {
                frameDuration = gifDict[fromCF kCGImagePropertyGIFDelayTime];
            }
            totalDuration += frameDuration.floatValue * 2;
            CGImageRelease(cgImg);
			
			if (delay + totalDuration >= bkGifDuration) {
				break;
			}
        }
        
        if (srcImage != nil) {
            CFRelease(srcImage);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            resultImageView.image = arrayImages.firstObject;
            resultImageView.animationImages = arrayImages;
            resultImageView.animationDuration = totalDuration;
            resultImageView.animationRepeatCount = (flag == YES? 0 : 1);
            if (shouldAnimate) {
                [resultImageView startAnimating];
            }
            TimerImageViewStruct *timerImageViewStruct = [[TimerImageViewStruct alloc] initWithImageView:resultImageView
                                                                                               delayTime:delay
                                                                                           andObjectType:ObjectAnimateGIF];
            [weakSelf.timerImageViews addObject:timerImageViewStruct];
            [weakSelf reCalculateMaxTimeWithDelay:timerImageViewStruct.delayTimeOfImageView
                                   andGifPlayTime:timerImageViewStruct.imageView.animationDuration];

        });
    });
}


- (UIImageView *)createImageViewWith:(NSData *)data frame:(CGRect)rect bAnimate:(BOOL)flag withAnimation:(BOOL)shouldAnimate {
    CGImageSourceRef srcImage = CGImageSourceCreateWithData(toCF data, nil);
    if (!srcImage) {
        NSLog(@"loading image failed");
    }
    
    size_t imgCount = CGImageSourceGetCount(srcImage);
    NSTimeInterval totalDuration = 0;
    NSNumber *frameDuration;
    NSMutableArray *arrayImages;
    
    arrayImages = [[NSMutableArray alloc] init];
    // Skip every second frame in the gif
    for (NSInteger i = 0; i < imgCount; i += 2) {
        CGImageRef cgImg = CGImageSourceCreateImageAtIndex(srcImage, i, nil);
        if (!cgImg) {
            NSLog(@"loading %ldth image failed from the source", (long)i);
            continue;
        }
                
        /*
         C0mrade Edit:
         
         Bellow code runs in for cycle as O(n), it's huge operation, needs to decompose and assign
         separate threads, image scale is hard coded and i think it should be gone to constants and
         it needs defined scale multiplier, for now multiplier is set to 3.0 as on iPhone 7 it works
         with no expenses, tested on iOS 11 Beta - Memory is stable and holds 22.5 MB - CPU load on zero.
         
        */
        
        // This line should be moved to app constants.
        // c0mrade: Size Fixes
        CGSize imagePixelSize = CGSizeMake(rect.size.width * 5.0, rect.size.height * 5.0); //
        
        UIImage *img = [[Global global] scaledImage:[UIImage imageWithCGImage:cgImg] size:imagePixelSize withInterpolationQuality:kCGInterpolationDefault];
        [arrayImages addObject:img];
        
        NSDictionary *property = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(srcImage, i, nil));
        NSDictionary *gifDict = property[fromCF kCGImagePropertyGIFDictionary];
        
        frameDuration = gifDict[fromCF kCGImagePropertyGIFUnclampedDelayTime];
        if (!frameDuration) {
            frameDuration = gifDict[fromCF kCGImagePropertyGIFDelayTime];
        }
        // Make delay between frames 2 times slower
        totalDuration += frameDuration.floatValue * 2;
        
        CGImageRelease(cgImg);
    }
    
    if (srcImage != nil) {
        CFRelease(srcImage);
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = arrayImages.firstObject;
    imgView.autoresizingMask = 0B11111;
    imgView.userInteractionEnabled = YES;
    
    imgView.animationImages = arrayImages;
    imgView.animationDuration = totalDuration;
	bkGifDuration = totalDuration;
    imgView.animationRepeatCount = (flag == YES? 0 : 1);
    if (shouldAnimate) {
        [imgView startAnimating];
    }
    
    return imgView;
}

- (void)setGifPropertiesOfImageView:(UIImageView *)oldImageView toNewImageView:(UIImageView *)newImageView {
    newImageView.image = oldImageView.image;
    newImageView.autoresizingMask = oldImageView.autoresizingMask;
    newImageView.animationImages = oldImageView.animationImages;
    newImageView.animationDuration = oldImageView.animationDuration;
    newImageView.animationRepeatCount = oldImageView.animationRepeatCount;
}

- (NSData *)getGifDataFromFileName:(NSString *)fileName {
    
    NSString *fileName1 = [NSString stringWithFormat:@"%@",[fileName lastPathComponent]];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName1]];
    
    NSData *gifData = [NSData dataWithContentsOfURL:fileURL];
    return gifData;
}

- (void)reCalculateMaxTimeWithDelay:(CGFloat)delayTime andGifPlayTime:(CGFloat)playTime {
    if ((delayTime + playTime) > _maxTimeOfFullAnimation) {
        _maxTimeOfFullAnimation = delayTime + playTime;
    }
}

- (void)mainTimer:(NSTimer *)timer {
    _isSlidePlaying = YES;
    if (_currentTimeInterval > _maxTimeOfFullAnimation) {
        [self stopAllGifPlays];
        
        if (self.playOneByOneDelegate && [self.playOneByOneDelegate conformsToProtocol:@protocol(PlayOneByOneLooper)] && [self.playOneByOneDelegate respondsToSelector:@selector(slideDidFinishPlayingOnceWithIndex:)]) {
            //This method will make the main controller to start animation of next slide
            [self.playOneByOneDelegate slideDidFinishPlayingOnceWithIndex:_index + 1];
            _isSlidePlaying = NO;
        }
        return;
    }
    
    for (TimerImageViewStruct *timerImageView in self.timerImageViews) {
        
        if (timerImageView.delayTimeOfImageView == 0) {
            timerImageView.imageView.hidden = YES;
        }
        
        if (timerImageView.imageView.animationImages.count > 1) { // FOR GIFs
            if (timerImageView.imageView.hidden == YES && (_currentTimeInterval >= timerImageView.delayTimeOfImageView)) {
                timerImageView.imageView.hidden = NO;
                [self makeImageViewStartItsAnimationFromFirstFrame:timerImageView.imageView];
            }
            if (timerImageView.imageView.hidden == NO && (_currentTimeInterval < timerImageView.delayTimeOfImageView)) {
                timerImageView.imageView.hidden = YES;
                [timerImageView.imageView stopAnimating];
            }
            if (_currentTimeInterval > timerImageView.imageView.animationDuration + timerImageView.delayTimeOfImageView) {
                timerImageView.imageView.image = nil;
                timerImageView.imageView.image = [timerImageView.imageView.animationImages lastObject];
                [timerImageView.imageView stopAnimating];
            }
        } else {  // FOR IMAGES
            if (timerImageView.imageView.hidden == YES && (_currentTimeInterval > timerImageView.delayTimeOfImageView)) {
                timerImageView.imageView.hidden = NO;
            }
            if (timerImageView.imageView.hidden == NO && (_currentTimeInterval <= timerImageView.delayTimeOfImageView)) {
                timerImageView.imageView.hidden = YES;
            }
            
            if (timerImageView.view.hidden == YES && (_currentTimeInterval > timerImageView.delayTimeOfImageView)) {
                timerImageView.view.hidden = NO;
            }
            if (timerImageView.view.hidden == NO && (_currentTimeInterval <= timerImageView.delayTimeOfImageView)) {
                timerImageView.view.hidden = YES;
            }
        }
    }
    _currentTimeInterval+=discreteValueOfSeconds;
}

- (void)makeImageViewStartItsAnimationFromFirstFrame:(UIImageView *)imageView {
    imageView.image = [imageView.animationImages firstObject];
    [imageView startAnimating];
}

#pragma mark - Play one by one

- (void)setInitialFrameOfCell {
    [self stopAllGifPlays];
}

- (void)animateOnce {
    //Start the play after some time
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTimer];
//    });
}

- (void)startTimer {
    [self setBorderColorWithPlayingStatus:YES];
    
    [_mainSlideTimer invalidate];
    _mainSlideTimer = nil;
    _mainSlideTimer = [NSTimer scheduledTimerWithTimeInterval:discreteValueOfSeconds
                                                       target:self
                                                     selector:@selector(mainTimer:)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stopAllGifPlays {
    for (TimerImageViewStruct *timerImageView in self.timerImageViews) {
        [timerImageView.imageView stopAnimating];
    }
    [_mainSlideTimer invalidate];
    _mainSlideTimer = nil;
    _currentTimeInterval = 0;
    [self setBorderColorWithPlayingStatus:NO];
}

- (void)setBorderColorWithPlayingStatus:(BOOL)isPlaying {
    if (isPlaying) {
        self.containerView.layer.borderColor = [UIColor yellowColor].CGColor;
    } else {
        self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

@end
