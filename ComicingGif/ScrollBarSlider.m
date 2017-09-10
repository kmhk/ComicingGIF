//
//  ScrollBarSlider.m
//  ComicingGif
//
//  Created by Amit on 01/06/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ScrollBarSlider.h"

@interface ScrollBarSlider() <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation ScrollBarSlider


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
//    CGRect fr = self.frame;
//    fr.size.height = 20;
//
//    self.frame = fr;
    self.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:242/255.0 blue:0/255.0 alpha:1.0];
}

- (CGFloat)positiveValue:(CGFloat)value {
    return value<0?-value:value;
}

- (UIImage *)getSliderBackView
{
    CGSize sliderSize = self.frame.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sliderSize.width, 20)];
    view.backgroundColor = [UIColor blackColor];
    view.clipsToBounds = YES;
    
    view.layer.borderWidth = 2;
    view.layer.borderColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:239/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = view.frame.size.height/2;
//    view.layer.masksToBounds = true;
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

- (void)enableTapOnSlider:(BOOL)isEnabled
{
    if (isEnabled) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(sliderTapGesture:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        self.tapGesture = tapGesture;
    } else if (self.tapGesture) {
        [self removeGestureRecognizer:self.tapGesture];
        self.tapGesture = nil;
    }
}

// MARK: - Tap getsture recognizer

- (void)sliderTapGesture:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat tapPercent = tapPoint.x * 100/ self.frame.size.width;
    CGFloat valuePercent = self.value * 100 / (self.maximumValue - self.minimumValue);
    
    if ([self positiveValue:tapPercent - valuePercent] <= 15) { //10% of distance accepted
        self.selected = !self.selected;
        
        if ([self.scrollBarSliderDelegate conformsToProtocol:@protocol(ScrollBarSliderDelegate)] && [self.scrollBarSliderDelegate respondsToSelector:@selector(refreshSliderStateWithCurrentSelectionState)]) {
            [self.scrollBarSliderDelegate refreshSliderStateWithCurrentSelectionState];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
