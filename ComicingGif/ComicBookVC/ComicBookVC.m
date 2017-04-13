//
//  ComicBookVC.m
//  CurlDemo
//
//  Created by Subin Kurian on 10/30/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import "ComicBookVC.h"
#import "AppDelegate.h"
#import "ComicCellViewController.h"
#import "AppConstants.h"
#import "MainPageVC.h"

@interface ComicBookVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,pagechangeDelegate, UIGestureRecognizerDelegate,ComicCellViewControllerwDelegate>
{
        BOOL isFirstTime;
    NSMutableArray *viewControllers;

}

@property (weak, nonatomic) IBOutlet UIView *CurlContainer;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImage;
@property (readonly, strong) ModelController *modelController;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *xRight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *yBottom;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *xConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *yConstraint;

@end

@implementation ComicBookVC
@synthesize modelController = _modelController;
@synthesize images, slidesArray;

@synthesize isSlidesContainImages, allSlideImages, isDelegateCalled;

- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirstTime=TRUE;
    viewControllers = [[NSMutableArray alloc] init];
    
    
    [self.view layoutIfNeeded];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /**
     *  setup notification reciever to know table of index pressed or not
     */
    NSString *notificationName = @"PageChange";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChanged:) name:notificationName object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PageChange" object:nil];
}

//- (void)setupBook
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//        self.pageViewController.delegate = self;
//        
//        self.modelController.slidesArray=slidesArray;
//        DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:[UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil]];
//        startingViewController.isSlidesContainImages = self.isSlidesContainImages;
//        //    startingViewController.imageArray=images;
//        
//        [AppDelegate application].dataManager.viewWidth = self.view.frame.size.width;
//        [AppDelegate application].dataManager.viewHeight = self.view.frame.size.height;
//        //        startingViewController.viewWidth = self.view.frame.size.width;
//        //        startingViewController.viewHeight = self.view.frame.size.height;
//        
//        startingViewController.slidesArray = slidesArray;
//        startingViewController.Tag = self.Tag;
//        
//        NSArray *viewControllers = @[startingViewController];
//        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
//        
//        self.pageViewController.dataSource = self.modelController;
//        [ self.pageViewController.view  setTranslatesAutoresizingMaskIntoConstraints:NO];
//        
//        [self.CurlContainer addSubview:self.pageViewController.view ];
//        
//        [self addChildViewController:self.pageViewController];
//        self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
//        
//        // Find the tap gesture recognizer so we can remove it!
//        UIGestureRecognizer* tapRecognizer = nil;
//        for (UIGestureRecognizer* recognizer in self.pageViewController.gestureRecognizers)
//        {
//            if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] )
//            {
//                tapRecognizer = recognizer;
//                break;
//            }
//        }
//    
//    if ( tapRecognizer )
//    {
//        [self.view removeGestureRecognizer:tapRecognizer];
//        [self.pageViewController.view removeGestureRecognizer:tapRecognizer];
//    }
//    
//    
//    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
//    [self setBoundary:0 :0 toView:self.CurlContainer addView:self.pageViewController.view];
//  
//    [self.pageViewController didMoveToParentViewController:self];
//
//    [self.modelController.dict setObject:@"-1" forKey:@"StartedPage"];
//    [self.modelController.dict setObject:[NSString stringWithFormat:@"%d",(int)-1] forKey:@"SelectedPageNumber"];
//    [self.modelController.dict setObject:[NSString stringWithFormat:@"%d",false] forKey:@"IndexSelected"];
//    [self.modelController.dict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"tag"];
//           });
//}

- (void)setupBook
{
    [self getPreviewSlideVC:self.allSlideImages];
    
    NSLog(@"%@",viewControllers);
    
    //    [self setViewControllers:@[viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageViewController.delegate = self;
    
    self.pageViewController.dataSource = self;
    
    [self.pageViewController setViewControllers:@[viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    
    self.modelController.slidesArray=slidesArray;
    
    
    self.CurlContainer.backgroundColor = [UIColor blueColor];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self.CurlContainer layoutIfNeeded];
    [self.view addSubview:self.pageViewController.view];
    
    [self addChildViewController:self.pageViewController];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
   // [self setBoundary:0 :0 toView:self.CurlContainer addView:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // Find the tap gesture recognizer so we can remove it!
    UIGestureRecognizer* tapRecognizer = nil;
    for (UIGestureRecognizer* recognizer in self.pageViewController.gestureRecognizers)
    {
        if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] )
        {
            tapRecognizer = recognizer;
            break;
        }
    }
    
    if ( tapRecognizer )
    {
        [self.view removeGestureRecognizer:tapRecognizer];
        [self.pageViewController.view removeGestureRecognizer:tapRecognizer];
    }

    
    // Find the tap gesture recognizer so we can remove it!
