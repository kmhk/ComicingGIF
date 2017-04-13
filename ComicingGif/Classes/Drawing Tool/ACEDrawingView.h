//
//  ACEDrawingView.h
//  ComicBook
//
//  Created by jistin francis on 17/9/15.
//  Copyright 2015 antony ouseph. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ACEDrawingViewVersion   1.0.0

typedef enum {
    ACEDrawingToolTypePen,
    ACEDrawingToolTypeLine,
    ACEDrawingToolTypeRectagleStroke,
    ACEDrawingToolTypeRectagleFill,
    ACEDrawingToolTypeEllipseStroke,
    ACEDrawingToolTypeEllipseFill,
    ACEDrawingToolTypeEraser,
    ACEDrawingToolTypeText,
    ACEDrawingToolTypeMultilineText
} ACEDrawingToolType;

typedef NS_ENUM(NSUInteger, ACEDrawingMode) {
    ACEDrawingModeScale,
    ACEDrawingModeOriginalSize
};

@protocol ACEDrawingViewDelegate, ACEDrawingTool;

@interface ACEDrawingView : UIView<UITextViewDelegate>

@property (nonatomic, assign) ACEDrawingToolType drawTool;
@property (nonatomic, assign) id<ACEDrawingViewDelegate> delegate;

// public properties
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) ACEDrawingMode drawMode;

// get the current drawing
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, readonly) NSUInteger undoSteps;

// load external image
- (void)loadImage:(UIImage *)image;
- (void)loadImageData:(NSData *)imageData;

// erase all
- (void)clear;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;

- (BOOL)canRedo;
- (void)redoLatestStep;

/**
 @discussion Discards the tool stack and renders them to prev_image, making the current state the 'start' state.
 (Can be called before resize to make content more predictable)
 */
- (void)commitAndDiscardToolStack;

@end

#pragma mark - 

@interface ACEDrawingView (Deprecated)
@property (nonatomic, strong) UIImage *prev_image DEPRECATED_MSG_ATTRIBUTE("Use 'backgroundImage' instead.");
@end

#pragma mark -

@protocol ACEDrawingViewDelegate <NSObject>

@optional
- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool;
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;

@end
