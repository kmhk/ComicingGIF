//
//  CropStickerViewController.m
//  CommicMakingPage
//
//  Created by ADNAN THATHIYA on 06/12/15.
//  Copyright (c) 2015 jistin. All rights reserved.
//

#import "CropStickerViewController.h"
#import "MZCroppableView.h"
#import "AVCamPreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Image.h"
#import "CropRegisterViewController.h"
#import "UIImage+resize.h"
#import "UIImage+Image.h"
#import "UIBezierPath-Points.h"
#import "UIImage+ImageCompress.h"
#import "UIImage+Trim.h"
#import "AppConstants.h"
#import "InstructionView.h"

//#import "SettingViewController.h"

//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//NSString *const SKeySticker = @"Sticker";

//#define IS_IOS8     ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;


@interface CropStickerViewController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
InstructionViewDelegate,
MZCroppableViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *viewCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnCrop;
@property (weak, nonatomic) IBOutlet UIImageView *imgvCrop;
@property (weak, nonatomic) IBOutlet UIView *viewCrop;

@property (weak, nonatomic) IBOutlet UIView *viewBlackBackground;
@property (weak, nonatomic) IBOutlet AVCamPreviewView *cameraPreview;
@property (weak, nonatomic) IBOutlet UIButton *btnUndo;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnImagePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnDoneCroping;
@property (weak, nonatomic) IBOutlet UIButton *btnCameraReverse;

@property (strong, nonatomic) MZCroppableView *mzCroppableView;
@property (nonatomic) BOOL isFrontCameraOn;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic) CGFloat lastScale;

// Camera Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *cameraPreviewLayer;

// Camera Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;
@property (nonatomic, strong) CropRegisterViewController *parentViewController;

@property CGPoint imgvCropCenter;

@property (nonatomic) BOOL isTakePicture;
@property (nonatomic) CGRect frameImgvCrop;

//@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGesture;
//@property (nonatomic) CGFloat lastScale;

@end

@implementation CropStickerViewController

@synthesize imgvCrop,btnCrop,mzCroppableView,cameraPreview,deviceAuthorized,sessionQueue,viewCrop,imgvCropCenter,isFrontCameraOn;

@synthesize btnBack,btnCamera,btnDoneCroping,btnImagePicker,btnUndo,btnCameraReverse, isTakePicture,viewBlackBackground;


#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.parentViewController)
    {
    #if TARGET_OS_SIMULATOR
        self.isRegView = NO;
    #else
        self.isRegView = YES;
    #endif
    }
    [self preparView];
    
    dispatch_async([self sessionQueue], ^
                   {
                       [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
                       [self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:CapturingStillImageContext];
                       [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
                       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
                       
                       __weak CropStickerViewController *weakSelf = self;
                       
                       [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
                           CropStickerViewController *strongSelf = weakSelf;
                           dispatch_async([strongSelf sessionQueue], ^{
                               // Manually restarting the session since it must have been stopped due to an error.
                               [[strongSelf session] startRunning];
                           });
                           
                       }]];
                       
                       [[self session] startRunning];
                   });
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isRegView == NO)
    {
        // open slide 5 Instruction
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"Do some work");
            
             if ([InstructionView getBoolValueForSlide:kInstructionSlide5] == NO)
             {
            InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
            instView.delegate = self;
            [instView showInstructionWithSlideNumber:SlideNumber5 withType:InstructionBubbleType];
            [instView setTrueForSlide:kInstructionSlide5];
            
            [self.view addSubview:instView];
             }
        });
        
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    dispatch_async([self sessionQueue], ^{
        [[self session] stopRunning];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
        
        [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        [self removeObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" context:CapturingStillImageContext];
        [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
    });
    
    
    
}

#pragma mark - UIView Methods
- (void)preparView
{
    imgvCropCenter = imgvCrop.center;
    
    btnUndo.enabled = NO;
    btnCrop.enabled = NO;
    btnDoneCroping.enabled = NO;
    
    //   cameraPreview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.8, 1.0);
    if (!self.isRegView)
    {
        if (IS_IPHONE_5)
        {
            imgvCrop.frame = CGRectMake(6, 41, 307, 458);
            viewBlackBackground.layer.cornerRadius = 21;
        }
        else if (IS_IPHONE_6)
        {
            imgvCrop.frame = CGRectMake(6, 48, 362, 538);
            viewBlackBackground.layer.cornerRadius = 26;
        }
        else if (IS_IPHONE_6P)
        {
            imgvCrop.frame = CGRectMake(7.5, 52.95, 398.5, 593);
            viewBlackBackground.layer.cornerRadius = 28;
        }
        
        self.frameImgvCrop = imgvCrop.frame;
        viewBlackBackground.frame = imgvCrop.frame;
        cameraPreview.frame = imgvCrop.frame;
        [self prepareCameraView];
    }
    else
    {
        self.frameImgvCrop = imgvCrop.frame;
        
        // open slide F Instruction
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if ([InstructionView getBoolValueForSlide:kInstructionSlideF] == NO)
            {
                InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                instView.delegate = self;
                [instView showInstructionWithSlideNumber:SlideNumber7 withType:InstructionGIFType];
                [instView setTrueForSlide:kInstructionSlideF];
                [self.view addSubview:instView];
            }
            
            
            
        });
        
        
        [self prepareCameraView];
    #if !(TARGET_OS_SIMULATOR)
        [self btnCameraReverseTap:nil];
    #endif
    }
}

