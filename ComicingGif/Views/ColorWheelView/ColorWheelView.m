//
//  ColorWheelView.m
//  ComicingGif
//
//  Created by Bero on 9/9/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ColorWheelView.h"
#import "ISColorWheel.h"

#define PenMinimumSize  5
#define PenMaximumSize 20
#define ScaleAnimationDuration 0.1
#define MovementAnimationDuration 0.3


@interface ColorWheelView () <ISColorWheelDelegate>
{
    ISColorWheel* _colorWheel;
    UIPinchGestureRecognizer *_pinchGesture;
    UILongPressGestureRecognizer *_longPressGesture;
    CGFloat width;
}

@end
@implementation ColorWheelView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupWithFrame:self.bounds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithFrame:frame];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)frame{
    _colorWheel = [[ISColorWheel alloc] initWithFrame:frame];
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    _colorWheel.borderWidth = 0;
    _colorWheel.knobView = nil;
    _colorWheel.knobSize = CGSizeMake(0, 0);
    
    [self addSubview:_colorWheel];
    
    NSDictionary *views = @{@"colorWheel":_colorWheel};
    
    NSArray *horizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[colorWheel]-0-|" options:0 metrics:nil views:views];
    
    NSArray *verticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[colorWheel]-0-|" options:0 metrics:nil views:views];
    
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints];
    
    
    self.backgroundColor = UIColor.clearColor;
    
    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesturePerformed:)];
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesturePerformed:)];

    self.gestureRecognizers = @[_pinchGesture, _longPressGesture];
    
    width = frame.size.width;
}

- (void)setPenIndicator:(PenIndicatorView *)penIndicator{
    _penIndicator = penIndicator;
    _penIndicator.layer.cornerRadius = _penIndicator.frame.size.width / 2;
}

- (void)setAlpha:(CGFloat)alpha{
    super.alpha = alpha;
    _penIndicator.alpha = alpha;
}

- (BOOL)isPointNearTheBorder:(CGPoint)point{
    return !CGRectContainsRect(self.superview.bounds, CGRectMake(point.x - 10, point.y - 10, 20, 20));
}

- (void)movePaletteBackWithAnimation{
    [self.superview setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:MovementAnimationDuration animations:^{
        [self.superview layoutIfNeeded];
    }];
}


#pragma mark - Delegate
- (void)colorWheelDidChangeColor:(ISColorWheel*)colorWheel{
    if (_delegate && [_delegate respondsToSelector:@selector(colorWheelDidChangeColor:withColor:)]){
        [_delegate colorWheelDidChangeColor:self withColor:colorWheel.currentColor];
    }
    _penIndicator.color = colorWheel.currentColor;
}


#pragma mark - Touches and gestures
- (void)pinchGesturePerformed:(UIPinchGestureRecognizer*)pinchGesture{
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan){
        
        //work around to avoid drawing under the pinch area when pinch started
        if (_delegate && [_delegate respondsToSelector:@selector(undoLastStepColorWheel:)]){
            [_delegate undoLastStepColorWheel:self];
        }
    }else if (pinchGesture.state == UIGestureRecognizerStateChanged) {
        //increase speed of the pinch
        CGFloat calculatedScale = pow(pinchGesture.scale, 2);
        
        //max and min size of the pen
        if (calculatedScale > 1){
            if (_penIndicator.size * calculatedScale < PenMaximumSize){
                _penIndicator.size = (_penIndicator.size * calculatedScale );
            }else{
                _penIndicator.size = PenMaximumSize;
            }
        }else  {
            if (_penIndicator.size * calculatedScale > PenMinimumSize){
                _penIndicator.size = (_penIndicator.size * calculatedScale);
            }else{
                _penIndicator.size = PenMinimumSize;
            }
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(colorWheelDidChangePenSize:size:)]){
        [_delegate colorWheelDidChangePenSize:self size:_penIndicator.size];
    }
    
    pinchGesture.scale = 1;
}


- (void)longPressGesturePerformed:(UILongPressGestureRecognizer*)longPressGesture{
    UIGestureRecognizerState state = [longPressGesture state];
    
    CGPoint point = [longPressGesture locationInView:self.superview];
    
    if (state == UIGestureRecognizerStateBegan){
        CGPoint pointInsideSelf = [longPressGesture locationInView:self];
        if (CGRectContainsPoint(_colorWheel.frame, pointInsideSelf)){
            [UIView animateWithDuration:ScaleAnimationDuration animations:^{
                self.transform = CGAffineTransformMakeScale(1.1, 1.1);
            }];
        }else{
            
            //reset the touch
            longPressGesture.enabled = NO;
            longPressGesture.enabled = YES;
            return;
        }
        
    }else if (state == UIGestureRecognizerStateChanged){
        if ([self isPointNearTheBorder:point] == false) {
            self.center = point;
        }
    }else if (state == UIGestureRecognizerStateEnded){
        if (([self isPointNearTheBorder:point] == true)){
            //            remove view
            if (_delegate && [_delegate respondsToSelector:@selector(hideColorWheel:)]){
                [_delegate hideColorWheel:self];
                [self performSelector:@selector(movePaletteBackWithAnimation) withObject:nil afterDelay:MovementAnimationDuration];
            }
        }else{
            [self movePaletteBackWithAnimation];
        }
        
        [UIView animateWithDuration:ScaleAnimationDuration animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}

#pragma mark - Check view acting area
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //extend touch area
    CGRect frame = CGRectInset(self.bounds,
                               (_penIndicator.frame.origin.x + _penIndicator.frame.size.width + 30 - (self.frame.origin.x + self.frame.size.width)) * -2,
                               (self.frame.origin.y - _penIndicator.frame.origin.y + 30) * -2);
    
    if (CGRectContainsPoint(_colorWheel.frame, point)){
        return _colorWheel;
    }else if (CGRectContainsPoint(frame, point)){
        return self;
    }else{
        return nil;
    }
}

@end
