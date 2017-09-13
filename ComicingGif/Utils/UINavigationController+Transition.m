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
                     indexOfSlide:(NSInteger)index
                       completion:(void(^)())completion
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraViewController *vcCameraViewController = [storyboard instantiateViewControllerWithIdentifier:CAMERA_VIEW];
    vcCameraViewController.indexOfSlide = index;
    vcCameraViewController.isVerticalCamera = isVerticalMode;
    
    [self curlDownTransitionToViewController:vcCameraViewController
                                    fromRoot:YES
                                  completion:completion];

}

- (void)curlUpTransitionToViewController:(UIViewController *)toVC
                                  fromRoot:(BOOL)shouldPresentFromRoot
                                completion:(void(^)())completion
{
    [self curlTransitionToViewController:toVC
                                fromRoot:shouldPresentFromRoot
                                 options:ASAnyCurlOptionVertical | ASAnyCurlOptionBottomLeft
                             directionUp:YES
                              completion:completion];
}

- (void)curlDownTransitionToViewController:(UIViewController *)toVC
                                  fromRoot:(BOOL)shouldPresentFromRoot
                                completion:(void(^)())completion
{
    [self curlTransitionToViewController:toVC
                                fromRoot:shouldPresentFromRoot
                                 options:ASAnyCurlOptionVertical | ASAnyCurlOptionBottomLeft
                             directionUp:NO
                              completion:completion];
}

- (void)curlTransitionToViewController:(UIViewController *)toVC
                                  fromRoot:(BOOL)shouldPresentFromRoot
                                   options:(ASAnyCurlOptions)options
                               directionUp:(BOOL)isUP
                                completion:(void(^)())completion
{
    UIView *sourceSnapshotView = [self.view snapshotViewAfterScreenUpdates:YES];
    UIView *destinationSnapshotView = [toVC.view snapshotViewAfterScreenUpdates:YES];
    
    [self.view.window addSubview:sourceSnapshotView];
    
    void(^transitionCompletionBlock)(void) = ^{
        if (shouldPresentFromRoot) {
            [self popToRootViewControllerAnimated:NO];
        }
        [self pushViewController:toVC animated:NO];
        
        [sourceSnapshotView removeFromSuperview];
        [destinationSnapshotView removeFromSuperview];
        
        if (completion) {
            completion();
        }
    };
    
    if (isUP) {
        [ASAnyCurlController animateTransitionUpFromView:sourceSnapshotView
                                                    toView:destinationSnapshotView
                                                  duration:1.5f
                                                   options:options
                                                completion:transitionCompletionBlock];
    } else {
        
        [ASAnyCurlController animateTransitionDownFromView:sourceSnapshotView
                                                    toView:destinationSnapshotView
                                                  duration:1.5f
                                                   options:options
                                                completion:transitionCompletionBlock];
    }
}
@end
