//
//  InstructionView.m
//  ComicBook
//
//  Created by ADNAN THATHIYA on 30/06/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "InstructionView.h"
#import "YLImageView.h"
#import "YLGIFImage.h"

@interface InstructionView()
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet UIImageView *imvgSlide1;


@property (weak, nonatomic) IBOutlet UIButton *btnBoxOk;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide2;
@property (weak, nonatomic) IBOutlet UIView *viewBubble;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIView *viewGIF;

@property (nonatomic) CGRect saveFrameBoxView;
@property (nonatomic) CGRect saveFrameImgvSlide2B;

@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide3;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide4;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide5;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide6;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide8;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide9;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide11;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide15;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide16;

@property (weak, nonatomic) IBOutlet YLImageView *imgvSlide13;
@property (weak, nonatomic) IBOutlet YLImageView *imgvSlide7;
@property (weak, nonatomic) IBOutlet YLImageView *imgvSlide10;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlideB;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlideC;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlideD;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlideE;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide14;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSlide2B;

@property CGFloat boxAnimationTime;

@property (nonatomic) NSTimer *timer;

@end

@implementation InstructionView

@synthesize boxView, saveFrameBoxView, boxAnimationTime, btnBoxOk, timer, viewBubble, viewBackground,imgvSlide3,imgvSlide4, imgvSlide5, imgvSlide6, imgvSlide2, imgvSlide8, imgvSlide11, imgvSlide9, imvgSlide1, imgvSlide13, imgvSlide7, viewGIF, imgvSlide10,imgvSlide14,imgvSlide15, imgvSlide16, imgvSlideB,imgvSlideC, imgvSlideD, imgvSlideE, imgvSlide2B, saveFrameImgvSlide2B;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"InstructionView" owner:self options:nil];
        self.view.frame = self.frame;
        [self addSubview:self.view];
        
        [self setup];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"InstructionView" owner:self options:nil];
        [self addSubview:self.view];
        [self.view setClipsToBounds:NO];
    }
    return self;
}

- (void)setup
{
    boxAnimationTime = 0.3;
    
    self.backgroundColor = [UIColor clearColor];
    viewBubble.backgroundColor = [UIColor clearColor];
    boxView.backgroundColor = [UIColor clearColor];
    viewGIF.backgroundColor = [UIColor clearColor];
    
    [self saveFrames];
    
    btnBoxOk.layer.cornerRadius = CGRectGetHeight(btnBoxOk.frame) / 2;
    btnBoxOk.layer.masksToBounds = YES;
    
    // boxview
    CGRect frame = boxView.frame;
    frame.origin.y = self.frame.size.height;
    boxView.frame = frame;
    
    frame = imgvSlide2B.frame;
    frame.origin.y = -1000;
    imgvSlide2B.frame = frame;
    
}

- (void)saveFrames
{
    saveFrameBoxView = boxView.frame;
    saveFrameImgvSlide2B = imgvSlide2B.frame;
}

