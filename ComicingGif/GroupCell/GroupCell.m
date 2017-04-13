//
//  GroupCell.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 05/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "GroupCell.h"
#import "AppConstants.h"
//
//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@implementation GroupCell

@synthesize widthconstraint,btnUser, profileImageView, lblComicTitle;

- (void)awakeFromNib {
    // Initialization code
    
    /*if(IS_IPHONE_5)
    {
        btnUser.frame = CGRectMake(CGRectGetMinX(btnUser.frame),
                                   CGRectGetMinY(btnUser.frame),
                                   30,
                                   30);
        profileImageView.frame = CGRectMake(CGRectGetMinX(profileImageView.frame),
                                   CGRectGetMinY(profileImageView.frame),
                                   30,
                                   30);
    }
    else if(IS_IPHONE_6)
    {
        btnUser.frame = CGRectMake(CGRectGetMinX(btnUser.frame),
                                   CGRectGetMinY(btnUser.frame) ,
                                   36,
                                   36);
        profileImageView.frame = CGRectMake(CGRectGetMinX(profileImageView.frame),
                                   CGRectGetMinY(profileImageView.frame) ,
                                   36,
                                   36);
    }
    else if(IS_IPHONE_6P)
    {
        btnUser.frame = CGRectMake(CGRectGetMinX(btnUser.frame),
                                   CGRectGetMinY(btnUser.frame) ,
                                   40,
                                   40);
        profileImageView.frame = CGRectMake(CGRectGetMinX(profileImageView.frame),
                                   CGRectGetMinY(profileImageView.frame) ,
                                   40,
                                   40);
    }*/
    
    CGFloat heiWei;

    if (IS_IPHONE_5)
    {
        heiWei = 34;
        _mUserName.font = [_mUserName.font fontWithSize:8.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:8.f];
        self.lblTime.font = [self.lblTime.font fontWithSize:8.f];
        
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];


    }
    else if (IS_IPHONE_6)
    {
        heiWei = 35;
        _mUserName.font = [_mUserName.font fontWithSize:9.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:9.f];
        self.lblTime.font = [self.lblTime.font fontWithSize:9.f];

        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:26];

    }
    else if (IS_IPHONE_6P)
    {
        heiWei = 36;
        _mUserName.font = [_mUserName.font fontWithSize:10.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:10.f];
        self.lblTime.font = [self.lblTime.font fontWithSize:10.f];
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:29];

    }
    
    _const_Width.constant = heiWei;
    _const_Height.constant = heiWei;
 //   btnUser.layer.cornerRadius = heiWei / 2;
 //   btnUser.layer.masksToBounds = YES;
    profileImageView.layer.cornerRadius = heiWei / 2;
    profileImageView.layer.masksToBounds = YES;
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if(IS_IPHONE_5)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
    }
    else if(IS_IPHONE_6)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:26];
        
    }
    else if(IS_IPHONE_6P)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:29];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)btnUserTouchDown:(id)sender
{
    [UIView animateWithDuration:0.1 animations:^
     {
         btnUser.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
         profileImageView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
     }];
}

- (IBAction)btnUserTouchUpInside:(id)sender
{
    [self restoreTransformWithBounceForView:btnUser];
    [self restoreTransformWithBounceForView:profileImageView];
}

- (IBAction)btnUserTouchUpOutside:(id)sender
{
    [self restoreTransformWithBounceForView:btnUser];
    [self restoreTransformWithBounceForView:profileImageView];
}

- (void)restoreTransformWithBounceForView:(UIView*)view
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^
     {
         view.layer.transform = CATransform3DIdentity;
     }
                     completion:nil];
}

@end
