//
//  CMCExpandableCollectionView.h
//  ComicingGif
//
//  Created by Ahmed Sulaiman on 7/19/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMCExpandableCollectionViewDelegate <UICollectionViewDelegateFlowLayout>
@optional
- (void)collectionView:(UICollectionView *)collectionView didExpandItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView willCollapseItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didCollapseItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView firstItemDidSelectedWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface CMCExpandableCollectionView : UICollectionView

@property (nonatomic, assign) id <CMCExpandableCollectionViewDelegate> delegate;
@property (nonatomic, assign) BOOL allowsMultipleExpandedSections;

- (BOOL)isExpandedSection:(NSInteger)section;
- (void)addExpandedSection:(BOOL)isExpanded;
- (void)insertExpandedSection:(BOOL)isExpanded atIndex:(NSUInteger)index;
- (void)collapseAllSections;


- (void)collapseActiveSection;

@end
