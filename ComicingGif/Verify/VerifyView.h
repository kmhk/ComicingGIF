//
//  VerifyView.h
//  ComicApp
//
//  Created by Ramesh on 09/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+colorWithHexString.h"

@protocol VerifyDelegate <NSObject>

@optional

-(void)getVerifyRequest;

@end

@interface VerifyView : UIView<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *verifyHeadText;
@property (weak, nonatomic) IBOutlet UILabel *captionText;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UIView *flagHolderView;
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnEnterCode;

@property (weak, nonatomic) IBOutlet UIView *verifyCode1ViewHolder;
@property (weak, nonatomic) IBOutlet UIView *verifyCode2ViewHolder;
@property (weak, nonatomic) IBOutlet UIView *verifyCode3ViewHolder;
@property (weak, nonatomic) IBOutlet UIView *verifyCode4ViewHolder;

@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode1;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode2;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode3;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode4;
@property (nonatomic, assign) id<VerifyDelegate> delegate;

- (IBAction)btnVerifyButtonClick:(id)sender;

-(void)autoFillVeryficationCode:(NSString*)fourDigitCode;
-(void)bindData:(UIImage*)flagImage CountryCode:(NSString*)cCode MobileNumber:(NSString*)mNumber;
@end
