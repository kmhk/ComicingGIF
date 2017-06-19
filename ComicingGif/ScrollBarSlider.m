//
//  ScrollBarSlider.m
//  ComicingGif
//
//  Created by Amit on 01/06/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ScrollBarSlider.h"

@implementation ScrollBarSlider



- (void)sliderTapGesture:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat tapPercent = tapPoint.x * 100/ self.frame.size.width;
    CGFloat valuePercent = self.value * 100 / (self.maximumValue - self.minimumValue);
    
    if ([self positiveValue:tapPercent - valuePercent] <= 10) { //10% of distance accepted
        self.selected = !self.selected;
        
        if ([self.scrollBarSliderDelegate conformsToProtocol:@protocol(ScrollBarSliderDelegate)] && [self.scrollBarSliderDelegate respondsToSelector:@selector(refreshSliderStateWithCurrentSelectionState)]) {
            [self.scrollBarSliderDelegate refreshSliderStateWithCurrentSelectionState];
        }
    }
}

- (CGFloat)positiveValue:(CGFloat)value {
    return value<0?-value:value;
}

- (UIImage *)getSliderBackView
{
    CGSize sliderSize = self.frame.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sliderSize.width, sliderSize.height/3)];
    view.backgroundColor = [UIColor blackColor];
    view.clipsToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.cornerRadius = view.frame.size.height/2;
    
    UIView *superView = [[UIView alloc] initWithFrame:view.frame];
    superView.backgroundColor = [UIColor blackColor];
    [superView addSubview:view];
    
    UIGraphicsBeginImageContextWithOptions(superView.bounds.size, superView.opaque, 0.0);
    [superView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(1, 25, 1, 25)];
    return img;
}

- (CGRect)getCurrentRectForScollBarIconWithSliderValue:(CGFloat)value {
    CGRect rect;
    rect.size.height = rect.size.width = 30;
    rect.origin.x = self.frame.origin.x + (self.frame.size.width * (value/self.maximumValue));
    rect.origin.y = self.frame.origin.y - rect.size.width;
    
    CGFloat halfWidthOfIndicator = 18;
    
    if (value <= self.maximumValue/2) {
        rect.origin.x += (halfWidthOfIndicator - halfWidthOfIndicator*(value/(self.maximumValue/2)));
    } else {
        rect.origin.x -= (halfWidthOfIndicator*((value - self.maximumValue/2)/(self.maximumValue/2)));
    }
    
    return rect;
}

- (CGFloat)getValueOfSliderFromIconRect:(CGRect)iconFrame {
    return (iconFrame.origin.x - self.frame.origin.x) * self.maximumValue / self.frame.size.width;
}

@end