- (void)addPinchGesture
{
    self.pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchDone:)];
    cameraPreview.userInteractionEnabled = YES;
    [cameraPreview addGestureRecognizer:self.pinchGesture];
}

- (IBAction)pinchDone:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        // Reset the last scale, necessary if there are multiple objects with different scales
        _lastScale = [gestureRecognizer scale];
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        
        [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        
        CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 2.0;
        const CGFloat kMinScale = 1.0;
    
        CGFloat newScale = 1 -  (_lastScale - [gestureRecognizer scale]);
        
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        
        CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
        
        [gestureRecognizer view].transform = transform;
        
        _lastScale = [gestureRecognizer scale];  // Store the previous scale factor for the next pinch gesture call
    }
}
- (void)prepareCameraView
{
    [self addPinchGesture];
    
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    
    // Setup the preview view
    [cameraPreview setSession:session];
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];
    
    dispatch_queue_t sessionQueue1 = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue1];
    
    dispatch_async(sessionQueue1, ^{
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [CropStickerViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:videoDeviceInput])
        {
            [session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Why are we dispatching this to the main queue?
                // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
                // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                
                [(AVCaptureVideoPreviewLayer *)[cameraPreview layer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//                [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            });
        }
        
        AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:audioDeviceInput])
        {
            [session addInput:audioDeviceInput];
        }
        
        /*AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        if ([session canAddOutput:movieFileOutput])
        {
            [session addOutput:movieFileOutput];
            
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if ([connection isVideoStabilizationSupported])
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeStandard;
            
            [self setMovieFileOutput:movieFileOutput];
        }*/
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ([session canAddOutput:stillImageOutput])
        {
            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
            
            //stillImageOutput.highResolutionStillImageOutputEnabled = NO;
            
            [session addOutput:stillImageOutput];
            
            
            
            [self setStillImageOutput:stillImageOutput];
        }
    });
    
}

