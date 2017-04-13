//
//  CBDrawingColor.m
//  ComicBook
//
//  Created by Sandeep Kumar Lall on 05/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "CBDrawingColor.h"
#import "UIColor+Color.h"
#import "AppConstants.h"
#import "CBSelfiRegistrationPageViewController.h"

@implementation CBDrawingColor
@synthesize btnBlack,btnBlue,btnBrown,btnGreen,btnRed,btnUndo,btnWhite,btnYellow,btnCyan,btnOrange,btnPink,btnPurple,btnReference,isAlreadyDouble,parentViewController;

//- (instancetype)initWithParentViewController :(id)parentVC
//{
//    
//    if (self)
//    {
//        
//        parentViewController=parentVC;
//    }
//    
//    return self;
//}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    
//    if (self)
//    {
//        self.frame=frame;
//    }
//    
//    return self;
//}

-(void)setControllerForMethod:(UIViewController *) controllerVC {
    
       // parentViewController=controllerVC;
}


- (void)setColorButtonsSize
{
    CGFloat dx;
    CGFloat dy;
    
    /*if (IS_IPHONE_5)
     {
     dx = 14;
     dy = 14;
     }
     else if (IS_IPHONE_6)
     {
     dx = 14;
     dy = 14;
     }
     else if (IS_IPHONE_6P)
     {
     dx = 14;
     dy = 14;
     }*/
    dx = 4.5f;
    dy = 4.5f;
    
    btnBlack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBlack setFrame:CGRectMake(10, 5, 10, 10)];
    [self addSubview:btnBlack];
    
    CALayer *subblack = [CALayer new];
    subblack.frame = CGRectInset(btnBlack.bounds, dx, dy);
    btnBlack.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    subblack.cornerRadius = CGRectGetHeight(subblack.frame) / 2;
    btnBlack.clipsToBounds = YES;
    btnBlack.backgroundColor = [UIColor clearColor];
    subblack.backgroundColor = [UIColor blackColor].CGColor;
    [btnBlack.layer addSublayer:subblack];
    [btnBlack setBackgroundColor:[UIColor blackColor]];
    [btnBlack addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnBlue=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBlue setFrame:CGRectMake(btnBlack.frame.origin.x+btnBlack.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnBlue];
    
    CALayer *subblue = [CALayer new];
    subblue.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subblue.cornerRadius = CGRectGetHeight(subblue.frame) / 2;
    
    btnBlue.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnBlue.clipsToBounds = YES;
    btnBlue.backgroundColor = [UIColor clearColor];
    subblue.backgroundColor = [UIColor drawingColorBlue].CGColor;
    [btnBlue.layer addSublayer:subblue];
    [btnBlue setBackgroundColor:[UIColor blueColor]];
    [btnBlue addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnBrown=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBrown setFrame:CGRectMake(btnBlue.frame.origin.x+btnBlue.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnBrown];
    
    CALayer *subbrown = [CALayer new];
    subbrown.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subbrown.cornerRadius = CGRectGetHeight(subblue.frame) / 2;
    
    btnBrown.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnBrown.clipsToBounds = YES;
    btnBrown.backgroundColor = [UIColor clearColor];
    subbrown.backgroundColor = [UIColor drawingColorBrown].CGColor;
    [btnBrown.layer addSublayer:subbrown];
    [btnBrown setBackgroundColor:[UIColor brownColor]];
    [btnBrown addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnGreen=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnGreen setFrame:CGRectMake(btnBrown.frame.origin.x+btnBrown.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnGreen];
    
    CALayer *subgreen = [CALayer new];
    subgreen.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subgreen.cornerRadius = CGRectGetHeight(subgreen.frame) / 2;
    
    btnGreen.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnGreen.clipsToBounds = YES;
    btnGreen.backgroundColor = [UIColor clearColor];
    subgreen.backgroundColor = [UIColor drawingColorGreen].CGColor;
    [btnGreen.layer addSublayer:subgreen];
    [btnGreen setBackgroundColor:[UIColor greenColor]];
    [btnGreen addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnRed=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRed setFrame:CGRectMake(btnGreen.frame.origin.x+btnGreen.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnRed];
    
    CALayer *subred = [CALayer new];
    subred.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subred.cornerRadius = CGRectGetHeight(subred.frame) / 2;
    
    btnRed.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnRed.clipsToBounds = YES;
    btnRed.backgroundColor = [UIColor clearColor];
    subred.backgroundColor = [UIColor drawingColorRed].CGColor;
    [btnRed.layer addSublayer:subred];
    [btnRed setBackgroundColor:[UIColor redColor]];
    [btnRed addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnWhite=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnWhite setFrame:CGRectMake(btnRed.frame.origin.x+btnRed.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnWhite];
    
    CALayer *subwhite = [CALayer new];
    subwhite.frame = CGRectInset(btnWhite.bounds, dx, dy);
    subwhite.cornerRadius = CGRectGetHeight(subwhite.frame) / 2;
    
    btnWhite.layer.cornerRadius = CGRectGetHeight(btnWhite.frame) / 2;
    btnWhite.clipsToBounds = YES;
    btnWhite.backgroundColor = [UIColor clearColor];
    subwhite.backgroundColor = [UIColor whiteColor].CGColor;
    [btnWhite.layer addSublayer:subwhite];
    [btnWhite setBackgroundColor:[UIColor whiteColor]];
    [btnWhite addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnYellow=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnYellow setFrame:CGRectMake(btnWhite.frame.origin.x+btnWhite.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnYellow];
    
    CALayer *subyellow = [CALayer new];
    subyellow.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subyellow.cornerRadius = CGRectGetHeight(subyellow.frame) / 2;
    
    btnYellow.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnYellow.clipsToBounds = YES;
    btnYellow.backgroundColor = [UIColor clearColor];
    subyellow.backgroundColor = [UIColor drawingColorYellow].CGColor;
    [btnYellow.layer addSublayer:subyellow];
    [btnYellow setBackgroundColor:[UIColor yellowColor]];
    [btnYellow addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnCyan=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCyan setFrame:CGRectMake(btnYellow.frame.origin.x+btnYellow.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnCyan];
    
    CALayer *subbtnCyan = [CALayer new];
    subbtnCyan.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subbtnCyan.cornerRadius = CGRectGetHeight(subbtnCyan.frame) / 2;
    
    btnCyan.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnCyan.clipsToBounds = YES;
    btnCyan.backgroundColor = [UIColor clearColor];
    subbtnCyan.backgroundColor = [UIColor drawingColorCyan].CGColor;
    [btnCyan.layer addSublayer:subbtnCyan];
    [btnCyan setBackgroundColor:[UIColor cyanColor]];
    [btnCyan addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnOrange=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnOrange setFrame:CGRectMake(btnCyan.frame.origin.x+btnCyan.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnOrange];
    
    CALayer *subbtnOrange = [CALayer new];
    subbtnOrange.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subbtnOrange.cornerRadius = CGRectGetHeight(subbtnOrange.frame) / 2;
    
    btnOrange.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnOrange.clipsToBounds = YES;
    btnOrange.backgroundColor = [UIColor clearColor];
    subbtnOrange.backgroundColor = [UIColor drawingColorOrange].CGColor;
    [btnOrange.layer addSublayer:subbtnOrange];
    [btnOrange setBackgroundColor:[UIColor orangeColor]];
    [btnOrange addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnPink=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnPink setFrame:CGRectMake(btnOrange.frame.origin.x+btnOrange.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnPink];
    
    CALayer *subbtnPink = [CALayer new];
    subbtnPink.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subbtnPink.cornerRadius = CGRectGetHeight(subbtnPink.frame) / 2;
    
    btnPink.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnPink.clipsToBounds = YES;
    btnPink.backgroundColor = [UIColor clearColor];
    subbtnPink.backgroundColor = [UIColor drawingColorPink].CGColor;
    [btnPink.layer addSublayer:subbtnPink];
    [btnPink setBackgroundColor:[UIColor pinkColor]];
    [btnPink addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    btnPurple=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnPurple setFrame:CGRectMake(btnPink.frame.origin.x+btnPink.frame.size.width+15, 5, 10, 10)];
    [self addSubview:btnPurple];
    
    CALayer *subbtnPurple = [CALayer new];
    subbtnPurple.frame = CGRectInset(btnBlack.bounds, dx, dy);
    subbtnPurple.cornerRadius = CGRectGetHeight(subbtnPurple.frame) / 2;
    
    btnPurple.layer.cornerRadius = CGRectGetHeight(btnBlack.frame) / 2;
    btnPurple.clipsToBounds = YES;
    btnPurple.backgroundColor = [UIColor clearColor];
    subbtnPurple.backgroundColor = [UIColor drawingColorPurple].CGColor;
    [btnPurple.layer addSublayer:subbtnPurple];
    [btnPurple setBackgroundColor:[UIColor purpleColor]];
    [btnPurple addTarget:self action:@selector(btnDrawingTap:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)btnDrawingTap:(UIButton *)sender
{
    
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.2f];
    btnBlack.transform = CGAffineTransformMakeScale(1,1);
    btnBlue.transform = CGAffineTransformMakeScale(1,1);
    btnBrown.transform = CGAffineTransformMakeScale(1,1);
    btnGreen.transform = CGAffineTransformMakeScale(1,1);
    btnRed.transform = CGAffineTransformMakeScale(1,1);
    btnWhite.transform = CGAffineTransformMakeScale(1,1);
    btnYellow.transform = CGAffineTransformMakeScale(1,1);
    btnCyan.transform = CGAffineTransformMakeScale(1,1);
    btnPink.transform = CGAffineTransformMakeScale(1,1);
    btnPurple.transform = CGAffineTransformMakeScale(1,1);
    btnOrange.transform = CGAffineTransformMakeScale(1,1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.2f];
    if (btnReference!=sender)
    {
        isAlreadyDouble = NO;
        btnReference=sender;
        sender.transform = CGAffineTransformMakeScale(1.8f,1.8f);
    }
    else
    {
        if (isAlreadyDouble)
        {
            isAlreadyDouble = NO;
            sender.transform = CGAffineTransformMakeScale(1.8f,1.8f);
        }
        else
        {
            isAlreadyDouble = YES;
            sender.transform = CGAffineTransformMakeScale(3.2f,3.2f);
        }
    }
    [UIView commitAnimations];
    
    if (sender == btnWhite)
    {
        [self.delegate drawingColorTapEventWithColor:@"white"];
    }
    else if (sender == btnBlack)
    {
        [self.delegate drawingColorTapEventWithColor:@"black"];
    }
    else if (sender == btnBlue)
    {
        [self.delegate drawingColorTapEventWithColor:@"blue"];
    }
    else if (sender == btnBrown)
    {
        [self.delegate drawingColorTapEventWithColor:@"brown"];
    }
    else if (sender == btnGreen)
    {
        [self.delegate drawingColorTapEventWithColor:@"green"];
    }
    else if (sender == btnRed)
    {
        [self.delegate drawingColorTapEventWithColor:@"red"];
    }
    else if (sender == btnYellow)
    {
        [self.delegate drawingColorTapEventWithColor:@"yellow"];
    }
    else if (sender == btnPink)
    {
        btnReference = btnPink;
        [self.delegate drawingColorTapEventWithColor:@"pink"];
    }
    else if (sender == btnPurple)
    {
        [self.delegate drawingColorTapEventWithColor:@"purple"];
    }
    else if (sender == btnOrange)
    {
        [self.delegate drawingColorTapEventWithColor:@"orange"];
    }
    else if (sender == btnCyan)
    {
        [self.delegate drawingColorTapEventWithColor:@"cyan"];
    }
    
}

- (IBAction)btnUndoTap:(id)sender
{
  //  [parentViewController drawingUndoTap];
}
-(void)allScaleToNormal
{
    btnReference = btnRed;
    isAlreadyDouble = NO;
    btnBlack.transform = CGAffineTransformMakeScale(1,1);
    btnBlue.transform = CGAffineTransformMakeScale(1,1);
    btnBrown.transform = CGAffineTransformMakeScale(1,1);
    btnGreen.transform = CGAffineTransformMakeScale(1,1);
    btnRed.transform = CGAffineTransformMakeScale(1,1);
    btnWhite.transform = CGAffineTransformMakeScale(1,1);
    btnYellow.transform = CGAffineTransformMakeScale(1,1);
    btnCyan.transform = CGAffineTransformMakeScale(1,1);
    btnPink.transform = CGAffineTransformMakeScale(1,1);
    btnPurple.transform = CGAffineTransformMakeScale(1,1);
    btnOrange.transform = CGAffineTransformMakeScale(1,1);
}
@end
