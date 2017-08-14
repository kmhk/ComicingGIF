//
//  CategoryCollectionViewCell.h
//  ComicBook
//
//  Created by Amit on 01/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCollectionViewCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property(weak, nonatomic) IBOutlet UILabel *categoryName;
@property(weak, nonatomic) NSString *imageNamePrefix;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *categoryNameLabelHeightConstraint;

- (void)shouldSelectCell:(BOOL)shouldSelect;

@end