#pragma mark - Camera Methods
- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    // Disable autorotation of the interface when recording is in progress.
    return ![self lockInterfaceRotation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [[(AVCaptureVideoPreviewLayer *)[cameraPreview layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CapturingStillImageContext)
    {
        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
        
        if (isCapturingStillImage)
        {
            [self runStillImageCaptureAnimation];
        }
    }
    else if (context == SessionRunningAndDeviceAuthorizedContext)
    {
        BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        
        
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)subjectAreaDidChange:(NSNotification *)notification
{
    CGPoint devicePoint = CGPointMake(.5, .5);
    
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

#pragma mark - Camera File Output Delegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error)
        NSLog(@"%@", error);
    
    [self setLockInterfaceRotation:NO];
    
    // Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens sometime after this method returns.
    UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
    [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
    
    [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error)
     {
         if (error)
             NSLog(@"%@", error);
         
         [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
         
         if (backgroundRecordingID != UIBackgroundTaskInvalid)
             [[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
     }];
}

#pragma mark - Camera Device Configuration

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = [[self videoDeviceInput] device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

#pragma mark - Camera UI
- (void)runStillImageCaptureAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[cameraPreview layer] setOpacity:0.0];
                       
                       [UIView animateWithDuration:.25 animations:^{
                           [[cameraPreview layer] setOpacity:1.0];
                       }];
                   });
}

- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted)
        {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"AVCam!"
                                            message:@"AVCam doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}


#pragma mark - UIImagePickerControllerDelegate Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"CropSticker" Action:@"UploadPicture" Label:@""];
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
         
         //  CGFloat width = selectedImage.size.width / 3;
         //  CGFloat height = selectedImage.size.height / 3;
         
         //  UIImage *compressImage = [selectedImage compressWithMaxSize:CGSizeMake(width, height) andQuality:1];
         
         //         NSData *imageData = UIImageJPEGR epresentation(selectedImage, 0);
         
         //     imgvCrop.image =  [self compressImage:selectedImage];
         //      imgvCrop.image = selectedImage;
//         imgvCrop.contentMode = UIViewContentModeScaleAspectFit;
         //         UIImage *image = [[UIImage alloc] initWithData:imageData];;
         //
         //         UIImage *small = [UIImage imageWithCGImage:image.CGImage scale:0 orientation:image.imageOrientation];
         
         //  UIImage *compressImage = [self compressImage:selectedImage compressRatio:0 maxCompressRatio:0];
         
         imgvCrop.image = selectedImage;
         cameraPreview.hidden = YES;
         btnCrop.enabled = YES;
         btnCameraReverse.hidden = YES;
         btnCamera.selected = YES;
         btnDoneCroping.enabled = self.isRegView?YES:NO;
         [self setImageViewSize];
     }];
}
- (UIImage *)compressImage:(UIImage *)image compressRatio:(CGFloat)ratio maxCompressRatio:(CGFloat)maxRatio
{
    
    //We define the max and min resolutions to shrink to
    int MIN_UPLOAD_RESOLUTION = 1136 * 640;
    int MAX_UPLOAD_SIZE = 300;
    
    float factor;
    float currentResolution = image.size.height * image.size.width;
    
    //We first shrink the image a little bit in order to compress it a little bit more
    if (currentResolution > MIN_UPLOAD_RESOLUTION) {
        factor = sqrt(currentResolution / MIN_UPLOAD_RESOLUTION) * 2;
        image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
    }
    
    //Compression settings
    CGFloat compression = ratio;
    CGFloat maxCompression = maxRatio;
    
    //We loop into the image data to compress accordingly to the compression ratio
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > MAX_UPLOAD_SIZE && compression > maxCompression) {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    //Retuns the compressed image
    return [[UIImage alloc] initWithData:imageData];
}
- (UIImage*)scaleDown:(UIImage*)image withSize:(CGSize)newSize
{
	UIImage* scaledImage;
	
	@autoreleasepool {
    //We prepare a bitmap with the new size
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    //Draws a rect for the image
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //We set the scaled image from the context
    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	}
	
    return scaledImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImageViewSize
{
    float widthRatio = self.imgvCrop.bounds.size.width / self.imgvCrop.image.size.width;
    float heightRatio = self.imgvCrop.bounds.size.height / self.imgvCrop.image.size.height;
    float scale = MIN(widthRatio, heightRatio);
    float imageWidth = scale * self.imgvCrop.image.size.width;
    float imageHeight = scale * self.imgvCrop.image.size.height;
    
    self.imgvCrop.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    self.imgvCrop.center = imgvCropCenter;
}

#pragma mark - Events Methods
- (IBAction)btnCropTap:(id)sender
{
    imgvCrop.hidden = NO;
    btnUndo.enabled = YES;
    btnDoneCroping.enabled = YES;
    btnCrop.userInteractionEnabled = YES;
    btnImagePicker.enabled = NO;
    [btnCrop setImage:[UIImage imageNamed:@"scissors-icon-gray"] forState:UIControlStateNormal];
    
    CGRect rect1 = CGRectMake(0, 0, imgvCrop.image.size.width, imgvCrop.image.size.height);
    
    CGRect rect2 = imgvCrop.frame;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"tappEnder"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [imgvCrop setFrame:[MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2 ]];


    [mzCroppableView removeFromSuperview];
    mzCroppableView = [[MZCroppableView alloc] initWithImageView:imgvCrop];
    mzCroppableView.delegate = self;
    [self.view addSubview:mzCroppableView];
    
    [self bringToFrontAllButtons];
}

- (IBAction)btnCameraTap:(id)sender
{
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"CropSticker" Action:@"Camera" Label:@""];
    
    if (btnCamera.isSelected)
    {
        btnCamera.selected = NO;
        
        imgvCrop.image = nil;
        cameraPreview.hidden = NO;
        btnCameraReverse.hidden = NO;
        
        imgvCrop.frame = self.frameImgvCrop;
        
        cameraPreview.transform = CGAffineTransformIdentity;
        cameraPreview.frame = imgvCrop.frame;
        
        [mzCroppableView removeFromSuperview];
        
        btnUndo.enabled = NO;
        btnCrop.enabled = NO;
        btnDoneCroping.enabled = self.isRegView?YES:NO;
    }
    else
    {
        btnCamera.selected = YES;
        btnDoneCroping.enabled = self.isRegView?YES:NO;
        dispatch_async([self sessionQueue], ^{
            // Update the orientation on the still image output video connection before capturing.
            [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[cameraPreview layer] connection] videoOrientation]];
            
            // Flash set to Auto for Still Capture
            [CropStickerViewController setFlashMode:AVCaptureFlashModeAuto forDevice:[[self videoDeviceInput] device]];
            
            // Capture a still image.
            [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                
                if (imageDataSampleBuffer)
                {
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    
                    if (self.isRegView)
                    {
                       CGRect cropRects = [imgvCrop convertRect:CGRectMake(0, 40, CGRectGetWidth(imgvCrop.frame), CGRectGetHeight(imgvCrop.frame)) toView:cameraPreview];
                        CGFloat factor = (image.size.width * image.scale) / CGRectGetWidth(self.view.frame);
                        
                        cropRects.origin.x *= factor;
                        cropRects.origin.y *= factor;
                        
                        cropRects.size.width  *= factor;
                        cropRects.size.height *= factor;
                        
                        UIImage *cropedImage = [image cropedImagewithCropRect:cropRects];
                        NSLog(@"%ld",(long)cropedImage.imageOrientation);
                        
                        if (isFrontCameraOn)
                        {
                            UIImage *flippedImage = [UIImage imageWithCGImage:cropedImage.CGImage
                                                                        scale:cropedImage.scale
                                                                  orientation:UIImageOrientationUpMirrored];
                            
                            imgvCrop.image =  flippedImage;
                            
                        }
                        else
                        {
                            imgvCrop.image = cropedImage;
                        }
                        
                      //  imgvCrop.image = [UIImage ScaletoFill:image toSize:imgvCrop.frame.size];
                      
                        imgvCrop.contentMode = UIViewContentModeScaleAspectFit;
                        
                    }
                    else
                    {
                        if (isFrontCameraOn)
                        {
                           CGRect cropRects = [imgvCrop convertRect:imgvCrop.frame toView:cameraPreview];
                            
                            CGFloat factor = (image.size.width * image.scale) / CGRectGetWidth(self.view.frame);
                            
                            cropRects.origin.x *= factor;
                            cropRects.origin.y *= factor;
                            
                            cropRects.size.width  *= factor;
                            cropRects.size.height *= factor;
                            
                            UIImage *cropedImage = [image cropedImagewithCropRect:cropRects];
                            
                            
                            UIImage *flippedImage = [UIImage imageWithCGImage:cropedImage.CGImage
                                                                scale:cropedImage.scale
                                                          orientation:UIImageOrientationUpMirrored];
                            
                            imgvCrop.image =  flippedImage;
                            imgvCrop.contentMode = UIViewContentModeScaleToFill;
                        }
                        else
                        {
                            CGRect cropRects = [imgvCrop convertRect:imgvCrop.frame toView:cameraPreview];
                            
                            CGFloat factor = (image.size.width * image.scale) / CGRectGetWidth(self.view.frame);
                            
                            cropRects.origin.x *= factor;
                            cropRects.origin.y *= factor;
                            
                            cropRects.size.width  *= factor;
                            cropRects.size.height *= factor;
                            
                            UIImage *cropedImage = [image cropedImagewithCropRect:cropRects];
                            
                            imgvCrop.image = cropedImage;
                            imgvCrop.contentMode = UIViewContentModeScaleAspectFill;
                            imgvCrop.clipsToBounds = YES;

                          
                        }
                    }
                    
                    
                    cameraPreview.hidden = YES;
                    btnCrop.enabled = YES;
                    btnCameraReverse.hidden = YES;
                    
                    
                    if (self.isRegView == NO)
                    {
                        // open slide 6 Instruction
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            NSLog(@"Do some work");
                            
                            if ([InstructionView getBoolValueForSlide:kInstructionSlide6] == NO)
                            {
                            InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                            instView.delegate = self;
                            [instView showInstructionWithSlideNumber:SlideNumber6 withType:InstructionBubbleType];
                            [instView setTrueForSlide:kInstructionSlide6];
                            
                            [self.view addSubview:instView];
                             }
                        });
                    }
                }
            }];
            
        });
    }
}

