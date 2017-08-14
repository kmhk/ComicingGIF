//
//  FriendsListTableViewCell.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *lblUerName;
@property (weak, nonatomic) IBOutlet UIImageView *selectedTickImage;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;

@end
