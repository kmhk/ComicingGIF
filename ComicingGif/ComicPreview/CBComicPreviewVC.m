//
//  CBComicLandingVC.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBComicPreviewVC.h"
#import "CBComicPreviewSection.h"
#import "CBPreviewHeaderSection.h"
#import "CBComicPreviewCell.h"
#import "CBPreviewHeaderCell.h"
//#import "CBComicPageViewController.h"
#import "UIView+CBConstraints.h"
#import "ZoomInteractiveTransition.h"
#import "ZoomTransitionProtocol.h"
#import "AppDelegate.h"
#import "CBComicTitleFontDropdownViewController.h"
#import "ComicBookColorCBViewController.h"
#import "ShareHelper.h"
#import "UIImage+Image.h"
#import "AppHelper.h"
#import "ComicTagViewController.h"
#import "ComicMakingAPIManager.h"
#import "CameraViewController.h"
#import "ComicMakingViewController.h"
#import "ComicObjectSerialize.h"
#import "ComicPreviewModel.h"
#import <Photos/Photos.h>
#import "CBComicPageCollectionVC.h"
#import "CBComicImageCell.h"

#define kPreviewViewTag 12001

@interface CBComicPreviewVC () <ZoomTransitionProtocol, UIGestureRecognizerDelegate, TitleFontDelegate, ComicBookColorCBViewControllerDelegate, CBPreviewHeaderDelegate,
CBComicPageCollectionDelegate,PlayOneByOneLooper
//,CBComicPageViewControllerDelegate
> {
    UILabel *headerTitleTextView;
    NSString *comicTitle;
    NSString *titleFontName;
    UIColor *comicBackgroundColor;
    
    ComicPreviewModel *viewModel;
    
    BOOL createComicCollectionOnce;
}
//@property (nonatomic, strong) CBComicPageViewController* previewVC;
@property (nonatomic, strong) CBComicPageCollectionVC* comicPageCollectionVC;
@property (nonatomic, strong) ZoomInteractiveTransition * transition;
@property (strong, nonatomic) NSString *fileNameToSave;
@property (strong, nonatomic) NSMutableArray *dirtySubviews;
@property (strong, nonatomic) NSMutableArray *dirtysubviewData;
@property (assign, nonatomic) NSInteger selectedIndexForAddOrEdit;
@property (nonatomic) int selectedIndex;
@end

@implementation CBComicPreviewVC

- (void) loadDataFromComicingScreen {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transition = [[ZoomInteractiveTransition alloc] initWithNavigationController:self.navigationController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataFromComicingScreen) name:@"xxxDataFromComicing" object:nil];
    self.transition.handleEdgePanBackGesture = NO;
    self.transition.transitionDuration = 0.4;
    
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor= [UIColor blackColor];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.dataArray= [NSMutableArray new];
    
    
    //Added By ramesh-> for handle slide type
    if(self.comicType == ReplyComic && self.replyType == FriendReply) {
        self.fileNameToSave = [NSString stringWithFormat:@"ComicSlide_F%@", self.friendOrGroupId];
    } else if(self.comicType == ReplyComic && self.replyType == GroupReply) {
        self.fileNameToSave = [NSString stringWithFormat:@"ComicSlide_G%@", self.friendOrGroupId];
    } else {
        self.fileNameToSave = @"ComicSlide";
    }
    
    
    
    //    [self.tableView reloadData];
    
    self.navigationController.navigationBar.hidden = YES;
    
    viewModel = [[ComicPreviewModel alloc] init];
    viewModel.parentVC = self;
}

- (void)initialiseComicPageCollectionVC {
    self.comicPageCollectionVC= [[CBComicPageCollectionVC alloc] initWithNibName:@"CBComicPageCollectionVC" bundle:nil];
    self.comicPageCollectionVC.view.tag= kPreviewViewTag;
    [self.comicPageCollectionVC.view layoutIfNeeded];
    self.comicPageCollectionVC.delegate= self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!createComicCollectionOnce) {
        createComicCollectionOnce = !createComicCollectionOnce;
        [self initialiseComicPageCollectionVC];
    }
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    if (!_shouldntRefreshAfterDidLayoutSubviews) {
        _shouldntRefreshAfterDidLayoutSubviews = YES;
        [self setupSections];
        [self.tableView reloadData];
        
        [self prepareView];
        
        if (self.dataArray == nil || self.dataArray.count == 0) {
            [self pushAddSlideTap:NO ofIndex:-1];
        }
        
        //            [self addEmptySlide:NO completionBlock:^(BOOL a) {
        //
        //            }];
        //            [self addEmptySlide:YES completionBlock:^(BOOL a) {
        //
        //            }];
        //            [self addEmptySlide:YES completionBlock:^(BOOL a) {
        //
        //            }];
        //            [self addEmptySlide:YES completionBlock:^(BOOL a) {
        //
        //            }];
        //            self.comicPageCollectionVC.collectionView.backgroundView.backgroundColor = [UIColor redColor];
        //End
    }
    //    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // c0mrade: avoid unsued recursion while list is empty and avoid crash.
    if (self.dataArray.count > 0) {
        [self startPlayingOneByOne];
    }
    
}