UIImageOrientation mirroredImageOrientation(UIImageOrientation orientation) {
    switch(orientation) {
        case UIImageOrientationUp: return UIImageOrientationUpMirrored;
        case UIImageOrientationDown: return UIImageOrientationDownMirrored;
        case UIImageOrientationLeft: return UIImageOrientationLeftMirrored;
        case UIImageOrientationRight: return UIImageOrientationRightMirrored;
        case UIImageOrientationUpMirrored: return UIImageOrientationUp;
        case UIImageOrientationDownMirrored: return UIImageOrientationDown;
        case UIImageOrientationLeftMirrored: return UIImageOrientationLeft;
        case UIImageOrientationRightMirrored: return UIImageOrientationRight;
        default: return orientation;
    }
}

-(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIView*)imageView
{
    float imageRatio = image.size.width / image.size.height;
    
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio)
    {
        float scale = imageView.frame.size.height / image.size.height;
        
        float width = scale * image.size.width;
        
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else
    {
        float scale = imageView.frame.size.width / image.size.width;
        
        float height = scale * image.size.height;
        
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}
- (IBAction)btnCameraReverseTap:(id)sender
{
    [UIView transitionWithView:cameraPreview
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                        dispatch_async([self sessionQueue], ^{
                            AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
                            AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
                            AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
                            
                            switch (currentPosition)
                            {
                                case AVCaptureDevicePositionUnspecified:
                                    preferredPosition = AVCaptureDevicePositionBack;
                                    isFrontCameraOn = NO;
                                    break;
                                case AVCaptureDevicePositionBack:
                                    preferredPosition = AVCaptureDevicePositionFront;
                                    isFrontCameraOn = YES;
                                    break;
                                case AVCaptureDevicePositionFront:
                                    preferredPosition = AVCaptureDevicePositionBack;
                                    isFrontCameraOn = NO;
                                    break;
                            }
                            
                            AVCaptureDevice *videoDevice = [CropStickerViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
                            AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
                            
                            [[self session] beginConfiguration];
                            
                            [[self session] removeInput:[self videoDeviceInput]];
                            if ([[self session] canAddInput:videoDeviceInput])
                            {
                                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
                                
                                [CropStickerViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
                                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
                                
                                [[self session] addInput:videoDeviceInput];
                                [self setVideoDeviceInput:videoDeviceInput];
                            }
                            else
                            {
                                [[self session] addInput:[self videoDeviceInput]];
                            }
                            
                            [[self session] commitConfiguration];
                            
                            dispatch_async(dispatch_get_main_queue(), ^
                                           {
                                               
                                           });
                        });
                        
                    } completion:nil];
    
}

- (IBAction)btnImagePickerTap:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    [picker setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    [self presentViewController:picker animated:YES completion:Nil];
}

- (IBAction)btnBackTap:(id)sender
{
    //[self dismissViewControllerAnimated:NO completion:nil];
    if (self.isRegView)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.delegate cropStickerViewControllerWithCropCancel:nil];
        
        if (self.delegate == nil && btnCamera.isSelected) {
            if (self.parentViewController != nil) {
                [self btnCameraTap:nil];
            }
        }
    }
}

