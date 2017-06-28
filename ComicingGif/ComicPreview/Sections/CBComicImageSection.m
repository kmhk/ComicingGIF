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
#import "UIImage+resize.h"

#define kHorizontalMargin 0.0f
#define kVerticalMargin 9.0f

#define kCollectionViewLeftMargin 0.0f
#define kCollectionViewRightMargin 0.0f
#define kCollectionViewMiddleMargin 0.0f

#define kLandscapeCellHeight 106.0f
#define kPortraitCellHeight 228.0f

#define kVerticalCellMultiplier 1.69f
#define kWideCellMultiplier 0.39f

#define kCellIdentifier @"ComicImageCell"

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
    
    cell.timerImageViews = [NSMutableArray array];
    
    return cell;
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView
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
    return [Global getSizeOfComicSlideWithModel:model];
}

- (void)printWidth:(CGFloat)width andH:(CGFloat)h andCollV:(CGRect)rect {
    NSLog(@"xxx             %f ,%f ,%@",width, h, NSStringFromCGRect(rect));
}

- (UIEdgeInsets)insetForSection{
    return UIEdgeInsetsMake(kHorizontalMargin, kVerticalMargin, kHorizontalMargin, kVerticalMargin);
}


@end
