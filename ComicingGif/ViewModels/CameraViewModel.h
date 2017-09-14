//
//  CameraViewModel.h
//  ComicingGif
//
//  Created by Com on 23/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCRecorder.h"


#define MAXDURATION		7.0 // 7 seconds video maxim


typedef enum : NSUInteger {
	CameraCaptureModePhoto,
	CameraCaptureModeVideo,
} CameraCaptureMode;


// MARK: - CameraViewModelDelegate definitions
@protocol CameraViewModelDelegate <NSObject>

@optional
- (void)videoProgressingWith:(CGFloat)progress;
- (void)didReceiveFirstFrame:(UIImage *)firstFrameImage;
- (void)finishedGifProcessingWith:(NSError *)error
                           gifURL:(NSURL *)url
                           frames:(NSArray <UIImage *> *)frameImages
                         duration:(CFTimeInterval)duration;
@end


// MARK: - CameraViewModel definitions
@interface CameraViewModel : NSObject
<
SCRecorderDelegate,
SCAssetExportSessionDelegate
>

// MARK: public member variables
@property (nonatomic) SCRecorder *recorder;

@property (nonatomic) NSMutableArray *arrayPhotos;

@property (weak, nonatomic) id<CameraViewModelDelegate> delegate;


// MARK: public methods
- (void)setupRecorderWith:(UIView *)view;

- (void)releaseCamera;

- (void)switchCameraCaptureMode:(CameraCaptureMode)mode;
- (void)changeCamera;

- (BOOL)isRecording;

- (void)startRecord;
- (void)stopRecord;
- (void)resetRecord;

- (void)capturePhotoWithCGRect:(CGRect)rect completionHandler:(void(^)(NSError *))completionHandler;
@end
