//
//  CBComicPageViewController.h
//  ComicBook
//
//  Created by Atul Khatri on 08/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBBasePageViewController.h"
#import "CBComicPageCollectionVC.h"
#import "CBComicItemModel.h"

@protocol CBComicPageViewControllerDelegate <NSObject>
- (void)didDeleteComicItem:(CBComicItemModel*)comicItem inPage:(CBComicPageCollectionVC*)pageVC;
- (void)didTapOnComicItemWithIndex:(NSInteger)index;
@end

@interface CBComicPageViewController : CBBasePageViewController
@property (nonatomic, weak) id <CBComicPageViewControllerDelegate> delegate;
- (void)addComicItem:(CBComicItemModel*)comicItem completion:(void (^)(BOOL finished))completion;
@end
