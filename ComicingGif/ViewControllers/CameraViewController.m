//
//  CameraViewController.m
//  ComicingGif
//
//  Created by Com on 22/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CameraViewController.h"
#import "RoundCapProgressView.h"
#import "ComicMakingViewController.h"


#define TOPBADDING		0.0
#define BOTTOMPADDING	0.0


@interface CameraViewController ()
{
	NSTimer *timerProgress;
	
	CGPoint ptOrigin;
	BOOL isSliding;
}

@property (weak, nonatomic) IBOutlet UIView *cameraPreview;
@property (weak, nonatomic) IBOutlet RoundCapProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UIImageView *imgviewToggle;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewRecording;
@property (weak, nonatomic) IBOutlet UIImageView *blueBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *btnChangeScene;

@property (weak, nonatomic) IBOutlet UIView *viewProgressContainer;
@property (weak, nonatomic) IBOutlet RoundCapProgressView *processingView;


@end


@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.viewModel = [[CameraViewModel alloc] init];
	self.viewModel.delegate = self;
	
	UITapGestureRecognizer *tapGesture;
	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordImageTapped:)];
	[self.imgviewRecording addGestureRecognizer:tapGesture];
	
	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleImageTapped:)];
	[self.imgviewToggle addGestureRecognizer:tapGesture];
	
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toggleImagePanGesutureHandler:)];
	[self.imgviewToggle addGestureRecognizer:panGesture];
	
	UIView *view = [self.viewProgressContainer viewWithTag:100];
	view.layer.cornerRadius = 8.0;
	view.clipsToBounds = YES;
	
	self.processingView.borderWidth = 1.0;
	self.processingView.cornerRect = 0;
	self.processingView.backgroundColor = [UIColor clearColor];
    
    self.progressBar.hidden = YES;
    
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imgviewToggle.frame = CGRectMake(self.imgviewToggle.frame.origin.x, self.blueBackgroundImageView.frame.size.height - (self.imgviewToggle.frame.size.height + 5),
                                          self.imgviewToggle.frame.size.width, self.imgviewToggle.frame.size.height);
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat height, y;
    if (self.isVerticalCamera) {
        height = self.cameraPreview.frame.size.width / 2;
        y = (self.view.frame.size.height - height) / 2;
    } else {
        height = self.view.frame.size.height - TOPBADDING - BOTTOMPADDING;
        y = 20;
    }
    self.cameraPreview.frame = CGRectMake(self.cameraPreview.frame.origin.x, y, self.cameraPreview.frame.size.width, height);
    [self.viewModel setupRecorderWith:self.cameraPreview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"segueMaking"]) {
		NSURL *url = (NSURL *)sender;
		ComicMakingViewController *vc = (ComicMakingViewController *)segue.destinationViewController;
		[vc initWithBaseImage:url frame:self.cameraPreview.frame andSubviewArray:nil];
	}
}



// MARK: - private methods
- (void)setRecordingProgress:(BOOL)isStarting {
	if (isStarting) {
        self.progressBar.hidden = NO;
		timerProgress = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
			self.progressBar.progress = self.progressBar.progress + 1.0 / MAXDURATION / 10;
		}];
		[timerProgress fire];
	} else {
		if (timerProgress) {
			[timerProgress invalidate];
		}
	}
}

- (void)setToggleImage:(BOOL)isRecording {
	if (isRecording) {
		self.imgviewToggle.image = [UIImage imageNamed:@"cameraRecButton"];
		self.imgviewRecording.image = nil;
		
	} else {
		self.imgviewToggle.image = nil;
		self.imgviewRecording.image = [UIImage imageNamed:@"cameraRecButton"];
	}
}

- (void)setRecordingImage:(BOOL)isRecording completed:(void(^)())completedHandler {
	if (isRecording) {
        NSLog(@"..........isRecording");
		[UIView animateWithDuration:0.2 animations:^{
			self.imgviewToggle.frame = CGRectMake(self.imgviewToggle.frame.origin.x, self.blueBackgroundImageView.frame.origin.y + 5,
												  self.imgviewToggle.frame.size.width, self.imgviewToggle.frame.size.height);
		} completion:^(BOOL finished) {
			completedHandler();
		}];
		
	} else {
        NSLog(@"..........isNotRecording");
		[UIView animateWithDuration:0.2 animations:^{
			self.imgviewToggle.frame = CGRectMake(self.imgviewToggle.frame.origin.x, self.imgviewToggle.frame.origin.y + self.imgviewToggle.frame.size.height,
												  self.imgviewToggle.frame.size.width, self.imgviewToggle.frame.size.height);
		} completion:^(BOOL finished) {
			completedHandler();
		}];
	}
}

