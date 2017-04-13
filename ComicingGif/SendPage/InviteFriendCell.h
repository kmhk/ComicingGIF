//
//  InviteFriendCell.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 04/04/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSelectCell;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedTickImage;


@end