- (void)showInstructionWithSlideNumber:(SlideNumber)number withType:(InstructionType)type
{
    self.type = type;
    self.number = number;
    
    if (type == InstructionBubbleType)
    {
        boxView.hidden = YES;
        viewGIF.hidden = YES;
    }
    else if (type == InstructionGIFType)
    {
        boxView.hidden = YES;
        viewBubble.hidden = YES;
    }
    else
    {
        // show boxview
        viewBubble.hidden = YES;
        viewGIF.hidden = YES;
    }
    
    [self hiddleAllBubbleImageView];
    
    if (number == SlideNumber1)
    {
        [self slide1Animation];
    }
    else if (number == SlideNumber2)
    {
        [self slide2Animation];
    }
    else if (number == SlideNumber3)
    {
        [self slide3Animation];
    }
    else if (number == SlideNumber4)
    {
        [self slide4Animation];
    }
    else if (number == SlideNumber5)
    {
        [self slide5Animation];
    }
    else if (number == SlideNumber6)
    {
        [self slide6Animation];
    }
    else if (number == SlideNumber8)
    {
        [self slide8Animation];
    }
    else if (number == SlideNumber9)
    {
        [self slide9Animation];
    }
    
    else if (number == SlideNumber7)
    {
        [self slide7Animation];
    }
    else if (number == SlideNumber10)
    {
        [self slide10Animation];
    }
    else if (number == SlideNumber11)
    {
        [self slide11Animation];
    }
    else if (number == SlideNumber12)
    {
        [self slide12Animation];
    }
    else if (number == SlideNumber13)
    {
        [self slide13Animation];
    }
    else if (number == SlideNumber14)
    {
        // not implemented yet
        [self slide14Animation];
    }
    else if (number == SlideNumber15)
    {
        [self slide15Animation];
    }
    else if (number == SlideNumber16)
    {
        [self slide16Animation];
    }
    else if (number == SlideNumber16B)
    {
        [self slide16BAnimation];
    }
    
    else if (number == SlideNumberB)
    {
        [self slideBAnimation];
    }
    else if (number == SlideNumber2B)
    {
        [self slide2BAnimation];
    }
    else if (number == SlideNumberC)
    {
        [self slideCAnimation];
    }
    else if (number == SlideNumberD)
    {
        [self slideDAnimation];
    }
    else if (number == SlideNumberE)
    {
        [self slideEAnimation];
    }
}

-(void)repeatAnimation:(NSTimer *)timerObj
{
    UIImageView *imgvSlide = (UIImageView *)timerObj.userInfo[@"imgvSlide"];
    
    //do smth
    [self bounsAnimationWithView:imgvSlide];
}

- (void)hiddleAllBubbleImageView
{
    imvgSlide1.hidden = YES;
    imgvSlide2.hidden = YES;
    imgvSlide3.hidden = YES;
    imgvSlide4.hidden = YES;
    imgvSlide5.hidden = YES;
    imgvSlide6.hidden = YES;
    imgvSlide7.hidden = YES;
    imgvSlide8.hidden = YES;
    imgvSlide9.hidden = YES;
    imgvSlide10.hidden = YES;
    imgvSlide11.hidden = YES;
    imgvSlide13.hidden = YES;
    imgvSlide15.hidden = YES;
    imgvSlide14.hidden = YES;
    imgvSlide16.hidden = YES;
    
    imgvSlideB.hidden = YES;
    imgvSlide2B.hidden = YES;
    imgvSlideC.hidden = YES;
    imgvSlideD.hidden = YES;
    imgvSlideE.hidden = YES;
}

#pragma mark - Events Methods
- (IBAction)btnBoxOkTap:(id)sender
{
    if (self.type == InstructionBubbleType)
    {
        if (self.number == SlideNumber2B)
        {
            [UIView animateWithDuration:boxAnimationTime animations:^{
                
                viewBubble.alpha = 0;
                CGRect frame = imgvSlide2B.frame;
                imgvSlide2B.alpha = 0;
                frame.origin.y = -1000;
                imgvSlide2B.frame = frame;

                
            }completion:^(BOOL finished)
             {
                 [self.delegate didCloseInstructionViewWith:self withClosedSlideNumber:self.number];
             }];

        }
        else
        {
            [UIView animateWithDuration:boxAnimationTime animations:^{
                viewBubble.alpha = 0;
                
            }completion:^(BOOL finished)
             {
                 [self.delegate didCloseInstructionViewWith:self withClosedSlideNumber:self.number];
             }];

        }
    }
    else if(self.type == InstructionBoxType)
    {
        [UIView animateWithDuration:boxAnimationTime animations:^{
            boxView.alpha = 0;
            CGRect frame = boxView.frame;
            frame.origin.y = self.frame.size.height;
            boxView.frame = frame;
        }
        completion:^(BOOL finished)
        {
            [self.delegate didCloseInstructionViewWith:self withClosedSlideNumber:self.number];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            viewGIF.alpha = 0;
        }completion:^(BOOL finished) {
            [self.delegate didCloseInstructionViewWith:self withClosedSlideNumber:self.number];

        }];
    }
}

