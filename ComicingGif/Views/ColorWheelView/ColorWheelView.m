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
#define PaletteSize 80

@interface ColorWheelView () <ISColorWheelDelegate>
{
    ISColorWheel* _colorWheel;
    UIPinchGestureRecognizer *_pinchGesture;
    UILongPressGestureRecognizer *_longPressGesture;
    IBOutlet NSLayoutConstraint *widthConstraint;
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
    
    widthConstraint.constant = PaletteSize;
}

- (void)setPenIndicator:(PenIndicatorView *)penIndicator{
    _penIndicator = penIndicator;
    _penIndicator.layer.cornerRadius = _penIndicator.frame.size.width / 2;
}

- (void)setAlpha:(CGFloat)alpha{
    super.alpha = alpha;
    _penIndicator.alpha = alpha;
}


#pragma mark - Delegate
- (void)colorWheelDidChangeColor:(ISColorWheel*)colorWheel{
    if (_delegate && [_delegate respondsToSelector:@selector(colorWheelDidChangeColor:withColor:)]){
        [_delegate colorWheelDidChangeColor:self withColor:colorWheel.currentColor];
    }
    _penIndicator.color = colorWheel.currentColor;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)pinchGesturePerformed:(UIPinchGestureRecognizer*)pinchGesture{
    //TODO: make sensibel area above views
    
    if (pinchGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat calculatedScale = pow(pinchGesture.scale, 2);
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

- (void)movePaletteBackWithAnimation{
    [self.superview setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.superview layoutIfNeeded];
    }];
}

- (void)longPressGesturePerformed:(UILongPressGestureRecognizer*)longPressGesture{
    UIGestureRecognizerState state = [longPressGesture state];
    
    CGPoint point = [longPressGesture locationInView:self.superview];
    if (state == UIGestureRecognizerStateBegan){
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
    }else if (state == UIGestureRecognizerStateChanged){
        if (CGRectContainsRect(self.superview.bounds, CGRectMake(point.x - 10, point.y - 10, 20, 20)) == true) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.center = point;
            }];
            
            
        }
    }else if (state == UIGestureRecognizerStateEnded){
        if (CGRectContainsRect(self.superview.bounds, CGRectMake(point.x - 10, point.y - 10, 20, 20)) == false){
            //            remove view
            if (_delegate && [_delegate respondsToSelector:@selector(hideColorWheel:)]){
                [_delegate hideColorWheel:self];
                [self performSelector:@selector(movePaletteBackWithAnimation) withObject:nil afterDelay:0.3];
            }
        }else{
            [self movePaletteBackWithAnimation];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}


//TODO: fix scale area
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //TODO: make few conditions to draw in sensible area
    CGRect frame = CGRectInset(self.bounds, -100, -100);
    
    return CGRectContainsPoint(frame, point) ? _colorWheel : nil;
}

@end
