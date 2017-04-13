//  Created by Subin Kurian on 10/8/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.

#import "ModelController.h"

#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@implementation ModelController
@synthesize dict;

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
      
       
        
        
        dict=[[NSMutableDictionary alloc]init];
        [dict setObject:@"-1" forKey:@"StartedPage"];
        [dict setObject:[NSString stringWithFormat:@"%d",(int)-1] forKey:@"SelectedPageNumber"];
        [dict setObject:[NSString stringWithFormat:@"%d",false] forKey:@"IndexSelected"];
        [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"tag"];
        
    }
    return self;
}
/**
 *  Setting up the page to show
 *
 *  @param index      the index of the page
 *  @param storyboard current story board
 *
 *  @return return the viewcontroller with the page which need to present
 */
- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    dataViewController.Tag=self.Tag;
    /**
     *  if previously come from table of content page go back to table of content page
     */
    
    if(![[dict objectForKey:@"tag"] isEqualToString:[NSString stringWithFormat:@"%d",self.Tag]])
    {
        [dict setObject:@"-1" forKey:@"StartedPage"];
        [dict setObject:[NSString stringWithFormat:@"%d",(int)-1] forKey:@"SelectedPageNumber"];
        [dict setObject:[NSString stringWithFormat:@"%d",false] forKey:@"IndexSelected"];
        [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"IndexSelected"];
        
    }
    
    if([[dict objectForKey:@"IndexSelected"] boolValue]==TRUE)
    {
        dataViewController.pageNumber=[[dict objectForKey:@"SelectedPageNumber"] intValue];
        
        [dict setObject:[NSString stringWithFormat:@"%d",false] forKey:@"IndexSelected"];
        [ [self delegate] pageChange:[[dict objectForKey:@"SelectedPageNumber"] intValue] :(int)self.slidesArray.count ];
    }
    else
    {
        // Create a new view controller and pass suitable data.
        
        dataViewController.pageNumber = (int)index;
        
        // vishnu
        if(self.slidesArray.count < 3) {
            [[self delegate] pageChange:(int)index :(int)self.slidesArray.count-1];
        } else {
            [[self delegate] pageChange:(int)index :(int)self.slidesArray.count];
        }
    }
    dataViewController.slidesArray = self.slidesArray;
    
    
    
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    
    return viewController.pageNumber;
}

#pragma mark - Page View Controller Data Source
/**
 *  going reverse to the page
 *
 *  @param pageViewController which contains all the comic pages of this book
 *  @param viewController     current page
 *
 *  @return returns the viewcontroller with previous page
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{

    
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    
    if(index==[[dict objectForKey:@"SelectedPageNumber"] intValue])
    {
        
        if([[dict objectForKey:@"StartedPage"] intValue]==1)
            index=1;
        else if ([[dict objectForKey:@"StartedPage"] intValue]==2)
            index=2;
        [dict setObject:@"-1" forKey:@"StartedPage"];
        [dict setObject:[NSString stringWithFormat:@"%d",(int)-1] forKey:@"SelectedPageNumber"];


    }
    
    
    else
    {
        index--;
    }
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}
/**
 *  go to next page
 *
 *  @param pageViewController which contains all the comic pages of this book
 *  @param viewController     current page
 *
 *  @return return viewcontroller with next page
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    //    if (index == self.imageArray.count || self.imageArray.count == 2) {
    //        return nil;
    //    }
    // vishnu
    if (index == self.slidesArray.count) {
        // post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNextPage" object:nil];
        return nil;
    } else if(self.slidesArray.count == 2) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
