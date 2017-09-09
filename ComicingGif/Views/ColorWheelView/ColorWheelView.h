//
//  ColorWheelView.h
//  ComicingGif
//
//  Created by Bero on 9/9/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PenIndicatorView.h"

@protocol ColorWheelDelegate <NSObject>
//@required
- (void)colorWheelDidChangeColor:(UIColor*)color;
@end

@interface ColorWheelView : UIView

@property(nonatomic, weak) IBOutlet id <ColorWheelDelegate> delegate;
@property(nonatomic, weak) IBOutlet PenIndicatorView* penIndicator;


@end
