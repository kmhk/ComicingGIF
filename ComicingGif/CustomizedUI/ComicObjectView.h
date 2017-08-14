//
//  ComicObjectView.h
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleObject.h"
#import "CaptionObject.h"
#import "TimerImageViewStruct.h"

@class BaseObject;
@class ComicObjectView;


@protocol ComicObjectViewAnimatedStickerStateDelegate <NSObject>
@optional
- (void)comicObjectView:(ComicObjectView *)comicObjectView didFinishRenderingWithDelayTime:(CGFloat)delayTime andBaseObject:(BaseObject *)baseObject;
@end

// MARK: -
@protocol ComicObjectViewDelegate <NSObject>

- (void)saveObject;
- (void)removeObject:(ComicObjectView *)view;

@end

// MARK: -
@interface ComicObjectView : UIView

@property (nonatomic) BaseObject *comicObject;

@property (nonatomic) id<ComicObjectViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray<TimerImageViewStruct *> *timerImageViews;
@property (nonatomic, assign) CGFloat delayTimeInSeconds;

- (void)playAnimate;

// create comic object view from obj
- (id)initWithComicObject:(BaseObject *)obj;

// create comic slide view with comic objects indicated in array
+ (ComicObjectView *)createComicViewWith:(NSArray *)array delegate:(id)userInfo timerImageViews:(NSMutableArray *)timerImageViews;

@property (strong, nonatomic) UIView *parentView;

+ (ComicObjectView *)createListViewComicBubbleObjectViewWithObject:(BubbleObject *)bubbleObject;
+ (ComicObjectView *)createListViewComicCaptionObjectViewWithObject:(CaptionObject *)captionObject;
+ (UIImageView *)createListViewComicPenObjectViewsWithArray:(inout NSArray<ComicObjectView *> *)penObjectViewsArray;

@property (nonatomic) id<ComicObjectViewAnimatedStickerStateDelegate> animatedStickerStateDelegate;

- (void)addImageViewSubview:(UIImageView *)view withTimeDelay:(CGFloat)timeDelay;
+ (ComicObjectView *)createSingleImageViewFromDrawingsArrayofPenViews:(inout NSMutableArray<ComicObjectView *> *)penObjectsViewArray;

@end