- (void)refreshSlideAtIndex:(NSInteger)indexOfSlide isTall:(BOOL)isTall completionBlock:(void (^)(BOOL))completionBlock {
    if (indexOfSlide+1 > self.dataArray.count) {
        return;
    }
    if (indexOfSlide == -1 && self.dataArray.count == 0) {
        [self addEmptySlide:isTall completionBlock:^(BOOL isCompleted) {
            completionBlock(YES);
        }];
        return;
    }
    if (indexOfSlide == -1) {
        indexOfSlide = self.dataArray.count - 1;
    }
    _indexForSlideToRefresh = indexOfSlide;
    _comicSlides = [[ComicObjectSerialize loadComicSlide] mutableCopy];
    
    ComicPage *comicPage = [[ComicPage alloc]init];
    [comicPage initWithgif:[[[self.comicSlides objectAtIndex:indexOfSlide] objectAtIndex:0]objectForKey:@"url"] andSubViewArray:[self.comicSlides objectAtIndex:indexOfSlide]];
    
    CBComicItemModel* model= [[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] comicPage:comicPage];
    
    [self.dataArray replaceObjectAtIndex:indexOfSlide withObject:model];
    //    NSLog(@"\n.............ADD FETCHED CELL............ %@ %@ %@", model, model.comicPage, model.comicPage.subviews);
    //    NSLog(@"\n............... DATA ARRAY: %@",self.dataArray);
    
    [self.comicPageCollectionVC replaceComicItemAtIndex:indexOfSlide withComicItem:model completion:^(BOOL finished, CBComicItemModel *comicItem) {
        if(finished){
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 1)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareView];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                completionBlock(YES);
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_shouldFetchAndReload) {
        [self prepareView];
    }
    _shouldFetchAndReload = NO;
    
    if ([Global global].haveAccessToOpenCameraScreen == true) {
        [self openVerticalCamera:false];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSInteger numberOfSlides = [self.comicPageCollectionVC.collectionView numberOfItemsInSection:0];
    for (int i = 0; i< numberOfSlides; i++) {
        CBComicImageCell *slideCell = (CBComicImageCell *)[self.comicPageCollectionVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [slideCell stopAllGifPlays];
    }
}

- (void)prepareView 
{
    //    self.comicSlides = [self getDataFromFile];
    
    _comicSlides = [[ComicObjectSerialize loadComicSlide] mutableCopy];
    
    [self.dataArray removeAllObjects];
    [self.comicPageCollectionVC.dataArray removeAllObjects];
    //    [((CBComicPageCollectionVC *)[self.previewVC.viewControllers lastObject]).dataArray removeAllObjects];
    
    for (int i=0; i<self.comicSlides.count; i++) {
        ComicPage *comicPage = [[ComicPage alloc]init];
        
        [comicPage initWithgif:[[[self.comicSlides objectAtIndex:i] objectAtIndex:0]objectForKey:@"url"] andSubViewArray:[self.comicSlides objectAtIndex:i]];
        CBComicItemModel* model= [[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] comicPage:comicPage];
        [self.dataArray addObject:model];
        NSLog(@"\n.............ADD FETCHED CELL............ %@ %@ %@", model, model.comicPage, model.comicPage.subviews);
        NSLog(@"\n............... DATA ARRAY: %@",self.dataArray);
        
        __weak CBComicPreviewVC *weakSelf = self;
        [self.comicPageCollectionVC addComicItem:model completion:^(BOOL finished, CBComicItemModel *itemModel) {
            weakSelf.transitionView = [weakSelf.comicPageCollectionVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.indexForSlideToRefresh inSection:0]].contentView;
            if(finished){
                if ([itemModel isEqual:[weakSelf.dataArray lastObject]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n");
                        //                        [self.comicPageCollectionVC.collectionView reloadData];
                        //                        [self.tableView reloadData];
                        
                        //                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 1)];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        });
                    });
                }
            }
        }];
        
        //        [self.previewVC addComicItem:model completion:^(BOOL finished) {
        //            if(finished){
        //                if ([model isEqual:[self.dataArray lastObject]]) {
        //                    dispatch_async(dispatch_get_main_queue(), ^{
        //
        //                        [self.previewVC.collectionView reloadData];
        ////                        [self.tableView reloadData];
        //                    });
        //                }
        //            }
        //        }];
        
    }
    
    //    for (NSData *data in self.comicSlides)
    //    {
    //        ComicPage *comicPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //
    //    }
}

- (void)printComicPageObjects {
    for (CBComicItemModel *model in self.dataArray) {
        NSLog(@"%@", model.comicPage);
    }
}

- (void)addComicPage:(ComicPage *)comicPage withIndex:(NSInteger)index {
    CBComicItemModel* model= [[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] comicPage:comicPage];
    
    // -1 indicates new cell will be added
    if (index == -1) {
        [self.dataArray addObject:model];
        __block CBComicPreviewVC* weekSelf= self;
        _selectedIndexForAddOrEdit = self.dataArray.count - 1;//Index of the empty cell added
        
        NSLog(@"\n.............ADD EMPTY CELL............ %@ %@ %@", model, model.comicPage, model.comicPage.subviews);
        NSLog(@"\n............... DATA ARRAY: %@",self.dataArray);
        
        //        [self.previewVC addComicItem:model completion:^(BOOL finished) {
        //            if(finished){
        //                [weekSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        //                //            [weekSelf.tableView reloadData];
        //            }
        //        }];
        
    } else {
        NSLog(@"\n.............REPLACE CELL............ %@ %@ %@", model, model.comicPage, model.comicPage.subviews);
        NSLog(@"\n............... DATA ARRAY: %@",self.dataArray);
        [((CBComicItemModel *)self.dataArray[index]) replaceWithNewModel:model];
        //        self.previewVC.dataArray = self.dataArray;
        
//                [((CBComicPageCollectionVC *)[[self.previewVC viewControllers] firstObject]) refreshDataArray:self.dataArray];
        
        [self.tableView reloadData];
    }
}

#pragma mark - Play one by one

