//
//  AccountView.h
//  ComicApp
//
//  Created by Ramesh on 09/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+colorWithHexString.h"
#import "ComicNetworking.h"
#import "FindFriendsViewController.h"

@interface AccountViewController : UIViewController
{
    UIDatePicker* datePicker;
    BOOL isProcessing;
}
@property (weak, nonatomic) IBOutlet UILabel *accountHeadText;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UITextField *txtId;
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtAge;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptionText;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (strong, nonatomic) UIImage *imgCropedImage;
//@property (nonatomic, assign) id<AccountDelegate> delegate;
- (IBAction)btnYesClick:(id)sender;

@end
