//
//  UIView+CBConstraints.m
//  ComicBook
//
//  Created by Atul Khatri on 06/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "UIView+CBConstraints.h"
#import <objc/runtime.h>

static void const *key;

@implementation UIView (CBConstraints)

-(void)saveCurrentRect{
    self.savedRect = self.frame;
}

- (void)restoreSavedRect {
    NSLog(@"..............................savedRect: %@",NSStringFromCGRect(self.savedRect));
    self.frame = self.savedRect;
}

- (void)setSavedRect:(CGRect)rect {
    NSValue *rectValue = [NSValue valueWithCGRect:rect];
    objc_setAssociatedObject(self, key, rectValue, OBJC_ASSOCIATION_RETAIN);

}

- (CGRect)savedRect {
    return [objc_getAssociatedObject(self, key) CGRectValue];
}

- (void)saveFrameOfAllSubviews {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIView class]]) {
            [subView saveCurrentRect];
            [subView saveFrameOfAllSubviews];
        }
    }
}

- (void)setSubViewWithWithDimensionAsPerRatio:(CGFloat)ratio treeCount:(NSInteger)treeCount {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIView class]]) {
            subView.frame = CGRectMake(self.savedRect.origin.x * ratio, self.savedRect.origin.y * ratio, self.savedRect.size.width * ratio, self.savedRect.size.height * ratio);
            NSLog(@".....................TREE COUNT: %d , RATIO: %f ,and from: %@", treeCount, ratio, NSStringFromCGRect(subView.frame));
            [subView setSubViewWithWithDimensionAsPerRatio:ratio treeCount:treeCount+1];
        }
    }
}

- (void)restoreFrameOfAllSubviews {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIView class]]) {
            [subView restoreSavedRect];
            [subView restoreFrameOfAllSubviews];
        }
    }
}

/*
 Each item in array must be a UIView that is already a subview of superView
 */
-(void)horizontallyConstrainViewsToCenter:(NSArray*)array
{
    [self constrainAllSubviews:array toSuperviewAttribute:NSLayoutAttributeCenterX];
}

-(void)verticallyConstrainViewsToCenter:(NSArray*)array
{
    [self constrainAllSubviews:array toSuperviewAttribute:NSLayoutAttributeCenterY];
}

-(void)constrainAllSubviews:(NSArray*)subviews toSuperviewAttribute:(NSLayoutAttribute)attribute
{
    for (UIView* subview in subviews) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self attribute:attribute multiplier:1.0 constant:0.0]];
    }
    
}

-(void)constrainViewToSize:(CGSize)size
{
    [self constrainToWidth:size.width];
    [self constrainToHeight:size.height];
}

-(void)constrainColumnVerticalPositioning:(NSArray*)subviews withTopPadding:(CGFloat)topPadding
{
    [self constrainSubviews:subviews withAttribute:NSLayoutAttributeTop oppositeAttribute:NSLayoutAttributeBottom withMargin:topPadding];
}

-(void)constrainToLeftSubviewWithoutVerticallyCentering:(UIView *)leftSubview andRightSubview:(UIView *)rightSubview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftSubview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightSubview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:leftSubview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightSubview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-margin]];
    
}

/*
 Create a two item horizontal view, with the left item vertically centered with the right one
 */
-(void)constrainToLeftSubview:(UIView*)leftSubview andRightSubview:(UIView*)rightSubview withMargin:(CGFloat)margin
{
    [self constrainToLeftSubviewWithoutVerticallyCentering:leftSubview andRightSubview:rightSubview withMargin:margin];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:leftSubview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rightSubview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rightSubview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rightSubview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
}

-(void)constrainSubviewArray:(NSArray*)subviews toTopWithMargin:(CGFloat)topMargin andMaxBottomWithMargin:(CGFloat)bottomMargin
{
    for (UIView* subview in subviews) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:topMargin]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:subview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottomMargin]];
    }
}

-(void)constrainToSizeOfSubview:(UIView *)subview
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
}

-(void)constrainSubviewToLeftAndRightEdges:(UIView *)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin]];
}

-(void)constrainSubviewToTopAndBottomEdges:(UIView *)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin]];
}

-(void)constrainSubviewToAllEdges:(UIView *)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin]];
}

