//
//  CBBasePageViewController.h
//  ComicBook
//
//  Created by Atul Khatri on 06/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBBaseViewController.h"
#import "CBPageViewController.h"

@interface CBBasePageViewController : CBBaseViewController
@property (strong, nonatomic) CBPageViewController *pageController;
@property (nonatomic, strong) UIView* pageControllerContainerView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) CBBaseViewController* currentViewController;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat topMargin;
- (void)reloadPageViewController;
- (void)addViewControllers:(NSArray*)viewControllers;
- (void)changePageToIndex:(NSInteger)index completed:(void (^)(BOOL success))completed;
- (void)pageChangedToIndex:(NSInteger)index;
- (void)scrollPageViewToLeft:(void (^)(BOOL sucess))completed;
- (void)scrollPageViewToRight:(void (^)(BOOL sucess))completed;
@end
