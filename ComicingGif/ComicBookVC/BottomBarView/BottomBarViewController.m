//
//  BottomBarViewController.m
//  Inbox
//
//  Created by Vishnu Vardhan PV on 16/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "BottomBarViewController.h"
#import "AppDelegate.h"

@implementation BottomBarViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _bottomButton.transform = CGAffineTransformRotate(_bottomButton.transform, M_PI);
    referTransform = _bottomButton.transform;


}
-(void)viewDidLayoutSubviews
{
    [self SetUpUI];
}
-(void)SetUpUI {
    
    rectContainer = self.view.bounds ;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [singleTap setNumberOfTouchesRequired:1];
    [_tap_View addGestureRecognizer:singleTap];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    panGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    self.closeFrame = CGRectMake(0, self.parentViewController.view.bounds.size.height - 30, rectContainer.size.width, rectContainer.size.height);
    self.openFrame = CGRectMake(0, self.parentViewController.view.bounds.size.height - rectContainer.size.height, rectContainer.size.width, rectContainer.size.height);
    theYStart = self.parentViewController.view.bounds.size.height - rectContainer.size.height;
    //    [self.view setFrame:CGRectMake(0, 500, self.view.frame.size.width, 320)];
    [_bottomButton setSelected:NO];
}

#pragma mark - Gestures and Menu animation methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // test if our control subview is on-screen
     CGPoint touchLocation = [touch locationInView:self.view];
    return !CGRectContainsPoint(_btn_ConnectFriend.frame, touchLocation);

    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        if ([touch.view isDescendantOfView:_btn_ConnectFriend]) {
            // we touched a button, slider, or other UIControl
            return NO; // ignore the touch
        }
    }
    return YES; // handle the touch
}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if (self.view.frame.origin.y == self.closeFrame.origin.y)
    {
        [self openMenu];
        
    } else {
        [self closeMenu ];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer {
    if( ([recognizer state] == UIGestureRecognizerStateBegan) ||
       ([recognizer state] == UIGestureRecognizerStateChanged) ) {
        CGPoint movement = [recognizer translationInView:self.view];
        CGRect old_rect = self.view.frame;
        old_rect.origin.y = old_rect.origin.y + movement.y;
        if(old_rect.origin.y < self.openFrame.origin.y) {
            self.view.frame = self.openFrame;
        } else if(old_rect.origin.y > self.closeFrame.origin.y) {
            self.view.frame = self.closeFrame;
        } else {
            self.view.frame = old_rect;
        }
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    else if (recognizer.state==UIGestureRecognizerStateEnded)
    {
        CGFloat halfPoint = (self.closeFrame.origin.y + self.openFrame.origin.y)/ 2;
        if(self.view.frame.origin.y > halfPoint) {
            [self closeMenu];
            
        } else {
            [self openMenu];
            
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"%ld",(long)recognizer.state);
        CGFloat halfPoint = (self.closeFrame.origin.y + self.openFrame.origin.y)/ 2;
        if(self.view.frame.origin.y > halfPoint) {
            [self closeMenuForPan];

        } else {
            [self openMenuForPan];

        }
    }
}
-(void)openMenuForPan
{
    _menuState = Open;
    [self.bottomButton setImage:[UIImage imageNamed:@"BubbleWhite"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMenu" object:nil];
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect= self.openFrame;
        rect.origin.y=self.openFrame.origin.y-10;
        self.view.frame = rect;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f  animations:^{
            self.view.frame = self.openFrame;
        } completion:^(BOOL finished) {
            [_bottomButton setSelected:YES];
        }];
        
    }];
}
-(void)openMenu
{
    _menuState = Open;
    [self.bottomButton setImage:[UIImage imageNamed:@"BubbleWhite"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMenu" object:nil];
    
    [UIView animateWithDuration:0.3f animations:^{
        
            _bottomButton.transform = CGAffineTransformRotate(referTransform, M_PI);

        [_bottomButton setSelected:YES];
        CGRect rect= self.openFrame;
        rect.origin.y=self.openFrame.origin.y-10;
        self.view.frame = rect;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f  animations:^{
            self.view.frame = self.openFrame;
           
        } completion:^(BOOL finished) {

        }];
        
    }];
}

-(void)closeMenuForPan
{
    _menuState = Close;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMenu" object:nil];
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect=self.closeFrame;
        
        rect.origin.y=self.closeFrame.origin.y+5;
        self.view.frame = rect;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f  animations:^{
            self.view.frame = self.closeFrame;
        } completion:^(BOOL finished) {
            [_bottomButton setSelected:NO];
        }];
    }];
}

-(void)closeMenu
{
    _menuState = Close;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMenu" object:nil];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        _bottomButton.transform = CGAffineTransformRotate(_bottomButton.transform, M_PI);
        [_bottomButton setSelected:NO];
        CGRect rect=self.closeFrame;

        rect.origin.y=self.closeFrame.origin.y+5;
        self.view.frame = rect;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f  animations:^{
            self.view.frame = self.closeFrame;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)setBottombuttonToYellow
{
    if (self.bottomButton.selected == NO)
    {
        [self.bottomButton setImage:[UIImage imageNamed:@"BubbleYellow"] forState:UIControlStateNormal];
    }
}
- (IBAction)tappedConnectFriendButton:(id)sender {
    [AppDelegate application].isShownFriendImage = YES;
    if(self.connectAction) {
        self.connectAction();
    }
}

@end
