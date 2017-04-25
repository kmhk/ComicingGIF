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

#define CELLID	@"ToolCollectionViewCell"


@interface ComicMakingViewController ()
{
	ComicMakingViewModel *viewModel;
	
	ComicObjectView *backgroundView;
}

@property (weak, nonatomic) IBOutlet UIView *viewTools;
@property (weak, nonatomic) IBOutlet UIButton *btnToolAnimateGIF;
@property (weak, nonatomic) IBOutlet UIButton *btnToolBubble;
@property (weak, nonatomic) IBOutlet UIButton *btnToolSticker;
@property (weak, nonatomic) IBOutlet UIButton *btnToolText;
@property (weak, nonatomic) IBOutlet UIButton *btnToolPen;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@end



// MARK: -

@implementation ComicMakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self createComicViews];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}


// MARK: - public initialize methods
- (void)initWithBaseImage:(NSURL *)url frame:(CGRect)rect andSubviewArray:(NSMutableArray *)arrSubviews{
	BkImageObject *obj = [[BkImageObject alloc] initWithURL:url];
	obj.frame = rect;
	
	if (!viewModel) {
		viewModel = [[ComicMakingViewModel alloc] init];
	}
	[viewModel.arrayObjects removeAllObjects];
	
	[viewModel addObject:obj];
    
    if (arrSubviews) {
        [self addSubviewsOnImageWithSubviews:arrSubviews];
    }
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
- (IBAction)btnToolAnimateGifTapped:(id)sender {
	UIView *toolView = [self createToolView:ObjectAnimateGIF];
	toolView.frame = CGRectOffset(toolView.frame, self.view.frame.size.width, 0);
	[self.view addSubview:toolView];
	
	[UIView animateWithDuration:0.2 animations:^{
		self.btnToolAnimateGIF.frame = CGRectOffset(self.btnToolAnimateGIF.frame, -self.view.frame.size.width, 0);
		toolView.frame = CGRectOffset(toolView.frame, -self.view.frame.size.width, 0);
	}];
}


- (IBAction)btnToolBubbleTapped:(id)sender {
}


- (IBAction)btnToolStickerTapped:(id)sender {
	UIView *toolView = [self createToolView:ObjectSticker];
	toolView.frame = CGRectOffset(toolView.frame, self.view.frame.size.width, 0);
	[self.view addSubview:toolView];
	
	[UIView animateWithDuration:0.2 animations:^{
		self.btnToolSticker.frame = CGRectOffset(self.btnToolSticker.frame, -self.view.frame.size.width, 0);
		toolView.frame = CGRectOffset(toolView.frame, -self.view.frame.size.width, 0);
	}];
}


- (IBAction)btnToolTextTapped:(id)sender {
}


- (IBAction)btnToolPenTapped:(id)sender {
}


- (IBAction)btnNextTapped:(id)sender {
	[viewModel saveObject];
	
	// for testing
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slides.plist"];
	
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
		mailCont.mailComposeDelegate = self;
		
		[mailCont setSubject:@"created GIF"];
		[mailCont setMessageBody:@"Please take a look attached GIF file." isHTML:NO];
		
		NSData *data = [NSData dataWithContentsOfFile:filePath];
		[mailCont addAttachmentData:data mimeType:@"plist" fileName:@"slides.plist"];
		
		[self presentViewController:mailCont animated:YES completion:nil];
	}
}


- (IBAction)btnToolCloseTapped:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


// MARK: - gesture handler
- (void)tapGestureHandlerForToolContainerView:(UITapGestureRecognizer *)gesture {
	[UIView animateWithDuration:0.2 animations:^{
		if (gesture.view.tag == ObjectAnimateGIF) {
			self.btnToolAnimateGIF.frame = CGRectOffset(self.btnToolAnimateGIF.frame, self.view.frame.size.width, 0);
			gesture.view.frame = CGRectOffset(gesture.view.frame, self.view.frame.size.width, 0);
			
		} else if (gesture.view.tag == ObjectSticker) {
			self.btnToolSticker.frame = CGRectOffset(self.btnToolSticker.frame, self.view.frame.size.width, 0);
			gesture.view.frame = CGRectOffset(gesture.view.frame, self.view.frame.size.width, 0);
			
		} else if (gesture.view.tag == ObjectBubble) {
			
		} else if (gesture.view.tag == ObjectCaption) {
			
		} else if (gesture.view.tag == ObjectPen) {
			
		}
		
	} completion:^(BOOL finished) {
		[gesture.view removeFromSuperview];
	}];
}


