//
//  RowButtonsViewController.m
//  ComicMakingPage
//
//  Created by Adnan on 12/24/15.
//  Copyright © 2015 ADNAN THATHIYA. All rights reserved.
//

#import "RowButtonsViewController.h"
#import "ComicMakingViewController.h"
#import "Global.h"
#import "JTAlertView.h"
#import "YLGIFImage.h"
#import "YLImageView.h"

@interface RowButtonsViewController ()

@property (nonatomic, strong) ComicMakingViewController *parentViewController;

@property (nonatomic, strong) YLImageView *imgvExclamation;
@property (nonatomic) UISwipeGestureRecognizer *swipeDirection;

@end

@implementation RowButtonsViewController

@synthesize parentViewController;
@synthesize btnBlackboard,btnBubble,btnCamera,btnExclamation,btnPen,btnSticker,btnText, isNewSlide, imgvExclamation;

CGPoint startLocation;

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [btnExclamation setImage:nil forState:UIControlStateNormal];
    
    imgvExclamation = [[YLImageView alloc] initWithFrame:btnExclamation.frame];
    
    imgvExclamation.image = [YLGIFImage imageNamed:@"Smiley-Button.gif"];
    
    [self.view insertSubview:imgvExclamation belowSubview:btnExclamation];
    
    if (isNewSlide)
    {
        btnCamera.selected = NO;
        
        [self allButtonsFadeOut:btnCamera];
    }
    else
    {
        btnCamera.selected = YES;
        
        [self allButtonsFadeIn:btnCamera];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeExclamation:) name:@"closeExclamation" object:nil];
    
    [self AddGestureToCameraButton];
}

#pragma mark- UISwipgesture implementation in camera button

-(void)AddGestureToCameraButton {
    
    startLocation.x=self.btnCameraViewContainer.frame.origin.x;
    startLocation.y=self.btnCameraViewContainer.frame.origin.y;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSwipe:)];
    [swipe setDirection:(UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown )];
    [self.btnCameraViewContainer addGestureRecognizer:swipe];
    [btnCamera addGestureRecognizer:swipe];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    NSLog(@"btnCamera----->%@",btnCamera);
    // NSLog(@"swipe----->%@",swipe);
    CGPoint location = [swipe locationInView:self.view];
    NSLog(@"location.y----->%f",location.y);
    //    CGFloat yOffset = self.view.frame.size.height - location.y;
    //    NSLog(@"yOffset----->%f",yOffset);
    //    if(yOffset > btnCamera.frame.size.height)
    //    {
    //        yOffset = btnCamera.frame.size.height+self.btnCamera.frame.origin.y;
    //        NSLog(@"yOffset after----->%f",yOffset);
    //    }
    
    //    CGRect frame=btnCamera.frame;
    //    frame.origin.y=location.y;
    //    btnCamera.frame=frame;
    
    
    //  btnCamera.frame = CGRectMake(btnCamera.frame.origin.x, self.view.frame.size.height-yOffset, btnCamera.frame.size.width, btnCamera.frame.size.height);
    
    //    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) swipe;
    //    NSLog(@"recognizer.state------>%ld",(long)recognizer.state);
    //    if (recognizer.state == UIGestureRecognizerStateChanged) {
    //
    //        CGPoint point = [recognizer locationInView:self.view];
    //     //   btnCamera.center=point;
    //    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) { // this is just for testing
        self.swipeDirection = swipe;
        NSLog(@"Gesture = %@", swipe);
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches ) {
        CGPoint currentLocalation = [touch locationInView:touch.view];
        //  if (self.swipeDirection.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swipe Left");
        if (currentLocalation.y < startLocation.y) { // Startlocation is a global CGPoint.
            NSLog(@"Current Y = %f, starting Y = %f", currentLocalation.y, startLocation.y);
            
            CGFloat distance =  currentLocalation.y-startLocation.y;
            CGPoint newPosition = CGPointMake(160 - distance, 170);
            CGPoint labelPosition = CGPointMake(160 - distance, 390);
            self.btnCameraViewContainer.center = newPosition;
            
        }
        
        //        } else {
        //            NSLog(@"Other direction");
        //        }
        
    }
}


