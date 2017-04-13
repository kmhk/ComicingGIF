//
//  FindFriendsTableCell.m
//  ComicApp
//
//  Created by Ramesh on 10/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "FindFriendsTableCell.h"

@implementation FindFriendsTableCell

- (void)awakeFromNib {
    // Initialization code
    
    self.btnInvite.layer.cornerRadius = 15;
    self.btnInvite.layer.borderWidth= 2.0;
    self.btnInvite.layer.masksToBounds = YES;
    self.btnInvite.layer.borderColor=[[UIColor colorWithHexStr:@"263E8E"] CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
