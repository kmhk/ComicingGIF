//
//  AccountView.m
//  ComicApp
//
//  Created by Ramesh on 09/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "AccountView.h"
#import "AppConstants.h"
#import "InstructionView.h"

#define kOFFSET_FOR_KEYBOARD (IS_IPHONE_5?80.0:80)
#define Y_FOR_SUPERVIEW_KEYBOARD (IS_IPHONE_5?80.0:80)



CGRect firstFrame;
NSString* AgeDOB;
@implementation AccountView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:self options:nil];
        self.view.frame = self.frame;
        [self addSubview:self.view];
        
        [self configView];
        [self bindData];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:self options:nil];
        [self addSubview:self.view];
        [self.view setClipsToBounds:NO];
        [self configView];
        
        //Just for test
//        [self bindData];
    }
    return self;
}


#pragma Methods

-(void)configView{
    //    [self.txtId becomeFirstResponder];
    firstFrame = self.view.superview.frame;
    CGRect mainFrame = CGRectZero;
    
    self.txtId.leftViewMode = UITextFieldViewModeAlways;
    self.txtId.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RegisterId_White"]];
    self.txtId.leftView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect leftFrame = self.txtId.leftView.frame;
    leftFrame.size.width = 70;
    self.txtId.leftView.frame = leftFrame;
    if (IS_IPHONE_5 || IS_IPHONE_3G) {
        mainFrame = self.txtId.frame;
        mainFrame.origin.x = 110;
        self.txtId.frame=mainFrame;
    }
    self.txtId.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    [self.txtId setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtId setFont:[UIFont fontWithName:@"Avenir Light" size:IS_IPHONE_5?22:IS_IPHONE_3G?15:32]];
    
    self.txtpassword.leftViewMode = UITextFieldViewModeAlways;
    self.txtpassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Password_White"]];
    self.txtpassword.leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftFrame = self.txtpassword.leftView.frame;
    leftFrame.size.width = 73;
    self.txtpassword.leftView.frame = leftFrame;
    if (IS_IPHONE_5 || IS_IPHONE_3G) {
        mainFrame = self.txtpassword.frame;
        mainFrame.origin.x = 110;
        self.txtpassword.frame=mainFrame;
    }
    self.txtpassword.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    [self.txtpassword setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtpassword setFont:[UIFont fontWithName:@"Avenir Light" size:IS_IPHONE_5?22:IS_IPHONE_3G?15:32]];
    
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    self.txtEmail.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Email_White"]];
    self.txtEmail.leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftFrame = self.txtEmail.leftView.frame;
    leftFrame.size.width = 73;
    self.txtEmail.leftView.frame = leftFrame;
    if (IS_IPHONE_5 || IS_IPHONE_3G) {
        mainFrame = self.txtEmail.frame;
        mainFrame.origin.x = 110;
        self.txtEmail.frame=mainFrame;
    }
    self.txtEmail.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    [self.txtEmail setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtEmail setFont:[UIFont fontWithName:@"Avenir Light" size:IS_IPHONE_5?22:IS_IPHONE_3G?15:32]];
    
    self.txtAge.leftViewMode = UITextFieldViewModeAlways;
    self.txtAge.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Age_White"]];
    self.txtAge.leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftFrame = self.txtAge.leftView.frame;
    leftFrame.size.width = 75;
    self.txtAge.leftView.frame = leftFrame;
    if (IS_IPHONE_5 || IS_IPHONE_3G) {
        mainFrame = self.txtAge.frame;
        mainFrame.origin.x = 110;
        self.txtAge.frame=mainFrame;
    }
    self.txtAge.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    [self.txtAge setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtAge setFont:[UIFont fontWithName:@"Avenir Light" size:IS_IPHONE_5?22:IS_IPHONE_3G?15:32]];
    
    if (IS_IPHONE_5) {
        mainFrame = self.btnSignUp.frame;
        mainFrame.size.width = 216;
        mainFrame.size.height = 54;
        self.btnSignUp.frame = mainFrame;
        
        mainFrame = self.lblCaptionText.frame;
        mainFrame.origin.y = 350;
        self.lblCaptionText.frame = mainFrame;
        
        mainFrame = self.btnTermsService.frame;
        mainFrame.origin.y = 385;
        mainFrame.size.width = 155;
        self.btnTermsService.frame = mainFrame;
        
        [self.btnTermsService.titleLabel setFont:[UIFont fontWithName:@"Avenir Black" size:18]];
    }else if (IS_IPHONE_3G) {
        mainFrame = self.btnSignUp.frame;
        mainFrame.size.width = 216;
        mainFrame.size.height = 54;
        mainFrame.origin.y = mainFrame.origin.y - 50;
        self.btnSignUp.frame = mainFrame;
        
        mainFrame = self.lblCaptionText.frame;
        mainFrame.origin.y = 300;
        self.lblCaptionText.frame = mainFrame;
        [self.lblCaptionText setFont:[UIFont fontWithName:@"Avenir Light" size:11]];
        
        mainFrame = self.btnTermsService.frame;
        mainFrame.origin.y = 328;
        mainFrame.origin.x = mainFrame.origin.x - 80;
        mainFrame.size.width = 155;
        self.btnTermsService.frame = mainFrame;
        
        [self.btnTermsService.titleLabel setFont:[UIFont fontWithName:@"Avenir Black" size:9]];
    }
    
    [self setTextFont];
    [self openDatePicker];
    
    
    self.txtpassword.delegate = self;
    self.txtEmail.delegate = self;
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hideAllKeyBoard)];
    [self addGestureRecognizer:singleFingerTap];
    singleFingerTap = nil;
}

