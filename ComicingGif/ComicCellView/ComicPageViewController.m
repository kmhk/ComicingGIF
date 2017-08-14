//
//  ComicPageViewController.m
//  ComicBook
//
//  Created by ADNAN THATHIYA on 06/10/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "ComicPageViewController.h"

@interface ComicPageViewController ()<ComicCellViewControllerwDelegate>

@end

@implementation ComicPageViewController
{
    NSMutableArray *viewControllers;
}
@synthesize allSlideImages, isDelegateCalled;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    viewControllers = [[NSMutableArray alloc] init];
    self.delegate = self;
    self.dataSource = self;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 1;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark public Methods

- (ComicCellViewController*)addPreviewView:(NSArray *)slides
{
    ComicCellViewController* viewPreviewSlide = [[ComicCellViewController alloc] initWithFrame:CGRectMake(0, 0,
                                                                                              self.view.frame.size.width,
                                                                                              self.view.frame.size.height)];
    
    viewPreviewSlide.delegate = self;
    [viewPreviewSlide.view setBackgroundColor:[UIColor whiteColor]];
    
    [viewPreviewSlide.view setUserInteractionEnabled:NO];
    
    [viewPreviewSlide setupComicSlidePreview:slides];
    
    return viewPreviewSlide;
    
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

#pragma mark method

- (void)setupBook
{
    NSLog(@"slides : %lu",(unsigned long)allSlideImages.count);

    [self getPreviewSlideVC:self.allSlideImages];
    
    
    NSLog(@"%@",viewControllers);
    
    [self setViewControllers:@[viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    // Find the tap gesture recognizer so we can remove it!
    UIGestureRecognizer* tapRecognizer = nil;
    for (UIGestureRecognizer* recognizer in self.gestureRecognizers)
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
        [self.view removeGestureRecognizer:tapRecognizer];
    }
}

#pragma mark Scrollviewdelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - UIPageViewController delegate methods

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

#pragma mark


#pragma mark - ComicSlidePreviewDelegate Methods

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
//                view.viewWhiteBorder.frame = frame;
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
            comicSlide.viewWhiteBorder.frame = frame;
            
        }
    }
}

@end
