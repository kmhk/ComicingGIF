//
//  MainPage3SlideCell.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 03/07/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicBook.h"

@interface MainPage3SlideCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *const_Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *const_Width;
@property (weak, nonatomic) IBOutlet UILabel *lblComicTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide1;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide2;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide3;

@property (weak, nonatomic) IBOutlet UIButton *btnBubble;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *viewComicBook;
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *mUserName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heighConstraintImgvSlide1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintComicView;

@property (strong, nonatomic) ComicBook *comic;

@end
