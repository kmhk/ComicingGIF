//
//  SignUp.m
//  ComicApp
//
//  Created by Ramesh on 07/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "SignUp.h"
#import "ComicNetworking.h"
#import "AppConstants.h"

@implementation SignUp


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"SignUp" owner:self options:nil];
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
        [[NSBundle mainBundle] loadNibNamed:@"SignUp" owner:self options:nil];
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
    
    //Config Caption text
    self.imgProfilePic.center = CGPointMake(self.frame.size.width  / 2,self.imgProfilePic.center.y);
    
    if (IS_IPHONE_3G) {
        //Config Caption text
        CGRect temRect = self.captionText.frame;
        temRect.origin.y = temRect.origin.y - 10;
        self.captionText.frame = temRect;
        self.captionText.center = CGPointMake(self.frame.size.width  / 2,self.captionText.center.y);
        
        //Config Button
        temRect = self.btnGetCode.frame;
        temRect.size.width= self.frame.size.width;
        temRect.origin.y = temRect.origin.y-76;
        self.btnGetCode.frame = temRect;
        
        //Config caption2
        temRect = self.lblCaptionText2.frame;
        temRect.origin.y = self.btnGetCode.frame.origin.y - temRect.size.height;
        self.lblCaptionText2.frame = temRect;
        
        self.lblCaptionText2.center = CGPointMake(self.frame.size.width  / 2,self.lblCaptionText2.center.y);
        
        //Config flag
        temRect = self.flagHolderView.frame;
        temRect.origin.x = 20;
        temRect.origin.y = self.captionText.frame.origin.y + self.captionText.frame.size.height + 5;
        self.flagHolderView.frame = temRect;
        
        //Config Mobile
        temRect = self.txtMobileNumber.frame;
        temRect.origin.x = temRect.origin.x - 25;
        temRect.origin.y = self.captionText.frame.origin.y + self.captionText.frame.size.height + 5;
        self.txtMobileNumber.frame = temRect;
        
        [self.lblCaptionText2 setHidden:YES];
    }
    else if (IS_IPHONE_5) {
        
        //Config Caption text
        CGRect temRect = self.captionText.frame;
        temRect.origin.y = temRect.origin.y - 13;
        self.captionText.frame = temRect;
        self.captionText.center = CGPointMake(self.frame.size.width  / 2,self.captionText.center.y);
        
        //Config Button
        temRect = self.btnGetCode.frame;
        temRect.size.width= self.frame.size.width;
        temRect.origin.y = temRect.origin.y - 29;
        self.btnGetCode.frame = temRect;
        
        //Config caption2
        temRect = self.lblCaptionText2.frame;
        temRect.origin.y = self.btnGetCode.frame.origin.y - temRect.size.height;
        self.lblCaptionText2.frame = temRect;
        
        self.lblCaptionText2.center = CGPointMake(self.frame.size.width  / 2,self.lblCaptionText2.center.y);
        
        //Config flag
        temRect = self.flagHolderView.frame;
        temRect.origin.x = 20;
        self.flagHolderView.frame = temRect;
        //Config Mobile
        temRect = self.txtMobileNumber.frame;
        temRect.origin.x = temRect.origin.x - 25;
        self.txtMobileNumber.frame = temRect;
    }else if (IS_IPHONE_6){
        //Config button
        CGRect temRect = self.btnGetCode.frame;
        temRect.origin.y = temRect.origin.y + 5;
        self.btnGetCode.frame = temRect;
    }else if(IS_IPHONE_6P){
        //Config button
        CGRect temRect = self.btnGetCode.frame;
        temRect.origin.y = temRect.origin.y + 15;
        self.btnGetCode.frame = temRect;
    }

//    [self.imgProfilePic setImage:[UIImage imageNamed:@"faceSignUp.png"]];
}

