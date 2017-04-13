//
//  PrivateConversationCell.h
//  CurlDemo
//
//  Created by Subin Kurian on 11/1/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateConversationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *const_Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *const_Width;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint*widthconstraint;
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIView *viewComicBook;
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UILabel *mUserName;
@property (weak, nonatomic) IBOutlet UILabel *mChatStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblComicTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicTitle;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintComicView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicView;


@end
