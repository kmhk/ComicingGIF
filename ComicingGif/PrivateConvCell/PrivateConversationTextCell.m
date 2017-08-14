//
//  PrivateConversationTextCell.m
//  ComicBook
//
//  Created by Guntikogula Dinesh on 10/07/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "PrivateConversationTextCell.h"
#import "AppConstants.h"

@implementation PrivateConversationTextCell

@synthesize btnUser, userProfilePic;

- (void)awakeFromNib {
    // Initialization code
    
    [self.mMessageHolderView setClipsToBounds:YES];
    [self.mMessageHolderView.layer setMasksToBounds:YES];
    [self.mMessageHolderView.layer setCornerRadius:8];
    
    
    /*if(IS_IPHONE_5)
    {
        btnUser.frame = CGRectMake(CGRectGetMinX(btnUser.frame),
                                   CGRectGetMinY(btnUser.frame),
                                   30,
                                   30);
        userProfilePic.frame = CGRectMake(CGRectGetMinX(userProfilePic.frame),
                                            CGRectGetMinY(userProfilePic.frame),
                                            30,
                                            30);
    }
    else if(IS_IPHONE_6)
    {
        btnUser.frame = CGRectMake(CGRectGetMinX(btnUser.frame),
                                   CGRectGetMinY(btnUser.frame) ,
                                   36,
                                   36);
        userProfilePic.frame = CGRectMake(CGRectGetMinX(userProfilePic.frame),
                                            CGRectGetMinY(userProfilePic.frame) ,
                                            36,
                                            36);
    }
    else if(IS_IPHONE_6P)
    {
        btnUser.frame = CGRectMake(CGRectGetMinX(btnUser.frame),
                                   CGRectGetMinY(btnUser.frame) ,
                                   40,
                                   40);
        userProfilePic.frame = CGRectMake(CGRectGetMinX(userProfilePic.frame),
                                            CGRectGetMinY(userProfilePic.frame) ,
                                            40,
                                            40);
    }*/
    
    
    CGFloat heiWei;
    
    if (IS_IPHONE_5)
    {
        heiWei = 30;
        _mUserName.font = [_mUserName.font fontWithSize:8.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:8.f];
        
    }
    else if (IS_IPHONE_6)
    {
        heiWei = 30;
        _mUserName.font = [_mUserName.font fontWithSize:9.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:9.f];
    }
    else if (IS_IPHONE_6P)
    {
        heiWei = 30;
        _mUserName.font = [_mUserName.font fontWithSize:10.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:10.f];
    }
    
    _const_Width.constant = heiWei;
    _const_Height.constant = heiWei;
    btnUser.layer.cornerRadius = heiWei / 2;
    btnUser.layer.masksToBounds = YES;
    userProfilePic.layer.cornerRadius = heiWei / 2;
    userProfilePic.layer.masksToBounds = YES;
    //    btnUser.layer.cornerRadius = CGRectGetHeight(btnUser.frame) / 2;
   /* btnUser.clipsToBounds = YES;
    
    //    userProfilePic.layer.cornerRadius = CGRectGetHeight(userProfilePic.frame) / 2;
    userProfilePic.clipsToBounds = YES;*/
    
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
         userProfilePic.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
     }];
}

- (IBAction)btnUserTouchUpInside:(id)sender
{
    [self restoreTransformWithBounceForView:btnUser];
    [self restoreTransformWithBounceForView:userProfilePic];
}

- (IBAction)btnUserTouchUpOutside:(id)sender
{
    [self restoreTransformWithBounceForView:btnUser];
    [self restoreTransformWithBounceForView:userProfilePic];
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
