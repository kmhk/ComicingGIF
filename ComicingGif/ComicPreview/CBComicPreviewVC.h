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

@interface CBComicPreviewVC : CBBaseTableViewController


@property (nonatomic) ComicType comicType;
@property (nonatomic) ReplyType replyType;
@property (nonatomic) NSString *friendOrGroupId;
@property (nonatomic) NSString *shareId;
@property (strong, nonatomic) NSMutableArray *comicSlides;
@property (nonatomic,strong) ComicPage *comicPageComicItems;
@property (nonatomic) NSInteger editSlideIndex;

- (void)prepareView;

@end
