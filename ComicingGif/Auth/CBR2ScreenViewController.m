//
//  CBR2ScreenViewController.m
//  ComicBook
//
//  Created by Sandeep Kumar Lall on 07/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "CBR2ScreenViewController.h"
#import "UIImage+resize.h"

@interface CBR2ScreenViewController () <CBDrawingColorDelegate>

@end

@implementation CBR2ScreenViewController

@synthesize  paths,pathColorArray,drawView,onColor,isAlreadyDoubleDrawColor,allPointsForRedFace,CBDrawingColorObj;
@synthesize faceImgView,imgvCrop,faceImg,imgAnimatedView,mMobileNumberValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setAlpha:0.5f];
   // self.croppedImageShown.image=self.croppedImg;
    self.signUpMobileNumber.delegate = self;
    self.verifyView.delegate = self;
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self createCroppedViewWithImage:self.croppedImg];
    //[self addDrawingView];
}

#pragma mark- setUp cropped Image view

-(void)createCroppedViewWithImage:(UIImage *)_croppedImage {
    
    self.croppedView=[[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.origin.x+[UIScreen mainScreen].bounds.size.width)/2-150, self.headerImg.frame.origin.y+self.headerImg.frame.size.height, 300, 300)];
    [self.view addSubview:self.croppedView];
    self.croppedView.layer.borderWidth=6.0;
    self.croppedView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.croppedView.layer.cornerRadius=150;
    self.croppedView.layer.masksToBounds=YES;
    [self.croppedView setBackgroundColor:[UIColor blackColor]];
    [self.croppedView setAlpha:1.0];
    
    self.croppedImageShown=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.croppedView.frame.size.width, self.croppedView.frame.size.height)];
    [self.croppedView addSubview:self.croppedImageShown];
    [self.croppedImageShown setImage:_croppedImage];
    self.croppedImageShown.layer.cornerRadius=150;
    self.croppedImageShown.layer.masksToBounds=YES;
   // [self.croppedImageShown setBackgroundColor:[UIColor blackColor]];
    [self.croppedImageShown setAlpha:1.0];
    
    [self.view bringSubviewToFront:self.backGroundBlackView];
    [self.view bringSubviewToFront:self.tickButton];
    [self.view bringSubviewToFront:self.backBtn];
    
    // lineDrwan View
    
    self.lineDrawView=[[UIView alloc] init];
    self.lineDrawView.frame=self.croppedImageShown.frame;
    [self.croppedView addSubview:self.lineDrawView];
    [self.lineDrawView setBackgroundColor:[UIColor clearColor]];
    [self.croppedView bringSubviewToFront:self.lineDrawView];
    
    [self addDrawingView];
    
}


#pragma mark- set up circle color view

- (void)addDrawingView
{
    
    CBDrawingColorObj=[[CBDrawingColor alloc] init];
    [CBDrawingColorObj setFrame:CGRectMake(30, self.croppedView.frame.origin.y+self.croppedView.frame.size.height+65, [UIScreen mainScreen].bounds.size.width-40, 30)];
    [CBDrawingColorObj setColorButtonsSize];
    [CBDrawingColorObj setDelegate:self];
    [CBDrawingColorObj setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:CBDrawingColorObj];
    [self drawingColorTapEventWithColor:@"red"];
    
    // pen button
    
    self.penBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.penBtn setFrame:CGRectMake(20, self.croppedView.frame.origin.y+self.croppedView.frame.size.height+55, 20, 30)];
    [self.view addSubview:self.penBtn];
    [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-red.png"] forState:UIControlStateNormal];
    
    
    self.drawLinePath = [[UIBezierPath alloc] init];
    [self.drawLinePath setLineWidth:5.0];
    [self.drawLinePath setLineJoinStyle:kCGLineJoinRound];
    // [self drawRect:self.lineDrawView.frame];
    
    self.pathDrawArray=[[NSMutableArray alloc] init];
    paths=[[NSMutableArray alloc] init];
    pathColorArray=[[NSMutableArray alloc] init];
    
    
//    /// tick button create
//    
//    self.tickButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
}

