//
//  CBComicImageSection.m
//  ComicBook
//
//  Created by Atul Khatri on 02/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBComicImageSection.h"
#import "CBComicImageCell.h"
#import "CBComicItemModel.h"
#import "AppHelper.h"
#import <ImageIO/ImageIO.h>
#import "BaseObject.h"
#import "BubbleObject.h"
#import "PenObject.h"
#import "ComicObjectView.h"
#import "Constants.h"
#import "CaptionObject.h"

#define kHorizontalMargin 0.0f
#define kVerticalMargin 5.0f

#define kCollectionViewLeftMargin 5.0f
#define kCollectionViewRightMargin 5.0f
#define kCollectionViewMiddleMargin 0.0f

#define kLandscapeCellHeight 106.0f
#define kPortraitCellHeight 228.0f

#define kVerticalCellMultiplier 1.65f
#define kWideCellMultiplier 0.406f

#define kCellIdentifier @"ComicImageCell"

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

#define discreteValueOfSeconds 0.01

@implementation CBComicImageSection
- (CBBaseCollectionViewCell*)cellForCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    [super cellForCollectionView:collectionView atIndexPath:indexPath];
    NSLog(@"CollectionVie... old: %@, new: %@",self.collectionView, collectionView);
    self.collectionView = collectionView;
    CBComicImageCell* cell= [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if(!cell){
        NSArray* nibs= [[NSBundle mainBundle] loadNibNamed:@"CBComicImageCell" owner:self options:nil];
        cell= [nibs firstObject];
    }
    
    for (CBComicItemModel *item in self.dataArray) {
        NSLog(@"............DATA ARRAY IN CELL: %@",item.comicPage);
    }
    
    self.timerImageViews = [NSMutableArray array];
    
    return cell;
}

