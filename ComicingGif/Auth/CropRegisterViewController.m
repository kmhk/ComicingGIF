//
//  CropStickerViewController.m
//  CommicMakingPage
//
//  Created by ADNAN THATHIYA on 06/12/15.
//  Copyright (c) 2015 jistin. All rights reserved.
//

#import "CropRegisterViewController.h"
#import "TermsServiceViewController.h"

//NSString *const SKeySticker = @"Sticker";

#define IS_IOS8     ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;


@implementation CropRegisterViewController

@synthesize imgvCrop,imgvCropCenter;

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"Register" Attributes:nil];
    
    //    self.cropHolder.isRegView = YES;
    [self setTextFont:@"Take a Selfie and \n Cut out your Profile Pic"];
    [self preparView];
    self.signUpMobileNumber.delegate = self;
    self.verifyView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRegisterNotificationSucess:) name:RegisterNotification_Sucess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRegisterNotificationFailed:) name:RegisterNotification_Failed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:RegisterNotification_Receive object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//you can also write this method in MainViewController to remove the child VC you added before.
- (void) hideContentController
{
    //fade out
    [UIView animateWithDuration:2.0f animations:^{
        [_viewContent.view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [_viewContent willMoveToParentViewController:nil];  // 1
        [_viewContent.view removeFromSuperview];            // 2
        [_viewContent removeFromParentViewController];      // 3
    }];
}


-(void)doJson{
    
}


#pragma mark - UIView Methods

-(void)setTextFont:(NSString*)textValue{
    
    [self.headText setFont:[UIFont  fontWithName:@"Myriad Roman" size:IS_IPHONE_3G?14:28]];
    self.headText.text = textValue;
}

- (void)preparView{
    imgvCropCenter = imgvCrop.center;
    
//    AVCaptureSession *session = [[AVCaptureSession alloc] init];
//    [self setSession:session];
//    // Setup the preview view
//    [cameraPreview setSession:session];
//    
//    [self initiateCamera];
    
//    btnUndo.enabled = NO;
//    btnCrop.enabled = NO;
//    btnDoneCroping.enabled = NO;
    
    self.accountHolderView.delegate = self;
//    [self.accountHolderView setHidden:YES];
    CGRect accountViewFrame = self.accountHolderView.frame;
    accountViewFrame.origin.x = self.view.frame.size.width;
    
//    [self.imgFinalCopedFace setHidden:NO];
//    [self.imgFinalCopedFace setAlpha:1];
//    [self.imgFinalCopedFace setImage:[UIImage imageNamed:@"faceSignUp.png"]];
}


-(void)openAccountViewController:(UIImage*)cropedImage{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AccountViewController *controller = (AccountViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"AccountController"];
    controller.imgCropedImage = [cropedImage copy];
//    controller.imgProfilePic.image = cropedImage;
    [self.navigationController pushViewController:controller animated:YES];
    mainStoryboard = nil;
}

- (IBAction)skipVerificationClick:(id)sender {
    [self sendMobileNumber:self.imgFinalCopedFace.image MobileNumberString:DEFAULT_PHONENUMBER];
}

#pragma mark - CropStickerViewControllerDelegate Methods

- (void)cropStickerViewController_:(CropStickerViewController *)controll didSelectDoneWithImage:(UIImageView *)stickerImageView{
    UIImage *cropedImage  = stickerImageView.image;
    cropedImage = [UIImage resizeImage:cropedImage newSize:CGSizeMake(130, 130)];
    [imgvCrop setImage:cropedImage];
    stickerImageView.frame = imgvCrop.frame;
    [self.view addSubview:stickerImageView];
    
    CGRect imgProfileRect = self.imgFinalCopedFace.frame;
    if ([self.view viewWithTag:909] &&
        imgProfileRect.origin.y < [self.view viewWithTag:909].frame.size.height &&
        !IS_IPHONE_5) {
        imgProfileRect.origin.y = imgProfileRect.origin.y + (IS_IPHONE_5?10:20);
        self.imgFinalCopedFace.frame = imgProfileRect;
    }
    
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [stickerImageView setFrame:self.imgFinalCopedFace.frame];
                     } completion:^(BOOL finished) {
                         [imgvCrop setHidden:YES];
                         self.imgFinalCopedFace.alpha = 1;
                         [self.imgFinalCopedFace setImage:stickerImageView.image];
                         [self.imgFinalCopedFace setHidden:NO];
                         [stickerImageView removeFromSuperview];
                     }];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.cropHolder setAlpha:0];
                     } completion:^(BOOL finished) {
                         self.accountHolderView.imgCropedImage = stickerImageView.image;
//                         [self.signUpMobileNumber.imgProfilePic setImage:stickerImageView.image];
//                         [self.verifyView.imgProfilePic setImage:stickerImageView.image];
                         [self openMobileEntryView:stickerImageView.image];
                         [self.cropHolder removeFromSuperview];
                     }];
}

