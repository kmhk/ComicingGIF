
//  Created by Subin Kurian on 10/8/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IndexPageVC.h"
@interface CustomScrollView : UIScrollView <UIScrollViewDelegate>
// Frame of the CurlDemo
@property (nonatomic) CGRect pageRect;
- (void)setPage:(NSString*)imageUrl;
@property(nonatomic,strong)    UIImageView *_CurlDemoPage;
@end
