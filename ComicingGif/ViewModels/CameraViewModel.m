//
//  CameraViewModel.m
//  ComicingGif
//
//  Created by Com on 23/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CameraViewModel.h"
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
	
	exportSize = view.frame.size;
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
	[self.recorder pause:^{
		[self recordingFinished];
	}];
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

- (void)capturePhoto:(void(^)(NSError *))completionHandler {
	[self switchCameraCaptureMode:CameraCaptureModePhoto];
	
	[self.recorder capturePhoto:^(NSError * _Nullable error, UIImage * _Nullable image) {
		completionHandler(error);
		
		if (!error && image) {
			NSLog(@"captured photo finished successfully");
			[self.arrayPhotos addObject:image];
		}
	}];
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
		
		NSLog(@"exporting video finished successfully");
		[self saveToPhotoLibraryWith:exportSession.outputUrl];
	}];
}

- (void)saveToPhotoLibraryWith:(NSURL *)url {
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


// MARK: - SCRecorder delegate implementations
- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session {
	NSLog(@"finished recording video with maxim duration");
	
	[self recordingFinished];
}


// MARK: - SCAssetExportSessionDelegate delegate implementations
- (void)assetExportSessionDidProgress:(SCAssetExportSession *__nonnull)assetExportSession {
	NSLog(@"exporting video with %.2f %%", assetExportSession.progress);
	
	if ([self.delegate respondsToSelector:@selector(videoProcessingWith:)]) {
		[self.delegate videoProcessingWith:assetExportSession.progress];
	}
}

@end
