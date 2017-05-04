//
//  ComicMakingViewController.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicMakingViewController.h"
#import "ComicMakingViewModel.h"
#import "./../Objects/ObjectHeader.h"
#import "./../CustomizedUI/ComicObjectView.h"

#import <Messages/Messages.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ComicItem.h"
#import "ComicObjectSerialize.h"
#import "CBComicPreviewVC.h"
#import "UIView+CBConstraints.h"

#define TOOLCELLID	@"ToolCollectionViewCell"
#define CATEGORYCELLID	@"CategoryCollectionViewCell"


@interface ComicMakingViewController () <ZoomTransitionProtocol>
{
	ComicMakingViewModel *viewModel;
	
	ComicObjectView *backgroundView;
	
	UICollectionView *collectionCategoryView;
	UICollectionView *collectionToolView;
	NSInteger nCategory;
}

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

@property (weak, nonatomic) IBOutlet UIButton *btnToolAnimateGIF;
@property (weak, nonatomic) IBOutlet UIButton *btnToolBubble;
@property (weak, nonatomic) IBOutlet UIButton *btnToolSticker;
@property (weak, nonatomic) IBOutlet UIButton *btnToolText;
@property (weak, nonatomic) IBOutlet UIButton *btnToolPen;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (strong, nonatomic) IBOutlet UIView *baseLayerView;
@property (assign, nonatomic) CGFloat ratioDecreasing;
@property (assign, nonatomic) CGRect baseLayerInitialFrame;

@end



// MARK: -

