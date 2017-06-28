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

- (void)createUIForCell:(CBComicImageCell *)cell withIndex:(NSInteger)index andFrame : (CGRect ) rect;

@end
