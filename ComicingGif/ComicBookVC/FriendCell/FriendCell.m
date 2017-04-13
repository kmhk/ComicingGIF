//
//  FriendCell.m
//  ComicApp
//
//  Created by ADNAN THATHIYA on 22/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import "FriendCell.h"
#import "AppConstants.h"

@implementation FriendCell
@synthesize lblComicTitle;
- (void)awakeFromNib
{
    // Initialization code

    if(IS_IPHONE_5)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
    }
    else if(IS_IPHONE_6)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:26];
        
    }
    else if(IS_IPHONE_6P)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:29];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
