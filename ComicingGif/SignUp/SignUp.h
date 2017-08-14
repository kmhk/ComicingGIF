//
//  SignUp.h
//  ComicApp
//
//  Created by Ramesh on 07/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+colorWithHexString.h"

@protocol SignUpDelegate <NSObject>

@optional

-(void)getCodeRequest:(NSString*)mNumber;
//-(void)hideKeyBoard;
@end

@interface SignUp : UIView<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView* datePicker;
    NSMutableArray* pickerData;
    NSArray *parsedObject;
    NSInteger currentDeviceCode;
}

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *signUpHeadText;
@property (weak, nonatomic) IBOutlet UILabel *captionText;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UIView *flagHolderView;
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptionText2;
@property (nonatomic, assign) id<SignUpDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtFlag;

-(void)bindData;
- (IBAction)btnGetCodeClick:(id)sender;


@end
