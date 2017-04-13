//  Created by Subin Kurian on 10/8/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomScrollView.h"


@class CustomScrollView;

@interface DataViewController : UIViewController
@property (strong) IBOutlet CustomScrollView* scrollView;
//@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *slidesArray;

@property int pageNumber;
@property CGFloat myScale;
@property(nonatomic,assign) int Tag;
//@property CGFloat viewWidth;
//@property CGFloat viewHeight;

@property BOOL isSlidesContainImages;

@end