#pragma mark - Set User defaults
+ (void)setAllSlideUserDefaultsValueNO
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setBool:false forKey:kInstructionSlide1];
    [userDefault setBool:false forKey:kInstructionSlide2];
    [userDefault setBool:false forKey:kInstructionSlide3];
    [userDefault setBool:false forKey:kInstructionSlide4];
    [userDefault setBool:false forKey:kInstructionSlide5];
    [userDefault setBool:false forKey:kInstructionSlide6];
    [userDefault setBool:false forKey:kInstructionSlide7];
    [userDefault setBool:false forKey:kInstructionSlide8];
    [userDefault setBool:false forKey:kInstructionSlide9];
    [userDefault setBool:false forKey:kInstructionSlide10];
    [userDefault setBool:false forKey:kInstructionSlide11];
    [userDefault setBool:false forKey:kInstructionSlide12];
    [userDefault setBool:false forKey:kInstructionSlide12repeat];

    [userDefault setBool:false forKey:kInstructionSlide13];
    [userDefault setBool:false forKey:kInstructionSlide14];
    [userDefault setBool:false forKey:kInstructionSlide15];
    [userDefault setBool:false forKey:kInstructionSlide16];
    [userDefault setBool:false forKey:kInstructionSlide16B];

    
    [userDefault setBool:false forKey:kInstructionSlideB];
    [userDefault setBool:false forKey:kInstructionSlide2B];
    [userDefault setBool:false forKey:kInstructionSlideC];
    [userDefault setBool:false forKey:kInstructionSlideD];
    [userDefault setBool:false forKey:kInstructionSlideE];
    [userDefault setBool:false forKey:kInstructionSlideF];

    [userDefault synchronize];
}

+ (void)setAllSlideUserDefaultsValueYES
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setBool:YES forKey:kInstructionSlide1];
    [userDefault setBool:YES forKey:kInstructionSlide2];
    [userDefault setBool:YES forKey:kInstructionSlide3];
    [userDefault setBool:YES forKey:kInstructionSlide4];
    [userDefault setBool:YES forKey:kInstructionSlide5];
    [userDefault setBool:YES forKey:kInstructionSlide6];
    [userDefault setBool:YES forKey:kInstructionSlide7];
    [userDefault setBool:YES forKey:kInstructionSlide8];
    [userDefault setBool:YES forKey:kInstructionSlide9];
    [userDefault setBool:YES forKey:kInstructionSlide10];
    [userDefault setBool:YES forKey:kInstructionSlide11];
    [userDefault setBool:YES forKey:kInstructionSlide12];
    [userDefault setBool:YES forKey:kInstructionSlide12repeat];

    
    [userDefault setBool:YES forKey:kInstructionSlide13];
    [userDefault setBool:YES forKey:kInstructionSlide14];
    [userDefault setBool:YES forKey:kInstructionSlide15];
    [userDefault setBool:YES forKey:kInstructionSlide16];
    [userDefault setBool:YES forKey:kInstructionSlide16B];

    
    [userDefault setBool:YES forKey:kInstructionSlideB];
    [userDefault setBool:YES forKey:kInstructionSlide2B];
    [userDefault setBool:YES forKey:kInstructionSlideC];
    [userDefault setBool:YES forKey:kInstructionSlideD];
    [userDefault setBool:YES forKey:kInstructionSlideE];
    [userDefault setBool:YES forKey:kInstructionSlideF];

    [userDefault synchronize];
}

- (void)setTrueForSlide:(NSString *)number
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setBool:YES forKey:number];
}

- (void)setFalseForSlide:(NSString *)number
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setBool:NO forKey:number];
}

+ (BOOL)getBoolValueForSlide:(NSString *)number
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    
    return [userDefault boolForKey:number];
}

#pragma mark - Bouns Animation
- (void)bounsAnimationWithView:(UIImageView *)sender
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///use transform
    theAnimation.duration = 0.7;
    theAnimation.repeatCount = 2;
    theAnimation.autoreverses = YES;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    theAnimation.toValue = [NSNumber numberWithFloat:-8];
    [sender.layer addAnimation:theAnimation forKey:@"animateTranslation"];
}

