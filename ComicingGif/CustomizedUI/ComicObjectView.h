//
//  ComicObjectView.h
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BubbleObject.h"


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

- (void)playAnimate;

// create comic object view from obj
- (id)initWithComicObject:(BaseObject *)obj;

// create comic slide view with comic objects indicated in array
+ (ComicObjectView *)createComicViewWith:(NSArray *)array delegate:(id)userInfo;

@property (strong, nonatomic) UIView *parentView;

+ (ComicObjectView *)createListViewComicBubbleObjectViewWithObject:(BubbleObject *)bubbleObject;
+ (UIImageView *)createListViewComicPenObjectViewsWithArray:(inout NSArray<ComicObjectView *> *)penObjectViewsArray;

@end