- (void)setInitialFrameForAllSlides {
    NSInteger numberOfSlides = [self.comicPageCollectionVC.collectionView numberOfItemsInSection:0];
    for (int i = 0; i< numberOfSlides; i++) {
        CBComicImageCell *slideCell = (CBComicImageCell *)[self.comicPageCollectionVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        slideCell.playOneByOneDelegate = self;
        [slideCell setInitialFrameOfCell];
    }
}

- (void)startPlayingOneByOne {
    // Ahmed: this method should be left unchanged, because otherwise the animation on ListView screen doesn't work
    [self setInitialFrameForAllSlides];
    [self slideDidFinishPlayingOnceWithIndex:0];
}

- (void)slideDidFinishPlayingOnceWithIndex:(NSInteger)index {
    NSInteger numberOfSlides = [self.comicPageCollectionVC.collectionView numberOfItemsInSection:0];
    if (index >= numberOfSlides) {
        //There are no more slides left
        //Restart play one by one
        [self slideDidFinishPlayingOnceWithIndex:0];
        return;
    }
    CBComicImageCell *slideCell = (CBComicImageCell *)[self.comicPageCollectionVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [slideCell animateOnce];
}

#pragma mark - ZoomTransitionProtocol

- (UIView *)viewForZoomTransition:(BOOL)isSource
{
    _transitionView.hidden = NO;
    NSLog(@"zzzzzzzzzzzzzzzzzz.............................. %@",self.transitionView);
    return self.transitionView;
}

- (void)setupSections{
    self.sectionArray= [NSMutableArray new];
    CBPreviewHeaderSection* headerSection= [CBPreviewHeaderSection new];
    [self.sectionArray addObject:headerSection];
    CBComicPreviewSection* previewSection= [CBComicPreviewSection new];
    [self.sectionArray addObject:previewSection];
}

- (CGFloat)maxPageHeight{
    CGFloat maxHeight= 0.0f;
    //    for(CBBaseViewController* vc in self.previewVC.viewControllers){
    ////        if(vc.collectionView.collectionViewLayout.collectionViewContentSize.height > maxHeight){
    //
    //            maxHeight= vc.collectionView.collectionViewLayout.collectionViewContentSize.height;
    ////        }
    //    }
    NSLog(@"CollectionView max height: %@",self.collectionView);
    maxHeight = self.comicPageCollectionVC.collectionView.collectionViewLayout.collectionViewContentSize.height;
    return ceilf(maxHeight);
}

#pragma mark- UITableViewDataSource handler methods
- (UITableViewCell*)ta_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell= [super ta_tableView:tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[CBPreviewHeaderCell class]]){
        CBPreviewHeaderCell* headerCell= (CBPreviewHeaderCell*)cell;
        [headerCell.horizontalAddButton addTarget:self action:@selector(didTapHorizontalButton) forControlEvents:UIControlEventTouchUpInside];
        [headerCell.verticalAddButton addTarget:self action:@selector(didTapVerticalButton) forControlEvents:UIControlEventTouchUpInside];
        headerCell.titleTextView.text = comicTitle;
        
        [headerCell setFontWithName:titleFontName];
        headerCell.delegate = self;
        [headerCell initialSetup];
    }else if([cell isKindOfClass:[CBComicPreviewCell class]]){
        // Add pageViewController view as a subview
        if(![cell.contentView viewWithTag:kPreviewViewTag]){
            [cell.contentView addSubview:self.comicPageCollectionVC.view];
            [self.comicPageCollectionVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
            [cell.contentView constrainSubviewToAllEdges:self.comicPageCollectionVC.view withMargin:0.0f];
            [cell.contentView layoutIfNeeded];
            
            [_comicPageCollectionVC.rainbowColorCircleButton addTarget:self action:@selector(rainbowCircleTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}
- (void)ta_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)ta_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height= [super ta_tableView:tableView heightForRowAtIndexPath:indexPath];
    UITableViewCell* cell= [super ta_tableView:tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[CBComicPreviewCell class]]){
        if (self.comicPageCollectionVC.dataArray.count == 0) {
            height = 0;
        } else {
            height= [self maxPageHeight] + 45;
            //45 is the sum of top and bottom constraint of collectionview in comic page
        }
    }
    if ([cell isKindOfClass:[CBPreviewHeaderCell class]]) {
        height = 80;
        //Same calculation in ComicTitleFontDropDownViewController
        //        height = IS_IPHONE_5?114: (IS_IPHONE_6?124: (IS_IPHONE_6P?134: 144));
    }
    return height;
}

#pragma mark- 
- (void) openCameraWithHorizontalView {
    if (self.dataArray.count == 4) {
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraViewController *vcCameraViewController = [storyboard instantiateViewControllerWithIdentifier:CAMERA_VIEW];
    vcCameraViewController.indexOfSlide = -1;
    vcCameraViewController.isVerticalCamera = YES;
    [self.navigationController pushViewController:vcCameraViewController animated:YES];
    
    [self addEmptySlide:NO completionBlock:^(BOOL isCompleted) {}];
}


- (void)didTapHorizontalButton{
    [self openCameraWithHorizontalView];
    
    //    if (self.dataArray.count == 8) {
    //        return;
    //    }
    //    ComicPage *comicPage = [ComicPage new];
    //    comicPage.slideType = slideTypeWide;
    //    [self addComicPage:comicPage withIndex:-1];
    //
    //    [self pushAddSlideTap:YES  ofIndex:-1];
    // Show Comic Making for Horizontal image
    //    NSString *animationPath = [[NSBundle mainBundle] pathForResource:@"OOPPS" ofType:@"gif"];
    //    CBComicItemModel* model= [[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] baseLayer:Gif staticImage:[UIImage imageNamed:@"WOW"] animatedImage:[YYImage imageWithContentsOfFile:animationPath] orientation:COMIC_ITEM_ORIENTATION_LANDSCAPE];
    //    [self.dataArray addObject:model];
    //    __block CBComicPreviewVC* weekSelf= self;
    //    [self.previewVC addComicItem:model completion:^(BOOL finished) {
    //        if(finished){
    //            [weekSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    //        }
    //    }];
}

- (void)addEmptySlide:(BOOL)isTall completionBlock:(void (^)(BOOL))completionBlock{
    if (!self.comicPageCollectionVC) {
        [self initialiseComicPageCollectionVC];
    }
    ComicPage *comicPage = [[ComicPage alloc]init];
    NSMutableArray *subviews = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isTall], @"isTall", nil];
    [subviews addObject:dict];
    
    [comicPage initWithgif:@"" andSubViewArray:subviews];
    CBComicItemModel* model= [[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] comicPage:comicPage];
    [self.dataArray addObject:model];
    NSLog(@"\n.............ADD FETCHED CELL............ %@ %@ %@", model, model.comicPage, model.comicPage.subviews);
    NSLog(@"\n............... DATA ARRAY: %@",self.dataArray);
    
    __weak CBComicPreviewVC *weakSelf = self;
    [self.comicPageCollectionVC addComicItem:model completion:^(BOOL finished, CBComicItemModel *itemModel) {
        if(finished){
            weakSelf.transitionView = [weakSelf.comicPageCollectionVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.dataArray.count - 1 inSection:0]].contentView;
            completionBlock(YES);
            //                if ([itemModel isEqual:[self.dataArray lastObject]]) {
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //
            //                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 1)];
            //                        dispatch_async(dispatch_get_main_queue(), ^{
            //                            //                            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            //                        });
            //                    });
            //                }
        }
    }];
}

