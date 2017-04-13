//
//  InviteFriendCell.m
//  ComicBook
//
//  Created by ADNAN THATHIYA on 04/04/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "InviteFriendCell.h"
#import "UIColor+colorWithHexString.h"

@implementation InviteFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btnInvite.layer.cornerRadius = 15;
    self.btnInvite.layer.borderWidth= 1.0;
    self.btnInvite.layer.masksToBounds = YES;
    self.btnInvite.layer.borderColor=[[UIColor colorWithHexStr:@"263E8E"] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
