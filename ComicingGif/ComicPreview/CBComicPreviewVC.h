//
//  CBComicLandingVC.h
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBBaseTableViewController.h"
#import "ComicMakingViewController.h"
#import "ZoomInteractiveTransition.h"
#import "ZoomTransitionProtocol.h"
#import "Utilities.h"
#import "SlidePreviewScrollView.h"
#import "InstructionView.h"
#import "ComicPage.h"

@class CBComicPageCollectionVC;
@interface CBComicPreviewVC : CBBaseTableViewController


@property (nonatomic) ComicType comicType;
@property (nonatomic) ReplyType replyType;
@property (nonatomic) NSString *friendOrGroupId;
@property (nonatomic) NSString *shareId;
@property (strong, nonatomic) NSMutableArray *comicSlides;
@property (nonatomic,strong) ComicPage *comicPageComicItems;
@property (nonatomic) NSInteger editSlideIndex;

@property (nonatomic, assign) BOOL shouldFetchAndReload;
@property (nonatomic, assign) BOOL shouldntRefreshAfterDidLayoutSubviews;
@property (nonatomic, assign) NSInteger indexForSlideToRefresh;
@property (strong, nonatomic) UIView *transitionView;
@property (nonatomic, strong) CBComicPageCollectionVC* comicPageCollectionVC;

- (void)prepareView;
- (void)refreshSlideAtIndex:(NSInteger)indexOfSlide isTall:(BOOL)isTall completionBlock:(void (^)(BOOL isComplete))completionBlock;
- (void)deleteLastCell;

@end
