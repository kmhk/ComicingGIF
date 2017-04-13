//
//  CBBasePageViewController.m
//  ComicBook
//
//  Created by Atul Khatri on 06/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBBasePageViewController.h"
#import "UIView+CBConstraints.h"

#define kPageControllerViewTag 44011

@interface CBBasePageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation CBBasePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.currentIndex= 0;
        self.topMargin= 0.0f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor= [UIColor whiteColor];
    
    self.pageControllerContainerView= [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.pageControllerContainerView];
    [self.pageControllerContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view constrainSubviewToAllEdges:self.pageControllerContainerView withMargin:0.0f];
//    self.pageControllerContainerView.backgroundColor= [UIColor whiteColor];
//    
//    self.pageController.view.backgroundColor= [UIColor whiteColor];
    self.viewControllers= [NSMutableArray new];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadPageViewController{
    if(self.viewControllers && self.viewControllers.count>0){
        self.pageController = [[CBPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.pageController.dataSource= self;
        self.pageController.delegate= self;
        
        if(self.viewControllers && self.viewControllers.count>0){
            for(CBBaseViewController* viewControlelr in self.viewControllers){
                viewControlelr.index= [self.viewControllers indexOfObject:viewControlelr];
                viewControlelr.parentController= self;
            }
        }
        
        self.currentViewController= [self.viewControllers objectAtIndex:self.currentIndex];
        [self.pageController setViewControllers:[NSArray arrayWithObject:self.currentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageController];
        [self.pageController didMoveToParentViewController:self];
        self.pageController.view.tag= kPageControllerViewTag;
        [self addPageControllerView];
    }else{
        NSLog(@"Error: View Controllers array empty");
    }
}

- (void)addViewControllers:(NSArray*)viewControllers{
    if(viewControllers && viewControllers.count>0){
        for(CBBaseViewController* viewController in viewControllers){
            [self.viewControllers addObject:viewController];
            viewController.index= [self.viewControllers indexOfObject:viewController];
            viewController.parentController= self;
        }
    }
    self.currentViewController= [self.viewControllers objectAtIndex:self.currentIndex];
    [self.pageController setViewControllers:[NSArray arrayWithObject:self.currentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)addPageControllerView{
    if(![self.pageControllerContainerView viewWithTag:kPageControllerViewTag]){
//        self.pageController.view.alpha= 0.0f;
        [self.pageControllerContainerView addSubview:self.pageController.view];
        [self.pageController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.pageControllerContainerView constrainSubviewToTopEdge:self.pageController.view withMargin:self.topMargin];
        [self.pageControllerContainerView constrainSubviewToBottomEdge:self.pageController.view withMargin:0.0f];
        [self.pageControllerContainerView constrainSubviewToLeftAndRightEdges:self.pageController.view withMargin:0.0f];
    }
}

- (void)removePageControllerView{
    [self.pageController.view removeFromSuperview];
    [self.pageController.view removeAllConstraints];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.pageController.view layoutIfNeeded];
}

- (void)navigateToPageAtIndex:(NSInteger)index completion:(void (^)(BOOL finished))completion{
    self.currentViewController = [self.pageController.viewControllers lastObject];
    
    if([self.viewControllers indexOfObject:self.currentViewController] < index){
        [self pageControllerSetViewControllers:[NSArray arrayWithObject:[self.viewControllers objectAtIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL success) {
            if(completion){
                completion(success);
            }
            if(success){
                [self pageChangedToIndex:index];
            }
        }];
    }else{
        [self pageControllerSetViewControllers:[NSArray arrayWithObject:[self.viewControllers objectAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL success) {
            if(completion){
                completion(success);
            }
            if(success){
                [self pageChangedToIndex:index];
            }
        }];
    }
}

- (void)pageChangedToIndex:(NSInteger)index{
    // Override in subclass
}

// -- Handled pageViewController InternalConsistencyException --- //
- (void)pageControllerSetViewControllers:(NSArray*)array direction:(UIPageViewControllerNavigationDirection)transitionStyle animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL success))completion{
    __weak CBBasePageViewController *blocksafeSelf = self;
    [self.pageController setViewControllers:array direction:transitionStyle animated:YES completion:^(BOOL finished){
        if(finished){
            dispatch_async(dispatch_get_main_queue(), ^{
                [blocksafeSelf.pageController setViewControllers:array direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
                    if(completion){
                        completion(finished);
                    }
                }];// bug fix for uipageview controller
            });
        }
    }];
}

- (void)scrollPageViewToLeft:(void (^)(BOOL sucess))completed{
    if(self.currentIndex != 0){
        [self navigateToPageAtIndex:self.currentIndex-1 completion:^(BOOL finished) {
            if(completed){
                completed(finished);
            }
        }];
    }else{
        if(completed){
            completed(NO);
        }
    }
}

- (void)scrollPageViewToRight:(void (^)(BOOL sucess))completed{
    if(self.currentIndex+1 < self.viewControllers.count){
        [self navigateToPageAtIndex:self.currentIndex+1 completion:^(BOOL finished) {
            if(completed){
                completed(finished);
            }
        }];
    }else{
        if(completed){
            completed(NO);
        }
    }
}

- (void)handleNavigationToController:(UIViewController*)vc{
    [self navigateToPageAtIndex:[self.viewControllers indexOfObject:vc] completion:nil];
}

- (void)changePageToIndex:(NSInteger)index completed:(void (^)(BOOL success))completed{
    if(self.currentIndex == index){
        completed(YES);
    }else{
        self.currentIndex= index;
        [self navigateToPageAtIndex:index completion:^(BOOL finished) {
            if(completed){
                completed(finished);
            }
        }];
    }
}

#pragma mark - UIPageViewControllerDataSource methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(CBBaseViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    return [self.viewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(CBBaseViewController *)viewController index];
    index++;
    if (index == self.viewControllers.count) {
        return nil;
    }
    return [self.viewControllers objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate methods

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(finished){
        CBBaseViewController* controller = [self.pageController.viewControllers lastObject];
        if([self.viewControllers containsObject:controller]){
            self.currentIndex= [self.viewControllers indexOfObject:controller];
            [self pageChangedToIndex:[self.viewControllers indexOfObject:controller]];
        }
    }
}

- (void)dealloc{
    self.pageController.delegate= nil;
}

@end
