//
//  BottomBarViewController.h
//  Inbox
//
//  Created by Vishnu Vardhan PV on 16/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ ConnectAction) (void);

typedef NS_ENUM(NSInteger, MenuState){
    Close,
    Open
};

@interface BottomBarViewController : UIViewController <UIGestureRecognizerDelegate> {
    CGRect rectContainer;
    CGAffineTransform referTransform;
    CGFloat frameDifference;
    CGFloat theYStart;
}

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIButton *btn_ConnectFriend;

@property (weak, nonatomic) IBOutlet UIView *tap_View;
@property (nonatomic,assign) CGRect openFrame;
@property (nonatomic,assign) CGRect closeFrame;
@property (nonatomic, strong) ConnectAction connectAction;

@property (assign, nonatomic) MenuState menuState;

-(void)closeMenu;
- (void)setBottombuttonToYellow;

@end
