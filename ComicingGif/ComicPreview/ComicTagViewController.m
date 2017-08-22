//
//  ComicTagViewController.m
//  ComicBook
//
//  Created by Amit on 23/01/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "ComicTagViewController.h"

@interface ComicTagViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSArray *titles;
    NSArray *titleImageNames;
    NSInteger selectedIndex;
    
    UIColor *selectionColor;
}

@end

@implementation ComicTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titles = [NSArray arrayWithObjects:@"food", @"failed", @"pets", @"funny", @"beauty", @"travel", @"random", nil];
    titleImageNames = [NSArray arrayWithObjects:@"ComicTagFood", @"ComicTagFailed", @"ComicTagPets", @"ComicTagFunny", @"ComicTagBeauty", @"ComicTagTravel", @"ComicTagRandom", nil];
    selectionColor = [UIColor colorWithRed:32/255.f green:165/255.f blue:226/255.f alpha:1.f];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *tagCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCollectionViewCell" forIndexPath:indexPath];
    
    UIButton *button = ((UIButton *)[tagCollectionViewCell viewWithTag:101]);
    UIImage *normalImage = [UIImage imageNamed:[titleImageNames objectAtIndex:indexPath.item]];
    UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Blue",[titleImageNames objectAtIndex:indexPath.item]]];
    
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    
    UILabel *titleLabel = ((UILabel *)[tagCollectionViewCell viewWithTag:102]);
    titleLabel.text = [titles objectAtIndex:indexPath.item];
    
    button.selected = selectedIndex == indexPath.item;
    [titleLabel setTextColor: (selectedIndex == indexPath.item)? selectionColor: [UIColor whiteColor]];
    
    return tagCollectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.item;
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width / 4 - 1, self.collectionView.frame.size.height / 2 - 1);
}

#pragma mark - IBAction methods

- (IBAction)emptySpaceTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
