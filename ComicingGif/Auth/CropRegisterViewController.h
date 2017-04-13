//
//  CropStickerViewController.h
//  CommicMakingPage
//
//  Created by ADNAN THATHIYA on 06/12/15.
//  Copyright (c) 2015 jistin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MZCroppableView.h"
#import "AVCamPreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AccountViewController.h"
#import "UIImage+resize.h"
#import "AccountView.h"
#import "CropStickerViewController.h"
#import "VerifyView.h"
#import "SignUp.h"
#import "InviteViewController.h"

//extern NSString *const SKeySticker;

@class CropRegisterViewController;


@interface CropRegisterViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AccountDelegate,CropStickerViewControllerDelegate,SignUpDelegate,VerifyDelegate>
{
    UIViewController* _viewContent;
    NSString* mMobileNumberValue;
    BOOL isReciveVeryfyCode;
}
@property (weak, nonatomic) IBOutlet UILabel *headText;
@property (weak, nonatomic) IBOutlet UIImageView *imgvCrop;
@property (strong, nonatomic) IBOutlet UIImageView *imgFinalCopedFace;
@property (strong, nonatomic) IBOutlet AccountView *accountHolderView;
@property (weak, nonatomic) IBOutlet UIView *cropHolder;
@property (weak, nonatomic) IBOutlet VerifyView *verifyView;
@property (weak, nonatomic) IBOutlet SignUp *signUpMobileNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipVerification;

@property CGPoint imgvCropCenter;

- (void)cropStickerViewController_:(CropStickerViewController *)controll didSelectDoneWithImage:(UIImageView *)stickerImageView;

@end