#pragma mark- End of swip Method

- (IBAction)btnBlackboardTap:(UIButton *)sender
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^
     {
         sender.layer.transform = CATransform3DIdentity;
     }
                     completion:nil];
    
    if (btnBlackboard.selected == YES && GlobalObject.isBlackBoardOpen == YES)
    {
//        [parentViewController openBlackBoardColors];
    }
    else
    {
        if (GlobalObject.isTakePhoto == YES)
        {
//            JTAlertView *alertView = [parentViewController showAlertView:@"Do you want abandon?" image:nil height:200];
//            
//            [alertView addButtonWithTitle:@"CANCEL" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView)
//             {
//                 [alertView hide];
//             }];
//            
//            [alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDestructive action:^(JTAlertView *alertView)
//             {
//                 [alertView hide];
//                 
//                 btnCamera.selected = YES;
//                 [self allButtonsFadeIn:btnBlackboard];
//                 [parentViewController openBlackBoard];
//             }];
//            
//            [alertView show];
        }
        else
        {
            btnCamera.selected = YES;
            [self allButtonsFadeIn:btnBlackboard];
//            [parentViewController openBlackBoard];
        }
        
        btnBlackboard.selected = YES;
        GlobalObject.isBlackBoardOpen = YES;
    }
}

- (IBAction)btnTextTap:(UIButton *)sender
{
    //    [UIView animateWithDuration:1
    //                          delay:0
    //         usingSpringWithDamping:0.2
    //          initialSpringVelocity:0.3
    //                        options:UIViewAnimationOptionTransitionCurlDown
    //                     animations:^
    //     {
    //         [parentViewController openCaptionView];
    //     }
    //                     completion:nil];
//    [parentViewController openCaptionView];
    
    [self checkStatusForBlackBoardWithButton:sender];
}

- (IBAction)btnExclamationTap:(UIButton *)sender
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^
     {
         sender.layer.transform = CATransform3DIdentity;
     }
                     completion:^(BOOL finished) {
                         [self checkStatusForBlackBoardWithButton:sender];
//                         [parentViewController openExclamationList:^(BOOL success) {
//                             
//                             [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:100 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                                 
//                                 [self.btnExclamation setEnabled:NO];
//                                 [self.btnBubble setEnabled:NO];
//                                 self.imgvExclamation.alpha = 0;
//                                 self.btnCamera.alpha = 0;
//                             } completion:^(BOOL finished) {
//                                 
//                             }];
//                             
//                         }];
                     }];
}

- (IBAction)btnCameraTap:(UIButton *)sender
{
    if (btnCamera.selected)
    {
//        JTAlertView *alertView = [parentViewController showAlertView:@"Do you want take another Picture" image:nil height:200];
//        
//        [alertView addButtonWithTitle:@"CANCEL" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView)
//         {
//             [alertView hide];
//         }];
//        
//        [alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDestructive action:^(JTAlertView *alertView)
//         {
//             btnCamera.selected = NO;
//             
//             [parentViewController closeCamera];
//             
//             [self allButtonsFadeOut:btnCamera];
//             
//             [parentViewController doRemoveAllItem:nil];
//             
//             [alertView hide];
//         }];
//        
//        [alertView show];
//    }
//    else
//    {
//        btnCamera.selected = YES;
//        
//        [parentViewController btnCameraTap:nil];
//        
//        [self allButtonsFadeIn:btnCamera];
    }
    
    [self checkStatusForBlackBoardWithButton:sender];
}

- (IBAction)btnBubbleTap:(UIButton *)sender
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^
     {
         sender.layer.transform = CATransform3DIdentity;
     }
                     completion:^(BOOL finished) {
//                         [parentViewController addStandardBubbleOnFirstTime];
                         [self checkStatusForBlackBoardWithButton:sender];
                     }];
}