- (void)cropStickerViewControllerWithCropCancel:(CropStickerViewController *)controll{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)openMobileEntryView:(UIImage*)profilePic{
    [self hideAllSubView];
    self.signUpMobileNumber.alpha = 1;
    [self.signUpMobileNumber bindData];
    [self.signUpMobileNumber setHidden:NO];
    [self.signUpMobileNumber.txtMobileNumber becomeFirstResponder];
    [self setTextFont:@"Sign up"];
    [self.btnSkipVerification setHidden:NO];
}

-(void)hideAllSubView{
    [self.signUpMobileNumber setHidden:YES];
    [self.verifyView setHidden:YES];
    [self.signUpMobileNumber setHidden:YES];
    
//    [self.accountHolderView setHidden:NO];
//    [self.signUpMobileNumber setHidden:YES];
//    [self.verifyView setHidden:NO];
//    [self.signUpMobileNumber setHidden:YES];
}

#pragma Signup delegate

-(void)getCodeRequest:(NSString*)mNumber{
    mMobileNumberValue = mNumber;
    [self setPushNotification];
//    [UIView animateWithDuration:1.0
//                     animations:^{
//                         [self.signUpMobileNumber setHidden:YES];
//                         [self.verifyView setHidden:NO];
//                     } completion:^(BOOL finished) {
//                         [self.verifyView.txtVerifyCode1 becomeFirstResponder];
//                     }];
}

#pragma Verify delegate

-(void)opemVerifyRequest:(NSString*)vCode{
    [self hideAllSubView];
    [self.verifyView bindData:self.signUpMobileNumber.imgFlag.image CountryCode:self.signUpMobileNumber.lblCountryCode.text MobileNumber:mMobileNumberValue];
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.signUpMobileNumber setHidden:YES];
                         [self.verifyView setHidden:NO];
                     } completion:^(BOOL finished) {
                         [self.verifyView autoFillVeryficationCode:vCode];
                     }];
}

-(void)getVerifyRequest{
    [self.btnSkipVerification setHidden:YES];
    [self setTextFont:@"Account"];
    [self hideAllSubView];
    CGRect imgProfileRect = self.imgFinalCopedFace.frame;
    imgProfileRect.origin.x = IS_IPHONE_5?30:IS_IPHONE_3G?10:45;
    
    [self.view bringSubviewToFront:self.imgFinalCopedFace];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.imgFinalCopedFace.frame = imgProfileRect;
                     } completion:^(BOOL finished) {
                     }];
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.accountHolderView.alpha = 0;
                         [self.accountHolderView setHidden:NO];
                         CGRect aHolderFrame = self.accountHolderView.frame;
                         aHolderFrame.origin.x = 0;
                         self.accountHolderView.alpha = 1;
                     } completion:^(BOOL finished) {
                     }];
}

#pragma AccountView delegate

-(void)openTermsService{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TermsServiceViewController *controller = (TermsServiceViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"TermsServiceView"];
    [self.navigationController pushViewController:controller animated:YES];
    mainStoryboard = nil;
}

