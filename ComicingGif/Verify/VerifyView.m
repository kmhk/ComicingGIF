//
//  VerifyView.m
//  ComicApp
//
//  Created by Ramesh on 09/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "VerifyView.h"
#import "AppConstants.h"
#import "AppHelper.h"
#import "ComicNetworking.h"

@implementation VerifyView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"VerifyView" owner:self options:nil];
        self.view.frame = self.frame;
        [self addSubview:self.view];
        
        [self configView];
        
        //Just for test
//        [self bindData];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"VerifyView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self configView];
        [self prepareView];
        //Just for test
//        [self bindData];
    }
    return self;
}


#pragma Methods

-(void)prepareView{
    
    self.imgProfilePic.center = CGPointMake(self.frame.size.width  / 2,self.imgProfilePic.center.y);
    CGRect temRect = CGRectZero;
    
    [_txtVerifyCode1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtVerifyCode2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtVerifyCode3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtVerifyCode4 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
   
    if (IS_IPHONE_3G) {
        temRect = self.verifyCode1ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 170;
        temRect.origin.x = temRect.origin.x - 55;
        self.verifyCode1ViewHolder.frame = temRect;
        
        temRect = self.verifyCode2ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 170;
        temRect.origin.x = temRect.origin.x - 55;
        self.verifyCode2ViewHolder.frame = temRect;
        
        temRect = self.verifyCode3ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 170;
        temRect.origin.x = temRect.origin.x - 55;
        self.verifyCode3ViewHolder.frame = temRect;
        
        temRect = self.verifyCode4ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 170;
        temRect.origin.x = temRect.origin.x - 55;
        self.verifyCode4ViewHolder.frame = temRect;
        
        temRect = self.lblMobileNumber.frame;
        temRect.origin.y = temRect.origin.y - 130;
        temRect.origin.x = temRect.origin.x - 20;
        self.lblMobileNumber.frame = temRect;
        
        temRect = self.flagHolderView.frame;
        temRect.origin.y = temRect.origin.y - 130;
        temRect.origin.x = temRect.origin.x - 20;
        self.flagHolderView.frame = temRect;
        
        temRect = self.btnEnterCode.frame;
        temRect.origin.y = temRect.origin.y - 230;
        temRect.size.width = self.frame.size.width;
        temRect.size.height = temRect.size.height - 10;
        self.btnEnterCode.frame = temRect;
        
        temRect = self.captionText.frame;
        temRect.origin.y = temRect.origin.y - 60;
        self.captionText.frame = temRect;
    }
    else if (IS_IPHONE_6) {
        
        //Config button
        temRect = self.btnEnterCode.frame;
        temRect.origin.y = temRect.origin.y - 59;
        self.btnEnterCode.frame = temRect;
        
        temRect = self.verifyCode1ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 20;
        temRect.origin.x = temRect.origin.x -28;
        self.verifyCode1ViewHolder.frame = temRect;
        
        temRect = self.verifyCode2ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 20;
        temRect.origin.x = temRect.origin.x -28;
        self.verifyCode2ViewHolder.frame = temRect;
        
        temRect = self.verifyCode3ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 20;
        temRect.origin.x = temRect.origin.x -28;
        self.verifyCode3ViewHolder.frame = temRect;
        
        temRect = self.verifyCode4ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 20;
        temRect.origin.x = temRect.origin.x -28;
        self.verifyCode4ViewHolder.frame = temRect;
        
        temRect = self.lblMobileNumber.frame;
        temRect.origin.x = temRect.origin.x - 20;
        self.lblMobileNumber.frame = temRect;
        
        temRect = self.flagHolderView.frame;
        temRect.origin.x = temRect.origin.x - 20;
        self.flagHolderView.frame = temRect;
        
        temRect = self.captionText.frame;
        temRect.origin.x = temRect.origin.x - 20;
        self.captionText.frame = temRect;
    }else if (IS_IPHONE_5)
    {
        temRect = self.verifyCode1ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 100;
        temRect.origin.x = temRect.origin.x - 55;
        self.verifyCode1ViewHolder.frame = temRect;
        
        temRect = self.verifyCode2ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 100;
        temRect.origin.x = temRect.origin.x - 55;
        self.verifyCode2ViewHolder.frame = temRect;
        
        temRect = self.verifyCode3ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 100;
        temRect.origin.x = temRect.origin.x - 55;
        self.verifyCode3ViewHolder.frame = temRect;
        
        temRect = self.verifyCode4ViewHolder.frame;
        temRect.origin.y = temRect.origin.y - 100;
        temRect.origin.x = temRect.origin.x - 55;
        self.verifyCode4ViewHolder.frame = temRect;
        
        temRect = self.lblMobileNumber.frame;
        temRect.origin.y = temRect.origin.y - 70;
        temRect.origin.x = temRect.origin.x - 20;
        self.lblMobileNumber.frame = temRect;
        
        temRect = self.flagHolderView.frame;
        temRect.origin.y = temRect.origin.y - 70;
        temRect.origin.x = temRect.origin.x - 20;
        self.flagHolderView.frame = temRect;
        
        temRect = self.btnEnterCode.frame;
        temRect.origin.y = temRect.origin.y - 159;
        temRect.size.width = self.frame.size.width;
        self.btnEnterCode.frame = temRect;
        
        temRect = self.captionText.frame;
        temRect.origin.y = temRect.origin.y - 20;
        self.captionText.frame = temRect;
    }
    
//    [self.imgProfilePic setImage:[UIImage imageNamed:@"faceSignUp.png"]];
}


-(void)configView{
//    [self.txtVerifyCode1 becomeFirstResponder];
    
//    self.flagHolderView.layer.borderColor = [[UIColor colorWithHexStr:@"5f7f94"] CGColor];
//    self.flagHolderView.layer.cornerRadius = 15;
//    self.flagHolderView.layer.masksToBounds = YES;
//    self.flagHolderView.layer.borderWidth = 1.0f;
    
    
    self.txtVerifyCode1.delegate =self;
    self.txtVerifyCode2.delegate =self;
    self.txtVerifyCode3.delegate =self;
    self.txtVerifyCode4.delegate =self;
    
    [self setTextFont];
    
    [self.captionText sizeToFit];
    self.captionText.numberOfLines = 0;
    
    [self.btnEnterCode setAlpha:0];
}

-(void)setActiveEnterCodeButton{
//    if (self.txtVerifyCode1.text.length > 0 &&
//        self.txtVerifyCode2.text.length > 0 &&
//        self.txtVerifyCode3.text.length > 0 &&
//        self.txtVerifyCode4.text.length > 0 &&
//        !self.btnEnterCode.selected) {
    
        //fade in
        [UIView animateWithDuration:2.0f animations:^{
            [self.btnEnterCode setAlpha:1];
        } completion:^(BOOL finished) {
//            self.btnEnterCode.selected = YES;
        }];
//    }else if(self.btnEnterCode.selected == YES)
//    {
//        //fade out
//        [UIView animateWithDuration:2.0f animations:^{
//            [self.btnEnterCode setHidden:0];
//        } completion:^(BOOL finished) {
//             self.btnEnterCode.selected = NO;
//        }];
//    }
}




-(void)setTextFont{
    
    [self.captionText setFont:[UIFont fontWithName:@"Myriad Roman" size:IS_IPHONE_5?20:IS_IPHONE_3G?14:28]];
    [self.verifyHeadText setFont:[UIFont  fontWithName:@"Myriad Roman" size:28]];
    [self.btnEnterCode.titleLabel setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_3G?14:28]];
    [self.lblMobileNumber setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_5?20:IS_IPHONE_3G?14:28]];
    [self.lblCountryCode setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_5?20:IS_IPHONE_3G?14:28]];

    CALayer *TopBorder1 = [CALayer layer];
    TopBorder1.frame = CGRectMake(0.0f, self.verifyCode1ViewHolder.frame.size.height, self.verifyCode1ViewHolder.frame.size.width, 1.0f);
    TopBorder1.backgroundColor = [UIColor whiteColor].CGColor;

    CALayer *TopBorder2 = [CALayer layer];
    TopBorder2.frame = CGRectMake(0.0f, self.verifyCode1ViewHolder.frame.size.height, self.verifyCode1ViewHolder.frame.size.width, 1.0f);
    TopBorder2.backgroundColor = [UIColor whiteColor].CGColor;
    
    CALayer *TopBorder3 = [CALayer layer];
    TopBorder3.frame = CGRectMake(0.0f, self.verifyCode1ViewHolder.frame.size.height, self.verifyCode1ViewHolder.frame.size.width, 1.0f);
    TopBorder3.backgroundColor = [UIColor whiteColor].CGColor;
    
    CALayer *TopBorder4 = [CALayer layer];
    TopBorder4.frame = CGRectMake(0.0f, self.verifyCode1ViewHolder.frame.size.height, self.verifyCode1ViewHolder.frame.size.width, 1.0f);
    TopBorder4.backgroundColor = [UIColor whiteColor].CGColor;
    
    
    [self.verifyCode1ViewHolder.layer addSublayer:TopBorder1];
    [self.verifyCode2ViewHolder.layer addSublayer:TopBorder2];
    [self.verifyCode3ViewHolder.layer addSublayer:TopBorder3];
    [self.verifyCode4ViewHolder.layer addSublayer:TopBorder4];
    
    [self.txtVerifyCode1 setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_3G?14:28]];
    [self.txtVerifyCode2 setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_3G?14:28]];
    [self.txtVerifyCode3 setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_3G?14:28]];
    [self.txtVerifyCode4 setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_3G?14:28]];
}

