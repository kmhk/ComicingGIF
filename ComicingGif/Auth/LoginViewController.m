//
//  LoginViewController.m
//  ComicMakingPage
//
//  Created by Ramesh on 15/02/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "LoginViewController.h"
#import "ComicNetworking.h"
#import "FindFriendsViewController.h"
#import "GlideScrollViewController.h"
#import "InstructionView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    self.txtPassword.delegate = self;
    
    [self.txtPassword setDelegate:self];
    [self.txtPassword setReturnKeyType:UIReturnKeyDone];
    [self.txtPassword addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self prepareview];
    [super viewDidLoad];

    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRegisterNotificationSucess:) name:RegisterNotification_Sucess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRegisterNotificationFailed:) name:RegisterNotification_Failed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:RegisterNotification_Receive object:nil];
    
    [self setPushNotification];

    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"LoginScreen" Attributes:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareview{
    
    self.txtLoginId.leftViewMode = UITextFieldViewModeAlways;
    self.txtLoginId.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RegisterId_White"]];
    self.txtLoginId.leftView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect leftFrame = self.txtLoginId.leftView.frame;
    leftFrame.size.width = 60;
    self.txtLoginId.leftView.frame = leftFrame;
    self.txtLoginId.delegate = self;
    self.txtLoginId.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    [self.txtLoginId setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    self.txtPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Password_White"]];
    self.txtPassword.leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftFrame = self.txtPassword.leftView.frame;
    leftFrame.size.width = 73;
    self.txtPassword.leftView.frame = leftFrame;
    self.txtPassword.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    [self.txtPassword setValue:[UIColor colorWithHexStr:@"F2F3F4"] forKeyPath:@"_placeholderLabel.textColor"];
    self.txtPassword.delegate = self;
    
//    [self.txtLoginId becomeFirstResponder];
    
    [self backButtonCreate];
}

#pragma mark- Method for back button Create

-(void)backButtonCreate {
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10, 30, 15, 24)];
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonCliked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark- Method for back button clicked

-(void)backButtonCliked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- touchesBegan method to dismiss the keypad
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.txtLoginId resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
}

#pragma method Action
- (IBAction)textFieldFinished:(id)sender{
    [self.txtPassword resignFirstResponder];
    [self btnDoneClick:nil];
}

#pragma mark UITextField delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self deSelectAllTheRow];
    [self selectedCurrentRow:textField];
    [self clearPlaceHolder:textField];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self deSelectAllTheRow];
    [self addPlaceHolder:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField==self.txtLoginId)
        [self.txtLoginId resignFirstResponder];
    return YES;
}
#pragma mark methods

-(void)clearPlaceHolder:(UITextField*)txtField{
    txtField.placeholder = @"";
}
-(void)addPlaceHolder:(UITextField*)txtFiled{
    if (txtFiled == self.txtLoginId) {
        self.txtLoginId.placeholder = @"My ID";
    }else if (txtFiled == self.txtPassword) {
        self.txtPassword.placeholder = @"Password";
    }
}

-(void)selectedCurrentRow:(UITextField*)textField{
    UIImageView* imgLeftView = nil;
    imgLeftView = (UIImageView*)textField.leftView;
    if (imgLeftView) {
        if (textField == self.txtLoginId) {
            [imgLeftView setImage:[UIImage imageNamed:@"RegisterId_Blue"]];
        }else if (textField == self.txtPassword) {
            [imgLeftView setImage:[UIImage imageNamed:@"Password_Blue"]];
        }
    }
    textField.textColor = [UIColor colorWithHexStr:@"263D8E"];
}

-(void)deSelectAllTheRow{
    UIImageView* imgLeftView = nil;
    
    
    imgLeftView = (UIImageView*)self.txtLoginId.leftView;
    if (imgLeftView) {
        [imgLeftView setImage:[UIImage imageNamed:@"RegisterId_White"]];
    }
    self.txtLoginId.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
    imgLeftView = (UIImageView*)self.txtPassword.leftView;
    if (imgLeftView) {
        [imgLeftView setImage:[UIImage imageNamed:@"Password_White"]];
    }
    self.txtPassword.textColor = [UIColor colorWithHexStr:@"F2F3F4"];
}

-(BOOL)validateFileds{
    
    //Validate is any filed are empty
    if ([self isTextEmpty:self.txtLoginId] || [self isTextEmpty:self.txtPassword]) {
        [self performSelector:@selector(showAlertMessage:) withObject:@"Please fill the details." afterDelay:0.6];
        //[self showAlertMessage:@"Please fill the details."];
        return NO;
    }
    
    return YES;
}

-(BOOL)isTextEmpty:(UITextField*)txt{
    BOOL empty = YES;
    if (txt && ![txt.text isEqualToString:@""]) {
        empty = NO;
    }
    return empty;
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

#pragma mark api

-(void)btnDoneClick:(id)sender{
    
    //Do Validate
    if([self validateFileds])
    {
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
        
        [userDic setObject:self.txtLoginId.text forKey:@"login_id"];
        [userDic setObject:[AppHelper MD5encryption:self.txtPassword.text] forKey:@"password"];
        [userDic setObject:[AppHelper getDeviceToken] forKey:@"device_token"];
        [dataDic setObject:userDic forKey:@"data"];
        
        
        ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
        [cmNetWorking postLogin:dataDic completion:^(id json,id jsonResposeHeader) {
            if ([[[json objectForKey:@"result"] lowercaseString] isEqualToString:@"failed"]) {
                [self showAlertMessage:[json objectForKey:@"message"]];
            }else if ([[[json objectForKey:@"result"] lowercaseString] isEqualToString:@"sucess"]) {

                if ([json objectForKey:@"data"] && ![[json objectForKey:@"data"] objectForKey:@"login_id"]) {
                    NSMutableDictionary* userDic = [[json objectForKey:@"data"] mutableCopy];
                    [userDic setObject:self.txtLoginId.text forKey:@"login_id"];
                    [AppHelper setCurrentUser:userDic];
                }else
                {
                    [AppHelper setCurrentUser:[json objectForKey:@"data"]];
                }
                
                [InstructionView setAllSlideUserDefaultsValueYES];

                
                [AppHelper setCurrentUserEmail:[[json objectForKey:@"data"] objectForKey:@"email"]];
                [AppHelper setCurrentLoginId:[[json objectForKey:@"data"] objectForKey:@"user_id"]];
                
                [AppHelper setAuthandNonceId:[jsonResposeHeader objectForKey:@"Authorization"] Nonce:[jsonResposeHeader objectForKey:@"Nonce"]];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
                GlideScrollViewController *controller = (GlideScrollViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"glidenavigation"];

                
                [self presentViewController:controller animated:YES completion:nil];
            }
            NSLog(@"json %@",json);
            
        } ErrorBlock:^(id error) {
            [AppHelper showSuccessDropDownMessage:ERROR_MESSAGE mesage:@""];
        }];
    }
}

#pragma mark Pushnotification

-(void)setPushNotification{
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                         settingsForTypes:(UIUserNotificationTypeSound |
                                                                                           UIUserNotificationTypeAlert |
                                                                                           UIUserNotificationTypeBadge)
                                                                         categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

-(void)doRegisterNotificationSucess:(NSNotification *)notification
{
    
}

-(void)doRegisterNotificationFailed:(NSNotification *)notification
{
    [AppHelper showErrorDropDownMessage:@"Oops ... veryfication failed" mesage:@""];
}
-(void)receiveRemoteNotification:(NSNotification *)notification
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - statusbar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
