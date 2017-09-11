//
//  ColorWheelView.h
//  ComicingGif
//
//  Created by Bero on 9/9/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PenIndicatorView.h"

@class ColorWheelView;

@protocol ColorWheelDelegate <NSObject>
@optional
- (void)colorWheelDidChangeColor:(ColorWheelView *)colorWheel withColor:(UIColor*)color;
- (void)colorWheelDidChangePenSize:(ColorWheelView *)colorWheel size:(CGFloat)size;
- (void)hideColorWheel:(ColorWheelView *)colorWheel;
- (void)undoLastStepColorWheel:(ColorWheelView *)colorWheel;
@end

@interface ColorWheelView : UIView

@property(nonatomic, weak) IBOutlet id <ColorWheelDelegate> delegate;
@property(nonatomic, weak) IBOutlet PenIndicatorView *penIndicator;

@property(nonatomic, readwrite) BOOL gesturesEnabled;


@end