- (void)boxAnimation
{
    boxView.alpha = 0;
    viewBackground.alpha = 0;
    
    [UIView animateWithDuration:boxAnimationTime animations:^{
        boxView.alpha = 1;
        boxView.frame = saveFrameBoxView;
        
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            viewBackground.alpha = 0.6;
        }];
    }];
}

- (void)bubbleAnimationWithView:(UIImageView *)view
{
    viewBubble.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        viewBubble.alpha = 1;

    }completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.2 animations:^{
            viewBackground.alpha = 0.6;
        }];
        
        [self bounsAnimationWithView:view];
        timer = [NSTimer scheduledTimerWithTimeInterval: 1.4
                                                 target: self
                                               selector:@selector(repeatAnimation:)
                                               userInfo: @{@"imgvSlide" : view} repeats:YES];
    }];
}

- (void)gifAnimation
{
    viewGIF.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        viewGIF.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];

}

#pragma mark - Slide Animation
- (void)slide1Animation
{
    imvgSlide1.hidden = NO;
    
    [self boxAnimation];
}

- (void)slide2Animation
{
    imgvSlide2.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide2];
}

- (void)slide3Animation
{
    imgvSlide3.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide3];
}

- (void)slide4Animation
{
    imgvSlide4.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide4];
}

- (void)slide5Animation
{
    imgvSlide5.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide5];
}

- (void)slide6Animation
{
    imgvSlide6.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide6];
}

- (void)slide8Animation
{
    imgvSlide8.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide8];
}

- (void)slide9Animation
{
    imgvSlide9.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide9];
}

- (void)slide11Animation
{
    imgvSlide11.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide11];
}

- (void)slide7Animation
{
    imgvSlide7.hidden = NO;
    imgvSlide7.image = [YLGIFImage imageNamed:@"Slide-7.gif"];
    
    [self gifAnimation];
}

- (void)slide10Animation
{
    imgvSlide10.hidden = NO;
    imgvSlide10.image = [YLGIFImage imageNamed:@"Slide-10.gif"];

    [self gifAnimation];
}

- (void)slide12Animation
{
    imgvSlide10.hidden = NO;
    imgvSlide10.image = [YLGIFImage imageNamed:@"Slide-12.gif"];
    
    [self gifAnimation];
}

- (void)slide13Animation
{
    imgvSlide13.hidden = NO;
    imgvSlide13.image = [YLGIFImage imageNamed:@"Slide-13.gif"];
    
    [self gifAnimation];
}

- (void)slide14Animation
{
    imgvSlide14.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide14];
}

- (void)slide15Animation
{
    imgvSlide15.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide15];
}

- (void)slide16Animation
{
    imgvSlide16.hidden = NO;
    [self bubbleAnimationWithView:imgvSlide16];
}

- (void)slide16BAnimation
{
    imgvSlide10.hidden = NO;
    imgvSlide10.image = [YLGIFImage imageNamed:@"Slide-12.gif"];
    
    [self gifAnimation];
}

- (void)slideBAnimation
{
    imgvSlideB.hidden = NO;
    [self bubbleAnimationWithView:imgvSlideB];
}

- (void)slide2BAnimation
{
    imgvSlide2B.hidden = NO;
    
    viewBubble.alpha = 0;
    
    [UIView animateWithDuration:boxAnimationTime animations:^
    {
        viewBubble.alpha = 1;

        imgvSlide2B.frame = saveFrameImgvSlide2B;
    }
                     completion:^(BOOL finished)
     {
     }];

    
    
    
  //  [self boxAnimation];
    
//    imgvSlide10.hidden = NO;
//    imgvSlide10.image = [YLGIFImage imageNamed:@"Slide-2B.gif"];
//    
//    [self gifAnimation];
}

- (void)slideCAnimation
{
    imgvSlideC.hidden = NO;
    [self bubbleAnimationWithView:imgvSlideC];
}

- (void)slideDAnimation
{
    imgvSlideD.hidden = NO;
    [self bubbleAnimationWithView:imgvSlideD];
}

- (void)slideEAnimation
{
    imgvSlide10.hidden = NO;
    imgvSlide10.image = [YLGIFImage imageNamed:@"Slide-E.gif"];
    
    [self gifAnimation];
}


@end