- (void)deleteLastCell {
    if (self.dataArray.count == 0) {
        return;
    }
    [self.dataArray removeObjectAtIndex:self.dataArray.count - 1];
    [self.comicPageCollectionVC removeComicItemAtIndex:self.dataArray.count];
}

- (void) openVerticalCamera :(BOOL) withSlide {
    if (self.dataArray.count == 4) {
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraViewController *vcCameraViewController = [storyboard instantiateViewControllerWithIdentifier:CAMERA_VIEW];
    vcCameraViewController.indexOfSlide = -1;
    
//    if (indexOfSlide == -1 && self.dataArray.count == 0) {
//        [self addEmptySlide:isTall completionBlock:^(BOOL isCompleted) {
//            completionBlock(YES);
//        }];
//    }
    
    vcCameraViewController.isVerticalCamera = NO;
    [self.navigationController pushViewController:vcCameraViewController animated:false];
//    if ([Global global].haveAccessToOpenCameraScreen == true && self.dataArray.count == 0) {
//        [self deleteLastCell];
//        [self refreshSlideAtIndex:0 isTall:false completionBlock:nil];
//    } else {
//        [self addEmptySlide:withSlide completionBlock:nil];
//    }
}

- (void)didTapVerticalButton{
    [self openVerticalCamera:true];
    
    
    
    //    if (self.dataArray.count == 8) {
    //        return;
    //    }
    //    ComicPage *comicPage = [ComicPage new];
    //    comicPage.slideType = slideTypeTall;
    //    [self addComicPage:comicPage withIndex:-1];
    //
    //    [self pushAddSlideTap:NO ofIndex:-1];
    // Show Comic Making for Vertical image
    //    NSString *animationPath = [[NSBundle mainBundle] pathForResource:@"OMG" ofType:@"gif"];
    //    CBComicItemModel* model= [[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] baseLayer:StaticImage staticImage:[UIImage imageNamed:@"StickerSelectionBg"] animatedImage:[YYImage imageWithContentsOfFile:animationPath] orientation:COMIC_ITEM_ORIENTATION_PORTRAIT];
    //    [self.dataArray addObject:model];
    //    __block CBComicPreviewVC* weekSelf= self;
    //    [self.previewVC addComicItem:model completion:^(BOOL finished) {
    //        if(finished){
    //            [weekSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    //        }
    //    }];
}

- (void)rainbowCircleTapped:(UIButton *)rainbowButton {
    CGRect frameOfRainbowCircle = [rainbowButton convertRect:rainbowButton.frame toView:self.view];
    frameOfRainbowCircle.origin.y+=10;
    UIStoryboard *mainPageStoryBoard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil];
    ComicBookColorCBViewController *comicBookColorCBViewController = [mainPageStoryBoard instantiateViewControllerWithIdentifier:@"ComicBookColorCBViewController"];
    comicBookColorCBViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    comicBookColorCBViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    comicBookColorCBViewController.delegate = self;
    comicBookColorCBViewController.frameOfRainbowCircle = frameOfRainbowCircle;
    [self presentViewController:comicBookColorCBViewController animated:NO completion:nil];
}

- (NSNumber*)currentTimestmap{
    return @([[NSDate date] timeIntervalSince1970]);
}
- (void)openFontDropDown:(UIView *)gestureView {
    
    UITextView *gestureTextView = (UITextView *)gestureView;
    if (gestureTextView.text.length == 0) {
        return;
    }
    
    UIStoryboard *mainPageStoryBoard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil];
    CBComicTitleFontDropdownViewController *cbComicTitleFontDropdownViewController = [mainPageStoryBoard instantiateViewControllerWithIdentifier:@"CBComicTitleFontDropdownViewController"];
    cbComicTitleFontDropdownViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    cbComicTitleFontDropdownViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cbComicTitleFontDropdownViewController.delegate = self;
    cbComicTitleFontDropdownViewController.titleText = gestureTextView.text;
    [self presentViewController:cbComicTitleFontDropdownViewController animated:NO completion:nil];
}

#pragma mark - TitleFontDelegate methods

- (void)getSelectedFontName:(NSString *)fontName andTitle:(NSString *)title {
    titleFontName = fontName;
    [self.tableView reloadData];
}

#pragma mark- CBComicPageViewControllerDelegate method
- (void)didDeleteComicItem:(CBComicItemModel *)comicItem inPage:(CBComicPageCollectionVC *)pageVC{
    [self.dataArray removeObject:comicItem];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    //    [self.tableView reloadData];
    //    if (self.previewVC.dataArray.count == 0 && [self.previewVC viewControllers].count == 1) {
    //        self.previewVC.view.hidden = YES;
    //    }
}

