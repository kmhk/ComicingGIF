//
//  RowButtonsViewController.h
//  ComicMakingPage
//
//  Created by Adnan on 12/24/15.
//  Copyright © 2015 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RowButtonsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnPen;
@property (weak, nonatomic) IBOutlet UIButton *btnBlackboard;
@property (weak, nonatomic) IBOutlet UIButton *btnText;
@property (weak, nonatomic) IBOutlet UIButton *btnExclamation;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnBubble;
@property (weak, nonatomic) IBOutlet UIButton *btnSticker;
@property (weak, nonatomic) IBOutlet UIView *btnCameraViewContainer;

- (void)allButtonsFadeOut:(UIButton *)sender;
- (void)allButtonsFadeIn:(UIButton *)sender;

@property (nonatomic) BOOL isNewSlide;

@end
