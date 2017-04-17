//
//  CameraViewModel.m
//  ComicingGif
//
//  Created by Com on 23/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CameraViewModel.h"
#import "GIFGenerator.h"
#import <Photos/Photos.h>

@interface CameraViewModel()
{
	CGSize exportSize;
}

@end


@implementation CameraViewModel

- (id)init {
	self = [super init];
	
	if (self) {
		self.arrayPhotos = [[NSMutableArray alloc] init];
		
		[self initCameraRecorder];
	}
	
	return self;
}


// MARK: - public recorder initialize & control method
- (void)setupRecorderWith:(UIView *)view {
	__weak id weakSelf = self;
	self.recorder.delegate = weakSelf;
	self.recorder.videoConfiguration.size = view.frame.size;
	self.recorder.previewView = view;
	
	exportSize = view.frame.size;//CGSizeMake(view.frame.size.width * [UIScreen mainScreen].scale, view.frame.size.height * [UIScreen mainScreen].scale);
}

- (void)releaseCamera {
	[self.recorder stopRunning];
}

- (void)switchCameraCaptureMode:(CameraCaptureMode)mode {
	switch (mode) {
		case CameraCaptureModePhoto:
			self.recorder.captureSessionPreset = AVCaptureSessionPresetHigh;
			break;
			
		default:
			self.recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
			break;
	}
}

- (void)changeCamera {
	[self.recorder switchCaptureDevices];
}

- (BOOL)isRecording {
	return self.recorder.isRecording;
}

- (void)startRecord {
	[self switchCameraCaptureMode:CameraCaptureModeVideo];
	[self.arrayPhotos removeAllObjects];
	
	[self.recorder record];
}

- (void)stopRecord {
	if (self.recorder.isRecording) {
		[self.recorder pause:^{
			[self recordingFinished];
		}];
		
	} else {
		[self recordingFinished];
	}
}

- (void)resetRecord {
	if ([self.recorder isRecording]) {
		[self.recorder pause];
	}
	
	if (self.recorder.session) {
		[self.recorder.session cancelSession:nil];
	}
	
	[self.arrayPhotos removeAllObjects];
	
	self.recorder.session = [[SCRecordSession alloc] init];
	self.recorder.session.fileType = AVFileTypeQuickTimeMovie;
}