@implementation ComicMakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	nCategory = 1;

    _ratioDecreasing = 1;
    _baseLayerView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchView = [touches anyObject].view;
    if ([touchView.superview.superview isEqual:self.baseLayerView]) {
        _ratioDecreasing = 1;
        [self.baseLayerView saveFrameOfAllSubviews];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchView = [touches anyObject].view;
    if ([touchView.superview.superview isEqual:self.baseLayerView]) {
        if (_ratioDecreasing >= 0.6) {
            _ratioDecreasing -= 0.01;
            
            NSLog(@"............RATIO DECREASING: %f",_ratioDecreasing);
            CGFloat newWidth = _baseLayerInitialFrame.size.width * _ratioDecreasing;
            CGFloat newHeight = _baseLayerInitialFrame.size.height * _ratioDecreasing;
            
            _baseLayerView.frame = CGRectMake(_baseLayerInitialFrame.origin.x, _baseLayerInitialFrame.origin.y, newWidth, newHeight);
            _baseLayerView.center = self.view.center;
            NSLog(@"............RESULTANT FRAME: %@",NSStringFromCGRect(_baseLayerView.frame));
            [self.baseLayerView setSubViewWithWithDimensionAsPerRatio:_ratioDecreasing treeCount:1];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchView = [touches anyObject].view;
    if ([touchView.superview.superview isEqual:self.baseLayerView]) {
        if (_ratioDecreasing >= 0.7){
            [self.baseLayerView restoreSavedRect];
            [self.baseLayerView restoreFrameOfAllSubviews];
            [UIView animateWithDuration:0.1 + 0.2*(1-_ratioDecreasing) animations:^{
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }];
        } else {
            //Save
            [self btnNextTapped:nil];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self createComicViews];
	
	if ([viewModel isContainedAnimatedSticker] == true) {
		self.btnPlay.hidden = false;
	} else {
		self.btnPlay.hidden = true;
	}
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _baseLayerInitialFrame = _baseLayerView.frame;
}

- (UIView *)viewForZoomTransition:(BOOL)isSource {
    return self.baseLayerView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}


// MARK: - public initialize methods

- (void)initWithBaseImage:(NSURL *)url frame:(CGRect)rect andSubviewArray:(NSMutableArray *)arrSubviews isTall:(BOOL)isTall index:(NSInteger)index {
	BkImageObject *obj = [[BkImageObject alloc] initWithURL:url isTall:isTall];
	obj.frame = rect;
    obj.isTall = isTall;
	
	if (!viewModel) {
		viewModel = [[ComicMakingViewModel alloc] init];
	}
	[viewModel.arrayObjects removeAllObjects];
	
	[viewModel addObject:obj];
	
	if (arrSubviews != nil) {
		for (NSDictionary *subObj in arrSubviews) {
			BaseObject *obj = [[BaseObject alloc] initFromDict:subObj];
			[viewModel.arrayObjects addObject:obj];
		}
	}
	
	[ComicObjectSerialize setSavedIndex:index];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// MARK: - button action implementations
- (IBAction)btnPlayTapped:(id)sender {
	[backgroundView playAnimate];
	
	for (UIView *view in backgroundView.subviews) {
		if (view.class == ComicObjectView.class) {
			[((ComicObjectView *)view) playAnimate];
		}
	}
}


- (IBAction)btnToolAnimateGifTapped:(id)sender {
	UIView *toolView = [self createToolView:ObjectAnimateGIF];
	toolView.frame = CGRectOffset(toolView.frame, self.baseLayerView.frame.size.width, 0);
	toolView.alpha = 0.0;
	[self.baseLayerView addSubview:toolView];
	
	[UIView animateWithDuration:0.5 animations:^{
		[self setToolButtonAlpah:0.0];
		
		toolView.frame = CGRectOffset(toolView.frame, -self.baseLayerView.frame.size.width, 0);
		toolView.alpha = 1.0;
		
	} completion:^(BOOL finished) {

	}];
}


- (IBAction)btnToolBubbleTapped:(id)sender {
}


- (IBAction)btnToolStickerTapped:(id)sender {
	UIView *toolView = [self createToolView:ObjectSticker];
	toolView.frame = CGRectOffset(toolView.frame, self.baseLayerView.frame.size.width, 0);
	toolView.alpha = 0.0;
	[self.baseLayerView addSubview:toolView];
	
	[UIView animateWithDuration:0.5 animations:^{
		[self setToolButtonAlpah:0.0];
		
		toolView.frame = CGRectOffset(toolView.frame, -self.baseLayerView.frame.size.width, 0);
		toolView.alpha = 1.0;
		
	} completion:^(BOOL finished) {

	}];
}


- (IBAction)btnToolTextTapped:(id)sender {
}


- (IBAction)btnToolPenTapped:(id)sender {
}


- (IBAction)btnNextTapped:(id)sender {
	[viewModel saveObject];
	
	// for testing
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slides.plist"];
//	
//	if([MFMailComposeViewController canSendMail]) {
//		MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
//		mailCont.mailComposeDelegate = self;
//		
//		[mailCont setSubject:@"created GIF"];
//		[mailCont setMessageBody:@"Please take a look attached GIF file." isHTML:NO];
//		
//		NSData *data = [NSData dataWithContentsOfFile:filePath];
//		[mailCont addAttachmentData:data mimeType:@"plist" fileName:@"slides.plist"];
//		
//		[self presentViewController:mailCont animated:YES completion:nil];
//	}
    
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[CBComicPreviewVC class]]) {
        CBComicPreviewVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CBComicPreviewVC"];
        vc.shouldFetchAndReload = YES;
        NSMutableArray *controllers = [[NSArray arrayWithObject:vc] mutableCopy];
        [controllers addObjectsFromArray:self.navigationController.viewControllers];
        [self.navigationController setViewControllers:controllers];
        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CBComicPreviewVC *vc = [self.navigationController.viewControllers firstObject];
        vc.shouldFetchAndReload = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (IBAction)btnToolCloseTapped:(id)sender {
    if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[CBComicPreviewVC class]]) {
        CBComicPreviewVC *vc = [self.navigationController.viewControllers firstObject];
        vc.shouldFetchAndReload = NO;
    }
	[self.navigationController popViewControllerAnimated:YES];
}


// MARK: - gesture handler
- (void)tapGestureHandlerForToolContainerView:(UITapGestureRecognizer *)gesture {
	[UIView animateWithDuration:0.5 animations:^{
		if (gesture.view.tag == ObjectAnimateGIF) {
			gesture.view.frame = CGRectOffset(gesture.view.frame, self.baseLayerView.frame.size.width, 0);
			gesture.view.alpha = 0.0;
			
		} else if (gesture.view.tag == ObjectSticker) {
			gesture.view.frame = CGRectOffset(gesture.view.frame, self.baseLayerView.frame.size.width, 0);
			gesture.view.alpha = 0.0;
			
		} else if (gesture.view.tag == ObjectBubble) {
			
		} else if (gesture.view.tag == ObjectCaption) {
			
		} else if (gesture.view.tag == ObjectPen) {
			
		}
		
		[self setToolButtonAlpah:1.0];
		
	} completion:^(BOOL finished) {
		[gesture.view removeFromSuperview];
		
	}];
}


// MARK: - private methods
- (BaseObject *)createComicObject:(ComicObjectType)type index:(NSInteger)index category:(NSInteger)category {
	BaseObject *obj;
	NSString *rcID;
	
	if (type == ObjectSticker) {
		rcID = [NSString stringWithFormat:@"theme_sticker%ld_%ld.png", (long)category, (long)index];
		obj = [BaseObject comicObjectWith:ObjectSticker userInfo:rcID];
		
	} else if (type == ObjectAnimateGIF) {
		rcID = [NSString stringWithFormat:@"theme_GIF%ld_%ld.gif", (long)category, (long)index];
		obj = [BaseObject comicObjectWith:ObjectAnimateGIF userInfo:rcID];
		
		self.btnPlay.hidden = false;
	}
	
	[viewModel addRecentObject:@{@"type":		@(type),
								 @"id":			@(index),
								 @"category":	@(category)}];
	
	return obj;
}

- (void)createComicViews {
	if (!viewModel || !viewModel.arrayObjects || !viewModel.arrayObjects.count) {
		NSLog(@"There is nothing comic objects");
		return;
	}
	
	backgroundView = [ComicObjectView createComicViewWith:viewModel.arrayObjects delegate:self];
	[self.baseLayerView insertSubview:backgroundView atIndex:0];
}

- (void)createComicViewWith:(BaseObject *)obj {
	[viewModel addObject:obj];
	
	ComicObjectView *comicView = [[ComicObjectView alloc] initWithComicObject:obj];
    comicView.parentView = backgroundView;
	comicView.delegate = self;
	[backgroundView addSubview:comicView];
}


- (UIView *)createToolView:(ComicObjectType)type {
	nCategory = 1;
	
	UIView *toolContainerView = [[UIView alloc] initWithFrame:self.baseLayerView.bounds];

	toolContainerView.backgroundColor = [UIColor clearColor];
	toolContainerView.tag = type;
	
	UITapGestureRecognizer *gesture;
	gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
													  action:@selector(tapGestureHandlerForToolContainerView:)];
	gesture.delegate = self;
	[toolContainerView addGestureRecognizer:gesture];
	
	// sticker collection view
	CGRect rt = CGRectMake(0, toolContainerView.frame.size.height - 140, toolContainerView.frame.size.width, 90);
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	layout.minimumInteritemSpacing = 30;
	layout.minimumLineSpacing = 30;
	
	collectionToolView = [[UICollectionView alloc] initWithFrame:rt collectionViewLayout:layout];
	collectionToolView.tag = type;
	collectionToolView.delegate = self;
	collectionToolView.dataSource = self;
	collectionToolView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
	collectionToolView.pagingEnabled = YES;
	[collectionToolView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:TOOLCELLID];
	
	[toolContainerView addSubview:collectionToolView];
	[collectionToolView reloadData];
	
	// category collection view
	rt = CGRectMake(0, toolContainerView.frame.size.height - 50, toolContainerView.frame.size.width, 50);
	
	layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	collectionCategoryView = [[UICollectionView alloc] initWithFrame:rt collectionViewLayout:layout];
	collectionCategoryView.delegate = self;
	collectionCategoryView.dataSource = self;
	collectionCategoryView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
	collectionCategoryView.pagingEnabled = YES;
	[collectionCategoryView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CATEGORYCELLID];
	
	[toolContainerView addSubview:collectionCategoryView];
	[collectionCategoryView reloadData];
	
	return toolContainerView;
}

- (void)setToolButtonAlpah:(CGFloat)alpha {
	self.btnToolAnimateGIF.alpha = alpha;
	self.btnToolPen.alpha = alpha;
	self.btnToolText.alpha = alpha;
	self.btnToolBubble.alpha = alpha;
	self.btnToolSticker.alpha = alpha;
	self.btnNext.alpha = alpha;
}


// MARK: - UIGesture delegate impelementation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	CGPoint translation = [touch locationInView:gestureRecognizer.view];
	BOOL flag = NO;
	
	UICollectionView *collectionView;
	for (UIView *view in gestureRecognizer.view.subviews) {
		if ([view class] == [UICollectionView class]) {
			collectionView = (UICollectionView *)view;
			flag = flag | CGRectContainsPoint(collectionView.frame, translation);
		}
	}
	
	return !flag;
}


