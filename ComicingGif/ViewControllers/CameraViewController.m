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
#import "ComicObjectSerialize.h"
#import "CBComicPreviewVC.h"
#import "Constants.h"

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
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewToggle;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewRecording;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeScene;
@property (weak, nonatomic) IBOutlet UIView *viewProgressContainer;
@property (weak, nonatomic) IBOutlet RoundCapProgressView *processingView;
@property (weak, nonatomic) IBOutlet UIButton *btnRotate;
@property (weak, nonatomic) IBOutlet UIView *captureHolder;
@property (weak, nonatomic) IBOutlet UIView *animView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;
@property (weak, nonatomic) IBOutlet UIView *closeView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Global global].haveAccessToOpenCameraScreen = false;
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
    
    //    self.imgviewToggle.frame = CGRectMake(self.imgviewToggle.frame.origin.x, self.blueBackgroundImageView.frame.size.height - (self.imgviewToggle.frame.size.height + 5),
    //                                          self.imgviewToggle.frame.size.width, self.imgviewToggle.frame.size.height);
    
    [self setCaptureImageWithDefaultPosition];
    [self showProgress:YES progress:0];
}

- (void) setCaptureImageWithDefaultPosition {
    // c0mrade Edit:
    CGFloat width = self.imgviewToggle.frame.size.width;
    CGFloat height = self.imgviewToggle.frame.size.height;
    CGPoint orgin = CGPointMake(self.imgviewToggle.frame.origin.x, self.captureHolder.frame.size.height - self.imgviewToggle.frame.size.height);
    
    __weak typeof(self) wSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        wSelf.animView.backgroundColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:239/255.0 alpha:0.6];
        wSelf.imgSelected.image = [UIImage imageNamed:@"cameraPhotoMode"];
        wSelf.imgviewToggle.frame = CGRectMake(orgin.x, orgin.y, width, height);
    }];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.animView.layer.cornerRadius = 35;
    self.animView.layer.masksToBounds = true;
    
    CGFloat height, y;
    if (self.isVerticalCamera) {
        height = self.cameraPreview.frame.size.width / 1.78;
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

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"segueMaking"]) {
//        NSURL *url = (NSURL *)sender;
//        ComicMakingViewController *vc = (ComicMakingViewController *)segue.destinationViewController;
//        vc.indexSaved = _indexOfSlide;
//        [vc initWithBaseImage:url frame:self.cameraPreview.frame andSubviewArray:nil isTall:!self.isVerticalCamera index:_indexOfSlide];
//    }
//}



// MARK: - private methods
- (void)setRecordingProgress:(BOOL)isStarting {
    if (isStarting) {
        self.progressBar.hidden = NO;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
            timerProgress = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self updateProgressBar];
            }];
        } else {
            timerProgress = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
        }
        
        [timerProgress fire];
    } else {
        if (timerProgress) {
            [timerProgress invalidate];
        }
    }
}

- (void)updateProgressBar {
    [UIView animateWithDuration:0.5 animations:^{
        self.progressBar.progress = self.progressBar.progress + 1.0 / MAXDURATION / 10;
    }];
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
        [UIView animateWithDuration:0.3 animations:^{
            self.animView.backgroundColor = [UIColor colorWithRed:237/255.0 green:28/255.0 blue:36/255.0 alpha:0.6];
            self.imgviewToggle.frame = CGRectMake(self.imgviewToggle.frame.origin.x, self.animView.frame.origin.y + 3,
                                                  self.imgviewToggle.frame.size.width, self.imgviewToggle.frame.size.height);
        } completion:^(BOOL finished) {
            completedHandler();
        }];
        
    } else {
        //        NSLog(@"..........isNotRecording");
        //        [UIView animateWithDuration:0.3 animations:^{
        //            self.imgviewToggle.frame = CGRectMake(self.imgviewToggle.frame.origin.x,
        //                                                  self.animView.frame.size.height,
        //                                                  self.imgviewToggle.frame.size.width,
        //                                                  self.imgviewToggle.frame.size.height);
        //        } completion:^(BOOL finished) {
        //            completedHandler();
        //        }];
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
	[self.viewModel stopRecord];
	
    [self setRecordingProgress:NO];
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
    if ([self.viewModel isRecording] && gesture.state == UIGestureRecognizerStateEnded) {
        if (isSliding == YES) {
            __weak typeof(self) wSelf = self;
            [UIView animateWithDuration:0.5 animations:^{
                wSelf.imgSelected.image = [UIImage imageNamed:@"cameraPhotoMode"];
            } completion:^(BOOL finished) {
                [wSelf stopRecord];
                [wSelf setCaptureImageWithDefaultPosition];
            }];
        }
        isSliding = NO;
    } else if ([self.viewModel isRecording]) { // already recording
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
            
            __weak typeof(self) wSelf = self;
            [self setRecordingImage:YES completed:^{
                [UIView animateWithDuration:0.5 animations:^{
                    wSelf.imgSelected.image = [UIImage imageNamed:@"cameraVideoMode"];
                }];
                [wSelf startRecord];
            }];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) { // end recording video
        if (isSliding == YES) {
            
            __weak typeof(self) wSelf = self;
            [self setRecordingImage:NO completed:^{
                [UIView animateWithDuration:0.5 animations:^{
                    wSelf.imgSelected.image = [UIImage imageNamed:@"cameraPhotoMode"];
                }];
                [wSelf stopRecord];
            }];
        }
        
        isSliding = NO;
    }
}


