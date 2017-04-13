//
//  CBR2ScreenViewController.h
//  ComicBook
//
//  Created by Sandeep Kumar Lall on 07/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBDrawingColor.h"
#import "RowButtonsViewController.h"
#import "ACEDrawingView.h"
#import "UIColor+Color.h"
#import "SignUp.h"
#import "CBR3SignUpViewController.h"
#import "VerifyView.h"

@interface CBR2ScreenViewController : UIViewController <SignUpDelegate,VerifyDelegate>

@property (nonatomic,strong) IBOutlet UIImageView *backGroundBlackView;
@property (nonatomic,strong) IBOutlet UIImage *croppedImg;
@property (nonatomic,strong) IBOutlet UIView *croppedView;
@property (nonatomic,strong) IBOutlet UIImageView *croppedImageShown,*headerImg;
@property (nonatomic) BOOL isShowBlackBG;
@property (strong, nonatomic) ACEDrawingView *drawView;
@property (nonatomic) UIColor *onColor;
@property (nonatomic) BOOL isAlreadyDoubleDrawColor;
@property (nonatomic,strong) IBOutlet UIButton *penBtn;
@property (strong,nonatomic) NSMutableArray *allPointsForRedFace;
@property (strong,nonatomic) UIColor *selectedColor;
@property (strong,nonatomic) IBOutlet UIView *lineDrawView;
@property (strong,nonatomic) NSMutableArray *pathDrawArray,*pathColorArray;
@property (strong,nonatomic) IBOutlet UIButton *tickButton,*backBtn;
@property (nonatomic, strong) NSMutableArray * paths;
@property (nonatomic, strong) IBOutlet CBDrawingColor *CBDrawingColorObj;
@property (nonatomic, strong) UIBezierPath *drawLinePath;
@property (weak, nonatomic) IBOutlet SignUp *signUpMobileNumber;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *headerForR3;
@property (weak, nonatomic) IBOutlet UIImageView *imgvCrop;
@property (weak, nonatomic) IBOutlet UIImageView *imgAnimatedView;
@property (strong, nonatomic) UIImage *faceImg;
@property (strong, nonatomic) UIImageView *faceImgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgFinalCopedFace;
@property (weak, nonatomic) IBOutlet UIView *cropHolder;
@property (strong, nonatomic) IBOutlet AccountView *accountHolderView;
@property (weak, nonatomic) IBOutlet VerifyView *verifyView;
@property (strong, nonatomic) NSString* mMobileNumberValue;



-(IBAction)imageDrawnDoneBtn:(id)sender;
-(IBAction)backBtnClicked:(id)sender;
@end
