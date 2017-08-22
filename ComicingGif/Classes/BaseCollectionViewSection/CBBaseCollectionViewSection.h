//
//  CBBaseCollectionViewSection.h
//  ComicBook
//
//  Created by Atul Khatri on 02/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBBaseCollectionViewCell.h"

@interface CBBaseCollectionViewSection : NSObject
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, assign) NSInteger index;

- (UICollectionReusableView*)sectionHeaderViewForCollectionView:(UICollectionView*)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView*)sectionFooterViewForCollectionView:(UICollectionView*)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (CBBaseCollectionViewCell*)cellForCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)registerNibForCollectionView:(UICollectionView *)collectionView;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)index;
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)index;
- (NSInteger)numberOfItemsInSection;
- (UIEdgeInsets)insetForSection;
- (CGSize)sectionHeaderSize;
- (CGSize)sectionFooterSize;
@end