-(void)setTextFont{
//    [self.lblCaptionText setFont:[UIFont fontWithName:@"Avenir Light" size:IS_IPHONE_5?18:20]];
}

-(void)bindData{
    
    [self bindProfilePic];
}

-(void)bindProfilePic{
//    if (self.imgCropedImage) {
//        [self.imgProfilePic setImage:self.imgCropedImage];
//    }
}

-(void)addDoneButtonToAge{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(btnDoneClick:)]];
    [numberToolbar sizeToFit];
    self.txtAge.inputAccessoryView = numberToolbar;
}
-(NSString*)getSelectedDOB:(NSString*)ageString{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentYear = [components year];
    NSInteger myInt = [ageString intValue];

    NSInteger dobYear = currentYear - myInt;
    NSString *inStr = [NSString stringWithFormat: @"%ld", (long)dobYear];
    

    NSString* strValue = [NSString stringWithFormat:@"%@-01-01",inStr];
    return strValue;
}
//-(void)openDatePicker{
//    
//    if (datePicker) {
//        datePicker = nil;
//    }
//    
//    datePicker = [[UIDatePicker alloc] init];
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate *currentDate = [NSDate date];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setYear:-18];
//    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
//    [comps setYear:-150];
//    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
//    comps = nil;
//    
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    [datePicker addTarget:self action:@selector(datePickerValueChanged:)
//         forControlEvents:UIControlEventValueChanged];
//    datePicker.minimumDate = minDate;
//    datePicker.maximumDate = maxDate;
//    //    gregorian = nil;
//    
//    self.txtAge.inputView = datePicker;
//}

-(NSMutableArray*)addAgeRange{
    if (pickerData) {
        pickerData = nil;
    }
    pickerData = [[NSMutableArray alloc] init];
    for (int i= 10; i < 99; i++) {
        NSString *nAge = [NSString stringWithFormat: @"%ld", (long)i];
        [pickerData addObject:nAge];
    }
    return pickerData;
}

-(void)openDatePicker{
    
    if (datePicker) {
        datePicker = nil;
    }
    
    [self addAgeRange];
    datePicker = [[UIPickerView alloc] init];
    
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDate *currentDate = [NSDate date];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setYear:-18];
//    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
//    [comps setYear:-150];
//    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
//    comps = nil;
//    
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    [datePicker addTarget:self action:@selector(datePickerValueChanged:)
//         forControlEvents:UIControlEventValueChanged];
//    datePicker.minimumDate = minDate;
//    datePicker.maximumDate = maxDate;
    //    gregorian = nil;
    
    datePicker.delegate = self;
//    datePicker.dataSource = self;
    datePicker.showsSelectionIndicator = YES;

    self.txtAge.inputView = datePicker;
    AgeDOB = [self getSelectedDOB:@"99"];
}
-(BOOL)validateFileds:(BOOL)showAlert{
    //Validate is any filed are empty
    if ([self isTextEmpty:self.txtId] ||
        [self isTextEmpty:self.txtEmail] ||
        [self isTextEmpty:self.txtpassword]) {
        if (showAlert)
            [self showAlertMessage:@"Please fill the details."];
        return NO;
    }else if(![AppHelper isValidEmail:self.txtEmail.text]){
        //Validate email
        if (showAlert){
            [self showAlertMessage:@"Please enter valid email."];
            [self.txtEmail becomeFirstResponder];
        }
        return NO;
    }else if(self.txtpassword.text.length < 6){
        //Validate min password
        if (showAlert){
            [self showAlertMessage:@"Password should be at least 6 characters."];
            self.txtpassword.text = @"";
            [self.txtpassword becomeFirstResponder];
        }
        return NO;
    }else
        if (![self isTextEmpty:self.txtAge])
            if(datePicker && self.txtAge && self.txtAge.text.length > 0){
                NSInteger intAgeValue = [self.txtAge.text intValue];
                if(intAgeValue < 17)
                {
                    if (showAlert)
                        [self showAlertMessage:@"Age should be 17+."];
                    return NO;
                }
            }
    return YES;
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

-(BOOL)isTextEmpty:(UITextField*)txt{
    BOOL empty = YES;
    if (txt && ![txt.text isEqualToString:@""]) {
        empty = NO;
    }
    return empty;
}

-(void)keyboardWillShow {
//    // Animate the current view out of the way
//    if (self.view.superview.frame.origin.y >= Y_FOR_SUPERVIEW_KEYBOARD)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if (self.view.superview.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
}

-(void)keyboardWillHide {
    [self setViewMovedUp:NO];
}
-(void)clearPlaceHolder:(UITextField*)txtField{
    txtField.placeholder = @"";
}
-(void)addPlaceHolder:(UITextField*)txtFiled{
    if (txtFiled == self.txtId) {
        self.txtId.placeholder = @"My ID";
    }else if (txtFiled == self.txtpassword) {
        self.txtpassword.placeholder = @"Password";
    }
    else if (txtFiled == self.txtEmail) {
        self.txtEmail.placeholder = @"Email";
    }
    else if (txtFiled == self.txtAge) {
        self.txtAge.placeholder = @"Age (optional)";
    }
}

-(void)selectedCurrentRow:(UITextField*)textField{
    UIImageView* imgLeftView = nil;
    imgLeftView = (UIImageView*)textField.leftView;
    if (imgLeftView) {
        if (textField == self.txtId) {
            [imgLeftView setImage:[UIImage imageNamed:@"RegisterId_Blue"]];
        }else if (textField == self.txtpassword) {
            [imgLeftView setImage:[UIImage imageNamed:@"Password_Blue"]];
        }else if (textField == self.txtEmail) {
            [imgLeftView setImage:[UIImage imageNamed:@"Email_Blue"]];
        }else if (textField == self.txtAge) {
            [imgLeftView setImage:[UIImage imageNamed:@"Age_Blue"]];
        }
    }
    textField.textColor = [UIColor colorWithHexStr:@"263D8E"];
}

-(void)deSelectAllTheRow{
    UIImageView* imgLeftView = nil;
    
    
    imgLeftView = (UIImageView*)self.txtId.leftView;
    if (imgLeftView) {
        [imgLeftView setImage:[UIImage imageNamed:@"RegisterId_White"]];
    }
    self.txtId.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    
    imgLeftView = (UIImageView*)self.txtpassword.leftView;
    if (imgLeftView) {
        [imgLeftView setImage:[UIImage imageNamed:@"Password_White"]];
    }
    self.txtpassword.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    
    imgLeftView = (UIImageView*)self.txtEmail.leftView;
    if (imgLeftView) {
        [imgLeftView setImage:[UIImage imageNamed:@"Email_White"]];
    }
    self.txtEmail.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    
    imgLeftView = (UIImageView*)self.txtAge.leftView;
    if (imgLeftView) {
        [imgLeftView setImage:[UIImage imageNamed:@"Age_White"]];
    }
    self.txtAge.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
    [UIView setAnimationDelay:0.2];
    CGRect rect = self.view.superview.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y = kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
        if (self.delegate && [self.delegate respondsToSelector:@selector(doImageAnimation:)])
        {
            [self.delegate doImageAnimation:NO];
        }
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y = firstFrame.origin.y;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        [self.delegate doImageAnimation:YES];
    }
    self.view.superview.frame = rect;
    
    [UIView commitAnimations];
}

- (IBAction)SignUpButtonClick:(id)sender {

    [self btnDoneClick:nil];
}
-(void)hideAllKeyBoard{
    [self deSelectAllTheRow];
    [self.txtId resignFirstResponder];
    [self.txtpassword resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtAge resignFirstResponder];
}
- (IBAction)termsServiceClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(openTermsService)])
    {
        [self.delegate openTermsService];
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
    self.txtAge.text = [pickerData objectAtIndex:row];
    AgeDOB = [self getSelectedDOB:self.txtAge.text];
}

