//
//  CBComicImageSection.h
//  ComicBook
//
//  Created by Atul Khatri on 02/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseCollectionViewSection.h"
#import "TimerImageViewStruct.h"

@class CBComicItemModel;
@class CBComicImageCell;

@interface CBComicImageSection : CBBaseCollectionViewSection

@property (strong, nonatomic) CBComicItemModel *comicItemModel;
@property (strong, nonatomic) NSTimer *mainSlideTimer;
@property (assign, nonatomic) CGFloat currentTimeInterval;
@property (assign, nonatomic) CGFloat maxTimeOfFullAnimation;

@property (strong, nonatomic) NSMutableArray<TimerImageViewStruct*> *timerImageViews;

- (void)createUIForCell:(CBComicImageCell *)cell withIndex:(NSInteger)index andFrame : (CGRect ) rect;

@end