- (IBAction)btnPenTap:(UIButton *)sender
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^
     {
         sender.layer.transform = CATransform3DIdentity;
     }
                     completion:nil];
    
    //    if (GlobalObject.isBlackBoardOpen)
    //    {
    //
    //    }
    //    else
    //    {
    if (btnPen.selected)
    {
        btnPen.selected = NO;
        
        [self allButtonsFadeIn:btnPen];
        
//        [parentViewController stopDrawing];
    }
    else
    {
        btnPen.selected = YES;
        
        [self allButtonsFadeOut:btnPen];
        
//        [parentViewController startDrawing];
        
        [self checkStatusForBlackBoardWithButton:sender];
    }
    //    }
}
//
- (IBAction)btnStickerTap:(UIButton *)sender
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^
     {
         sender.layer.transform = CATransform3DIdentity;
         
     }completion:^(BOOL finished)
     {
//         [parentViewController openStickerList];
         [self checkStatusForBlackBoardWithButton:sender];
     }];
    
    
}

- (void)checkStatusForBlackBoardWithButton:(UIButton *)sender
{
    if (GlobalObject.isBlackBoardOpen && sender != btnBlackboard)
    {
//        [parentViewController closeBlackBoardColors];
    }
}

#pragma mark - Jelly Effect
- (IBAction)buttonTouchDown:(UIButton *)sender
{
    [UIView animateWithDuration:0.1 animations:^
     {
         sender.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
     }];
}

- (IBAction)buttonTouchUpOutside:(UIButton *)sender
{
    [self restoreTransformWithBounceForView:sender];
}

- (void)restoreTransformWithBounceForView:(UIView*)view
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^
     {
         view.layer.transform = CATransform3DIdentity;
     }
                     completion:nil];
}

#pragma mark - Helper Methods
- (void)allButtonsFadeOut:(UIButton *)sender
{
    [self checkStatusForBlackBoardWithButton:sender];
    
    CGFloat speed = 0.5;
    
    if (sender == btnBlackboard)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBubble.alpha = 0;
            btnCamera.alpha = 0;
            btnExclamation.alpha = 0;
            imgvExclamation.alpha = 0;
            btnPen.alpha = 0;
            btnSticker.alpha = 0;
            btnText.alpha = 0;
        }];
    }
    else if (sender == btnBubble)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 0;
            btnCamera.alpha = 0;
            btnExclamation.alpha = 0;
            imgvExclamation.alpha = 0;
            btnPen.alpha = 0;
            btnSticker.alpha = 0;
            btnText.alpha = 0;
        }];
    }
    else if (sender == btnCamera)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 1;
            btnBubble.alpha = 0;
            btnExclamation.alpha = 0;
            imgvExclamation.alpha = 0;
            btnPen.alpha = 0;
            btnSticker.alpha = 0;
            btnText.alpha = 0;
        }];
    }
    else if (sender == btnExclamation)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 0;
            btnBubble.alpha = 0;
            btnCamera.alpha = 0;
            btnPen.alpha = 0;
            btnSticker.alpha = 0;
            btnText.alpha = 0;
        }];
    }
    else if (sender == btnPen)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnCamera.alpha = 0;
            btnBlackboard.alpha = 0;
            btnBubble.alpha = 0;
            btnExclamation.alpha = 0;
            imgvExclamation.alpha = 0;
            
            btnSticker.alpha = 0;
            btnText.alpha = 0;
            
            //            if (GlobalObject.isTakePhoto)
            //            {
            //                btnBlackboard.alpha = 0;
            //                btnBubble.alpha = 0;
            //                btnExclamation.alpha = 0;
            //                btnSticker.alpha = 0;
            //                btnText.alpha = 0;
            //            }
            //            else
            //            {
            //                btnBlackboard.alpha = 1;
            //                btnBubble.alpha = 1;
            //                btnExclamation.alpha = 1;
            //                btnSticker.alpha = 1;
            //                btnText.alpha = 1;
            //
            //            }
        }];
    }
    else if (sender == btnSticker)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 0;
            btnBubble.alpha = 0;
            btnCamera.alpha = 0;
            btnExclamation.alpha = 0;
            imgvExclamation.alpha = 0;
            
            btnPen.alpha = 0;
            btnText.alpha = 0;
        }];
    }
    else if (sender == btnText)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 0;
            btnBubble.alpha = 0;
            btnCamera.alpha = 0;
            btnExclamation.alpha = 0;
            imgvExclamation.alpha = 0;
            
            btnPen.alpha = 0;
            btnSticker.alpha = 0;
        }];
    }
}

