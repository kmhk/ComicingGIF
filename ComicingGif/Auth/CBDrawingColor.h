//
//  CBDrawingColor.h
//  ComicBook
//
//  Created by Sandeep Kumar Lall on 05/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBDrawingColorDelegate <NSObject>

- (void)drawingColorTapEventWithColor:(NSString *)colorName;

@end

@interface CBDrawingColor : UIView

@property (strong, nonatomic)  UIButton *btnUndo;
@property (strong, nonatomic)  UIButton *btnBlack;
@property (strong, nonatomic)  UIButton *btnBrown;
@property (strong, nonatomic)  UIButton *btnBlue;

@property (strong, nonatomic)  UIButton *btnGreen;
@property (strong, nonatomic)  UIButton *btnYellow;
@property (strong, nonatomic)  UIButton *btnWhite;

@property (strong, nonatomic)  UIButton *btnOrange;
@property (strong, nonatomic)  UIButton *btnCyan;
@property (strong, nonatomic)  UIButton *btnPink;
@property (strong, nonatomic)  UIButton *btnPurple;
@property (strong, nonatomic)  UIButton *btnReference;
@property (nonatomic) BOOL isAlreadyDouble;
@property (strong, nonatomic)  UIButton *btnRed;
@property (nonatomic, strong) id parentViewController;
@property (nonatomic, weak) id<CBDrawingColorDelegate> delegate;

-(void)allScaleToNormal;
- (void)setColorButtonsSize;
-(void)setControllerForMethod:(UIViewController *) controllerVC;
//- (instancetype)initWithParentViewController :(id)parentVC;

@end
