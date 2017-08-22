//
//  PassthroughBackgroundView.m
//  ComicingGif
//
//  Created by Ahmed Sulaiman on 7/30/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "PassthroughBackgroundView.h"

@implementation PassthroughBackgroundView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden &&
            view.alpha > 0 &&
            view.userInteractionEnabled &&
            [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end
