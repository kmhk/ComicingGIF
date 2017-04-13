//
//  CBBaseCollectionViewController.m
//  ComicBook
//
//  Created by Atul Khatri on 02/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseCollectionViewController.h"
#import "CBBaseCollectionViewSection.h"
#import "CBBaseCollectionViewCell.h"
#import "CBBaseCollectionViewSection.h"

@interface CBBaseCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation CBBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate= self;
    self.collectionView.dataSource= self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource/Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] numberOfItemsInSection];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self ta_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [self ta_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self ta_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [self ta_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}
#pragma mark – UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBBaseCollectionViewSection* section= [self.sectionArray objectAtIndex:indexPath.section];
    section.collectionView = collectionView;
    return [section sizeForItemAtIndexPath:indexPath];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return [[self.sectionArray objectAtIndex:section] insetForSection];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [[self.sectionArray objectAtIndex:section] sectionHeaderSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self ta_collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] minimumLineSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] minimumInteritemSpacingForSectionAtIndex:section];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark- Public methods
- (void)ta_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CBBaseCollectionViewSection* section= [self.sectionArray objectAtIndex:indexPath.section];
    [section collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

- (UICollectionViewCell *)ta_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CBBaseCollectionViewSection* section= [self.sectionArray objectAtIndex:indexPath.section];
    CBBaseCollectionViewCell* cell= [section cellForCollectionView:collectionView atIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)ta_collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CBBaseCollectionViewSection* section= [self.sectionArray objectAtIndex:indexPath.section];
    if(kind == UICollectionElementKindSectionHeader){
        return [section sectionHeaderViewForCollectionView:collectionView atIndexPath:indexPath];
    }else{
        return [section sectionFooterViewForCollectionView:collectionView atIndexPath:indexPath];
    }
}

- (void)ta_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)ta_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] sectionFooterSize];
}

@end
