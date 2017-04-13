//
//  ACEDrawingTool.h
//  ComicBook
//
//  Created by jistin francis on 17/9/15.
//  Copyright 2015 antony ouseph. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#define ACE_HAS_ARC 1
#define ACE_RETAIN(exp) (exp)
#define ACE_RELEASE(exp)
#define ACE_AUTORELEASE(exp) (exp)
#else
#define ACE_HAS_ARC 0
#define ACE_RETAIN(exp) [(exp) retain]
#define ACE_RELEASE(exp) [(exp) release]
#define ACE_AUTORELEASE(exp) [(exp) autorelease]
#endif


@protocol ACEDrawingTool <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

- (void)draw;

@end

#pragma mark -

@interface ACEDrawingPenTool : UIBezierPath<ACEDrawingTool> {
    CGMutablePathRef path;
}

- (CGRect)addPathPreviousPreviousPoint:(CGPoint)p2Point withPreviousPoint:(CGPoint)p1Point withCurrentPoint:(CGPoint)cpoint;

@end

#pragma mark -

@interface ACEDrawingEraserTool : ACEDrawingPenTool

@end

#pragma mark -

@interface ACEDrawingLineTool : NSObject<ACEDrawingTool>

@end

#pragma mark -

@interface ACEDrawingTextTool : NSObject<ACEDrawingTool>
@property (strong, nonatomic) NSAttributedString* attributedText;
@end

@interface ACEDrawingMultilineTextTool : ACEDrawingTextTool
@end

#pragma mark -

@interface ACEDrawingRectangleTool : NSObject<ACEDrawingTool>

@property (nonatomic, assign) BOOL fill;

@end

#pragma mark -

@interface ACEDrawingEllipseTool : NSObject<ACEDrawingTool>

@property (nonatomic, assign) BOOL fill;

@end
