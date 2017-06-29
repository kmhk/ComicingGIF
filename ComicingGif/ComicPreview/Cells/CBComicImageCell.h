//
//  CBComicImageCell.h
//  ComicBook
//
//  Created by Atul Khatri on 04/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseCollectionViewCell.h"
#import "ComicItem.h"
#import "CBComicItemModel.h"
#import "TimerImageViewStruct.h"

@protocol PlayOneByOneLooper <NSObject>

- (void)slideDidFinishPlayingOnceWithIndex:(NSInteger)index;

@end

@interface CBComicImageCell : CBBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *baseLayerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *staticImageView;
@property (weak, nonatomic) IBOutlet UIView *topLayerView;



@property (strong, nonatomic) CBComicItemModel *comicItemModel;
@property (strong, nonatomic) NSTimer *mainSlideTimer;
@property (assign, nonatomic) CGFloat currentTimeInterval;
@property (assign, nonatomic) CGFloat maxTimeOfFullAnimation;

@property (strong, nonatomic) NSMutableArray<TimerImageViewStruct*> *timerImageViews;

@property (assign, nonatomic) id<PlayOneByOneLooper> playOneByOneDelegate;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) BOOL isSlidePlaying;

- (void)createUIForCell:(CBComicImageCell *)cell withIndex:(NSInteger)index andFrame : (CGRect ) rect;
- (void)setInitialFrameOfCell;
- (void)animateOnce;
- (void)stopAllGifPlays;

@end