-(void)constrainSubviewToTopEdge:(UIView *)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin]];
}

-(void)constrainSubviewToBottomEdge:(UIView *)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin]];
}

-(void)constrainSubviewToLeftEdge:(UIView *)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin]];
}

-(void)constrainSubviewToRightEdge:(UIView *)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin]];
}

- (void)constrainSubviewToHorizontallyCenter:(UIView*)subview
{
    [self constrainSubviewToHorizontallyCenter:subview withMargin:0.0f];
}

- (void)constrainSubviewToHorizontallyCenter:(UIView*)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:margin]];
}

- (void)constrainSubviewToVerticallyCenter:(UIView*)subview
{
    [self constrainSubviewToVerticallyCenter:subview withMargin:0.0f];
}

- (void)constrainSubviewToVerticallyCenter:(UIView*)subview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:margin]];
}

-(void)constrainSubviews:(NSArray*)subviews withAttribute:(NSLayoutAttribute)firstAttribute oppositeAttribute:(NSLayoutAttribute)secondAttribute withMarginArray:(NSArray*)margins
{
    if (margins.count != subviews.count) {
        return;
    }
    
    UIView* firstSubview = [subviews firstObject];
    if (firstSubview) {
        NSNumber* firstMargin = [margins firstObject];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:firstSubview attribute:firstAttribute relatedBy:NSLayoutRelationEqual toItem:self attribute:firstAttribute multiplier:1.0 constant:firstMargin.floatValue]];
    }
    
    UIView* topView = firstSubview;
    for (int i = 1; i < subviews.count; i++) {
        UIView* subview = [subviews objectAtIndex:i];
        NSNumber* margin = [margins objectAtIndex:i];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:firstAttribute relatedBy:NSLayoutRelationEqual toItem:topView attribute:secondAttribute multiplier:1.0 constant:margin.floatValue]];
        topView = subview;
    }
}



-(void)constrainSubviews:(NSArray*)subviews withAttribute:(NSLayoutAttribute)firstAttribute oppositeAttribute:(NSLayoutAttribute)secondAttribute withMargin:(CGFloat)margin
{
    UIView* firstSubview = [subviews firstObject];
    if (firstSubview) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:firstSubview attribute:firstAttribute relatedBy:NSLayoutRelationEqual toItem:self attribute:firstAttribute multiplier:1.0 constant:margin]];
    }
    UIView* topView = firstSubview;
    for (int i = 1; i < subviews.count; i++) {
        UIView* subview = [subviews objectAtIndex:i];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:firstAttribute relatedBy:NSLayoutRelationEqual toItem:topView attribute:secondAttribute multiplier:1.0 constant:margin]];
        topView = subview;
    }
}

-(void)constrainColumnVerticalPositioning:(NSArray *)subviews withTopPaddingArray:(NSArray*)topPaddings
{
    [self constrainSubviews:subviews withAttribute:NSLayoutAttributeTop oppositeAttribute:NSLayoutAttributeBottom withMarginArray:topPaddings];
}

-(void)constrainRowHorizontalPositioningFromRight:(NSArray*)subviews withRightPadding:(CGFloat)rightPadding
{
    [self constrainSubviews:subviews withAttribute:NSLayoutAttributeRight oppositeAttribute:NSLayoutAttributeLeft withMargin:-rightPadding];
}

-(void)constrainRowHorizontalPositioningFromLeft:(NSArray *)subviews withLeftPadding:(CGFloat)leftPadding
{
    [self constrainSubviews:subviews withAttribute:NSLayoutAttributeLeft oppositeAttribute:NSLayoutAttributeRight withMargin:leftPadding];
}

-(void)constrainSubview:(UIView*)subview toOrigin:(CGPoint)point
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:point.x]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:point.y]];
}

-(void)constrainToWidth:(CGFloat)width
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
}

-(void)constrainToHeight:(CGFloat)height
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
}

-(void)constrainTopSubview:(UIView *)topSubview withBottomSubview:(UIView *)bottomSubview withMargin:(CGFloat)margin
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:topSubview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomSubview attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin]];
}

- (void)removeAllConstraints{
    UIView *superview = self.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == self || c.secondItem == self) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }
    
    [self removeConstraints:self.constraints];
    self.translatesAutoresizingMaskIntoConstraints = YES;
}
@end
