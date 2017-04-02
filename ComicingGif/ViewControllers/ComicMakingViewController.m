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


@interface ComicMakingViewController ()
{
	ComicMakingViewModel *viewModel;
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
	
	[self createComicViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}


// MARK: - private methods
- (void)createComicViews {
	if (!viewModel || !viewModel.arrayObjects || !viewModel.arrayObjects.count) {
		NSLog(@"There is nothing comic objects");
		return;
	}
	
	// create background GIF from first object of comic object array
	ComicObjectView *backgroundView = [[ComicObjectView alloc] initWithComicObject:viewModel.arrayObjects.firstObject];
	
	for (NSInteger i = 1; i < viewModel.arrayObjects.count; i ++) {
		BaseObject *obj = viewModel.arrayObjects[i];
		ComicObjectView *comicView = [[ComicObjectView alloc] initWithComicObject:obj];
		[backgroundView addSubview:comicView];
	}
	
	[self.view addSubview:backgroundView];
}


// MARK: - public initialize methods
- (void)initWithBaseImage:(NSURL *)url {
	BkImageObject *obj = [[BkImageObject alloc] initWithURL:url];
	
	if (!viewModel) {
		viewModel = [[ComicMakingViewModel alloc] init];
	}
	[viewModel.arrayObjects removeAllObjects];
	
	[viewModel addObject:obj];
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
}


- (IBAction)btnToolBubbleTapped:(id)sender {
}


- (IBAction)btnToolStickerTapped:(id)sender {
}


- (IBAction)btnToolTextTapped:(id)sender {
}


- (IBAction)btnToolPenTapped:(id)sender {
}


- (IBAction)btnNextTapped:(id)sender {
}


- (IBAction)btnToolCloseTapped:(id)sender {
}


@end
