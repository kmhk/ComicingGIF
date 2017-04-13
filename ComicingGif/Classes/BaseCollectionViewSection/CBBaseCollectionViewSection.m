//
//  CBBaseCollectionViewSection.m
//  ComicBook
//
//  Created by Atul Khatri on 02/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseCollectionViewSection.h"

@interface CBBaseCollectionViewSection()
@property (nonatomic, assign) BOOL nibLoaded;
@end

@implementation CBBaseCollectionViewSection

- (CBBaseCollectionViewCell*)cellForCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    _collectionView= collectionView;
    if(!_nibLoaded)
    {
        [self registerNibForCollectionView:collectionView];
        _nibLoaded=YES;
    }
    return nil;
}

-(void)registerNibForCollectionView:(UICollectionView *)collectionView
{
    // Override this in subclass to register cells
}

- (NSInteger)numberOfItemsInSection{
    return self.dataArray.count;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)insetForSection{
    return UIEdgeInsetsZero;
}

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)index{
    return 0.0f;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)index{
    return 0.0f;
}

- (UICollectionReusableView*)sectionHeaderViewForCollectionView:(UICollectionView*)collectionView atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (UICollectionReusableView*)sectionFooterViewForCollectionView:(UICollectionView*)collectionView atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (CGSize)sectionHeaderSize{
    return CGSizeZero;
}

- (CGSize)sectionFooterSize{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
