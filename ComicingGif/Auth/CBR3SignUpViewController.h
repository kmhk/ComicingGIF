//
//  CBR3SignUpViewController.h
//  ComicBook
//
//  Created by Sandeep Kumar Lall on 08/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUp.h"
#import "AccountView.h"

@interface CBR3SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet SignUp *signUpMobileNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgvCrop;
@property (weak, nonatomic) IBOutlet UIImageView *imgAnimatedView;
@property (strong, nonatomic) UIImage *faceImg;
@property (strong, nonatomic) UIImageView *faceImgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgFinalCopedFace;
@property (weak, nonatomic) IBOutlet UIView *cropHolder;
@property (strong, nonatomic) IBOutlet AccountView *accountHolderView;

@end