-(void)doImageAnimation:(BOOL)zoomIn{

    [UIView animateWithDuration:0.5
                          delay:zoomIn?0.8:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (zoomIn) {
                             self.imgFinalCopedFace.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
 
                         }else{
                             self.imgFinalCopedFace.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                         }
                     } completion:^(BOOL finished) {
                     }];
}

-(void)getAccountRequest
{
    /*UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    FindFriendsViewController *controller = (FindFriendsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"FindFriendsViewController"];
    
    controller.imgUser = _imgFinalCopedFace.image;
    
    [self.navigationController pushViewController:controller animated:YES];
    mainStoryboard = nil;*/
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    InviteViewController *controller = (InviteViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
    
    //controller.imgUser = _imgFinalCopedFace.image;
    
    [self.navigationController pushViewController:controller animated:YES];
    mainStoryboard = nil;
}

#pragma mark api methods

-(void)sendMobileNumber:(UIImage*)imagProfilePic MobileNumberString:(NSString*)mNumber{
    [self sendMobileNumber:imagProfilePic MobileNumberString:mNumber isSkip:NO];
}
-(void)sendMobileNumber:(UIImage*)imagProfilePic MobileNumberString:(NSString*)mNumber isSkip:(BOOL)skip{
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    
    [userDic setObject:[AppHelper getDeviceToken] forKey:@"device_token"];
    [userDic setObject:mNumber forKey:@"mobile"];
    
    [dataDic setObject:userDic forKey:@"data"];
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking postRegister:dataDic completion:^(id json,id jsonResposeHeader) {
        if (json &&
                  [json objectForKey:@"data"] &&
                  ([[json objectForKey:@"data"] objectForKey:@"verification_code"] ||
                   [[json objectForKey:@"data"] objectForKey:@"user_id"])) {
                      //Check is we recive the code
                      [AppHelper setCurrentLoginId:[[json objectForKey:@"data"] objectForKey:@"user_id"]];
                      
                      if ([mNumber isEqualToString:DEFAULT_PHONENUMBER] || skip == YES) {
                          [self getVerifyRequest];
                      }else{
                          [self opemVerifyRequest:@""];
                          if (isReciveVeryfyCode) {
                              [AppHelper showHUDLoader:YES];
                          }
                          [self setTextFont:@"Verify"];
                      }
        }else if (json && [[json objectForKey:@"error_code"] isEqualToString:@"1"]) {
            [AppHelper showErrorDropDownMessage:ERROR_MESSAGE mesage:@""];
        }
    } ErrorBlock:^(JSONModelError *error) {
        
    }];
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
    [self sendMobileNumber:self.imgFinalCopedFace.image MobileNumberString:mMobileNumberValue];
}

-(void)doRegisterNotificationFailed:(NSNotification *)notification
{
//    UIAlertView* failureAlert = [[UIAlertView alloc] initWithTitle:@""
//                                                           message:@"Enable notification for verification."
//                                                          delegate:self
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles:nil];
//    [failureAlert show];
    
//    [AppHelper showErrorDropDownMessage:@"Oops ... veryfication failed" mesage:@""];
//    [self skipVerificationClick:nil];
    [self sendMobileNumber:self.imgFinalCopedFace.image MobileNumberString:mMobileNumberValue isSkip:YES];
}
-(void)receiveRemoteNotification:(NSNotification *)notification
{
    [self.signUpMobileNumber.txtMobileNumber resignFirstResponder];
    
    NSDictionary* userInfo = notification.object;
    if (userInfo && [userInfo objectForKey:@"verification_code"]) {
        [AppHelper showSuccessDropDownMessage:@"Your Comicing verification code is " mesage:[[userInfo objectForKey:@"verification_code"] stringValue] autoHideView:NO];
        [self.verifyView autoFillVeryficationCode:[[userInfo objectForKey:@"verification_code"] stringValue]];
    }
    
    [AppHelper showHUDLoader:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - statusbar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
