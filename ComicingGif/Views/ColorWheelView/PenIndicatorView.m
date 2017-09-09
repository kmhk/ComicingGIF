//
//  PenIndicatorView.m
//  ComicingGif
//
//  Created by Bero on 9/9/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "PenIndicatorView.h"

@interface PenIndicatorView ()

@property(nonatomic, weak) IBOutlet NSLayoutConstraint* sizeConstraint;

@end

@implementation PenIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSize:(CGFloat)size{
    _sizeConstraint.constant = size;
    [self setNeedsLayout];
}

- (CGFloat)size{
    return _sizeConstraint.constant;
}

@end
