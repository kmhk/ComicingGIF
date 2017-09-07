//
//  UINavigationController+Transition.m
//  ComicingGif
//
//  Created by Sergii on 9/7/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "UINavigationController+Transition.h"
#import "CameraViewController.h"
#import "ASAnyCurlController.h"
#import "UIImage+Image.h"

@implementation UINavigationController (Transition)

- (void)presentCameraViewWithMode:(BOOL)isVerticalMode
                       completion:(void(^)())completion
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraViewController *vcCameraViewController = [storyboard instantiateViewControllerWithIdentifier:CAMERA_VIEW];
    vcCameraViewController.indexOfSlide = -1;
    vcCameraViewController.isVerticalCamera = isVerticalMode;
    
    [self curlDownTransitionToViewController:vcCameraViewController
                                    fromRoot:YES
                                  completion:completion];

}

- (void)curlDownTransitionToViewController:(UIViewController *)toVC
                                  fromRoot:(BOOL)shouldPresentFromRoot
                                completion:(void(^)())completion;
{
    UIImage *fromVCImage = [UIImage imageWithView:self.view  paque:NO];
    UIImage *toVCImage = [UIImage imageWithView:toVC.view  paque:NO];
    
    UIImageView *fromImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImageView *toImgView =  [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    fromImgView.image = fromVCImage;
    toImgView.image = toVCImage;
    
    [toVC.view addSubview:fromImgView];
    
    if (shouldPresentFromRoot) {
        [self popToRootViewControllerAnimated:NO];
    }
    [self pushViewController:toVC animated:NO];
    
    [ASAnyCurlController animateTransitionDownFromView:fromImgView
                                              toView:toImgView
                                            duration:1.5f
                                             options:ASAnyCurlOptionVertical | ASAnyCurlOptionBottomLeft
                                          completion:^{
                                              [fromImgView removeFromSuperview];
                                              [toImgView removeFromSuperview];
                                              if (completion) {
                                                  completion();
                                              }
                                          }];
}
@end
