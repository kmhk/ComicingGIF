//
//  RegistrationViewController.h
//  ComicApp
//
//  Created by Ramesh on 07/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUp.h"
#import "VerifyView.h"
#import "AccountView.h"
#import "FindFriendsView.h"
#import "ProfilePicView.h"
#import "CropStickerViewController.h"

@interface RegistrationViewController : UIViewController<SignUpDelegate,VerifyDelegate,AccountDelegate,ProfilePicDelegate,CropStickerViewControllerDelegate>
@property (strong, nonatomic) IBOutlet SignUp *signUpView;
@property (strong, nonatomic) VerifyView *verifyView;
@property (strong, nonatomic) AccountView *accountView;
@property (strong, nonatomic) FindFriendsView *findFriendsView;
@property (strong, nonatomic) IBOutlet ProfilePicView *ProfilePicView;
@end