- (void)createUIForCell:(CBComicImageCell *)cell withIndex:(NSInteger)index andFrame : (CGRect ) rect {
    
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
//        cell.baseLayerImageView.image = [AppHelper getGifFile:_comicItemModel.comicPage.gifLayerPath];

        [self.timerImageViews addObject:[[TimerImageViewStruct alloc]initWithImageView:cell.baseLayerImageView delayTime:0 andObjectType:ObjectAnimateGIF]];
        
        self.maxTimeOfFullAnimation = cell.baseLayerImageView.animationDuration;
        
        cell.staticImageView.image = [AppHelper getImageFile:_comicItemModel.comicPage.printScreenPath];
        //-> Loop subviews and get animation sticker and static image.
        //animation sticker you can check like …
        
        NSMutableArray<ComicObjectView *> *penObjectsViewsArray = [NSMutableArray new];
        CGRect screenRect = [UIScreen mainScreen].bounds;
        CGSize scales = CGSizeMake(cell.bounds.size.width / screenRect.size.width,
                                   cell.bounds.size.height / screenRect.size.height);
        
        int i = 0;
        for (NSDictionary* subview in _comicItemModel.comicPage.subviews) {
            int objectTypeIndex = [[[subview objectForKey:@"baseInfo"] objectForKey:@"type"] intValue];
            
            if (objectTypeIndex == ObjectAnimateGIF) {
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
                
                CGFloat ratioWidth = rect.size.width / SCREEN_WIDTH; //ratio SlideView To ScreenSize
//                CGFloat ratioHeight = rect.size.height / SCREEN_HEIGHT;
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth)/2, (frameOfObject.origin.y * ratioWidth)/2, (frameOfObject.size.width * ratioWidth)/2, (frameOfObject.size.height * ratioWidth)/2);
                } else {
                    rectOfGif = CGRectMake(frameOfObject.origin.x * ratioWidth, frameOfObject.origin.y * ratioWidth, frameOfObject.size.width * ratioWidth, frameOfObject.size.height * ratioWidth);
                }
                i ++;

                
                UIImageView *stickerImageView = [self createImageViewWith:gifData frame:rectOfGif bAnimate:YES withAnimation:NO];
                
                CGFloat rotationAngle = [[[subview objectForKey:@"baseInfo"] objectForKey:@"angle"]intValue];
                stickerImageView.transform = CGAffineTransformMakeRotation(rotationAngle);
                [cell.topLayerView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                [cell.topLayerView addSubview:stickerImageView];
                
                [self.timerImageViews addObject:[[TimerImageViewStruct alloc]initWithImageView:stickerImageView delayTime:[[[subview objectForKey:@"baseInfo"] objectForKey:@"delayTime"] floatValue] andObjectType:ObjectAnimateGIF]];
                
            } else if (objectTypeIndex == ObjectSticker) {
                
                CGRect frameOfObject = CGRectFromString([[subview objectForKey:@"baseInfo"] objectForKey:@"frame"]);
                
                NSBundle *bundle = [NSBundle mainBundle] ;
                NSString *strFileName = [[subview objectForKey:@"url"] lastPathComponent];
                NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".png" withString:@""] ofType:@"png"];
                NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
                CGRect rectOfGif;
                
                CGFloat ratioWidth = rect.size.width / SCREEN_WIDTH; //ratio SlideView To ScreenSize
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth)/2, (frameOfObject.origin.y * ratioWidth)/2, (frameOfObject.size.width * ratioWidth)/2, (frameOfObject.size.height * ratioWidth)/2);
                } else {
                    rectOfGif = CGRectMake(frameOfObject.origin.x * ratioWidth, frameOfObject.origin.y * ratioWidth, frameOfObject.size.width * ratioWidth, frameOfObject.size.height * ratioWidth);
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
                
            } else if (objectTypeIndex == ObjectBubble) {
                BubbleObject *bubbleObject = [[BubbleObject alloc] initFromDict:subview];
                ComicObjectView *bubbleObjectView = [ComicObjectView createListViewComicBubbleObjectViewWithObject:bubbleObject];
                
                CGPoint scaledOriginPoint = CGPointMake(bubbleObjectView.frame.origin.x * scales.width,
                                                        bubbleObjectView.frame.origin.y * scales.height);
                
                bubbleObjectView.transform = CGAffineTransformScale(bubbleObjectView.transform, scales.width, scales.height);
                
                [bubbleObjectView setFrame:CGRectMake(scaledOriginPoint.x, scaledOriginPoint.y,
                                                      bubbleObjectView.frame.size.width,
                                                      bubbleObjectView.frame.size.height)];
                
                cell.topLayerView.bounds = CGRectInset(cell.topLayerView.frame, kVerticalMargin, kVerticalMargin);
                [cell.topLayerView setFrame:cell.frame];
                [cell.topLayerView addSubview:bubbleObjectView];
                
            } else if (objectTypeIndex == ObjectPen) {
                PenObject *penObject = [[PenObject alloc] initFromDict:subview];
                ComicObjectView *drawingObjectView = [[ComicObjectView alloc] initWithComicObject:penObject];
                [penObjectsViewsArray addObject:drawingObjectView];
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
            }
        }
        
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
        
        
        [_mainSlideTimer invalidate];
        _mainSlideTimer = nil;
        _mainSlideTimer = [NSTimer scheduledTimerWithTimeInterval:discreteValueOfSeconds
                                                           target:self
                                                         selector:@selector(mainTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
    } else {
        // This can be 2 layer or single layer
        
//        cell.baseLayerImageView.image = [AppHelper getImageFile:_comicItemModel.comicPage.printScreenPath];
        self.maxTimeOfFullAnimation = 0;
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
                
                CGFloat ratioWidth = rect.size.width / SCREEN_WIDTH; //ratio SlideView To ScreenSize
                //                CGFloat ratioHeight = rect.size.height / SCREEN_HEIGHT;
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth)/2, (frameOfObject.origin.y * ratioWidth)/2, (frameOfObject.size.width * ratioWidth)/2, (frameOfObject.size.height * ratioWidth)/2);
                } else {
                    rectOfGif = CGRectMake(frameOfObject.origin.x * ratioWidth, frameOfObject.origin.y * ratioWidth, frameOfObject.size.width * ratioWidth, frameOfObject.size.height * ratioWidth);
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
                
                CGFloat ratioWidth = rect.size.width / SCREEN_WIDTH; //ratio SlideView To ScreenSize
                if (_comicItemModel.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF) {
                    rectOfGif = CGRectMake((frameOfObject.origin.x * ratioWidth)/2, (frameOfObject.origin.y * ratioWidth)/2, (frameOfObject.size.width * ratioWidth)/2, (frameOfObject.size.height * ratioWidth)/2);
                } else {
                    rectOfGif = CGRectMake(frameOfObject.origin.x * ratioWidth, frameOfObject.origin.y * ratioWidth, frameOfObject.size.width * ratioWidth, frameOfObject.size.height * ratioWidth);
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

- (void)mainTimer:(NSTimer *)timer {
    if (_currentTimeInterval > _maxTimeOfFullAnimation) {
        _currentTimeInterval = 0;
    }
    for (TimerImageViewStruct *timerImageView in self.timerImageViews) {

        if (timerImageView.imageView.animationImages.count > 1) { // FOR GIFs
            if (timerImageView.imageView.hidden == YES && (_currentTimeInterval > timerImageView.delayTimeOfImageView)) {
                timerImageView.imageView.hidden = NO;
                [self makeImageViewStartItsAnimationFromFirstFrame:timerImageView.imageView];
            }
            if (timerImageView.imageView.hidden == NO && (_currentTimeInterval <= timerImageView.delayTimeOfImageView)) {
                timerImageView.imageView.hidden = YES;
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

-(void)registerNibForCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerNib:[UINib nibWithNibName:@"CBComicImageCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
}

//- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"CollectionView size for item : %@",self.collectionView);
//    NSLog(@"......................SCREENSIZE: %@",NSStringFromCGRect([UIScreen mainScreen].bounds));
////    CGSize collectionViewSize= self.collectionView.bounds.size;
//    CGFloat width= floorf(([UIScreen mainScreen].bounds.size.width - (32+16))-(kCollectionViewLeftMargin+kCollectionViewRightMargin+ (kHorizontalMargin*2))); // 32 and 16 are the leading and trailing of collectionview
//    CBComicItemModel* model= [self.dataArray objectAtIndex:indexPath.row];
//    
//    if(model.imageOrientation == COMIC_IMAGE_ORIENTATION_LANDSCAPE){
//        [self printWidth:width andH:width*kWideCellMultiplier andCollV:self.collectionView.frame];
//        return CGSizeMake(width, width*kWideCellMultiplier);
//    }else if(model.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF){
//        CGFloat cellWidth= floorf((width-kCollectionViewMiddleMargin - kVerticalCellMultiplier)/2 -1);
//        [self printWidth:cellWidth andH:cellWidth*kVerticalCellMultiplier andCollV:self.collectionView.frame];
//        return CGSizeMake(cellWidth, floorf(cellWidth*kVerticalCellMultiplier));
//    }else {
//        [self printWidth:width andH:floorf(width*kVerticalCellMultiplier) andCollV:self.collectionView.frame];
//        return CGSizeMake(width, floorf(width*kVerticalCellMultiplier));
//    }
//}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CBComicItemModel* model= [self.dataArray objectAtIndex:indexPath.row];
    
    if(model.imageOrientation == COMIC_IMAGE_ORIENTATION_LANDSCAPE){
        CGSize size = CGSizeMake(WideSlideWidth, (WideSlideWidth) * (WideSlideWidthToHeightRatio));
        return size;
    }else if(model.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF){
        CGSize size = CGSizeMake(SmallTallSlideWidth, (SmallTallSlideWidth) * (TallSlideWidthToHeightRatio));
        return size;
    }else {
        CGSize size = CGSizeMake(LargeTallSlideWidth, (LargeTallSlideWidth) * (TallSlideWidthToHeightRatio));
        return size;
    }
}

- (void)printWidth:(CGFloat)width andH:(CGFloat)h andCollV:(CGRect)rect {
    NSLog(@"xxx             %f ,%f ,%@",width, h, NSStringFromCGRect(rect));
}

- (UIEdgeInsets)insetForSection{
    return UIEdgeInsetsMake(kHorizontalMargin, kVerticalMargin, kHorizontalMargin, kVerticalMargin);
}


@end
