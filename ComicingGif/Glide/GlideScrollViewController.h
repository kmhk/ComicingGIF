//
//  GlideScrollViewController.h
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 23/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidesScrollView.h"
#import "ComicMakingViewController.h"
#import "ZoomInteractiveTransition.h"
#import "ZoomTransitionProtocol.h"
#import "Utilities.h"
#import "SlidePreviewScrollView.h"

@interface GlideScrollViewController : UIViewController<SlidesScrollViewDelegate,ZoomTransitionProtocol>

@property (weak, nonatomic) IBOutlet SlidesScrollView *scrvComicSlide;

@property (nonatomic, strong) ZoomInteractiveTransition * transition;
@property (strong, nonatomic) NSMutableArray *comicSlides;
@property (strong, nonatomic) UIView *transitionView;

@property (nonatomic) NSInteger newSlideIndex;
@property (nonatomic) NSInteger editSlideIndex;
@property (assign, nonatomic) BOOL isSendPageReload;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) ComicPage *comicPageComicItems;
@property (nonatomic, strong) ComicMakingViewController *parentViewController;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (strong, nonatomic) UINavigationController *navigation;

@property (nonatomic) ComicType comicType;
@property (nonatomic) ReplyType replyType;
@property (nonatomic) NSString *friendOrGroupId;
@property (nonatomic) NSString *shareId;

//@property (nonatomic, strong) SlidePreviewScrollView *viewPreviewScrollSlide;

//@end


//- (void)comicMakingItemSave:(ComicPage *)comicPage
//              withImageView:(id)comicItemData
//            withPrintScreen:(UIImage *)printScreen
//                 withRemove:(BOOL)remove;
//
////- (void)comicMakingItemRemoveAll:(ComicPage *)comicPage removeAll:(BOOL)isRemoveAll;
//
//- (void)comicMakingViewControllerWithEditingDone:(ComicMakingViewController *)controll
//                                   withImageView:(UIImageView *)imageView
//                                 withPrintScreen:(UIImage *)printScreen
//                                    withNewSlide:(BOOL)newslide
//                                     withPopView:(BOOL)isPopView;

@end