- (void)drawingColorTapEventWithColor:(NSString *)colorName
{    
    RowButtonsViewController *rowController;
    
    for (UIViewController *controller in self.childViewControllers)
    {
        if ([controller isKindOfClass:[RowButtonsViewController class]])
        {
            rowController = (RowButtonsViewController *)controller;
           // [self.backGroundBlackView addSubview:rowController.view];
            
        }
    }
    if ([colorName isEqualToString:@"white"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-white.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorWhite];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-white.png"] forState:UIControlStateNormal];
        self.selectedColor=[UIColor whiteColor];
    }
    else if ([colorName isEqualToString:@"black"])
    {;
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-black.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor blackColor];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-black.png"] forState:UIControlStateNormal];
        self.selectedColor=[UIColor blackColor];
    }
    else if ([colorName isEqualToString:@"blue"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-blue.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorBlue];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-blue.png"] forState:UIControlStateNormal];
        self.selectedColor=[UIColor blueColor];
        
    }
    else if ([colorName isEqualToString:@"red"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-red.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorRed];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-red.png"] forState:UIControlStateNormal];
        self.selectedColor=[UIColor redColor];
        
    }
    else if ([colorName isEqualToString:@"yellow"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-yellow.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorYellow];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-yellow.png"] forState:UIControlStateNormal];
        self.selectedColor=[UIColor yellowColor];
    }
    else if ([colorName isEqualToString:@"brown"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-brown.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorBrown];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-brown.png"] forState:UIControlStateNormal];
        self.selectedColor=[UIColor brownColor];
    }
    else if ([colorName isEqualToString:@"green"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-green.png"] forState:UIControlStateNormal];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-green.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorGreen];
        self.selectedColor=[UIColor greenColor];
    }
    else if ([colorName isEqualToString:@"pink"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-pink.png"] forState:UIControlStateNormal];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-pink.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorPink];
        self.selectedColor=[UIColor pinkColor];
    }
    else if ([colorName isEqualToString:@"purple"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-purple.png"] forState:UIControlStateNormal];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-purple.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorPurple];
        self.selectedColor=[UIColor purpleColor];
    }
    else if ([colorName isEqualToString:@"orange"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-orange.png"] forState:UIControlStateNormal];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-orange.png"] forState:UIControlStateNormal];
        
        drawView.lineColor = [UIColor drawingColorOrange];
        self.selectedColor=[UIColor orangeColor];
    }
    else if ([colorName isEqualToString:@"cyan"])
    {
        [rowController.btnPen setImage:[UIImage imageNamed:@"pen-icon-cyan.png"] forState:UIControlStateNormal];
        [self.penBtn setImage:[UIImage imageNamed:@"pen-icon-cyan.png"] forState:UIControlStateNormal];
        drawView.lineColor = [UIColor drawingColorCyan];
        self.selectedColor=[UIColor cyanColor];
    }
    
    if ([onColor isEqual: drawView.lineColor])
    {
        if (isAlreadyDoubleDrawColor)
        {
            isAlreadyDoubleDrawColor = NO;
            drawView.lineWidth = 2.8f;
        }
        else
        {
            isAlreadyDoubleDrawColor = YES;
            drawView.lineWidth = 5.64f;
        }
    }
    else
    {
        isAlreadyDoubleDrawColor = NO;
        drawView.lineWidth = 2.8f;
        onColor = drawView.lineColor;
    }
}

- (void) updateDrawingBoard {
    
    UIGraphicsBeginImageContext(self.croppedImageShown.bounds.size);
    [self.croppedImageShown.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIBezierPath *nPath=[self.pathDrawArray objectAtIndex:[self.pathDrawArray count]-1];
    
    if(self.selectedColor) {
        
        [self.selectedColor setStroke];
        [self.selectedColor setFill];
    }
    else
        [[UIColor redColor] setStroke];
    
    [nPath stroke];
    
    if([paths count]) {
        
        for (int i=0;i<[paths count];i++ ) {
            
            UIBezierPath * bezierPath=[paths objectAtIndex:i];
            
            if([pathColorArray count]>i) {
                
                UIColor *pathColor=[pathColorArray objectAtIndex:i];
                [pathColor setStroke];
                [bezierPath stroke];
            }
        }
    }
    
    
    UIImage *croppedImg = UIGraphicsGetImageFromCurrentImageContext();
    self.croppedImageShown.image=croppedImg;
    UIGraphicsEndImageContext();
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self.croppedView];
    UIView* viewNeedToDraw = [self.croppedView hitTest:locationPoint withEvent:event];
    
    if(viewNeedToDraw== self.lineDrawView) {
        
        self.drawLinePath = [UIBezierPath bezierPath] ;
        self.drawLinePath.lineCapStyle = kCGLineCapRound;
        self.drawLinePath.lineWidth = 2;
        [self.pathDrawArray addObject:self.drawLinePath];
        [self.lineDrawView setBackgroundColor:[UIColor clearColor]];
        
        UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
        [self.drawLinePath moveToPoint:[mytouch locationInView:self.lineDrawView]];
        [self updateDrawingBoard];
        
        
        
        if (allPointsForRedFace == nil)
        {
            allPointsForRedFace = [[NSMutableArray alloc]init];
        }
        [allPointsForRedFace addObject:[NSValue valueWithCGPoint:[mytouch locationInView:self.lineDrawView]]];
    }
    else {
        
        [super touchesBegan:touches withEvent:event];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self.croppedView];
    UIView* viewNeedToDraw = [self.croppedView hitTest:locationPoint withEvent:event];
    
    if(viewNeedToDraw== self.lineDrawView) {
        
        UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
        
        CGPoint touchLocation = [mytouch locationInView:self.lineDrawView];
        
        // move the image view
        self.drawLinePath=[self.pathDrawArray objectAtIndex:[self.pathDrawArray count]-1];
        [self.drawLinePath addLineToPoint:touchLocation];
        [paths addObject:self.drawLinePath];
        [allPointsForRedFace addObject:[NSValue valueWithCGPoint:[mytouch locationInView:self.lineDrawView]]];
        [pathColorArray addObject:self.selectedColor];
        [self updateDrawingBoard];
        
    }
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //    CGPoint locationPoint = [[touches anyObject] locationInView:self.croppedView];
    //    UIView* viewNeedToDraw = [self.croppedView hitTest:locationPoint withEvent:event];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark- animating image

-(void)animatedImage:(UIImageView *)stickerImageView {
    
    UIImage *cropedImage  = stickerImageView.image;
    cropedImage = [UIImage resizeImage:cropedImage newSize:CGSizeMake(130, 130)];
    [imgAnimatedView setImage:cropedImage];
    stickerImageView.frame = imgAnimatedView.frame;
    [self.view addSubview:stickerImageView];
    
    CGRect imgProfileRect = self.imgFinalCopedFace.frame;
    if ([self.view viewWithTag:909] &&
        imgProfileRect.origin.y < [self.view viewWithTag:909].frame.size.height &&
        !IS_IPHONE_5) {
        imgProfileRect.origin.y = imgProfileRect.origin.y + (IS_IPHONE_5?10:20);
        self.imgFinalCopedFace.frame = imgProfileRect;
    }
    
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [stickerImageView setFrame:self.imgFinalCopedFace.frame];
                     } completion:^(BOOL finished) {
                         [imgAnimatedView setHidden:YES];
                         self.imgFinalCopedFace.alpha = 1;
                         [self.imgFinalCopedFace setImage:stickerImageView.image];
                         [self.imgFinalCopedFace setHidden:NO];
                         [stickerImageView removeFromSuperview];
                     }];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.cropHolder setAlpha:0];
                     } completion:^(BOOL finished) {
                         self.accountHolderView.imgCropedImage = stickerImageView.image;
                         [self openMobileEntryView:stickerImageView.image];
                         [self.cropHolder removeFromSuperview];
                     }];
    
    
}

