//
//  FindFriendsTableCell.h
//  ComicApp
//
//  Created by Ramesh on 10/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+colorWithHexString.h"

@interface FindFriendsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSelectCell;


@end
