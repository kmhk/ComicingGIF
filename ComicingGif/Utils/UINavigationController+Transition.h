//
//  UINavigationController+Transition.h
//  ComicingGif
//
//  Created by Sergii on 9/7/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transition)

// Present camera view controller from root with curl down transition
- (void)presentCameraViewWithMode:(BOOL)isVerticalMode
                       completion:(void(^)())completion;


/// Push provided view controller in navigation stack with curl down animation
- (void)curlDownTransitionToViewController:(UIViewController *)toVC
                                  fromRoot:(BOOL)shouldPresentFromRoot
                                completion:(void(^)())completion;


@end