- (void)showProgress:(BOOL)bHide progress:(double)progress {
	[self.viewProgressContainer setHidden:bHide];
	self.processingView.progress = progress;
}


// MARK: recorder control
- (void)resetRecord {
	[self.viewModel resetRecord];
	
	if (timerProgress) {
		[timerProgress invalidate];
	}
	self.progressBar.hidden = YES;
	[UIView animateWithDuration:0.1 animations:^{
		self.progressBar.progress = 0.0;
	}];
	
	self.imgviewToggle.image = [UIImage imageNamed:@"cameraRecButton"];
	self.imgviewRecording.image = nil;
}

- (void)startRecord {
	[self setRecordingProgress:YES];
	
	[self.viewModel startRecord];
}

- (void)stopRecord {
	[self setRecordingProgress:NO];
	
	[self.viewModel stopRecord];
}


// MARK: - gesture implementations
- (void)recordImageTapped:(UITapGestureRecognizer *)gesture {
	BOOL isRecording = [self.viewModel isRecording];
	
	if (isRecording) {
		[self stopRecord];
		
	} else {
		[self startRecord];
	}
	
	[self setToggleImage:isRecording];
}

- (void)toggleImageTapped:(UITapGestureRecognizer *)gesture {
	if ([self.viewModel isRecording]) { // already recording
		[self recordImageTapped:nil];
		return;
	}
	
	[self.viewModel capturePhotoWithCGRect:self.cameraPreview.bounds completionHandler:^(NSError *error) {
		if (error) {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:alert animated:YES completion:nil];
		}
		
		[self nextBtnTapped:nil];
	}];
}

- (void)toggleImagePanGesutureHandler:(UIPanGestureRecognizer *)gesture {
	if ([self.viewModel isRecording]) { // already recording
		return;
	}
	
	NSLog(@"pan gesture status with %ld", (long)gesture.state);
	if (gesture.state == UIGestureRecognizerStateBegan) {
		ptOrigin = [gesture translationInView:self.view];
		isSliding = NO;
		
	} else if (gesture.state == UIGestureRecognizerStateChanged) {
		CGPoint pt = [gesture translationInView:self.view];
		if (ptOrigin.y > pt.y && !isSliding) { // start recording video
			isSliding = YES;
			
			__weak id weakself = self;
			[self setRecordingImage:YES completed:^{
				[weakself startRecord];
			}];
		}
		
	} else if (gesture.state == UIGestureRecognizerStateEnded) { // end recording video
		if (isSliding == YES) {
			__weak id weakself = self;
			[self setRecordingImage:NO completed:^{
				[weakself stopRecord];
			}];
		}
		
		isSliding = NO;
	}
}


// MARK: - button actions
- (IBAction)closeBtnTapped:(id)sender {
	[self resetRecord];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeCameraTapped:(id)sender {
	[self.viewModel changeCamera];
}

- (IBAction)changeSceneTapped:(id)sender {
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
		
//		if (self.cameraPreview.frame.size.height > self.view.frame.size.height / 2) {
//			[self.btnChangeScene setImage:[UIImage imageNamed:@"cameraTallSide"] forState:UIControlStateNormal];
//		} else {
//			[self.btnChangeScene setImage:[UIImage imageNamed:@"cameraWideSide"] forState:UIControlStateNormal];
//		}
	}];
}

- (IBAction)nextBtnTapped:(id)sender {
	[self.viewModel stopRecord];
}


// MARK: - CameraViewModelDelegate implementaions
- (void)videoProgressingWith:(CGFloat)progress
{
	NSLog(@"generating GIF with %.2f %%", progress);
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self showProgress:NO progress:progress];
	});
}

- (void)finishedGifProcessingWith:(NSError *)error gifURL:(NSURL *)url
{
	[self showProgress:YES progress:0];
	
	if (error) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Generation GIF failed!" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
		[self presentViewController:alert animated:YES completion:nil];

		return;
	}
	
	// send email GIF for the testing
	/*if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
		mailCont.mailComposeDelegate = self;
		
		[mailCont setSubject:@"created GIF"];
		[mailCont setMessageBody:@"Please take a look attached GIF file." isHTML:NO];
		
		NSData *data = [NSData dataWithContentsOfURL:url];
		[mailCont addAttachmentData:data mimeType:@"GIF" fileName:@"sample.GIF"];
		
		[self presentViewController:mailCont animated:YES completion:nil];
		
		[self resetRecord];
	}*/
	
	// show comic making controller
	[self performSegueWithIdentifier:@"segueMaking" sender:url];
	[self resetRecord];
}


// MARK: - MFMailComposeViewController delegate implementation
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
