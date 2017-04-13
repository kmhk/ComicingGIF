//  Created by Subin Kurian on 10/8/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
#import <UIKit/UIKit.h>
#import "CustomTextView.h"
#import "BottomBarViewController.h"
#import "TopBarViewController.h"

@interface MainPageVC : UIViewController <UIPageViewControllerDelegate> {
    BottomBarViewController *bottomBarView;
    TopBarViewController *topBarView;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property(weak, nonatomic) NSLayoutConstraint *width;
@property(weak, nonatomic) NSLayoutConstraint *height;
@property(weak, nonatomic) NSLayoutConstraint *xConstraint;
@property(weak, nonatomic) NSLayoutConstraint *yConstraint;
@property (nonatomic,strong) NSMutableDictionary *ComicBookDict;
@end
