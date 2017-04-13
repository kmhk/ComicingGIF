//
//  CBComicPageCollectionVC.h
//  ComicBook
//
//  Created by Atul Khatri on 08/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBBaseCollectionViewController.h"
#import "CBComicItemModel.h"

@class CBComicPageCollectionVC;
@protocol CBComicPageCollectionDelegate <NSObject>
- (void)didDeleteComicItem:(CBComicItemModel*)comicItem inComicPage:(CBComicPageCollectionVC*)comicPage;
- (void)didTapOnComicItemWithIndex:(NSInteger)index;
@end

@interface CBComicPageCollectionVC : CBBaseCollectionViewController
@property (nonatomic, weak) id <CBComicPageCollectionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *comicBookBackgroundTop;
@property (weak, nonatomic) IBOutlet UIImageView *comicBookBackgroundLeft;
@property (weak, nonatomic) IBOutlet UIImageView *comicBookBackgroundRight;
@property (weak, nonatomic) IBOutlet UIImageView *comicBookBackgroundBottom;
@property (weak, nonatomic) IBOutlet UIButton *rainbowColorCircleButton;
- (void)addComicItem:(CBComicItemModel*)comicItem;
- (CGFloat)contentHeight;
- (void)refreshDataArray:(NSMutableArray*)dataArray;
- (UIView*)getZoomTransitionViewForIndexPath:(NSIndexPath *)indexPath;
@end
