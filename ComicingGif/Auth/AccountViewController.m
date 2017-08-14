//
//  AccountView.m
//  ComicApp
//
//  Created by Ramesh on 09/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "AccountViewController.h"

@implementation AccountViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    [self bindData];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [super viewWillAppear:animated];
}


#pragma Methods

-(void)configView{
//    [self.txtId becomeFirstResponder];
    
    self.txtId.leftViewMode = UITextFieldViewModeAlways;
    self.txtId.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountId.png"]];
    self.txtId.leftView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect leftFrame = self.txtId.leftView.frame;
    leftFrame.size.width = 60;
    self.txtId.leftView.frame = leftFrame;
    [self.txtId setValue:[UIColor colorWithHexStr:@"263D8E"] forKeyPath:@"_placeholderLabel.textColor"];

    self.txtpassword.leftViewMode = UITextFieldViewModeAlways;
    self.txtpassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountPassword.png"]];
    self.txtpassword.leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftFrame = self.txtpassword.leftView.frame;
    leftFrame.size.width = 73;
    self.txtpassword.leftView.frame = leftFrame;
    [self.txtpassword setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    self.txtEmail.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountEmail.png"]];
    self.txtEmail.leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftFrame = self.txtEmail.leftView.frame;
    leftFrame.size.width = 73;
    self.txtEmail.leftView.frame = leftFrame;
    [self.txtEmail setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.txtAge.leftViewMode = UITextFieldViewModeAlways;
    self.txtAge.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountAge.png"]];
    self.txtAge.leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftFrame = self.txtAge.leftView.frame;
    leftFrame.size.width = 73;
    self.txtAge.leftView.frame = leftFrame;
    [self.txtAge setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self setTextFont];
    [self openDatePicker];
    [self addDoneButtonToAge];
}

-(void)setTextFont{
    [self.accountHeadText setFont:[UIFont  fontWithName:@"Myriad Roman" size:28]];
}

-(void)bindData{

    [self bindProfilePic];
}

-(void)bindProfilePic{
    if (self.imgCropedImage) {
        [self.imgProfilePic setImage:self.imgCropedImage];
    }
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
-(void)openDatePicker{
    
    if (datePicker) {
        datePicker = nil;
    }
    
    datePicker = [[UIDatePicker alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-150];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    comps = nil;

    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
//    gregorian = nil;
    
    self.txtAge.inputView = datePicker;
}

-(BOOL)validateFileds{
    
    //Validate is any filed are empty
    if ([self isTextEmpty:self.txtId] || [self isTextEmpty:self.txtEmail] ||
        [self isTextEmpty:self.txtpassword] || [self isTextEmpty:self.txtAge]) {
        [self showAlertMessage:@"Please fill the details."];
        return NO;
    }else if(![AppHelper isValidEmail:self.txtEmail.text]){
        //Validate email
        [self showAlertMessage:@"Please enter valid email."];
        [self.txtEmail becomeFirstResponder];
        return NO;
    }else if(self.txtpassword.text.length < 6){
         //Validate min password
        [self showAlertMessage:@"Password should be at least 6 characters."];
        self.txtpassword.text = @"";
        [self.txtpassword becomeFirstResponder];
        return NO;
    }else
        if(datePicker && datePicker.date){
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-17];
        NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        NSDate *selectedDate = datePicker.date;
        
        NSComparisonResult result = [minDate compare:selectedDate];
        if(result == NSOrderedAscending)
        {
            [self showAlertMessage:@"Age should be 17+."];
            return NO;
        }
        return YES;
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
#pragma Events

-(void)datePickerValueChanged:(UIDatePicker *)sender{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY-MM-d"];
    self.txtAge.text = [outputFormatter stringFromDate:sender.date];
}

-(void)btnDoneClick:(id)sender{

    if (isProcessing) {
        return;
    }
    
    isProcessing = YES;
    [self.txtAge resignFirstResponder];
    [self.txtAge.inputAccessoryView removeFromSuperview];
    self.txtAge.inputAccessoryView = nil;
    
    //Do Validate
    [AppHelper showWarningDropDownMessage:@"Please wait !" mesage:@""];
    if([self validateFileds])
    {
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
        
        [userDic setObject:self.txtEmail.text forKey:@"email"];
        [userDic setObject:self.txtId.text forKey:@"login_id"];
        [userDic setObject:[AppHelper MD5encryption:self.txtpassword.text] forKey:@"password"];
        [userDic setObject:@"" forKey:@"first_name"];
        [userDic setObject:@"" forKey:@"last_name"];
        [userDic setObject:[AppHelper getDeviceId] forKey:@"device_type"];
        [userDic setObject:[AppHelper getDeviceToken] forKey:@"device_token"];
        [userDic setObject:self.txtAge.text forKey:@"dob"];
        [userDic setObject:[AppHelper getDeviceCountry] forKey:@"country"];
        [userDic setObject:[AppHelper encodeToBase64String:self.imgProfilePic.image] forKey:@"profile_pic"];
        
        [dataDic setObject:userDic forKey:@"data"];
        
        ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
        [cmNetWorking postRegister:dataDic completion:^(id json,id jsonResposeHeader) {
            
            [AppHelper showSuccessDropDownMessage:@"Thank you for the registration." mesage:@""];
            if ([json objectForKey:@"data"] && ![[json objectForKey:@"data"] objectForKey:@"login_id"]) {
                NSMutableDictionary* userDic = [[json objectForKey:@"data"] mutableCopy];
                [userDic setObject:self.txtId.text forKey:@"login_id"];
                [AppHelper setCurrentUser:userDic];
            }else
            {
                [AppHelper setCurrentUser:[json objectForKey:@"data"]];
            }
            [AppHelper setCurrentUserEmail:[[json objectForKey:@"data"] objectForKey:@"email"]];
            [AppHelper setCurrentLoginId:[[json objectForKey:@"data"] objectForKey:@"user_id"]];
            
            [AppHelper setAuthandNonceId:[jsonResposeHeader objectForKey:@"Authorization"] Nonce:[jsonResposeHeader objectForKey:@"Nonce"]];
            [[NSUserDefaults standardUserDefaults] setValue:[[json objectForKey:@"data"] objectForKey:@"user_id"] forKey:@"userId"];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            FindFriendsViewController *controller = (FindFriendsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"FindFriendsViewController"];
            [self.navigationController pushViewController:controller animated:YES];
            mainStoryboard = nil;
            
        } ErrorBlock:^(JSONModelError *error) {
            NSLog(@"Error %@",error);
            [AppHelper showSuccessDropDownMessage:ERROR_MESSAGE mesage:@""];
            isProcessing = NO;
        }];
    }
}

- (IBAction)btnYesClick:(id)sender {
   
}


@end
