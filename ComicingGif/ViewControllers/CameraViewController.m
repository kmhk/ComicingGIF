//
//  CameraViewController.m
//  ComicingGif
//
//  Created by Com on 22/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CameraViewController.h"

#define TOPBADDING		20.0
#define BOTTOMPADDING	40.0


@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet UIView *cameraPreview;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UIImageView *imgviewToggle;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewRecording;

@property (weak, nonatomic) IBOutlet UIButton *btnChangeScene;

@end


@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.viewModel = [[CameraViewModel alloc] init];
	[self.viewModel setupRecorderWith:self.cameraPreview];
	
	UITapGestureRecognizer *tapGesture;
	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordImageTapped:)];
	[self.imgviewRecording addGestureRecognizer:tapGesture];
	
	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleImageTapped:)];
	[self.imgviewToggle addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// MARK: - gesture implementations

- (void)recordImageTapped:(UITapGestureRecognizer *)gesture {
	if ([self.viewModel isRecording]) {
		[self.viewModel stopRecord];
		
		self.imgviewToggle.image = [UIImage imageNamed:@"cameraRecButton"];
		self.imgviewRecording.image = nil;
		
	} else {
		[self.viewModel startRecord];
		
		self.imgviewToggle.image = nil;
		self.imgviewRecording.image = [UIImage imageNamed:@"cameraRecButton"];
	}
}

- (void)toggleImageTapped:(UITapGestureRecognizer *)gesture {
	[self.viewModel capturePhoto:^(NSError *error) {
		if (error) {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:alert animated:YES completion:nil];
		}
	}];
}


// MARK: - button actions

- (IBAction)closeBtnTapped:(id)sender {
	[self.viewModel resetRecord];
}

- (IBAction)changeCameraTapped:(id)sender {
	[self.viewModel changeCamera];
}

- (IBAction)changeSceneTappep:(id)sender {
	CGFloat height, y;
	
	if (self.cameraPreview.frame.size.height > self.view.frame.size.height / 2) {
		height = self.cameraPreview.frame.size.width / 2;
		y = (self.view.frame.size.height - height) / 2;
		
	} else {
		height = self.view.frame.size.height - TOPBADDING - BOTTOMPADDING;
		y = 20;
	}
	
	[UIView animateWithDuration:0.2 animations:^{
		self.cameraPreview.frame = CGRectMake(self.cameraPreview.frame.origin.x, y, self.cameraPreview.frame.size.width, height);
		[self.viewModel setupRecorderWith:self.cameraPreview];
	} completion:^(BOOL finished) {
		
	}];
}

@end
