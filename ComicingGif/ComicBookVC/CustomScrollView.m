//  Created by Subin Kurian on 10/8/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
#import "CustomScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "Slides.h"
#import "Global.h"

@implementation CustomScrollView
@synthesize _CurlDemoPage;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    if( self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

/**
 *  initializing the scrollview
 */
-(void)initialize {
    
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2;
    self.layer.masksToBounds = TRUE;
    
}

/**
 *  Load the scrollview with image
 *
 *  @param CurlDemoPage is the image which need to show
 *  @param index        index is the index of image in image array
 */
- (void)setPage:(Slides *)slide
{
    _CurlDemoPage = [[UIImageView alloc]init];
    
    // adnan
    if ([slide isKindOfClass:[UIImage class]])
    {
        _CurlDemoPage.image = (UIImage *)slide;
    }
    else
    {
        [_CurlDemoPage sd_setImageWithURL:[NSURL URLWithString:slide.slideImage]
                         placeholderImage:GlobalObject.placeholder_comic
                                  options:SDWebImageRetryFailed
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                }];

    }
    
    
   
    [self addSubview:_CurlDemoPage];
    [_CurlDemoPage setTranslatesAutoresizingMaskIntoConstraints:NO];
    /**
     *  Setting view with autolayout
     */
  
    
    [self setBoundaryX:0 Y:0 toView:self ChildView:_CurlDemoPage];
    _CurlDemoPage.contentMode = UIViewContentModeScaleAspectFill;
    
}
/**
 *  Setting the boundary
 *
 *  @param x      x Constant
 *  @param Y      Y Constant
 *  @param parent the view which is parent
 *  @param child  The sub view which is needed to add
 */

-(void)setBoundaryX:(int)x Y:(int)Y toView:(UIView*)parent ChildView:(UIView*)child

{
    
    //NSLog(@"%@ ********* %@",NSStringFromCGRect(parent.frame),NSStringFromCGRect(child.frame));
    
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:parent
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:1.0
                                                        constant:0]];
    
    // Height constraint, half of parent view height
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:parent
                                                       attribute:NSLayoutAttributeHeight
                                                      multiplier:1
                                                        constant:0]];
    
    
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                       attribute:NSLayoutAttributeLeading                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:parent
                                                       attribute:NSLayoutAttributeLeading
                                                      multiplier:1.0
                                                        constant:0]];
    
    
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:parent
                                                       attribute:NSLayoutAttributeTrailing
                                                      multiplier:1.0
                                                        constant:0]];
    
    [child setNeedsLayout];
    
}

@end
