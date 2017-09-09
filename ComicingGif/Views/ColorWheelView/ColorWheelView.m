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

@interface ColorWheelView () <ISColorWheelDelegate>
{
    ISColorWheel* _colorWheel;
    UIPinchGestureRecognizer* _pinchGesture;
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
    
    self.backgroundColor = UIColor.clearColor;
    
    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesturePerformed:)];

    self.gestureRecognizers = @[_pinchGesture];
}

- (void)setPenIndicator:(PenIndicatorView *)penIndicator{
    _penIndicator = penIndicator;
    _penIndicator.layer.cornerRadius = _penIndicator.frame.size.width / 2;
}

- (void)changePenIndicatorSize:(CGFloat)size{
    
    _penIndicator.layer.cornerRadius = _penIndicator.frame.size.width / 2;
}

- (void)setAlpha:(CGFloat)alpha{
    super.alpha = alpha;
    _penIndicator.alpha = alpha;
}


#pragma mark - Delegate
- (void)colorWheelDidChangeColor:(ISColorWheel*)colorWheel{
    if (_delegate && [_delegate respondsToSelector:@selector(colorWheelDidChangeColor:)]){
        [_delegate colorWheelDidChangeColor:colorWheel.currentColor];
    }
    
    _penIndicator.backgroundColor = colorWheel.currentColor;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)pinchGesturePerformed:(UIPinchGestureRecognizer*)pinchGesture{
//    static CGFloat scaleStart;
    //    NSLog(@"CMC4: receive pinch gesture with state %ld", (long)gestureRecognizer.state);
    if (pinchGesture.scale > 1){
        if (_penIndicator.size * pinchGesture.scale < PenMaximumSize){
            _penIndicator.size = _penIndicator.size * pinchGesture.scale;
        }else{
            _penIndicator.size = PenMaximumSize;
        }
    }else  {
        if (_penIndicator.size * pinchGesture.scale > PenMinimumSize){
            _penIndicator.size = _penIndicator.size * pinchGesture.scale;
        }else{
            _penIndicator.size = PenMinimumSize;
        }
    }
    
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        scaleStart = scale;
//    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        scale = scaleStart * gestureRecognizer.scale;
//    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        scale = 1;
//    }
}

@end