//    UIGestureRecognizer* tapRecognizer = nil;
//    for (UIGestureRecognizer* recognizer in self.gestureRecognizers)
//    {
//        if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] )
//        {
//            tapRecognizer = recognizer;
//            break;
//        }
//    }
//    
//    if ( tapRecognizer )
//    {
//        [self.view removeGestureRecognizer:tapRecognizer];
//        [self.view removeGestureRecognizer:tapRecognizer];
//    }

}

#pragma mark - UIPageViewController delegate methods

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 1;//ceil(self.allSlideImages.count / 4);
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (nil == viewController)
    {
        return viewControllers[0];
    }
    NSInteger idx = [viewControllers indexOfObject:viewController];
    NSParameterAssert(idx != NSNotFound);
    
    if (idx >= [viewControllers count] - 1)
    {
        // we're at the end of the _pages array
        return nil;
    }
    // return the next page's view controller
    return viewControllers[idx + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (nil == viewController) {
        return viewControllers[0];
    }
    NSInteger idx = [viewControllers indexOfObject:viewController];
    NSParameterAssert(idx != NSNotFound);
    if (idx <= 0) {
        // we're at the end of the _pages array
        return nil;
    }
    // return the previous page's view controller
    return viewControllers[idx - 1];
}



- (void)getPreviewSlideVC:(NSArray *)slides
{
    if (viewControllers)
    {
        [viewControllers removeAllObjects];
    }
    
//    if ([slides count] >4)
//    {
//        NSArray* firstArray = [slides subarrayWithRange:NSMakeRange(0, 4)];
//        NSArray* secondArray = [slides subarrayWithRange:NSMakeRange(4, [slides count]-4)];
//        
//        [viewControllers addObject:[self addPreviewView:firstArray]];
//        [viewControllers addObject:[self addPreviewView:secondArray]];
//    }
//    else
//    {
        [viewControllers addObject:[self addPreviewView:slides]];
//    }
    
    [self setPageViewControllerFrame];
    [self centreWhiteView];
}


- (ComicCellViewController*)addPreviewView:(NSArray *)slides
{
    CGFloat width = ComicWidthIPhone5;
    
    if (IS_IPHONE_5)
    {
        width = ComicWidthIPhone5;
    }
    else if (IS_IPHONE_6)
    {
        width = ComicWidthIPhone6;
        
    }
    else if (IS_IPHONE_6P)
    {
        width = ComicWidthIPhone6plus;
    }

    if ([_parentController isKindOfClass:[MainPageVC class]]) {
        if (IS_IPHONE_5)
        {
            width = 250;
        }
        else if (IS_IPHONE_6)
        {
            width = 305;
            
        }
        else if (IS_IPHONE_6P)
        { 
            width = 340;
        }
    }
    
    ComicCellViewController* viewPreviewSlide = [[ComicCellViewController alloc] initWithFrame:CGRectMake(0, 0,
                                                                                                          width,
                                                                                                          self.view.frame.size.height)];
    viewPreviewSlide.comicBookColorCode = self.comicBookColorCode;
    viewPreviewSlide.delegate = self;
    [viewPreviewSlide.view setBackgroundColor:[UIColor whiteColor]];
    
    [viewPreviewSlide.view setUserInteractionEnabled:NO];
    
    [viewPreviewSlide setupComicSlidePreview:slides];
    
    return viewPreviewSlide;
    
}

- (void)setPageViewControllerFrame
{
    //   NSArray *allviewControllers = self.viewControllers;
    
    CGRect selfFrame = CGRectMake(0, 0, 0, 0);
    
    for (UIViewController *controller in viewControllers)
    {
        if ([controller isKindOfClass:[ComicCellViewController class]])
        {
            ComicCellViewController *comicSlide = (ComicCellViewController *)controller;
            
            if(selfFrame.size.height < comicSlide.view.frame.size.height)
            {
                CGRect viewFrame = self.view.frame;
                
                viewFrame.size.width = comicSlide.viewWhiteBorder.frame.size.width;
                viewFrame.size.height = comicSlide.viewWhiteBorder.frame.size.height;
                //self.view.frame = viewFrame;
                
                // Added by Ramesh, adding center to main view
                float superviewY = [UIApplication sharedApplication].keyWindow.frame.size.height/2;
                float viewY = viewFrame.size.height/2;
                float centerY = superviewY - viewY;
                
                CGRect viewRect = viewFrame;
                viewRect.origin.y = centerY;
                viewFrame = viewRect;
                self.view.frame = viewFrame;
                
                selfFrame = viewFrame;
            }
//            else
//            {
//                CGRect viewFrame = comicSlide.view.frame;
//                viewFrame.size.width = self.view.frame.size.width;
//                
//                comicSlide.view.frame = viewFrame;
//                
//                CGRect viewWhiteFrame = comicSlide.viewWhiteBorder.frame;
//                
//                viewWhiteFrame.size.width = 100;
//                
//                comicSlide.viewWhiteBorder.frame = viewWhiteFrame;
//                
//            }
        }
    }
}


