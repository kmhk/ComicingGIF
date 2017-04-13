//
//  CBBaseCollectionViewController.h
//  ComicBook
//
//  Created by Atul Khatri on 02/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseViewController.h"

@interface CBBaseCollectionViewController : CBBaseViewController
- (void)ta_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)ta_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)ta_collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
- (void)ta_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)ta_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end