- (IBAction)btnUndoTap:(id)sender
{
    if (mzCroppableView != nil)
    {
        [mzCroppableView removeFromSuperview];
    }
    
    btnCrop.userInteractionEnabled = YES;
    
    [btnCrop setImage:[UIImage imageNamed:@"scissors-icon-white"] forState:UIControlStateNormal];
    
    btnUndo.enabled = NO;
    btnDoneCroping.enabled = NO;
    btnImagePicker.enabled = YES;
}

- (IBAction)btnCropDoneTap:(id)sender
{
    if (mzCroppableView != nil && [[mzCroppableView.croppingPath points] count]  > 0)
    {
        mzCroppableView.camImageView = imgvCrop;
        
        // add this lines
        NSLog(@"==1");
        
        [AppHelper showHUDLoader:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Call your function or whatever work that needs to be done
            //Code in this part is run on a background thread
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Stop your activity indicator or anything else with the GUI
                //Code here is run on the main thread
                
                //Not sure is correct logic.. But sorry no other option 
//                if (imgvCrop.image.size.width > 1080) {
//                    //Just just rezie it
//                    NSData* data = UIImageJPEGRepresentation(imgvCrop.image,0.2);
//                    UIImage *compressedimage = [[UIImage alloc] initWithData:data];
//                    imgvCrop.image = [UIImage ScaletoFill:compressedimage toSize:CGSizeMake(1080, 1440)];
//                }
                
                UIImageView* temImageView = imgvCrop;
                temImageView.image = [UIImage fixrotation:temImageView.image];
                UIImage *cropedImageWithoutBorder = [[UIImage alloc] init];
                UIImage *cropedImageWithBorder = [mzCroppableView deleteBackgroundOfImageWithBorder:temImageView withOutBorderImage:&cropedImageWithoutBorder];
                UIImage *cropedImage  = [self imageWithShadowForImage:cropedImageWithBorder];
                cropedImage =  [cropedImage imageByTrimmingTransparentPixelsRequiringFullOpacity:NO trimTop:YES];
                cropedImageWithoutBorder = [cropedImageWithoutBorder imageByTrimmingTransparentPixelsRequiringFullOpacity:NO trimTop:YES];
                [AppHelper showHUDLoader:NO];
                
                if (cropedImageWithoutBorder)
                {
                    // save sticker here....
                    
                    UIImageView *imageView = [[UIImageView alloc] init];
                    
                    if (IS_IPHONE_5)
                    {
                        imageView.frame = CGRectMake(0, 0, 320, 320);
                    }
                    else if (IS_IPHONE_6)
                    {
                        imageView.frame = CGRectMake(0, 0, 375, 375);
                    }
                    else if (IS_IPHONE_6P)
                    {
                        imageView.frame = CGRectMake(0, 0, 414, 414);
                    }
                    else
                    {
                        imageView.frame = CGRectMake(0, 0, 320, 320);
                    }
                    
                    imageView.image = cropedImageWithoutBorder;
                    
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    
//                    float widthRatio = imageView.bounds.size.width / imageView.image.size.width;
//                    float heightRatio = imageView.bounds.size.height / imageView.image.size.height;
//                    float scale = MIN(widthRatio, heightRatio);
//                    float imageWidth = scale * imageView.image.size.width;
//                    float imageHeight = scale * imageView.image.size.height;
                    
//                    imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
                    imageView.center = self.view.center;
                    NSLog(@"==19");
                    
                    if (self.delegate == nil)
                    {
                        if (self.parentViewController != nil)
                        {
                    
                            [self.parentViewController cropStickerViewController_:nil didSelectDoneWithImage:imageView];
                        }
                    }
                    else
                    {
                        [self.delegate cropStickerViewController:nil didSelectDoneWithImage:imageView withBorderImage:cropedImage];
                    }
                    NSLog(@"==20");
                    NSLog(@"btnCropDoneTap END");
                }
            });
        });
    }
    else if(self.isRegView)
    {
        UIImage* reSizeImage = [UIImage ScaletoFill:imgvCrop.image toSize:CGSizeMake(112, 112)];
        UIImage* imgRounded = [UIImage makeRoundedImage:reSizeImage radius:112/2];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, 112, 112);
        
        imageView.image = imgRounded;
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    
        if (self.delegate == nil) {
            if (self.parentViewController != nil) {
                [self.parentViewController cropStickerViewController_:nil didSelectDoneWithImage:imageView];
            }
        }
    }
}

