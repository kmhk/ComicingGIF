//  Created by Subin Kurian on 10/8/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.

#import <UIKit/UIKit.h>
@class DataViewController;
@protocol pagechangeDelegate<NSObject>

@optional
-(void)pageChange:(int)currentpage :(int)totalPage;

@end
@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;
//@property NSArray *imageArray;
@property NSArray *slidesArray;
@property int numberOfPages;
@property (strong) id <pagechangeDelegate> delegate;
@property (nonatomic,assign)int indexSelected;
@property(nonatomic,strong)NSMutableDictionary *dict;
@property(nonatomic,assign) int Tag;

@end