// MARK: - private methods
- (void)createComicViews {
	if (!viewModel || !viewModel.arrayObjects || !viewModel.arrayObjects.count) {
		NSLog(@"There is nothing comic objects");
		return;
	}
	
	backgroundView = [ComicObjectView createComicViewWith:viewModel.arrayObjects];
	[self.view insertSubview:backgroundView atIndex:0];
}

- (void)createComicViewWith:(BaseObject *)obj {
	[viewModel addObject:obj];
	
	ComicObjectView *comicView = [[ComicObjectView alloc] initWithComicObject:obj];
    comicView.parentView = backgroundView;
	[backgroundView addSubview:comicView];
	
	[viewModel saveObject];
}


- (UIView *)createToolView:(ComicObjectType)type {
	UIView *toolContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
	toolContainerView.backgroundColor = [UIColor clearColor];
	toolContainerView.tag = type;
	
	UITapGestureRecognizer *gesture;
	gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
													  action:@selector(tapGestureHandlerForToolContainerView:)];
	gesture.delegate = self;
	[toolContainerView addGestureRecognizer:gesture];
	
	CGRect rt = CGRectMake(0, toolContainerView.frame.size.height - 150, toolContainerView.frame.size.width, 150);
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rt collectionViewLayout:layout];
	collectionView.tag = type;
	collectionView.delegate = self;
	collectionView.dataSource = self;
	collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
	collectionView.pagingEnabled = YES;
	[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];
	
	[toolContainerView addSubview:collectionView];
	[collectionView reloadData];
	
	return toolContainerView;
}


// MARK: - UIGesture delegate impelementation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	CGPoint translation = [touch locationInView:gestureRecognizer.view];
	
	UICollectionView *collectionView;
	for (UIView *view in gestureRecognizer.view.subviews) {
		if ([view class] == [UICollectionView class]) {
			collectionView = (UICollectionView *)view;
			break;
		}
	}
	
	return !CGRectContainsPoint(collectionView.frame, translation);
}


// MARK: - UICollectionView delegate & data source implementation
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (collectionView.tag == ObjectSticker) {
		return COUNT_STICKERS;
		
	} else if (collectionView.tag == ObjectAnimateGIF) {
		return COUNT_GIFS;
	}
	
	return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
	if (!cell) {
		cell = [[UICollectionViewCell alloc] init];
	}
	cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	
	NSString *rcID;
	if (collectionView.tag == ObjectSticker) {
		rcID = [NSString stringWithFormat:@"theme_sticker%ld.png", (long)indexPath.row + 1];
		
	} else if (collectionView.tag == ObjectAnimateGIF) {
		rcID = [NSString stringWithFormat:@"theme_GIF%ld.gif", (long)indexPath.row + 1];
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
	NSString *rcID;
	BaseObject *obj;
	if (collectionView.tag == ObjectSticker) {
		rcID = [NSString stringWithFormat:@"theme_sticker%ld.png", (long)indexPath.row + 1];
		obj = [BaseObject comicObjectWith:ObjectSticker userInfo:rcID];
		
	} else if (collectionView.tag == ObjectAnimateGIF) {
		rcID = [NSString stringWithFormat:@"theme_GIF%ld.gif", (long)indexPath.row + 1];
		obj = [BaseObject comicObjectWith:ObjectAnimateGIF userInfo:rcID];
	}
	
	if (obj) {
		[self createComicViewWith:obj];
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake((collectionView.frame.size.width - 40) / 3, collectionView.frame.size.height - 20);
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
            
            [self.view addSubview:sticker];
        }
    }
    
}
@end
