//
//  MainPageCell.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 26/06/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *const_Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *const_Width;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint*widthconstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *viewComicBook;
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *mUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblComicTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicTitle;
@property(strong, nonatomic) NSString *fontName;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintCointainerView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpacingComicView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBubbleBottomConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnFacebookBottomConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTwitterBottomConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintComicView;
@property (weak, nonatomic) IBOutlet UIView *viewComicCointainer;

@property (weak, nonatomic) IBOutlet UIButton *btnBubble;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;


@end
