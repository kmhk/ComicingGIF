//
//  ComicObjectView.h
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerImageViewStruct.h"

@class BaseObject;
@class ComicObjectView;


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

@end
