//
//  MeCell.m
//  CurlDemo
//
//  Created by Subin Kurian on 11/1/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import "MeCell.h"
#import "AppConstants.h"

@implementation MeCell
@synthesize widthconstraint;

@synthesize lblComicTitle;

- (void)awakeFromNib
{
    // Initialization code

    if (IS_IPHONE_5)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
    }
    else if (IS_IPHONE_6)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:26];
    }
    else if (IS_IPHONE_6P)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:29];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
