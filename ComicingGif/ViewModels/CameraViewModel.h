//
//  CameraViewModel.h
//  ComicingGif
//
//  Created by Com on 23/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SCRecorder/SCRecorder.h>


typedef enum : NSUInteger {
	CameraCaptureModePhoto,
	CameraCaptureModeVideo,
} CameraCaptureMode;


// MARK: - CameraViewModel definitions

@interface CameraViewModel : NSObject
<
SCRecorderDelegate,
SCAssetExportSessionDelegate
>

// MARK: public member variables
@property (nonatomic) SCRecorder *recorder;

@property (nonatomic) NSMutableArray *arrayPhotos;


// MARK: public methods
- (void)setupRecorderWith:(UIView *)view;

- (void)releaseCamera;

- (void)switchCameraCaptureMode:(CameraCaptureMode)mode;
- (void)changeCamera;

- (BOOL)isRecording;

- (void)startRecord;
- (void)stopRecord;
- (void)resetRecord;

- (void)capturePhoto:(void(^)(NSError *))completionHandler;

@end
