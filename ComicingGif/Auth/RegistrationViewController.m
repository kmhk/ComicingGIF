//
//  RegistrationViewController.m
//  ComicApp
//
//  Created by Ramesh on 07/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad
{
    self.signUpView.delegate = self;
    self.ProfilePicView.delegate = self;
    [self bindSignUpPage];
    
    [self showCropViewController];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bindSignUpPage{
}


- (void)showCropViewController
{
    CropStickerViewController *csv = [self.storyboard instantiateViewControllerWithIdentifier:@"CropStickerViewController"];
    
    csv.delegate = self;
    
    csv.providesPresentationContextTransitionStyle = YES;
    csv.definesPresentationContext = YES;
    
    [csv setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self displayContentController:csv];
    //    [self presentViewController:csv animated:YES completion:nil];
}

// write this method in MainViewController
- (void) displayContentController: (UIViewController*) viewContent
{
    [self addChildViewController:viewContent];                 // 1
    viewContent.view.bounds = self.view.bounds;                 //2
    [self.view addSubview:viewContent.view];
    [self didMoveToParentViewController:viewContent];          // 3
    [self.view bringSubviewToFront:viewContent.view];
    
    //    [self.view setAlpha:0.0f];
    //    //fade in
    //    [UIView animateWithDuration:2.0f animations:^{
    //        [self.view setAlpha:1.0f];
    //    } completion:^(BOOL finished) {
    //    }];
}

//#pragma mark - CropStickerViewControllerDelegate Methods
//- (void)cropStickerViewController:(CropStickerViewController *)controll didSelectDoneWithImage:(UIImageView *)stickerImageView
//{
//    
//    UIImage* cropedImage = [UIImage resizeImage:stickerImageView.image newSize:CGSizeMake(112, 112)];
//    
//    [UIView animateWithDuration:1.0
//                     animations:^{
//                         //Animation code goes here
//                         CGRect fram = self.imgFinalCopedFace.frame;
//                         imgvCrop.frame = fram ; //CGRectMake(191,100,20,20); //Now imageview moves from 0 to 100
//                         imgvCrop.alpha = 0.7;
//                     } completion:^(BOOL finished) {
//                         [imgvCrop setHidden:YES];
//                         self.imgFinalCopedFace.alpha = 1;
//                         [self.imgFinalCopedFace setImage:cropedImage];
//                         [self.imgFinalCopedFace setHidden:NO];
//                     }];
//    
//    [UIView animateWithDuration:1.5
//                     animations:^{
////                         [self buttonAnimation:btnUndo];
////                         [self buttonAnimation:btnImagePicker];
////                         [self buttonAnimation:btnCamera];
////                         [self buttonAnimation:btnCrop];
////                         [self buttonAnimation:btnBack];
////                         [self buttonAnimation:btnDoneCroping];
//                     } completion:^(BOOL finished) {
//                         
//                         self.accountHolderView.alpha = 0;
//                         [self.accountHolderView setHidden:NO];
//                         [UIView animateWithDuration:1.0
//                                               delay:1.0
//                                             options:UIViewAnimationOptionCurveEaseIn
//                                          animations:^{
//                                              CGRect aHolderFrame = self.accountHolderView.frame;
//                                              aHolderFrame.origin.x = 0;
//                                              self.accountHolderView.alpha = 1;
//                                          } completion:^(BOOL finished) {
//                                              self.accountHolderView.imgCropedImage = cropedImage;
//                                          }];
//                     }];
//}
//
//- (void)cropStickerViewControllerWithCropCancel:(CropStickerViewController *)controll
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma Methods

-(void)removeView:(id)viewObj{
    if(viewObj)
    {
        [viewObj removeFromSuperview];
        viewObj = nil;
    }
}

-(void)addSignUpScreen{
    [self removeView:self.ProfilePicView];
    if (self.signUpView==nil) {
        self.signUpView = [[SignUp alloc] initWithFrame:self.view.frame];
        self.signUpView.delegate = self;
    }
    [self.view addSubview:self.signUpView];
}

-(void)addVerifyScreen{
    [self removeView:self.signUpView];
    if (self.verifyView==nil) {
        self.verifyView = [[VerifyView alloc] initWithFrame:self.view.frame];
        self.verifyView.delegate = self;
    }
    [self.view addSubview:self.verifyView];
}

-(void)addAccountScreen{
    [self removeView:self.verifyView];
    if (self.accountView==nil) {
        self.accountView = [[AccountView alloc] initWithFrame:self.view.frame];
        self.accountView.delegate = self;
    }
    [self.view addSubview:self.accountView];
}

-(void)addFindFriendsScreen{
    [self removeView:self.accountView];
    if (self.findFriendsView==nil) {
        self.findFriendsView = [[FindFriendsView alloc] initWithFrame:self.view.frame];
        //        self.accountView.delegate = self;
    }
    [self.view addSubview:self.findFriendsView];
}

#pragma Signup delegate

-(void)getCodeRequest{
    [self addVerifyScreen];
}

#pragma Verify delegate

-(void)getVerifyRequest{
    [self addAccountScreen];
}

#pragma AccountView delegate

-(void)getAccountRequest{
    [self addFindFriendsScreen];
}

#pragma Profile delegate

-(void)getProfilePicRequest{
//    [self addSignUpScreen];
    [self addAccountScreen];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