#pragma mark UItextfiled Delegate


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self deSelectAllTheRow];
    [self selectedCurrentRow:textField];
    [self keyboardWillShow];
    [self clearPlaceHolder:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self deSelectAllTheRow];
    [self addPlaceHolder:textField];
//    if ([self validateFileds:NO]) {
    [self.btnSignUp setImage:[UIImage imageNamed:[self validateFileds:NO]?@"SignUpButton":@"SignUpButton_Off"] forState:UIControlStateNormal];
//    }else
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtId) {
        [textField resignFirstResponder];
        [self.txtpassword becomeFirstResponder];
    } else if (textField == self.txtpassword) {
        [textField resignFirstResponder];
        [self.txtEmail becomeFirstResponder];
    }
    else if (textField == self.txtEmail) {
        [textField resignFirstResponder];
        [self.txtAge becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma Events

-(void)datePickerValueChanged:(UIDatePicker *)sender
{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY-MM-d"];
    
    NSDate* now = [NSDate date];
    
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:sender.date
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    
    self.txtAge.text = [NSString stringWithFormat:@"%ld",(long)age];
    AgeDOB = [outputFormatter stringFromDate:sender.date];
}

-(void)btnDoneClick:(id)sender{
    
//    [self keyboardWillHide];
    if (isProcessing) {
        return;
    }
    //Do Validate
    if([self validateFileds:YES])
    {
        isProcessing = YES;
        [self.txtAge resignFirstResponder];
        NSString* defaultEmail = [NSString stringWithFormat:@"%@@comicing.cc",[[NSUUID UUID] UUIDString]];
        [AppHelper showWarningDropDownMessage:@"Please wait !" mesage:@""];
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
        
        [userDic setObject:[self isTextEmpty:self.txtEmail] ?defaultEmail:self.txtEmail.text forKey:@"email"];
        [userDic setObject:self.txtId.text forKey:@"login_id"];
        [userDic setObject:[AppHelper MD5encryption:self.txtpassword.text] forKey:@"password"];
        [userDic setObject:self.txtId.text forKey:@"first_name"];
        [userDic setObject:@"" forKey:@"last_name"];
        [userDic setObject:[AppHelper getDeviceId] forKey:@"device_type"];
        [userDic setObject:[AppHelper getDeviceToken] forKey:@"device_token"];
        [userDic setObject:AgeDOB forKey:@"dob"];
        [userDic setObject:[AppHelper getDeviceCountry] forKey:@"country"];
        [userDic setObject:[AppHelper encodeToBase64String:self.imgCropedImage] forKey:@"profile_pic"];
        
        [dataDic setObject:userDic forKey:@"data"];
        
//        NSError * err;
//        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:0 error:&err];
//        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
        [cmNetWorking updateUserInfo:dataDic Id:[AppHelper getCurrentLoginId] completion:^(id json,id jsonResposeHeader) {
            
            if ([[json objectForKey:@"result"] isEqualToString:@"failed" ]) {
                NSString* strMessage = [NSString stringWithFormat:@"There is a user who is currently using either %@ or %@", self.txtId.text,self.txtEmail.text ];
                [AppHelper showErrorDropDownMessage:@"Failed" mesage:strMessage];
                isProcessing = NO;
                [self.txtId becomeFirstResponder];
                return;
            }
            
            self.isRegister = YES;
            
            // all instruction bool set to NO
            [InstructionView setAllSlideUserDefaultsValueNO];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserRegisterFirstTime];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self doLogin];
            
        } ErrorBlock:^(JSONModelError *error) {
            NSLog(@"Error %@",error);
            [AppHelper showSuccessDropDownMessage:ERROR_MESSAGE mesage:@""];
            isProcessing = NO;
        }];
    }else{
    }
}

