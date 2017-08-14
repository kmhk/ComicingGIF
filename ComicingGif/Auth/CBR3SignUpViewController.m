//
//  CBR3SignUpViewController.m
//  ComicBook
//
//  Created by Sandeep Kumar Lall on 08/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "CBR3SignUpViewController.h"
#import "UIImage+resize.h"

@interface CBR3SignUpViewController ()

@end

@implementation CBR3SignUpViewController
@synthesize faceImgView,imgvCrop,faceImg,imgAnimatedView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.faceImgView=[[UIImageView alloc] initWithImage:faceImg];
    //self.faceImgView.image=faceImg;
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self animatedImage:self.faceImgView];
}

#pragma mark- animating image 

-(void)animatedImage:(UIImageView *)stickerImageView {
    
        UIImage *cropedImage  = stickerImageView.image;
        cropedImage = [UIImage resizeImage:cropedImage newSize:CGSizeMake(130, 130)];
        [imgAnimatedView setImage:cropedImage];
        stickerImageView.frame = imgAnimatedView.frame;
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
                             [imgAnimatedView setHidden:YES];
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

-(void)openMobileEntryView:(UIImage*)profilePic{
    [self hideAllSubView];
    self.signUpMobileNumber.alpha = 1;
    [self.signUpMobileNumber bindData];
    [self.signUpMobileNumber setHidden:NO];
    //[self.signUpMobileNumber.txtMobileNumber becomeFirstResponder];
//    [self setTextFont:@"Sign up"];
//    [self.btnSkipVerification setHidden:NO];
}
-(void)hideAllSubView{
    [self.signUpMobileNumber setHidden:YES];
   // [self.verifyView setHidden:YES];
    [self.signUpMobileNumber setHidden:YES];
    
    //    [self.accountHolderView setHidden:NO];
    //    [self.signUpMobileNumber setHidden:YES];
    //    [self.verifyView setHidden:NO];
    //    [self.signUpMobileNumber setHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
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