- (void)didTapOnComicItemWithIndex:(NSInteger)index {
//    CBComicItemModel *itemModel = ((CBComicItemModel *)[self.dataArray objectAtIndex:index]);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kComicMakingStoryboard bundle:nil];
    
    ComicMakingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:ComicMakingViewControllerIdentifier];
    
    NSMutableArray *arrTemp = [NSMutableArray new];
    arrTemp = [[self.comicSlides objectAtIndex:index] mutableCopy];
    [arrTemp removeObjectAtIndex:0];
    
    
    NSString *baseURLString = [[[self.comicSlides objectAtIndex:index] objectAtIndex:0]objectForKey:@"url"];
    CGRect slideRect = CGRectFromString([[[[self.comicSlides objectAtIndex:index] objectAtIndex:0] valueForKey:@"baseInfo"] valueForKey:@"frame"]);
    
    
    vc.indexSaved = index;
    vc.urlOfSlide = [NSURL URLWithString:baseURLString];
    [vc initWithBaseImage:[NSURL URLWithString:baseURLString] frame:slideRect andSubviewArray:arrTemp isTall:[[[[self.comicSlides objectAtIndex:index] firstObject] valueForKey:@"isTall"] boolValue] index:index];
    
    self.selectedIndex = (int) index;
    self.transitionView = [_comicPageCollectionVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]].contentView;
    
    [self.navigationController pushViewController:vc animated:YES];
    //    [self pushAddSlideTap:!(itemModel.itemOrientation==COMIC_ITEM_ORIENTATION_PORTRAIT) ofIndex:index];
}

#pragma mark - ComicBookColorCBViewControllerDelegate method


- (void)getSelectedColor:(UIColor *)color andComicBackgroundImageName:(NSString *)backgroundImageName {
    comicBackgroundColor = color;
    if (self.comicPageCollectionVC.dataArray != 0) {
        [_comicPageCollectionVC.collectionView setBackgroundColor:color];
        
        //        CBComicPageCollectionVC *comicPage = ((CBComicPageCollectionVC *)[[self.previewVC viewControllers] lastObject]);
        _comicPageCollectionVC.comicBookBackgroundTop.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Top",backgroundImageName]];
        _comicPageCollectionVC.comicBookBackgroundLeft.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Left",backgroundImageName]];
        _comicPageCollectionVC.comicBookBackgroundRight.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Right",backgroundImageName]];
        _comicPageCollectionVC.comicBookBackgroundBottom.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Bottom",backgroundImageName]];
    }
    //    [self.tableView reloadData];
    [self.comicPageCollectionVC.collectionView reloadData];
}

#pragma mark - CBPreviewHeaderDelegate methods

- (void)tapGesture:(UIView *)view {
    
}

- (void)holdGesture:(UIView *)view {
    [self openFontDropDown:view];
}

- (void)textUpdated:(NSString *)text {
    comicTitle = text;
}

#pragma mark - Button actions

- (IBAction)openMainScreen {
    [AppHelper openMainPageviewController:self];
}

- (IBAction)arrowButtonTapped:(id)sender {
    [self sendComic];
}

- (IBAction)tagButtonTapped:(id)sender {
    //    UIStoryboard *mainPageStoryBoard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil];
    //    ComicTagViewController *comicTagViewController = [mainPageStoryBoard instantiateViewControllerWithIdentifier:@"ComicTagViewController"];
    //    comicTagViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    comicTagViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //    [self presentViewController:comicTagViewController animated:YES completion:nil];
    [viewModel generateVideos:^(NSURL *url) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            
            NSLog(@"%@", changeRequest.description);
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"saved down");
            } else {
                NSLog(@"something wrong %@", error.localizedDescription);
            }
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"Saved to library successfully" preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:controller animated:YES completion:nil];
        }];
    }];
}

- (IBAction)twitterButtonTapped:(UIButton *)sender {
    [viewModel generateVideos:^(NSURL *url) {
        [self doShareTo:TWITTER ShareImage:[UIImage imageNamed:@"comicBookBackground"] url:url];
    }];
}

- (IBAction)facebookButtonTapped:(UIButton *)sender {
    [viewModel generateVideos:^(NSURL *url) {
        [self doShareTo:FACEBOOK ShareImage:[UIImage imageNamed:@"comicBookBackground"] url:url];
    }];
    //    [self doShareTo:FACEBOOK ShareImage:[UIImage imageNamed:@"comicBookBackground"]];
}

- (IBAction)instagramButtonTapped:(UIButton *)sender {
    [viewModel generateVideos:^(NSURL *url) {
        [self doShareTo:INSTAGRAM ShareImage:[UIImage imageNamed:@"comicBookBackground"] url:url];
    }];
    //    [self doShareTo:INSTAGRAM ShareImage:[UIImage imageNamed:@"comicBookBackground"]];
}

-(void)doShareTo :(ShapeType)type ShareImage:(UIImage*)imgShareto url:(NSURL *)url {
    
    //    UIImage* imgProcessShareImage = [self createImageWithLogo:imgShareto];
    
    imgShareto = [self createImageWithLogo:imgShareto];
    
    //    NSData *imageData = UIImagePNGRepresentation(imgShareto);
    //    UIImage *image =[UIImage imageWithData:imageData];
    
    //    UIImage* img = [self getnewImage:image];
    //Just to test
    
    //    UIBezierPath *path = [UIBezierPath bezierPath];
    //        UIGraphicsBeginImageContextWithOptions([image size], YES, [image scale]);
    //
    //        [image drawAtPoint:CGPointZero];
    //
    //        CGContextRef ctx = UIGraphicsGetCurrentContext();
    //        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    //        [path fill];
    //
    //
    //        UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    
    //        UIImageWriteToSavedPhotosAlbum(imgShareto, nil, nil, nil);
    //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    //        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
    //        [imageData writeToFile:filePath atomically:YES]; //Write the file
    //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    //        NSLog(@"File Path :%@",filePath);
    
    /* Commented for testing*/
    ShareHelper* sHelper = [ShareHelper shareHelperInit];
    sHelper.parentviewcontroller = self;
    [sHelper shareAction:type
               ShareText:@""
              ShareImage:imgShareto
                ShareUrl:url.absoluteString
              completion:^(BOOL status) {
                  
              }];
}