-(void)doLogin
{
    //Do Validate
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
        
        [userDic setObject:self.txtId.text forKey:@"login_id"];
        [userDic setObject:[AppHelper MD5encryption:self.txtpassword.text] forKey:@"password"];
        [userDic setObject:[AppHelper getDeviceToken] forKey:@"device_token"];
        [dataDic setObject:userDic forKey:@"data"];
        
        
        ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
        [cmNetWorking postLogin:dataDic completion:^(id json,id jsonResposeHeader)
    {
            if ([[[json objectForKey:@"result"] lowercaseString] isEqualToString:@"failed"])
            {
                [self showAlertMessage:[json objectForKey:@"message"]];
            }
            else if ([[[json objectForKey:@"result"] lowercaseString] isEqualToString:@"sucess"])
            {
               
                if (self.isRegister == NO)
                {
                    [InstructionView setAllSlideUserDefaultsValueYES];

                }
                
                
                [AppHelper showSuccessDropDownMessage:@"Thank you for the registration." mesage:@""];
                [AppHelper setAuthandNonceId:[jsonResposeHeader objectForKey:@"Authorization"] Nonce:[jsonResposeHeader objectForKey:@"Nonce"]];
                if ([json objectForKey:@"data"] && ![[json objectForKey:@"data"] objectForKey:@"login_id"]) {
                    NSMutableDictionary* userDic = [[json objectForKey:@"data"] mutableCopy];
                    [userDic setObject:self.txtId.text forKey:@"login_id"];
                    [AppHelper setCurrentUser:userDic];
                }
                else
                {
                    [AppHelper setCurrentUser:[json objectForKey:@"data"]];
                }
                if ([json objectForKey:@"data"] &&
                    [[json objectForKey:@"data"] objectForKey:@"user_id"])
                {
                    [AppHelper setCurrentLoginId:[[json objectForKey:@"data"] objectForKey:@"user_id"]];
                }
                
                [AppHelper setCurrentUserEmail:self.txtEmail.text];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(getAccountRequest)])
                {
                    [self.delegate getAccountRequest];
                }
            }
        
        NSLog(@"json %@",json);
            
        } ErrorBlock:^(id error) {
            [AppHelper showSuccessDropDownMessage:ERROR_MESSAGE mesage:@""];
        }];
}

- (IBAction)btnYesClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getAccountRequest)])
    {
        [self.delegate getAccountRequest];
    }
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 

@end