// MARK: - button actions
- (IBAction)closeBtnTapped:(id)sender {
    [self resetRecord];
    [self.navigationController popViewControllerAnimated:YES];
    if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[CBComicPreviewVC class]]) {
        CBComicPreviewVC *vc = [self.navigationController.viewControllers firstObject];
        [vc deleteLastCell];
    }
}

- (IBAction)changeCameraTapped:(id)sender {
    
    // C0mrade:
    __weak typeof(self) wSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        if (CGAffineTransformEqualToTransform(wSelf.btnRotate.transform, CGAffineTransformIdentity)) {
            wSelf.btnRotate.transform = CGAffineTransformMakeRotation(M_PI * 0.999);
        } else {
            wSelf.btnRotate.transform = CGAffineTransformIdentity;
        }
    }];
    
    [self.viewModel changeCamera];
}

- (IBAction)changeSceneTapped:(id)sender {
    _isVerticalCamera = (self.cameraPreview.frame.size.height > self.view.frame.size.height / 2) ? YES:NO;
    
    CGFloat padding, height, centerY;
    CGFloat progressBarHeight = 10.0;
    
    if (_isVerticalCamera == true) {
        padding = 5.0 + progressBarHeight;
        height = self.view.frame.size.width * 0.39; // formula should be gone to centralized constants
        centerY = self.captureHolder.frame.origin.y - (height + padding);
    } else {
        padding = 0.0;
        height = self.view.frame.size.height;
        centerY = 0;
    }
    
    // C0mrade:
    __weak typeof(self) wSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        wSelf.cameraPreview.frame = CGRectMake(wSelf.cameraPreview.frame.origin.x,
                                               centerY, wSelf.cameraPreview.frame.size.width, height);
        if (CGAffineTransformEqualToTransform(wSelf.btnChangeScene.transform, CGAffineTransformIdentity)) {
            wSelf.btnChangeScene.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            wSelf.btnChangeScene.transform = CGAffineTransformIdentity;
        }
        [wSelf.viewModel setupRecorderWith:wSelf.cameraPreview];
    }];
}

- (IBAction)nextBtnTapped:(id)sender {
    [self.viewModel stopRecord];
}


// MARK: - CameraViewModelDelegate implementaions
- (void)videoProgressingWith:(CGFloat)progress {
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
    //    [self performSegueWithIdentifier:@"segueMaking" sender:url];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ComicMaking" bundle:nil];
    ComicMakingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ComicMakingViewController"];
    vc.isFromCamera = true;
    vc.indexSaved = _indexOfSlide;

    __weak typeof(self) wSelf = self;
//    self.captureHolder.translatesAutoresizingMaskIntoConstraints = true;
//    self.topBar.translatesAutoresizingMaskIntoConstraints = true;
    
    CGRect tempFrame = self.captureHolder.frame;
    tempFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    CGRect tempTopBar = self.closeView.frame;
    tempTopBar.origin.y = 0 - self.topBar.frame.size.height;
    
//    CGRect fr = self.cameraPreview.frame;
//    fr.size.height -= 72;
//    
//    [UIView animateWithDuration:0.7 animations:^{
//        self.cameraPreview.transform = CGAffineTransformMakeScale(0.97, 0.87);
//        self.cameraPreview.frame = fr;
//        
//    } completion:^(BOOL finished) {
//        
//
//    }];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        wSelf.captureHolder.frame = tempFrame;
        wSelf.topBar.frame = tempTopBar;
        wSelf.viewProgressContainer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [wSelf resetRecord];
        [vc initWithBaseImage:url frame:wSelf.cameraPreview.frame andSubviewArray:nil isTall:!wSelf.isVerticalCamera index:_indexOfSlide];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wSelf setupDefaultsValuesForTopAndBottomAnimatedViews];
        });
        
        [UIView transitionWithView:self.navigationController.view duration:0.75
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               [wSelf.navigationController pushViewController:vc animated:NO];
                           } completion:nil];
        
    }];

    
    
    
    // ComicMakingViewController
    
}

- (void) setupDefaultsValuesForTopAndBottomAnimatedViews {
    self.captureHolder.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewProgressContainer.alpha = 1.0;
    self.viewProgressContainer.hidden = YES;
    self.cameraPreview.transform = CGAffineTransformIdentity;
    CGRect fr = self.cameraPreview.frame;
    fr.size.height += 72;
    self.cameraPreview.frame = fr;
}


// MARK: - MFMailComposeViewController delegate implementation
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