-(void)configView{
    
    self.txtMobileNumber.delegate = self;
    [[self txtFlag] setTintColor:[UIColor clearColor]];
    self.flagHolderView.layer.borderColor = [[UIColor colorWithHexStr:@"5f7f94"] CGColor];
    self.flagHolderView.layer.cornerRadius = 15;
    self.flagHolderView.layer.masksToBounds = YES;
    self.flagHolderView.layer.borderWidth = 1.0f;
    
    [self setTextFont];
    
    [self.captionText sizeToFit];
    self.captionText.numberOfLines = 0;
    [self bindPickerData];
    [self setPicker];
    
}
-(void)setTextFont{
    
    // Create the attributes
    NSDictionary *attrs = @{
                            NSFontAttributeName:[UIFont fontWithName:@"Myriad Roman" size:IS_IPHONE_5?25:IS_IPHONE_3G?10:28],
                            NSForegroundColorAttributeName:[UIColor whiteColor]
                            };
    NSDictionary *subAttrs = @{
                               NSFontAttributeName:[UIFont fontWithName:@"MYRIADPRO-BOLD" size:IS_IPHONE_5?23:IS_IPHONE_3G?8:26]
                               };
    
    const NSRange range = NSMakeRange(11,5);
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:self.captionText.text
                                           attributes:attrs];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:IS_IPHONE_5?5:IS_IPHONE_3G?2:10];
    
    [attributedText setAttributes:subAttrs range:range];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                           range:NSMakeRange(0, [self.captionText.text length])];

    // Set it in our UILabel and we are done!
    [self.captionText setAttributedText:attributedText];
    
    [self.signUpHeadText setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_3G?14:28]];

    [self.lblCaptionText2 setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_5?18:IS_IPHONE_3G?10:21]];
    [self.btnGetCode.titleLabel setFont:[UIFont  fontWithName:@"Myriad Roman" size:28]];
    [self.txtMobileNumber setFont:[UIFont  fontWithName:@"Myriad Roman" size:28]];
    [self.lblCountryCode setFont:[UIFont  fontWithName:@"Myriad Roman" size:24]];
}
-(void)bindData{
    
    [self getCountriesFlag];
//    [self bindFlagImage];
//    [self bindCountryCode];
    [self bindProfilePic];
}
-(void)bindFlagImage{
    [self.imgFlag setImage:[UIImage imageNamed:@"flagImage.png"]];
}
-(void)bindCountryCode{
    self.lblCountryCode.text = @"+1";
}
-(void)bindProfilePic{
//    [self.imgProfilePic setImage:[UIImage imageNamed:@"faceSignUp.png"]];
}
-(void)showAlertMessage:(NSString*)message{
    UIAlertView* alt = [[UIAlertView alloc] initWithTitle:@""
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil, nil];
    [alt show];
    alt = nil;
}

-(NSMutableArray*)bindPickerData{
    if (pickerData) {
        pickerData = nil;
    }
    pickerData = [[NSMutableArray alloc] init];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];

    NSLocale *theLocale = [NSLocale currentLocale];
    
    for (int i= 0; i < [parsedObject count]; i++) {
        NSDictionary *dicObj = [parsedObject objectAtIndex:i];
        [pickerData addObject:[dicObj objectForKey:@"name"]];
        if ([[[dicObj objectForKey:@"iso" ] lowercaseString]
             isEqualToString:[[theLocale
                               objectForKey:NSLocaleCountryCode] lowercaseString]]) {
            currentDeviceCode = i;
        }
    }
    return pickerData;
}
-(void)setPicker{
    
    if (datePicker) {
        datePicker = nil;
    }
    datePicker = [[UIPickerView alloc] init];
    
    CGRect frame = datePicker.frame;
    frame.size.height = frame.size.height + (IS_IPHONE_6P?10:0);
    
    datePicker.frame = frame;
    
    datePicker.delegate = self;
    datePicker.showsSelectionIndicator = YES;
    self.txtFlag.inputView = datePicker;
    
    [datePicker selectRow:currentDeviceCode inComponent:0 animated:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnGetCodeClick:(id)sender {
    NSString* mNumber = [[[[self.txtMobileNumber.text
                            stringByReplacingOccurrencesOfString:@"(" withString:@""]
                           stringByReplacingOccurrencesOfString:@")" withString:@""]
                          stringByReplacingOccurrencesOfString:@"-" withString:@""]
                         stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mNumber.length <= 6) {
        [self showAlertMessage:@"Please enter valid mobile number"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCodeRequest:)])
    {
        [self.delegate getCodeRequest:mNumber];
    }

}

#pragma mark UIPicker delegate

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary* selectedCountry = [parsedObject objectAtIndex:row];
    
    NSString* flagUrl = [selectedCountry objectForKey:@"flag"];
    flagUrl = [flagUrl stringByReplacingOccurrencesOfString:@"#SERVER_URL#" withString:SERVER_URL];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:flagUrl]]];
    [self.imgFlag setImage:image];
    NSString* txtCode = [selectedCountry objectForKey:@"dial_code"];
    if (txtCode.length > 3) {
        [self.lblCountryCode setFont:[UIFont  fontWithName:@"Myriad Roman" size:18]];
        self.lblCountryCode.text =  txtCode;
    }else{
        self.lblCountryCode.text =  txtCode;
    }
}

#pragma mark - Phone Number Field Formatting

// Adopted from: http://stackoverflow.com/questions/6052966/phone-number-formatting
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == self.mobileNumberField || textField == self.homeNumberField || textField == self.workNumberField) {
        NSUInteger length = [self getLength:textField.text];
        
        if(length == 10) {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3) {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6) {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
//    }
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSUInteger length = [mobileNumber length];
    if(length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}


-(NSUInteger)getLength:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSUInteger length = [mobileNumber length];
    return length;
}

#pragma mark api
-(void)getCountriesFlag{
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *code = [theLocale objectForKey:NSLocaleCountryCode];
    NSString* flagUrl = [AppHelper getCountryImageByisoCode:code];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:flagUrl]]];
    [self.imgFlag setImage:image];
    self.lblCountryCode.text = [AppHelper getDialCodeByisoCode:code];
}
@end
