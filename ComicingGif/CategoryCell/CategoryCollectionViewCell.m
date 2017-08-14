//
//  CategoryCollectionViewCell.m
//  ComicBook
//
//  Created by Amit on 01/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@interface CategoryCollectionViewCell() {
    UIColor *selectionColor;
}

@end

@implementation CategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    selectionColor = [UIColor colorWithRed:32/255.f green:165/255.f blue:226/255.f alpha:1.f];
}

- (void)shouldSelectCell:(BOOL)shouldSelect {
    if (shouldSelect) {
        [_categoryName setTextColor:selectionColor];
        _categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Blue",_imageNamePrefix]];
    } else {
        [_categoryName setTextColor:[UIColor whiteColor]];
        _categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@White",_imageNamePrefix]];
    }
}

@end
