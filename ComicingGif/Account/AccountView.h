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

@protocol AccountDelegate <NSObject>

@optional

-(void)getAccountRequest;

-(void)doImageAnimation:(BOOL)zoomIn;
-(void)openTermsService;

@end

@interface AccountView : UIView<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView* datePicker;
    BOOL isProcessing;
    NSMutableArray* pickerData;
}
@property (strong, nonatomic) IBOutlet UIView *view;
//@property (weak, nonatomic) IBOutlet UILabel *accountHeadText;
//@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (strong, nonatomic) UIImage *imgCropedImage;
@property (weak, nonatomic) IBOutlet UITextField *txtId;
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtAge;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptionText;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (nonatomic, assign) id<AccountDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnTermsService;

@property (nonatomic) BOOL isRegister;

- (IBAction)btnYesClick:(id)sender;

@end
