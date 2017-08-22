//
//  CMCUserCell.m
//  ComicApp
//
//  Created by ADNAN THATHIYA on 01/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import "CMCUserCell.h"
#import "UIButton+WebCache.h"

@interface CMCUserCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgvUser;

@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@end

@implementation CMCUserCell

@synthesize user, imgvUser, btnUser;

- (void)setUser:(CMCUser *)userInfo
{
    user = userInfo;
    
    // imgvUser.image = user.imgProfile;
    
    //    [btnUser setBackgroundImage:user.imgProfile forState:UIControlStateNormal];
    //    [btnUser setBackgroundImage:user.imgProfile forState:UIControlStateHighlighted];
    //    [btnUser setBackgroundImage:user.imgProfile forState:UIControlStateSelected];
    
//    [btnUser sd_setBackgroundImageWithURL:user.profileImageURL forState:UIControlStateNormal placeholderImage:nil];
    [self.btnUser sd_setImageWithURL:user.profileImageURL forState:UIControlStateNormal];
    if ([user.role isEqualToString:@"2"])
    {
        /*CGRect frame = self.frame;
        
        frame.origin.y = frame.origin.y - 7;
        frame.origin.x = frame.origin.x - 11;
        frame.size.width = frame.size.width + 14;
        frame.size.height = frame.size.height + 14;
        
        self.frame = frame;
        
        btnUser.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));*/
    }
    else
    {
        //btnUser.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
    
    /*btnUser.layer.cornerRadius = CGRectGetHeight(btnUser.frame) / 2;
    btnUser.clipsToBounds = YES;
    btnUser.layer.masksToBounds=YES;*/
}
-(void)layoutSubviews
{
    if (btnUser.bounds.size.height != self.bounds.size.height)
    {
        btnUser.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
    }
    btnUser.layer.cornerRadius = self.bounds.size.height/2;;
    btnUser.clipsToBounds = YES;
    btnUser.layer.masksToBounds=YES;
}
- (IBAction)btnUserTouchDown:(id)sender
{
    [UIView animateWithDuration:0.1 animations:^
     {
         btnUser.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
     }];
}

- (IBAction)btnUserTouchUpInside:(id)sender
{
    [self restoreTransformWithBounceForView:btnUser];
}

- (IBAction)btnUserTouchUpOutside:(id)sender
{
    [self restoreTransformWithBounceForView:btnUser];
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