//-(void)bindData{
//    
//    [self bindFlagImage];
//    [self bindCountryCode];
//    [self bindProfilePic];
//}
-(void)bindData:(UIImage*)flagImage CountryCode:(NSString*)cCode MobileNumber:(NSString*)mNumber{
    
    [self.imgFlag setImage:flagImage];
    self.lblCountryCode.text = cCode;
    self.lblMobileNumber.text= mNumber;
    
}
//-(void)bindFlagImage{
//    [self.imgFlag setImage:[UIImage imageNamed:@"flagImage.png"]];
//}
//-(void)bindCountryCode{
//    self.lblCountryCode.text = @"+1";
//}

//-(void)bindProfilePic{
//    [self.imgProfilePic setImage:[UIImage imageNamed:@"faceSignUp.png"]];
//}

#pragma mark uitextfilede delegate

#define MAXLENGTH 1

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setActiveEnterCodeButton];
}
- (void)textFieldDidEndEditing:(UITextField *)textField

{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.txtVerifyCode1) {
        [self.txtVerifyCode2 becomeFirstResponder];
    }
    else if (textField == self.txtVerifyCode2) {
        [self.txtVerifyCode3 becomeFirstResponder];
    }
    else if (textField == self.txtVerifyCode3) {
        [self.txtVerifyCode4 becomeFirstResponder];
    }
    return YES;
}