-(UIImage*)createImageWithLogo:(UIImage*)imgActualImage{
    
    //lets fix the share sticker size
    //w = 110;
    //h = 155;
    
    //Selected image adding to imageview
    UIImageView *imageViewSticker = [[UIImageView alloc] initWithImage:imgActualImage];
    imageViewSticker.frame = CGRectMake(50, 50, 110, 155);
    [imageViewSticker setContentMode:UIViewContentModeScaleAspectFit];
    
    //get logo
    UIImage* imgStickerLogo = [UIImage imageNamed:@"ShareStickerLogo"];
    
    
    //lets fix the share footer logo size
    //w = 133;
    //h = 28;
    
    //Selected image adding to imageview
    UIImageView *imageViewStLogo = [[UIImageView alloc] initWithImage:imgStickerLogo];
    imageViewStLogo.frame = CGRectMake(38, 225, 133, 28);
    [imageViewStLogo setContentMode:UIViewContentModeScaleAspectFit];
    
    //Calculating Framesize
    UIView* viewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 293)];
    [viewHolder setClipsToBounds:YES];
    
    [viewHolder setBackgroundColor:[UIColor clearColor]];
    [viewHolder addSubview:imageViewSticker];
    [viewHolder addSubview:imageViewStLogo];
    
    //Generating image
    UIImage* imgShareTo = [UIImage imageWithView:viewHolder paque:NO];
    
    viewHolder = nil;
    imageViewSticker = nil;
    
    //---------------------
    //uncomment to check the file type and quality
    /*NSData *pngData = UIImagePNGRepresentation(imgShareTo);
     
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
     NSString *filePath = [documentsPath stringByAppendingPathComponent:@"wa_image.png"]; //Add the file name
     [pngData writeToFile:filePath atomically:YES]; //Write the file*/
    //---------------------
    
    
    return imgShareTo;
}

