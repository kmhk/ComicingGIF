//
//  MeCell.h
//  CurlDemo
//
//  Created by Subin Kurian on 11/1/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCell : UITableViewCell
@property(nonatomic,weak)IBOutlet NSLayoutConstraint*widthconstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblComicTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpacingComicView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintComicView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicTitle;


@end