-(void)openMobileEntryView:(UIImage*)profilePic{
    [self hideAllSubView];
    self.signUpMobileNumber.alpha = 1;
    [self.signUpMobileNumber bindData];
    [self.signUpMobileNumber setHidden:NO];
    [self.headerForR3 setHidden:NO];
    [self.headerForR3 setBackgroundColor:[UIColor blackColor]];
    [self.view bringSubviewToFront:self.headerForR3];
    [self.signUpMobileNumber.txtMobileNumber becomeFirstResponder];
}
-(void)hideAllSubView{
    
    [self.view setBackgroundColor:[UIColor colorWithRed:42/255.0 green:172/255.0 blue:226/255.0 alpha:1]];
  //  [self.croppedImageShown setHidden:YES];
    [self.signUpMobileNumber setHidden:YES];
    [CBDrawingColorObj setHidden:YES];
    [self.backGroundBlackView setHidden:YES];
    [self.croppedView setHidden:YES];
    [self.lineDrawView setHidden:YES];
    [self.penBtn setHidden:YES];
    [self.tickButton setHidden:YES];
    [self.backBtn setHidden:YES];
    [self.headerImg setHidden:YES];
    
    

}

-(IBAction)imageDrawnDoneBtn:(id)sender {
    
    [self hideAllSubView];
    
    [self animatedImage:self.croppedImageShown];
    
    
}
-(IBAction)backBtnClicked:(id)sender {
    
}

#pragma Signup delegate

-(void)getCodeRequest:(NSString*)mNumber{

//    mMobileNumberValue = mNumber;
//    [self setPushNotification];
    
    [self opemVerifyRequest:@""];
}

-(void)getVerifyRequest{

    [self hideAllSubView];
    [self.signUpMobileNumber.txtMobileNumber resignFirstResponder];
    CGRect imgProfileRect = self.imgFinalCopedFace.frame;
    //imgProfileRect.origin.x = IS_IPHONE_5?30:IS_IPHONE_3G?10:45;
    self.headerLabel.text=@"Account";
    
    [self.view bringSubviewToFront:self.imgFinalCopedFace];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.imgFinalCopedFace.frame = imgProfileRect;
                     } completion:^(BOOL finished) {
                     }];
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.accountHolderView.alpha = 0;
                         [self.accountHolderView setHidden:NO];
                         CGRect aHolderFrame = self.accountHolderView.frame;
                         aHolderFrame.origin.x = 0;
                         self.accountHolderView.alpha = 1;
                     } completion:^(BOOL finished) {
                     }];
}

#pragma Verify delegate

-(void)opemVerifyRequest:(NSString*)vCode{
    [self hideAllSubView];
    [self.verifyView setHidden:NO];
    self.headerLabel.text=@"Verify";
    [self.verifyView bindData:self.signUpMobileNumber.imgFlag.image CountryCode:self.signUpMobileNumber.lblCountryCode.text MobileNumber:mMobileNumberValue];
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.signUpMobileNumber setHidden:YES];
                         [self.verifyView setHidden:NO];
                     } completion:^(BOOL finished) {
                         [self.verifyView autoFillVeryficationCode:vCode];
                     }];
}



@end
