//
//  LoginViewController.h
//  ComicMakingPage
//
//  Created by Ramesh on 15/02/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtLoginId;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;


@end
