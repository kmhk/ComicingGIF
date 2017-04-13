//
//  ComicBookVC.h
//  CurlDemo
//
//  Created by Subin Kurian on 10/30/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"
#import "DataViewController.h"
#import "AppConstants.h"

@protocol BookChangeDelegate <NSObject>

-(void)bookChanged:(int)Tag;

@end
@interface ComicBookVC : UIViewController
-(void)setupBook;
@property(nonatomic,assign) int Tag;
@property(nonatomic,strong) NSArray *images;
@property(nonatomic,strong) NSArray *slidesArray;

@property BOOL isSlidesContainImages;
@property (strong, atomic) UIPageViewController *pageViewController;

@property(nonatomic,strong)id<BookChangeDelegate>delegate;
@property (strong, nonatomic) NSArray *allSlideImages;
@property (nonatomic) BOOL isDelegateCalled;

@property(assign, nonatomic) CGFloat bookWidth;
@property(strong, nonatomic) UIViewController *parentController;

@property (assign, nonatomic) ComicBookColorCode comicBookColorCode;

- (void)ResetBook;

@end
