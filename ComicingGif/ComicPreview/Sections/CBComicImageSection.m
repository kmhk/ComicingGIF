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
#import "Constants.h"

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
    
//    self.collectionView.backgroundColor = [UIColor redColor];
//    _comicItemModel = [self.dataArray objectAtIndex:indexPath.row];
    for (CBComicItemModel *item in self.dataArray) {
        NSLog(@"............DATA ARRAY IN CELL: %@",item.comicPage);
    }
    
//    self.collectionView.backgroundColor = [UIColor yellowColor];
    
//    ComicItemAnimatedSticker *st = [ComicItemAnimatedSticker new];
//    st.objFrame = CGRectMake(50, 80, 100, 100);
//    [st addItemWithImage:[YYImage imageNamed:@"WTF"]];
//    _comicItemModel.comicPage.subviews = [NSMutableArray arrayWithObject:st];
//    cell.staticImageView.image = _comicItemModel.baseLayerImage;
//    cell.animatedImageView.image = _comicItemModel.baseLayerGif;
    
    return cell;
}

- (void)createUIForCell:(CBComicImageCell *)cell withIndex:(NSInteger)index andFrame : (CGRect ) rect {
    
    NSLog(@"\n\n\nCELLLLLLLLLLLLLLLLL B: %lu %@, CollFrame: %@", index, _comicItemModel.comicPage.subviews, NSStringFromCGRect(rect));
    for (UIView *view in [cell.topLayerView subviews]) {
        [view removeFromSuperview];
    }
    if (_comicItemModel.isBaseLayerGif)
    {
        // NEED to handle 3 layer
        cell.baseLayerImageView.image = [AppHelper getGifFile:_comicItemModel.comicPage.gifLayerPath];
        cell.staticImageView.image = [AppHelper getImageFile:_comicItemModel.comicPage.printScreenPath];
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
                    UIImageView *stickerImageView = [self createImageViewWith:gifData frame:rectOfGif bAnimate:YES];
                    
                    
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
    } else {
        // This can be 2 layer or single layer
        
        cell.baseLayerImageView.image = [AppHelper getImageFile:_comicItemModel.comicPage.printScreenPath];
        
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
                UIImageView *stickerImageView = [self createImageViewWith:gifData frame:rectOfGif bAnimate:YES];
                
                
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
    [imgView startAnimating];
    
    return imgView;
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