// MARK: - UICollectionView delegate & data source implementation
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (collectionView == collectionCategoryView) { // for category view
		return COUNT_CATEGORY;
	}
	
	// for recent section of each tool view
	if (nCategory == 0) {
		return [viewModel getRecentObjects:(ComicObjectType)collectionView.tag].count;
	}
	
	// for sticker tool view
	if (collectionView.tag == ObjectSticker) {
		return [COUNT_STICKERS[nCategory - 1] integerValue];
		
	} else if (collectionView.tag == ObjectAnimateGIF) {
		return [COUNT_GIFS[nCategory - 1] integerValue];
	}
	
	return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	// for category view
	if (collectionView == collectionCategoryView) {
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CATEGORYCELLID forIndexPath:indexPath];
		if (!cell) {
			cell = [[UICollectionViewCell alloc] init];
		}
		
		NSString *rcID = [NSString stringWithFormat:@"category%ld.png", (long)indexPath.row];
		
		UIImageView *imgView = [cell viewWithTag:0x100];
		if (!imgView) {
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width / 4, 0, cell.bounds.size.width / 2, cell.bounds.size.height / 2)];
			imgView.tag = 0x100;
			imgView.userInteractionEnabled = YES;
			imgView.contentMode = UIViewContentModeScaleAspectFit;
			[cell addSubview:imgView];
		}
		imgView.image = [UIImage imageNamed:rcID];
		
		UIView *chosenView = [cell viewWithTag:0x101];
		if (nCategory == indexPath.row) {
			if (!chosenView) {
				chosenView = [[UIView alloc] initWithFrame:CGRectMake((cell.bounds.size.width - 8) / 2, cell.bounds.size.height - 10, 8, 8)];
				chosenView.layer.cornerRadius = chosenView.frame.size.width / 2;
				chosenView.backgroundColor = [UIColor whiteColor];
				chosenView.clipsToBounds = YES;
				chosenView.tag = 0x101;
				[cell addSubview:chosenView];
			}
			
		} else {
			if (chosenView) {
				[chosenView removeFromSuperview];
			}
		}
		
		return cell;
	}
	
	// for tool view
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TOOLCELLID forIndexPath:indexPath];
	if (!cell) {
		cell = [[UICollectionViewCell alloc] init];
	}
	//cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	
	NSString *rcID;
	NSInteger type, index, category;
	
	if (nCategory == 0) { // for recent section
		NSDictionary *dict = [viewModel getRecentObjects:(ComicObjectType)collectionView.tag][indexPath.row];
		type = [dict[@"type"] integerValue];
		index = [dict[@"id"] integerValue];
		category = [dict[@"category"] integerValue];
		
	} else {
		type = collectionView.tag;
		index = indexPath.row;
		category = nCategory - 1;
	}
	
	if (type == ObjectSticker) {
		rcID = [NSString stringWithFormat:@"theme_sticker%ld_%ld.png", (long)category, (long)index];
		
	} else if (type == ObjectAnimateGIF) {
		rcID = [NSString stringWithFormat:@"theme_GIF%ld_%ld.gif", (long)category, (long)index];
	}
	
	UIImageView *imgView = [cell viewWithTag:0x100];
	if (!imgView) {
		imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
		imgView.tag = 0x100;
		imgView.userInteractionEnabled = YES;
		imgView.contentMode = UIViewContentModeScaleAspectFit;
		[cell addSubview:imgView];
	}
	
	imgView.image = [UIImage imageNamed:rcID];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView == collectionCategoryView) { // for category colleciton view
		if (nCategory == indexPath.row) {
			return;
		}
		
		nCategory = indexPath.row;
		[collectionToolView reloadData];
		[collectionCategoryView reloadData];
		
		collectionToolView.frame = CGRectOffset(collectionToolView.frame, self.view.frame.size.width, 0);
		collectionToolView.alpha = 0.0;
		[UIView animateWithDuration:0.5 animations:^{
			collectionToolView.frame = CGRectOffset(collectionToolView.frame, -self.view.frame.size.width, 0);
			collectionToolView.alpha = 1.0;
		}];
		
		return;
	}
	
	// for tool category view
	NSInteger type, index, category;
	
	if (nCategory == 0) { // for recent object
		NSDictionary *dict = [viewModel getRecentObjects:(ComicObjectType)collectionView.tag][indexPath.row];
		type = [dict[@"type"] integerValue];
		index = [dict[@"id"] integerValue];
		category = [dict[@"category"] integerValue];
		
	} else {
		type = collectionView.tag;
		index = indexPath.row;
		category = nCategory - 1;
	}
	
	BaseObject *obj = [self createComicObject:(ComicObjectType)type index:index category:category];
	
	if (obj) {
		[self createComicViewWith:obj];
		[viewModel saveObject];
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView == collectionCategoryView) {
		return CGSizeMake(40, 40);
	}
	
	return CGSizeMake(80, 80);
	//return CGSizeMake((collectionView.frame.size.width - 40) / 3, collectionView.frame.size.height - 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	if (collectionView == collectionCategoryView) {
		return UIEdgeInsetsMake(3, 10, 3, 10);
	}
	
	return UIEdgeInsetsMake(3, 15, 3, 30);
}