- (void)capturePhotoWithCGRect:(CGRect)rect completionHandler:(void(^)(NSError *))completionHandler {
	[self switchCameraCaptureMode:CameraCaptureModePhoto];
	
	[self.recorder capturePhoto:^(NSError * _Nullable error, UIImage * _Nullable image) {
		if (!error && image) {
//			NSLog(@"captured photo finished successfully");
//			[self saveImageToPhotoLibrary:image];
			
			UIImage *imageToDisplay = [self imageByScalingAndCroppingForSize:rect.size andImage:image];
			[self.arrayPhotos addObject:imageToDisplay];
		}
		
		completionHandler(error);
	}];
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize andImage:(UIImage *)image{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}
// MARK: - private methods
- (void)initCameraRecorder {
	if (!self.recorder) {
		self.recorder = [[SCRecorder alloc] init];
	}
	
	self.recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
	self.recorder.device = AVCaptureDevicePositionFront;
	self.recorder.maxRecordDuration = CMTimeMake(MAXDURATION * 1000, 1000);
	
	self.recorder.videoConfiguration.enabled = YES;
	self.recorder.videoConfiguration.size = [[UIScreen mainScreen] bounds].size;
	self.recorder.videoConfiguration.scalingMode = AVVideoScalingModeResizeAspectFill;
	self.recorder.videoConfiguration.timeScale = 1.0;
//	self.recorder.videoConfiguration.maxFrameRate = 30;
	
	self.recorder.session = [[SCRecordSession alloc] init];
	self.recorder.session.fileType = AVFileTypeQuickTimeMovie;
	
	[self.recorder startRunning];
}

- (void)recordingFinished {
	if (self.arrayPhotos.count > 0) { // create GIF from captured photos
		[self exportGIFwithPhotos];
		
	} else { // create GIF from recorded video
		[self exportGIFwithVideo];
	}
}

- (void)exportGIFwithPhotos {
	[GIFGenerator generateGIF:self.arrayPhotos delayTime:0.5 progress:^(double progress) {		
		if ([self.delegate respondsToSelector:@selector(videoProgressingWith:)]) {
			[self.delegate videoProgressingWith:(progress)];
		}
	} completed:^(NSError *error, NSURL *url) {
		if ([self.delegate respondsToSelector:@selector(finishedGifProcessingWith:gifURL:)]) {
			[self.delegate finishedGifProcessingWith:error gifURL:url];
		}
	}];
}

- (void)exportGIFwithVideo {
	SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:self.recorder.session.assetRepresentingSegments];
	exportSession.videoConfiguration.enabled = true;
	exportSession.videoConfiguration.size = exportSize;
	exportSession.videoConfiguration.scalingMode = AVVideoScalingModeResizeAspectFill;
	exportSession.videoConfiguration.timeScale = 1.0;
	exportSession.videoConfiguration.sizeAsSquare = false;
	
	exportSession.audioConfiguration.preset = SCPresetHighestQuality;
	exportSession.outputUrl = self.recorder.session.outputUrl;
	exportSession.outputFileType = AVFileTypeMPEG4;
	exportSession.delegate = self;
	exportSession.contextType = SCContextTypeAuto;
	
	[exportSession exportAsynchronouslyWithCompletionHandler:^{
		[self.recorder.session removeAllSegments];
		
		if (exportSession.error) {
			NSLog(@"exporting video failed with %@", exportSession.error.localizedDescription);
			return;
		}
		
		NSLog(@"exporting video finished and generating gif now");
//		[self saveToPhotoLibraryWith:exportSession.outputUrl];
		
		// generate GIF from exported video
		[GIFGenerator generateGIF:exportSession.outputUrl frameCount:0 delayTime:0 progress:^(double progress) {
			if ([self.delegate respondsToSelector:@selector(videoProgressingWith:)]) {
				[self.delegate videoProgressingWith:(progress / 2 + 0.5)];
			}
		} completed:^(NSError *error, NSURL *url) {
			if ([self.delegate respondsToSelector:@selector(finishedGifProcessingWith:gifURL:)]) {
				[self.delegate finishedGifProcessingWith:error gifURL:url];
			}
		}];
		
	}];
}

- (void)saveVideoToPhotoLibraryWith:(NSURL *)url {
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		[PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
	} completionHandler:^(BOOL success, NSError * _Nullable error) {
		if (success) {
			NSLog(@"saved succesfully");
		} else {
			NSLog(@"saved failed with %@", error.localizedDescription);
		}
	}];
}

- (void)saveImageToPhotoLibrary:(UIImage *)image {
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		[PHAssetChangeRequest creationRequestForAssetFromImage:image];
	} completionHandler:^(BOOL success, NSError * _Nullable error) {
		if (success) {
			NSLog(@"saved succesfully");
		} else {
			NSLog(@"saved failed with %@", error.localizedDescription);
		}
	}];
}

- (UIImage *)fixOrientation:(UIImage *)src {
	UIImageOrientation orientation = src.imageOrientation;
	UIGraphicsBeginImageContext(src.size);
	
	[src drawAtPoint:CGPointMake(0, 0)];
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orientation == UIImageOrientationRight) {
		CGContextRotateCTM (context, M_PI_2);
	} else if (orientation == UIImageOrientationLeft) {
		CGContextRotateCTM (context, M_PI_2);
	} else if (orientation == UIImageOrientationDown) {
		// NOTHING
	} else if (orientation == UIImageOrientationUp) {
		CGContextRotateCTM (context, 0);
	}
	
	return UIGraphicsGetImageFromCurrentImageContext();
}


// MARK: - SCRecorder delegate implementations
- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session {
	[self recordingFinished];
}


// MARK: - SCAssetExportSessionDelegate delegate implementations
- (void)assetExportSessionDidProgress:(SCAssetExportSession *__nonnull)assetExportSession {
	if ([self.delegate respondsToSelector:@selector(videoProgressingWith:)]) {
		[self.delegate videoProgressingWith:(assetExportSession.progress / 2)];
	}
}

@end
