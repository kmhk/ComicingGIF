//
//  ComicCell.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 08/10/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *viewComicBook;
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *mUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblComicTitle;

@property (weak, nonatomic) IBOutlet UIView *viewComicCointainer;

@property (weak, nonatomic) IBOutlet UIButton *btnBubble;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicTitle;

@end
