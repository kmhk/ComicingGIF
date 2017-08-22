//
//  ComicPageViewController.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 06/10/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicCellViewController.h"


@interface ComicPageViewController : UIPageViewController<UIGestureRecognizerDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *allSlideImages;

- (ComicCellViewController*)getSlideVC:(NSInteger)index withImages:(NSArray *)slides;

- (void)setupBook;


@property (nonatomic) BOOL isDelegateCalled;

@end
