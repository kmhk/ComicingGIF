//
//  MZCroppableView.h
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZCroppableView;

@protocol MZCroppableViewDelegate <NSObject>

@optional

- (void)didFinishedTouch;

@end

@interface MZCroppableView : UIView
{
    UIImageView *animationView;
  
}
@property (nonatomic, strong) UIBezierPath *croppingPath;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) float lineWidth;
@property (nonatomic, strong) UIImageView* camImageView;
@property (nonatomic, assign) id<MZCroppableViewDelegate> delegate;

- (id)initWithImageView:(UIImageView *)imageView;

+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2;
+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2;

- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image;
- (UIImage *)deleteBackgroundOfImageWithBorder:(UIImageView *)image;
- (UIImage *)deleteBackgroundOfImageWithShadow:(UIImageView *)image;
- (UIImage *)deleteBackgroundOfImageWithBorder:(UIImageView *)image withOutBorderImage:(UIImage **)imgWithOutBorder;
@end