#pragma mark - Helper Methods

- (UIImage*)imageWithShadow:(UIImage*)originalImage BlurSize:(float)blurSize {
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, originalImage.size.width + (blurSize*2), originalImage.size.height + (blurSize*2), CGImageGetBitsPerComponent(originalImage.CGImage), 0, colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(0, 0), blurSize, [UIColor blackColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(blurSize, blurSize, originalImage.size.width, originalImage.size.height), originalImage.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    
    return shadowedImage;
}

-(UIImage*)imageWithShadowForImage:(UIImage *)initialImage {
    
    CGFloat blur;
    
    if (IS_IPHONE_5)
    {
        blur = 50;
    }
    else if (IS_IPHONE_6)
    {
        blur = 60;
    }
    else if (IS_IPHONE_6P)
    {
        blur = 80;
    }
    else
    {
        blur = 50;
    }
    
    blur = 10;

    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, initialImage.size.width + 10, initialImage.size.height + 10, CGImageGetBitsPerComponent(initialImage.CGImage), 0, colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(0,0), blur, [UIColor blackColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(0, 0, initialImage.size.width, initialImage.size.height), initialImage.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    return shadowedImage;
}


- (UIImage *)makeIconStroke:(UIImage *)image
{
    CGImageRef originalImage = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       CGImageGetWidth(originalImage),
                                                       CGImageGetHeight(originalImage),
                                                       8,
                                                       CGImageGetWidth(originalImage)*4,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), originalImage);
    
    CGImageRef finalMaskImage = [self createMaskWithImageAlpha:bitmapContext];
    
    UIImage *result = [UIImage imageWithCGImage:finalMaskImage];
    
    CGContextRelease(bitmapContext);
    CGImageRelease(finalMaskImage);
	
	UIImage *coloredImg;
	
	@autoreleasepool {
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(result.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [[UIColor whiteColor] setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, result.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, result.size.width, result.size.height);
    CGContextDrawImage(context, rect, result.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, result.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	}
	
    //return the color-burned image
    return coloredImg;
    
}

- (CGImageRef)createMaskWithImageAlpha:(CGContextRef)originalImageContext {
    
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(originalImageContext);
    
    float width = CGBitmapContextGetBytesPerRow(originalImageContext) / 4;
    float height = CGBitmapContextGetHeight(originalImageContext);
    
    int strideLength = ceil(width * 1);
    unsigned char * alphaData = (unsigned char * )calloc(strideLength * height, 1);
    CGContextRef alphaOnlyContext = CGBitmapContextCreate(alphaData,
                                                          width,
                                                          height,
                                                          8,
                                                          strideLength,
                                                          NULL,
                                                          kCGImageAlphaOnly);
    
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            unsigned char val = data[y*(int)width*4 + x*4 + 3];
            val = 255 - val;
            alphaData[y*strideLength + x] = val;
        }
    }
    
    CGImageRef alphaMaskImage = CGBitmapContextCreateImage(alphaOnlyContext);
    CGContextRelease(alphaOnlyContext);
    free(alphaData);
    
    // Make a mask
    CGImageRef finalMaskImage = CGImageMaskCreate(CGImageGetWidth(alphaMaskImage),
                                                  CGImageGetHeight(alphaMaskImage),
                                                  CGImageGetBitsPerComponent(alphaMaskImage),
                                                  CGImageGetBitsPerPixel(alphaMaskImage),
                                                  CGImageGetBytesPerRow(alphaMaskImage),
                                                  CGImageGetDataProvider(alphaMaskImage),     NULL, false);
    CGImageRelease(alphaMaskImage);
    
    return finalMaskImage;
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

- (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second
{
    // get size of the second image
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    float offsetwt,offsetht,offset;
    
    offset=20;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        offset=offset/2;
    }
    offsetht=(secondHeight   * (secondWidth+offset)) /secondWidth;
    offsetwt=secondWidth+offset;
    
    // build merged size
    CGSize mergedSize = CGSizeMake(offsetwt,offsetht);
	
	UIImage *newImage;
	
	@autoreleasepool {
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    //Draw images onto the context
    [first drawInRect:CGRectMake(0, 0, offsetwt, offsetht)];
    [second drawInRect:CGRectMake(offset/2, offset/2, secondWidth, secondHeight) blendMode:kCGBlendModeNormal alpha:1.0];
    
    // assign context to new UIImage
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
	}
	
    return  newImage;
}

- (void)bringToFrontAllButtons
{
    [self.view bringSubviewToFront:btnDoneCroping];
    [self.view bringSubviewToFront:btnCamera];
    [self.view bringSubviewToFront:btnBack];
    [self.view bringSubviewToFront:btnCrop];
    [self.view bringSubviewToFront:btnDoneCroping];
    [self.view bringSubviewToFront:btnImagePicker];
    [self.view bringSubviewToFront:btnUndo];
}

- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
	
	UIImage *newImage;
	
	@autoreleasepool {
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	}
	
    return newImage;
}