- (void)allButtonsFadeIn:(UIButton *)sender
{
    [self checkStatusForBlackBoardWithButton:sender];
    
    CGFloat speed = 0.5;
    
    if (sender == btnBlackboard)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBubble.alpha = 1;
            btnCamera.alpha = 1;
            btnExclamation.alpha = 1;
            imgvExclamation.alpha = 1;
            
            btnPen.alpha = 1;
            btnSticker.alpha = 1;
            btnText.alpha = 1;
            btnBlackboard.alpha = 1;
        }];
    }
    else if (sender == btnBubble)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 1;
            btnCamera.alpha = 1;
            btnExclamation.alpha = 1;
            imgvExclamation.alpha = 1;
            
            btnPen.alpha = 1;
            btnSticker.alpha = 1;
            btnText.alpha = 1;
            btnBubble.alpha = 0;
            
        }];
    }
    else if (sender == btnCamera)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 1;
            btnBubble.alpha = 1;
            btnExclamation.alpha = 1;
            imgvExclamation.alpha = 1;
            
            btnPen.alpha = 1;
            btnSticker.alpha = 1;
            btnText.alpha = 1;
            btnCamera.alpha = 1;
            
            
        }];
    }
    else if (sender == btnExclamation)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 1;
            btnBubble.alpha = 1;
            btnCamera.alpha = 1;
            btnPen.alpha = 1;
            btnSticker.alpha = 1;
            btnText.alpha = 1;
            btnExclamation.alpha = 0;
            imgvExclamation.alpha = 0;
            
            
        }];
    }
    else if (sender == btnPen)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 1;
            btnBubble.alpha = 1;
            btnCamera.alpha = 1;
            btnExclamation.alpha = 1;
            imgvExclamation.alpha = 1;
            
            btnSticker.alpha = 1;
            btnText.alpha = 1;
            btnPen.alpha = 1;
            
            
            //            if (GlobalObject.isBlackBoardOpen)
            //            {
            //
            //            }
            //            else
            //            {
            //                if (GlobalObject.isTakePhoto)
            //                {
            //                    btnBlackboard.alpha = 1;
            //                    btnBubble.alpha = 1;
            //                    btnCamera.alpha = 1;
            //                    btnExclamation.alpha = 1;
            //                    btnSticker.alpha = 1;
            //                    btnText.alpha = 1;
            //                    btnPen.alpha = 1;
            //                }
            //                else
            //                {
            //                    btnBlackboard.alpha = 0;
            //                    btnBubble.alpha = 0;
            //                    btnCamera.alpha = 1;
            //                    btnExclamation.alpha = 0;
            //                    btnSticker.alpha = 0;
            //                    btnText.alpha = 0;
            //                    btnPen.alpha = 1;
            //                }
            //
            //            }
        }];
    }
    else if (sender == btnSticker)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 1;
            btnBubble.alpha = 1;
            btnCamera.alpha = 1;
            btnExclamation.alpha = 1;
            btnPen.alpha = 1;
            btnText.alpha = 1;
            btnSticker.alpha = 0;
            
        }];
    }
    else if (sender == btnText)
    {
        [UIView animateWithDuration:speed animations:^{
            
            btnBlackboard.alpha = 1;
            btnBubble.alpha = 1;
            btnCamera.alpha = 1;
            btnExclamation.alpha = 1;
            btnPen.alpha = 1;
            btnSticker.alpha = 1;
            btnText.alpha = 0;
            
        }];
    }
}

-(void)closeExclamation:(NSNotification *)notification
{
    [self.btnExclamation setEnabled:YES];
    [self.btnBubble setEnabled:YES];
    self.imgvExclamation.alpha = 1;
    self.btnCamera.alpha = 1;
    
}
@end
