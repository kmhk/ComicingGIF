//
//  CBComicImageCell.m
//  ComicBook
//
//  Created by Atul Khatri on 04/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBComicImageCell.h"
#import <ImageIO/ImageIO.h>

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

#define discreteValueOfSeconds 0.01

#define W_H 40

@implementation CBComicImageCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 3.0f;
    
    if (_maxTimeOfFullAnimation < 3) {
        _maxTimeOfFullAnimation = 3;
    }
}

- (void)createUIForCell:(CBComicImageCell *)cell withIndex:(NSInteger)index andFrame : (CGRect ) rect {
    _index = index;
    NSLog(@"\n\n\nCELLLLLLLLLLLLLLLLL B: %lu %@, CollFrame: %@", index, _comicItemModel.comicPage.subviews, NSStringFromCGRect(rect));
    for (UIView *view in [cell.topLayerView subviews]) {
        [view removeFromSuperview];
    }
    
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
                
                CGFloat ratioWidth = rect.size.width / [Global getWidthOfSlideAsPerUIImplemented]; //ratio SlideView To ScreenSize
                //                CGFloat ratioHeight = rect.size.height / SCREEN_HEIGHT;
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth)/2, (frameOfObject.origin.y * ratioWidth)/2, (frameOfObject.size.width * ratioWidth - W_H)/2, (frameOfObject.size.height * ratioWidth - W_H)/2);
                } else {
                    rectOfGif = CGRectMake(frameOfObject.origin.x * ratioWidth, frameOfObject.origin.y * ratioWidth, frameOfObject.size.width * ratioWidth - W_H, frameOfObject.size.height * ratioWidth - W_H);
                }
                i ++;
                
                NSLog(@"GGGGGGGGGGGGGGGG   %@",NSStringFromCGRect(rectOfGif));
                UIImageView *stickerImageView = [self createImageViewWith:gifData frame:rectOfGif bAnimate:YES withAnimation:NO];
                
                CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"]intValue];
                stickerImageView.transform = CGAffineTransformMakeRotation(rotationAngle);
                [cell.topLayerView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                [cell.topLayerView addSubview:stickerImageView];
                
//                [cell.topLayerView addConstraint:[NSLayoutConstraint constraintWithItem:cell.topLayerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:stickerImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:rectOfGif.origin.x]];
//                
//                [cell.topLayerView addConstraint:[NSLayoutConstraint constraintWithItem:cell.topLayerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:stickerImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:rectOfGif.origin.y]];
//                
//                [cell.topLayerView addConstraint:[NSLayoutConstraint constraintWithItem:stickerImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:rectOfGif.size.height]];
//                
//                [cell.topLayerView addConstraint:[NSLayoutConstraint constraintWithItem:stickerImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:rectOfGif.size.width]];
                
                TimerImageViewStruct *timerImageViewStruct = [[TimerImageViewStruct alloc]initWithImageView:stickerImageView delayTime:[[[subview objectForKey:@"baseInfo"] objectForKey:@"delayTime"] floatValue] andObjectType:ObjectAnimateGIF];
                [self.timerImageViews addObject:timerImageViewStruct];
                [self reCalculateMaxTimeWithDelay:timerImageViewStruct.delayTimeOfImageView andGifPlayTime:timerImageViewStruct.imageView.animationDuration];
                
            }
            
            //18 is for static stickers
            if ([[[subview objectForKey:@"baseInfo"] objectForKey:@"type"]intValue] == 18) {
                CGRect frameOfObject = CGRectFromString([[subview objectForKey:@"baseInfo"] objectForKey:@"frame"]);
                
                NSBundle *bundle = [NSBundle mainBundle] ;
                NSString *strFileName = [[subview objectForKey:@"url"] lastPathComponent];
                NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".png" withString:@""] ofType:@"png"];
                NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
                CGRect rectOfGif;
                
                CGFloat ratioWidth = rect.size.width / [Global getWidthOfSlideAsPerUIImplemented]; //ratio SlideView To ScreenSize
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth)/2, (frameOfObject.origin.y * ratioWidth)/2, (frameOfObject.size.width * ratioWidth - W_H)/2, (frameOfObject.size.height * ratioWidth - W_H)/2);
                } else {
                    rectOfGif = CGRectMake(frameOfObject.origin.x * ratioWidth, frameOfObject.origin.y * ratioWidth, frameOfObject.size.width * ratioWidth - W_H, frameOfObject.size.height * ratioWidth - W_H);
                }
                i ++;
                
                UIImageView *stickerImageView = [[UIImageView alloc]initWithFrame:rectOfGif];
                stickerImageView.image = [UIImage imageWithData:gifData];
                
                CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"]intValue];
                stickerImageView.transform = CGAffineTransformMakeRotation(rotationAngle);
                stickerImageView.hidden = YES;
                [cell.topLayerView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                [cell.topLayerView addSubview:stickerImageView];
                
                [self.timerImageViews addObject:[[TimerImageViewStruct alloc]initWithImageView:stickerImageView delayTime:[[[subview objectForKey:@"baseInfo"] objectForKey:@"delayTime"] floatValue] andObjectType:ObjectSticker]];
            }
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
                
                CGFloat ratioWidth = rect.size.width / [Global getWidthOfSlideAsPerUIImplemented]; //ratio SlideView To ScreenSize
                //                CGFloat ratioHeight = rect.size.height / SCREEN_HEIGHT;
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth)/2, (frameOfObject.origin.y * ratioWidth)/2, (frameOfObject.size.width * ratioWidth - W_H)/2, (frameOfObject.size.height * ratioWidth - W_H)/2);
                } else {
                    rectOfGif = CGRectMake(frameOfObject.origin.x * ratioWidth, frameOfObject.origin.y * ratioWidth, frameOfObject.size.width * ratioWidth - W_H, frameOfObject.size.height * ratioWidth - W_H);
                }
                i ++;
                
                
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImageView *stickerImageView = [self createImageViewWith:gifData frame:rectOfGif bAnimate:YES withAnimation:YES];
                
                
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"]intValue];
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
                
                CGFloat ratioWidth = rect.size.width / [Global getWidthOfSlideAsPerUIImplemented]; //ratio SlideView To ScreenSize
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth)/2, (frameOfObject.origin.y * ratioWidth - W_H)/2, (frameOfObject.size.width * ratioWidth)/2, (frameOfObject.size.height * ratioWidth - W_H)/2);
                } else {
                    rectOfGif = CGRectMake(frameOfObject.origin.x * ratioWidth, frameOfObject.origin.y * ratioWidth, frameOfObject.size.width * ratioWidth - W_H, frameOfObject.size.height * ratioWidth - W_H);
                }
                i ++;
                
                UIImageView *stickerImageView = [[UIImageView alloc]initWithFrame:rectOfGif];
                stickerImageView.image = [UIImage imageWithData:gifData];
                
                CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"]intValue];
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
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
    for (NSInteger i = 0; i < imgCount; i ++) {
        CGImageRef cgImg = CGImageSourceCreateImageAtIndex(srcImage, i, nil);
        if (!cgImg) {
            NSLog(@"loading %ldth image failed from the source", (long)i);
            continue;
        }
        
        UIImage *img = [[Global global] scaledImage:[UIImage imageWithCGImage:cgImg] size:rect.size];
        //        UIImage *imageTemp = [UIImage imageWithCGImage:cgImg];
        //        UIImage *img = [UIImage resizeImage:imageTemp newSize:rect.size];
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
    
    if (srcImage != nil) {
        CFRelease(srcImage);
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = arrayImages.firstObject;
    imgView.autoresizingMask = 0B11111;
    imgView.userInteractionEnabled = YES;
    
    imgView.animationImages = arrayImages;
    imgView.animationDuration = totalDuration;
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
