//
//  ComicBookColorCBViewController.m
//  ComicBook
//
//  Created by Amit on 17/01/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "ComicBookColorCBViewController.h"

#define InnerCircleDistanceFromOrigin 63
#define OuterCircleDistanceFromOrigin 112

#define SecondMutiplier 0.5
#define ThirdMultiplier 0.85

#define ColorViewTag 150

@interface ComicBookColorCBViewController () {
    NSArray *imageNames;
}

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *circle1WidthConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *circle2WidthConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *circle3WidthConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *circle4WidthConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *circle5WidthConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *circle6WidthConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *circle7WidthConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *circle8WidthConstraint;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *originTopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *originTrailingConstraint;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *innerCircle1TopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *innerCircle1TrailingConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *innerCircle2TopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *innerCircle2TrailingConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *innerCircle3TopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *innerCircle3TrailingConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *innerCircle4TopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *innerCircle4TrailingConstraint;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *outerCircle1TopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *outerCircle1TrailingConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *outerCircle2TopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *outerCircle2TrailingConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *outerCircle3TopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *outerCircle3TrailingConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *outerCircle4TopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *outerCircle4TrailingConstraint;

@end

@implementation ComicBookColorCBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _originTopConstraint.constant = _frameOfRainbowCircle.origin.y - 20; //20 is status bar length
    _originTrailingConstraint.constant = 20;

    [self setComicColorViewsWidthAndHeightTo:0];
    imageNames = [NSArray arrayWithObjects:@"Purple", @"Green", @"Yellow", @"Orange", @"NBlue", @"LBlue", @"White", @"Pink", nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self bringAndShowColors];
}

- (void)bringAndShowColors {
    self.innerCircle1TopConstraint.constant = 0;
    self.innerCircle1TrailingConstraint.constant = -InnerCircleDistanceFromOrigin;
    self.innerCircle2TopConstraint.constant = InnerCircleDistanceFromOrigin * SecondMutiplier;
    self.innerCircle2TrailingConstraint.constant = -InnerCircleDistanceFromOrigin * ThirdMultiplier;
    self.innerCircle3TopConstraint.constant = InnerCircleDistanceFromOrigin * ThirdMultiplier;
    self.innerCircle3TrailingConstraint.constant = -(InnerCircleDistanceFromOrigin * SecondMutiplier);
    self.innerCircle4TopConstraint.constant = InnerCircleDistanceFromOrigin;
    self.innerCircle4TrailingConstraint.constant = 0;
    
    self.outerCircle1TopConstraint.constant = 0;
    self.outerCircle1TrailingConstraint.constant = -OuterCircleDistanceFromOrigin;
    self.outerCircle2TopConstraint.constant = OuterCircleDistanceFromOrigin * SecondMutiplier;
    self.outerCircle2TrailingConstraint.constant = -OuterCircleDistanceFromOrigin * ThirdMultiplier;
    self.outerCircle3TopConstraint.constant = OuterCircleDistanceFromOrigin * ThirdMultiplier;
    self.outerCircle3TrailingConstraint.constant = -(OuterCircleDistanceFromOrigin * SecondMutiplier);
    self.outerCircle4TopConstraint.constant = OuterCircleDistanceFromOrigin;
    self.outerCircle4TrailingConstraint.constant = 0;
    
    [self setComicColorViewsWidthAndHeightTo:25];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (IBAction)emptyScreenTapped:(id)sender {
    [self dismissControllerWithBounceInAnimation];
}

- (void)dismissControllerWithBounceInAnimation {
    self.innerCircle1TopConstraint.constant = self.innerCircle1TrailingConstraint.constant = self.innerCircle2TopConstraint.constant = self.innerCircle2TrailingConstraint.constant = self.innerCircle3TopConstraint.constant = self.innerCircle3TrailingConstraint.constant = self.innerCircle4TopConstraint.constant = self.innerCircle4TrailingConstraint.constant = self.outerCircle1TopConstraint.constant = self.outerCircle1TrailingConstraint.constant = self.outerCircle2TopConstraint.constant = self.outerCircle2TrailingConstraint.constant = self.outerCircle3TopConstraint.constant = self.outerCircle3TrailingConstraint.constant = self.outerCircle4TopConstraint.constant = self.outerCircle4TrailingConstraint.constant = 0;

    [self setComicColorViewsWidthAndHeightTo:0];

    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)someColorCircleButtonTapped:(id)sender {
    UIView *superViewOfButton = ((UIButton *)sender).superview;
    UIView *colorView = [superViewOfButton viewWithTag:ColorViewTag];
    
    NSString *imageName = [imageNames objectAtIndex:((UIView *)sender).tag - 201];
    
    if (colorView) {
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ComicBookColorCBViewControllerDelegate)]) {
            if ([self.delegate respondsToSelector:@selector(getSelectedColor:andComicBackgroundImageName:)]) {
                [self.delegate getSelectedColor:[colorView.backgroundColor copy] andComicBackgroundImageName:imageName];
            }
        }
    }
    [self dismissControllerWithBounceInAnimation];
}
- (void)setComicColorViewsWidthAndHeightTo:(NSInteger)widthHeight {
    //Width Height are the same
    _circle1WidthConstraint.constant = _circle2WidthConstraint.constant = _circle3WidthConstraint.constant = _circle4WidthConstraint.constant = _circle5WidthConstraint.constant = _circle6WidthConstraint.constant = _circle7WidthConstraint.constant = _circle8WidthConstraint.constant = widthHeight;
}
@end