- (void)centreWhiteView
{
    for (UIViewController *controller in viewControllers)
    {
        if ([controller isKindOfClass:[ComicCellViewController class]])
        {
            ComicCellViewController *comicSlide = (ComicCellViewController *)controller;
            
            CGFloat y = (self.view.frame.size.height - comicSlide.viewWhiteBorder.frame.size.height) / 2;
            
            CGRect frame = comicSlide.view.frame;
            
            frame.origin.y = y;
            
            frame.origin.x = 0;
            
            comicSlide.viewWhiteBorder.frame = frame;
            
        }
    }
}

#pragma mark - ComicCellViewControllerDelegate Methodss
- (void)didFrameChange:(ComicCellViewController *)view withFrame:(CGRect)frame
{
    //    view.view.center = self.view.center;
    
    self.view.backgroundColor = [UIColor redColor];
    
    
//    if(allSlideImages.count > 4)
//    {
//        if (frame.size.height > self.view.frame.size.height)
//        {
//            
//        }
//        else
//        {
//            if (isDelegateCalled)
//            {
//                isDelegateCalled = NO;
//                
//                
//                CGFloat y = (self.view.frame.size.height - view.view.frame.size.height) / 2;
//                
//                CGRect frame = view.view.frame;
//                
//                frame.origin.y = y;
//                frame.origin.x = 0;
//                
//                view.viewWhiteBorder.frame = frame;
//                
//                return;
//            }
//            else
//            {
//                if (allSlideImages.count > 4)
//                {
//                    isDelegateCalled = YES;
//                }
//            }
//        }
//    }
    
    isDelegateCalled = YES;
    
    CGRect viewFrame = self.view.frame;
    
    viewFrame.size.width = frame.size.width;
    viewFrame.size.height = frame.size.height;
    //self.view.frame = viewFrame;
    
    // Added by Ramesh, adding center to main view
    float superviewY = [UIApplication sharedApplication].keyWindow.frame.size.height/2;
    float viewY = viewFrame.size.height/2;
    float centerY = superviewY - viewY;
    
    CGRect viewRect = viewFrame;
    viewRect.origin.y = centerY;
    viewFrame = viewRect;
    self.view.frame = viewFrame;
}


/**
 *  Go to the page from table of content
 *
 *  @param notification
 */
- (void)pageChanged:(NSNotification *)notification
{
    NSDictionary *dict=notification.userInfo;
    [self.modelController.dict setObject:[dict objectForKey:@"StartedPage"] forKey:@"StartedPage"];
    [self.modelController.dict setObject:[dict objectForKey:@"SelectedPageNumber"] forKey:@"SelectedPageNumber"];
    [self.modelController.dict setObject:[dict objectForKey:@"IndexSelected"] forKey:@"IndexSelected"];
    [self.modelController.dict setObject:[dict objectForKey:@"tag"] forKey:@"tag"];
    
    if([[dict objectForKey:@"tag"] isEqualToString:[NSString stringWithFormat:@"%d",self.Tag]])
    {
        DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:[UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil]];
        self.modelController.slidesArray=slidesArray;
        startingViewController.slidesArray=slidesArray;
        startingViewController.Tag=self.Tag;
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        self.pageViewController.dataSource = self.modelController;
    }
}
- (void)ResetBook
{
    [self.modelController.dict setObject:@"-1" forKey:@"StartedPage"];
    [self.modelController.dict setObject:[NSString stringWithFormat:@"%d",(int)-1] forKey:@"SelectedPageNumber"];
    [self.modelController.dict setObject:[NSString stringWithFormat:@"%d",false] forKey:@"IndexSelected"];
    
    
    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:[UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil]];
    self.modelController.slidesArray=slidesArray;
    startingViewController.slidesArray=slidesArray;
    startingViewController.Tag=self.Tag;
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:NULL];
    
    self.pageViewController.dataSource = self.modelController;
    
}
- (ModelController *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.

    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
        
        
    }
    _modelController.delegate=self;
    _modelController.Tag=self.Tag;
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods
/**
 *  Checking for set the shadow of bookstack
 *
 *  @param currentpage present page index
 *  @param totalPage   total number of pages
 */