// MARK: - ComicObjectView delegate implementations
- (void)saveObject {
	[viewModel saveObject];
}

- (void)removeObject:(ComicObjectView *)view {
	[viewModel.arrayObjects removeObject:view.comicObject];
	
	[UIView animateWithDuration:0.3 animations:^{
		view.alpha = 0.0;
	} completion:^(BOOL finished) {
		[view removeFromSuperview];
		
		[self saveObject];
	}];
}

- (void) addSubviewsOnImageWithSubviews:(NSMutableArray *)arrSubviews {
    //Handle top layer that is sticker gif
    int i=0;
    for (NSDictionary* subview in arrSubviews) {
        if ([[[subview objectForKey:@"baseInfo"] objectForKey:@"type"]intValue]==17) {
            ComicItemAnimatedSticker *sticker = [ComicItemAnimatedSticker new];
            sticker.objFrame = CGRectFromString([[subview objectForKey:@"baseInfo"] objectForKey:@"frame"]);
            sticker.combineAnimationFileName = [subview objectForKey:@"url"];
            
            NSBundle *bundle = [NSBundle mainBundle] ;
            NSString *strFileName = [[subview objectForKey:@"url"] lastPathComponent];
            NSString *imagePath = [bundle pathForResource:[strFileName stringByReplacingOccurrencesOfString:@".gif" withString:@""] ofType:@"gif"];
            NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
            
            sticker.image =  [UIImage sd_animatedGIFWithData:gifData];
            
            
            sticker.frame = CGRectMake(sticker.objFrame.origin.x, sticker.objFrame.origin.y, sticker.objFrame.size.width, sticker.objFrame.size.height);
            i ++;
            
            [self.baseLayerView addSubview:sticker];
        }
    }
}

@end
