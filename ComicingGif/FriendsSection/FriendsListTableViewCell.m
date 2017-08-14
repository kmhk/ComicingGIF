//
//  FriendsListTableViewCell.m
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "FriendsListTableViewCell.h"
#import "UIColor+colorWithHexString.h"

@implementation FriendsListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.userImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
//    self.userImage.layer.cornerRadius= self.userImage.frame.size.width/2;
//    self.userImage.layer.borderWidth=2.0;
//    self.userImage.layer.masksToBounds = YES;
//    self.userImage.layer.borderColor=[[UIColor clearColor] CGColor];
    
    self.btnInvite.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.btnInvite.layer.cornerRadius= 15;
    self.btnInvite.layer.borderWidth= 1.0;
    self.btnInvite.layer.masksToBounds = YES;
    self.btnInvite.layer.borderColor = [[UIColor colorWithHexStr:@"263E8E"] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
