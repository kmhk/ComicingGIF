//
//  UIView+CBConstraints.h
//  ComicBook
//
//  Created by Atul Khatri on 06/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CBConstraints)

@property (assign, nonatomic) CGRect savedRect;

- (void)saveCurrentRect;
- (void)restoreSavedRect;

- (void)saveFrameOfAllSubviewsWithTreeCount:(NSInteger)treeCount;
- (void)setSubViewWithWithDimensionAsPerRatio:(CGFloat)ratio treeCount:(NSInteger)treeCount;
- (void)restoreFrameOfAllSubviews;

-(void)horizontallyConstrainViewsToCenter:(NSArray*)array;
-(void)verticallyConstrainViewsToCenter:(NSArray*)array;
-(void)constrainSubviewArray:(NSArray*)subviews toTopWithMargin:(CGFloat)topMargin andMaxBottomWithMargin:(CGFloat)bottomMargin;

-(void)constrainColumnVerticalPositioning:(NSArray*)subviews withTopPadding:(CGFloat)topPadding;
-(void)constrainViewToSize:(CGSize)size;
-(void)constrainToSizeOfSubview:(UIView *)subview;
-(void)constrainToLeftSubviewWithoutVerticallyCentering:(UIView *)leftSubview andRightSubview:(UIView *)rightSubview withMargin:(CGFloat)margin;
-(void)constrainToLeftSubview:(UIView*)leftSubview andRightSubview:(UIView*)rightSubview withMargin:(CGFloat)margin;

-(void)constrainSubviewToLeftAndRightEdges:(UIView *)subview withMargin:(CGFloat)margin;
-(void)constrainSubviewToTopAndBottomEdges:(UIView *)subview withMargin:(CGFloat)margin;
-(void)constrainSubviewToAllEdges:(UIView *)subview withMargin:(CGFloat)margin;

-(void)constrainSubviewToTopEdge:(UIView *)subview withMargin:(CGFloat)margin;
-(void)constrainSubviewToBottomEdge:(UIView *)subview withMargin:(CGFloat)margin;
-(void)constrainSubviewToRightEdge:(UIView *)subview withMargin:(CGFloat)margin;
-(void)constrainSubviewToLeftEdge:(UIView *)subview withMargin:(CGFloat)margin;

- (void)constrainSubviewToHorizontallyCenter:(UIView*)subview;
- (void)constrainSubviewToHorizontallyCenter:(UIView*)subview withMargin:(CGFloat)margin;
- (void)constrainSubviewToVerticallyCenter:(UIView*)subview;
- (void)constrainSubviewToVerticallyCenter:(UIView*)subview withMargin:(CGFloat)margin;

-(void)constrainRowHorizontalPositioningFromRight:(NSArray*)subviews withRightPadding:(CGFloat)rightPadding;
-(void)constrainRowHorizontalPositioningFromLeft:(NSArray*)subviews withLeftPadding:(CGFloat)leftPadding;

-(void)constrainColumnVerticalPositioning:(NSArray *)subviews withTopPaddingArray:(NSArray*)topPaddings;

-(void)constrainSubview:(UIView*)subview toOrigin:(CGPoint)point;
-(void)constrainToWidth:(CGFloat)width;
-(void)constrainToHeight:(CGFloat)height;

-(void)constrainTopSubview:(UIView *)topSubview withBottomSubview:(UIView *)bottomSubview withMargin:(CGFloat)margin;

- (void)removeAllConstraints;
@end