-(void)textFieldDidChange :(UITextField *)textField
{
    NSLog( @"text changed: %@", textField.text);
    
    if (textField.text.length >= 1)
    {
        if (textField == self.txtVerifyCode1)
        {
            [textField resignFirstResponder];
            [self.txtVerifyCode2 becomeFirstResponder];
        }
        else if (textField == self.txtVerifyCode2)
        {
            [textField resignFirstResponder];
            [self.txtVerifyCode3 becomeFirstResponder];
        }
        else if (textField == self.txtVerifyCode3)
        {
            [textField resignFirstResponder];
            [self.txtVerifyCode4 becomeFirstResponder];
        }
    }
    else
    {
        if (textField == self.txtVerifyCode4)
        {
            [textField resignFirstResponder];
            [self.txtVerifyCode3 becomeFirstResponder];
        }
        else if (textField == self.txtVerifyCode3)
        {
            [textField resignFirstResponder];
            [self.txtVerifyCode2 becomeFirstResponder];
        }
        else if (textField == self.txtVerifyCode2)
        {
            [textField resignFirstResponder];
            [self.txtVerifyCode1    becomeFirstResponder];
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = (textField.text.length - range.length) + string.length;
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newString.length > 1)
    {
        return NO;
    }
    
    return YES;
}



-(void)autoFillVeryficationCode:(NSString*)fourDigitCode{
//    [self.txtVerifyCode1 becomeFirstResponder];
}

-(NSString*)getUserEnterCode{
    return [NSString stringWithFormat:@"%@%@%@%@",self.txtVerifyCode1.text,self.txtVerifyCode2.text,self.txtVerifyCode3.text,self.txtVerifyCode4.text];
}

- (IBAction)btnVerifyButtonClick:(id)sender {
    
    //TO Check is code is valid or not
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    
    [userDic setObject:[self getUserEnterCode] forKey:@"verification_code"];
    [userDic setObject:[AppHelper getDeviceId] forKey:@"device_type"];
    [userDic setObject:[AppHelper getDeviceToken] forKey:@"device_token"];
    
    [dataDic setObject:userDic forKey:@"data"];
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking updateUserInfo:dataDic Id:[AppHelper getCurrentLoginId] completion:^(id json,id jsonResposeHeader) {
#if TARGET_OS_SIMULATOR
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(getVerifyRequest)])
        {
            [AppHelper hideAllDropMessages];
            [self.txtVerifyCode1 resignFirstResponder];
            [self.txtVerifyCode2 resignFirstResponder];
            [self.txtVerifyCode3 resignFirstResponder];
            [self.txtVerifyCode4 resignFirstResponder];
            [self.delegate getVerifyRequest];
        }
        
#else
        if ([json objectForKey:@"result"] &&
            [[json objectForKey:@"result"] isEqualToString:@"failed"]) {
            [AppHelper showSuccessDropDownMessage:@"Invalid verification code" mesage:@""];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(getVerifyRequest)])
            {
                [AppHelper hideAllDropMessages];
                [self.txtVerifyCode1 resignFirstResponder];
                [self.txtVerifyCode2 resignFirstResponder];
                [self.txtVerifyCode3 resignFirstResponder];
                [self.txtVerifyCode4 resignFirstResponder];
                [self.delegate getVerifyRequest];
            }
        }
#endif
    } ErrorBlock:^(JSONModelError *error) {
        
        [AppHelper showSuccessDropDownMessage:ERROR_MESSAGE mesage:@""];
    }];
    
    
}

@end