- (NSString *)freeFromNewLine:(NSString *)text {
    return [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle // Ramesh Methods

- (void)pushAddSlideTap:(BOOL)isWideSlide ofIndex:(NSInteger)index
{
    //    CBComicPageCollectionVC *comicPage = ((CBComicPageCollectionVC *)[[self.previewVC viewControllers] lastObject]);
    
    NSIndexPath *indexPath;
    BOOL _isNewSlide = YES;
    if (index == -1) {
        indexPath = [NSIndexPath indexPathForItem:self.dataArray.count inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        _isNewSlide = NO;
    }
    _transitionView = [_comicPageCollectionVC getZoomTransitionViewForIndexPath:indexPath];
    
    //    ComicMakingViewController *cmv = [self.storyboard instantiateViewControllerWithIdentifier:@"ComicMakingViewController"];
    //
    //    if (isWideSlide == YES)
    //    {
    //        cmv.isWideSlide = YES;
    //    }
    //    else
    //    {
    //        cmv.isWideSlide = NO;
    //    }
    //
    //    cmv.isNewSlide = _isNewSlide;
    //    cmv.delegate = self;
    //    cmv.comicType = self.comicType;
    //    cmv.replyType = self.replyType;
    //    cmv.friendOrGroupId = self.friendOrGroupId;
    //    cmv.shareId = self.shareId;
    //    if (!_isNewSlide) {
    //        cmv.comicPage =  [NSKeyedUnarchiver unarchiveObjectWithData:[self.comicSlides objectAtIndex:index]];
    //    }
    //    [self.navigationController pushViewController:cmv animated:NO];
}

-(NSMutableArray*)getDataFromFile{
    return [AppHelper getDataFromFile:self.fileNameToSave];
}

#pragma mark - ComicMakingViewControllerDelegate

- (void)comicMakingItemRemoveAll:(ComicPage *)comicPage removeAll:(BOOL)isRemoveAll{
    
    if (self.comicPageComicItems != nil) {
        //Remove subviews
        [self.comicPageComicItems.subviews removeAllObjects];
        [self.comicPageComicItems.subviewData removeAllObjects];
    }
    
}
- (void)comicMakingItemSave:(ComicPage *)comicPage
              withImageView:(id)comicItemData
            withPrintScreen:(UIImage *)printScreen
                 withRemove:(BOOL)remove
              withImageView:(UIImageView *)imageView
{
    
    //    if (self.comicPageComicItems == nil) {
    self.comicPageComicItems = [[ComicPage alloc] init];
    //    }
    if (imageView == nil)
        return;
    
    dispatch_queue_t autoSaveCurrentDrawQueue  = dispatch_queue_create("comicItem_AutoSave", NULL);
    dispatch_async( autoSaveCurrentDrawQueue ,
                   ^ {
                       @try {
                           self.dirtysubviewData = nil;
                           self.dirtySubviews = nil;
                           
                           //Removing existign data
                           if (self.comicPageComicItems.subviews == nil) {
                               self.comicPageComicItems.subviews = [[NSMutableArray alloc] init];
                           }
                           if (self.comicPageComicItems.subviewData == nil) {
                               self.comicPageComicItems.subviewData = [[NSMutableArray alloc] init];
                           }
                           if (self.comicPageComicItems.subviewTranformData == nil) {
                               self.comicPageComicItems.subviewTranformData = [[NSMutableArray alloc] init];
                           }
                           
                           if (remove) {
                               if ([self.comicPageComicItems.subviews containsObject:comicItemData]) {
                                   
                                   NSInteger anIndex = [self.comicPageComicItems.subviews indexOfObject:comicItemData];
                                   if (anIndex >= 0 && [self.comicPageComicItems.subviewData count] > anIndex) {
                                       [self.comicPageComicItems.subviewData removeObjectAtIndex:anIndex];
                                   }
                                   if (anIndex >= 0 && [self.comicPageComicItems.subviewTranformData count] > anIndex) {
                                       [self.comicPageComicItems.subviewTranformData removeObjectAtIndex:anIndex];
                                   }
                                   [self.comicPageComicItems.subviews removeObject:comicItemData];
                               }
                           }else{
                               
                               if ([self.comicPageComicItems.subviews containsObject:comicItemData]) {
                                   
                                   NSInteger anIndex = [self.comicPageComicItems.subviews indexOfObject:comicItemData];
                                   if (anIndex >= 0 && [self.comicPageComicItems.subviewData count] > anIndex) {
                                       [self.comicPageComicItems.subviewData removeObjectAtIndex:anIndex];
                                   }
                                   if (anIndex >= 0 && [self.comicPageComicItems.subviewTranformData count] > anIndex) {
                                       [self.comicPageComicItems.subviewTranformData removeObjectAtIndex:anIndex];
                                   }
                                   
                                   [self.comicPageComicItems.subviews removeObject:comicItemData];
                               }
                               
                               [self.comicPageComicItems.subviews addObject:comicItemData];
                               [self.comicPageComicItems.subviewData addObject:[NSValue valueWithCGRect:((UIView*)comicItemData).frame]];
                               [self.comicPageComicItems.subviewTranformData addObject:[NSValue valueWithCGAffineTransform:((UIView*)comicItemData).transform]];
                               
                               self.dirtysubviewData  =  self.comicPageComicItems.subviewData;
                               self.dirtySubviews = self.comicPageComicItems.subviews;
                               
                           }
                           
                           self.comicPageComicItems.containerImagePath =  [AppHelper SaveImageFile:UIImagePNGRepresentation(imageView.image)/*UIImageJPEGRepresentation(imageView.image,1)*/ type:@"png"];
                           self.comicPageComicItems.printScreenPath = [AppHelper SaveImageFile:UIImagePNGRepresentation(printScreen)/*UIImageJPEGRepresentation(printScreen, 1) */type:@"png"];
                           
                           NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.comicPageComicItems];
                           
                           
                           if ([self.comicSlides count ] > self.editSlideIndex) {
                               [self.comicSlides replaceObjectAtIndex:self.editSlideIndex withObject:data];
                               [AppHelper saveDataToFile:self.comicSlides fileName:self.fileNameToSave];
                           }else{
                               [self.comicSlides addObject:data];
                               [AppHelper saveDataToFile:self.comicSlides fileName:self.fileNameToSave];
                           }
                       }
                       @catch (NSException *exception) {
                       }
                       @finally {
                       }
                   });
    
}


- (void)comicMakingViewControllerWithEditingDone:(ComicMakingViewController *)controll
                                   withImageView:(UIImageView *)imageView
                                 withPrintScreen:(UIImage *)printScreen
                                    gifLayerPath:(NSString *)gifLayerPath
                                    withNewSlide:(BOOL)newslide withPopView:(BOOL)isPopView withIsWideSlide:(BOOL)isWideSlide
{
    if (isPopView)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Do background work
            @try {
                
                //                self.scrvComicSlide.isStillSaving = YES;
                @autoreleasepool {
                    //                    self.comicPageComicItems = nil;
                    if (self.comicPageComicItems == nil)
                    {
                        self.comicPageComicItems = [[ComicPage alloc] init];
                        
                        self.comicPageComicItems.subviewData = self.dirtysubviewData;
                        self.comicPageComicItems.subviews = self.dirtySubviews;
                    }
                    
                    self.comicPageComicItems.containerImagePath =  [AppHelper SaveImageFile:UIImagePNGRepresentation(imageView.image) type:@"png"];
                    self.comicPageComicItems.printScreenPath = [AppHelper SaveImageFile:UIImagePNGRepresentation(printScreen) type:@"png"];
                    self.comicPageComicItems.gifLayerPath = gifLayerPath;
                    //Add time line
                    NSDate *now = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"h.mm a";
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    self.comicPageComicItems.timelineString = [dateFormatter stringFromDate:now];
                    dateFormatter = nil;
                    
                    if (isWideSlide)
                    {
                        self.comicPageComicItems.slideType = slideTypeWide;
                    }
                    else
                    {
                        self.comicPageComicItems.slideType = slideTypeTall;
                    }
                    
                    if (!self.comicSlides) {
                        self.comicSlides = [NSMutableArray array];
                    }
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.comicPageComicItems];
                    if (newslide)
                    {
                        [self.comicSlides addObject:data];
                        [AppHelper saveDataToFile:self.comicSlides fileName:self.fileNameToSave];
                    }
                    else
                    {
                        [self.comicSlides replaceObjectAtIndex:self.editSlideIndex withObject:data];
                        [AppHelper saveDataToFile:self.comicSlides fileName:self.fileNameToSave];
                    }
                    //                    self.scrvComicSlide.isStillSaving = NO;
                    data = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserEnterSecondTimeGlideViewController] == YES)
                        {
                            // below code for slide 16
                            if ([InstructionView getBoolValueForSlide:kInstructionSlide16] == YES)
                            {
                                // open "delete a comic" Instruction
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    NSLog(@"Do some work");
                                    
                                    if ([InstructionView getBoolValueForSlide:kInstructionSlideE] == NO)
                                    {
                                        InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                                        instView.delegate = self;
                                        [instView showInstructionWithSlideNumber:SlideNumberE withType:InstructionGIFType];
                                        [instView setTrueForSlide:kInstructionSlideE];
                                        
                                        [self.view addSubview:instView];
                                    }
                                    
                                    //                                    for (NSData *data in self.comicSlides) {
                                    //                                        ComicPage *comicPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                    //
                                    //                                        [self.dataArray addObject:comicPage];
                                    //                                    }
                                    [self addComicPage:_comicPageComicItems withIndex:_selectedIndexForAddOrEdit];
                                });
                            }
                        }
                        // second time gif animation
                        
                        
                        if ([InstructionView getBoolValueForSlide:kInstructionSlide14] == YES)
                        {
                            // "send it to friends" slide16
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                NSLog(@"Do some work");
                                
                                if ([InstructionView getBoolValueForSlide:kInstructionSlide16] == NO)
                                {
                                    InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                                    instView.delegate = self;
                                    [instView showInstructionWithSlideNumber:SlideNumber16 withType:InstructionBubbleType];
                                    [instView setTrueForSlide:kInstructionSlide16];
                                    
                                    [self.view addSubview:instView];
                                }
                            });
                        }
                        
                        
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserEnterFirstTimeGlideViewController] == YES)
                        {
                            // second time
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserEnterSecondTimeGlideViewController];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        
                        // first time
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserEnterFirstTimeGlideViewController];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        // open Instruction
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            NSLog(@"Do some work");
                            
                            if ([InstructionView getBoolValueForSlide:kInstructionSlide13] == NO)
                            {
                                InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                                instView.delegate = self;
                                [instView showInstructionWithSlideNumber:SlideNumber13 withType:InstructionGIFType];
                                [instView setTrueForSlide:kInstructionSlide13];
                                
                                [self.view addSubview:instView];
                            }
                        });
                        
                        
                    });
                }
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
        });
    }
    else
    {
        //Doing main thread
        //        [scrvComicSlide reloadComicImageAtIndex:newSlideIndex withComicSlide:printScreen withComicSlide:dataArray];
        @try {
            //            self.scrvComicSlide.isStillSaving = YES;
            @autoreleasepool {
                if (self.comicPageComicItems == nil) {
                    self.comicPageComicItems = [[ComicPage alloc] init];
                    
                    self.comicPageComicItems.subviewData = self.dirtysubviewData;
                    self.comicPageComicItems.subviews = self.dirtySubviews;
                }
                
                self.comicPageComicItems.containerImagePath =  [AppHelper SaveImageFile:UIImagePNGRepresentation(imageView.image)/*UIImageJPEGRepresentation(imageView.image,1)*/ type:@"png"];
                self.comicPageComicItems.printScreenPath = [AppHelper SaveImageFile:UIImagePNGRepresentation(printScreen)/*UIImageJPEGRepresentation(printScreen, 1)*/ type:@"png"];
                
                //Add time line
                NSDate *now = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"h.mm a";
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                self.comicPageComicItems.timelineString = [dateFormatter stringFromDate:now];
                dateFormatter = nil;
                
                if (isWideSlide)
                {
                    self.comicPageComicItems.slideType = slideTypeWide;
                }
                else
                {
                    self.comicPageComicItems.slideType = slideTypeTall;
                }
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.comicPageComicItems];
                
                if (newslide)
                {
                    [self.comicSlides addObject:data];
                    [AppHelper saveDataToFile:self.comicSlides fileName:self.fileNameToSave];
                }
                else
                {
                    [self.comicSlides replaceObjectAtIndex:self.editSlideIndex withObject:data];
                    [AppHelper saveDataToFile:self.comicSlides fileName:self.fileNameToSave];
                }
                
                //                NSLog(@"************* editSlideIndex ***************");
                //                ComicPage * sample = [NSKeyedUnarchiver unarchiveObjectWithData:dataArray[editSlideIndex]];
                //                NSLog(@"%@",sample.subviews);
                //                NSLog(@"************* editSlideIndex ***************");
                
                self.comicPageComicItems = nil;
                data = nil;
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}


#pragma mark - API

-(void)sendComic {
    
    //Desable the image view intactin
    [self.view setUserInteractionEnabled:NO];
    
    if(self.replyType == FriendReply) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartFriendReplyComicAnimation" object:nil];
    } else if(self.replyType == GroupReply) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartGroupReplyComicAnimation" object:nil];
    }
    
    [ComicMakingAPIManager sendComic:self.replyType
                      FileNameToSave:self.fileNameToSave
                handleUploadCallback:^(id jsonResponse, BOOL isSucess) {
                    if (!isSucess) {
                        [self.view setUserInteractionEnabled:YES];
                        if(self.replyType == FriendReply) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopFriendReplyComicAnimation" object:nil];
                            [self dismissViewControllerAnimated:YES completion:^{}];
                        } else if(self.replyType == GroupReply) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopGroupReplyComicAnimation" object:nil];
                            [self dismissViewControllerAnimated:YES completion:^{}];
                        }
                    }else{
                        [ComicMakingAPIManager postComicCreation:jsonResponse
                                                       replyType:self.replyType
                                                       comicType:self.comicType
                                                  FileNameToSave:self.fileNameToSave
                                                 FriendOrGroupId:self.friendOrGroupId
                                                         ShareId:self.shareId handleUploadCallback:^(id jsonResponse, BOOL isSucess) {
                                                             if (!isSucess) {
                                                                 [self.view setUserInteractionEnabled:YES];
                                                                 if(self.replyType == FriendReply) {
                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"StopFriendReplyComicAnimation" object:nil];
                                                                     [self dismissViewControllerAnimated:YES completion:^{}];
                                                                 } else if(self.replyType == GroupReply) {
                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"StopGroupReplyComicAnimation" object:nil];
                                                                     [self dismissViewControllerAnimated:YES completion:^{}];
                                                                 }
                                                             }else{
                                                                 if (jsonResponse && isSucess) {
                                                                     if(self.replyType == FriendReply) {
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFriendComics" object:nil];
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"StopFriendReplyComicAnimation" object:nil];
                                                                         [self dismissViewControllerAnimated:YES completion:^{}];
                                                                     } else if(self.replyType == GroupReply) {
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupComics" object:nil];
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"StopGroupReplyComicAnimation" object:nil];
                                                                         [self dismissViewControllerAnimated:YES completion:^{}];
                                                                     }
                                                                     if (self.fileNameToSave) {
                                                                         [AppHelper deleteSlideFile:self.fileNameToSave];
                                                                     }
                                                                 }else{
                                                                     [AppHelper showErrorDropDownMessage:@"something went wrong !" mesage:@""];
                                                                 }
                                                             }
                                                             
                                                         }];
                    }
                }];
    
}

@end