- (UIImage *)compressImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    
    float maxHeight = 1136; //new max. height for image
    float maxWidth = 640; //new max. width for image

    
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 1; //50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    
    NSLog(@"Actual height : %f and Width : %f",actualHeight,actualWidth);
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
	
	NSData *imageData;
	
	@autoreleasepool {
	UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
	}
	
    return [UIImage imageWithData:imageData];
}
-(UIImage*)rotateUIImage:(UIImage*)src {
    
    // No-op if the orientation is already correct
    if (src.imageOrientation == UIImageOrientationUp) return src ;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (src.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, src.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, src.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (src.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, src.size.width, src.size.height,
                                             CGImageGetBitsPerComponent(src.CGImage), 0,
                                             CGImageGetColorSpace(src.CGImage),
                                             CGImageGetBitmapInfo(src.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (src.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,src.size.height,src.size.width), src.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,src.size.width,src.size.height), src.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - InstructionViewDelegate Methods
- (void)didCloseInstructionViewWith:(InstructionView *)view withClosedSlideNumber:(SlideNumber)number
{
    [view removeFromSuperview];
    
    if (number == SlideNumber6)
    {
        // open slide 7 Instruction
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"Do some work");
            
             if ([InstructionView getBoolValueForSlide:kInstructionSlide7] == NO)
             {
            InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
            instView.delegate = self;
            [instView showInstructionWithSlideNumber:SlideNumber7 withType:InstructionGIFType];
            [instView setTrueForSlide:kInstructionSlide7];
            
            [self.view addSubview:instView];
             }
        });

    }
}

#pragma mark - MZCroppableView Methods
-(void)didFinishedTouch
{
    if (_isRegView == NO)
    {
        // open slide 8 Instruction
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"Do some work");
            
            if ([InstructionView getBoolValueForSlide:kInstructionSlide8] == NO)
            {
                InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                instView.delegate = self;
                [instView showInstructionWithSlideNumber:SlideNumber8 withType:InstructionBubbleType];
                [instView setTrueForSlide:kInstructionSlide8];
                
                [self.view addSubview:instView];
            }
        });

    }
}

@end
