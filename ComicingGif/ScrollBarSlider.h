//
//  ScrollBarSlider.h
//  ComicingGif
//
//  Created by Amit on 01/06/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollBarSliderDelegate <NSObject>

- (void)refreshSliderStateWithCurrentSelectionState;

@end

@interface ScrollBarSlider : UISlider

@property(assign, nonatomic) id<ScrollBarSliderDelegate> scrollBarSliderDelegate;

- (void)sliderTapGesture:(UITapGestureRecognizer *)gesture;
- (UIImage *)getSliderBackView;
- (CGRect)getCurrentRectForScollBarIconWithSliderValue:(CGFloat)value;
- (CGFloat)getValueOfSliderFromIconRect:(CGRect)iconFrame;
- (void)enableTapOnSlider:(BOOL)isEnabled;

@end