-(void)pageChange:(int)currentpage :(int)totalPage
{

    if(currentpage>0)
        [[self delegate]bookChanged:self.Tag];
    
    if(currentpage == totalPage)
//    if(currentpage== 0)
    {
        self.shadowImage.hidden=true;
    }
    else
    {
        self.shadowImage.hidden=false;
    }
    [self updateBoundary:-(currentpage*2) :-(currentpage*2) toView:self.view addView:self.shadowImage];
    
    
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
//        DataViewController *currentViewController = self.pageViewController.viewControllers[0];
//        currentViewController.Tag = self.Tag;
//        currentViewController.slidesArray=slidesArray;
//        NSArray *viewControllers = @[currentViewController];
//        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
//        
//        self.pageViewController.doubleSided = NO;
        
        
        
        return UIPageViewControllerSpineLocationMin;
    }
    
    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
//    DataViewController *currentViewController = self.pageViewController.viewControllers[0];
//    currentViewController.Tag=self.Tag;
//    currentViewController.slidesArray=slidesArray;
//    
//    NSArray *viewControllers = nil;
//    
//    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
//    
//    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
//        DataViewController *nextViewController =(DataViewController*) [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
//        nextViewController.Tag=self.Tag;
//        nextViewController.slidesArray=slidesArray;
//        viewControllers = @[currentViewController, nextViewController];
//        
//    }
//    else
//    {
//        DataViewController *previousViewController =( DataViewController*) [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
//        previousViewController.Tag=self.Tag;
//        previousViewController.slidesArray=slidesArray;
//        viewControllers = @[previousViewController, currentViewController];
//        
//    }
//    
//    
//    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    return UIPageViewControllerSpineLocationMid;
}

-(void) setBoundary :(float) x :(float) y toView:(UIView*)toView addView:(UIView*)childView
{
    
    // Width constraint, half of parent view width
    [toView addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:toView
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:1
                                                        constant:x]];
    
    // Height constraint, half of parent view height
    [toView addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:toView
                                                       attribute:NSLayoutAttributeHeight
                                                      multiplier:1
                                                        constant:y]];
    
    // Center horizontally
    [toView addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:toView
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0]];
    
    // Center vertically
    [toView addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:toView
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0]];
    
    
}

-(void) updateBoundary :(float) x :(float) y toView:(UIView*)toView addView:(UIView*)childView
{
  

    
    if(self.xRight)
        [toView removeConstraint:self.xRight];
    if(self.yBottom)
        [toView removeConstraint:self.yBottom];
    if(self.xConstraint)
        [toView removeConstraint:self.xConstraint];
    if(self.yConstraint)
        [toView removeConstraint:self.yConstraint];
    

    
    
    self.xRight=[NSLayoutConstraint constraintWithItem:childView
                                                  attribute:NSLayoutAttributeTrailingMargin
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:toView
                                                  attribute:NSLayoutAttributeTrailingMargin
                                                 multiplier:1.0
                                                   constant:x];
    self.yBottom=[NSLayoutConstraint constraintWithItem:childView
                                                  attribute:NSLayoutAttributeBottomMargin
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:toView
                                                  attribute:NSLayoutAttributeBottomMargin
                                                 multiplier:1.0
                                                   constant:y];
    
    self.xConstraint=[NSLayoutConstraint constraintWithItem:childView
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:toView
                                                  attribute:NSLayoutAttributeLeading
                                                 multiplier:1.0
                                                   constant:0];
    self.yConstraint=[NSLayoutConstraint constraintWithItem:childView
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:toView
                                                  attribute:NSLayoutAttributeTop
                                                 multiplier:1.0
                                                   constant:0];
    [toView addConstraint:self.xRight];
    
    
    [toView addConstraint:self.yBottom];
    
    // Center horizontally
    [toView addConstraint:self.xConstraint];
    
    // Center vertically
    [toView addConstraint:self.yConstraint];
    
    
    if(!isFirstTime)
    {
    [UIView animateWithDuration:.3
                     animations:^{
                         [toView layoutIfNeeded]; // Called on parent view
                     }];
    }
    else
    {
         [toView layoutIfNeeded];
        isFirstTime=FALSE;
    }
    
}
@end
