//
//  GIFGenerator.m
//  ComicingGif
//
//  Created by Com on 25/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "GIFGenerator.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>


// MARK: -
@interface GIFGenerator()
{
	AVURLAsset *asset;
	double duration;
	
	ProgressHandler progressHandler;
	CompletionHandler completedHandler;
	
	NSInteger frameCount;
	double delayPerFrame;
	
	NSMutableArray *arrayFrames;
}
@end


// MARK: -
@implementation GIFGenerator

// MARK: - global static methods
+ (void)generateGIF:(NSURL *)videoURL frameCount:(NSInteger)count delayTime:(double)delay
		   progress:(ProgressHandler)progressing
		  completed:(CompletionHandler)completed
{
	GIFGenerator *generator = [[GIFGenerator alloc] init:videoURL frameCount:count delayTime:delay
												progress:progressing completed:completed];
	
	[generator createGifFromVideo];
}

+ (void)generateGIF:(NSArray *)images delayTime:(double)delay
		   progress:(ProgressHandler)progressing
		  completed:(CompletionHandler)completed
{
	GIFGenerator *generator = [[GIFGenerator alloc] init:images delayTime:delay
												progress:progressing completed:completed];
	
	[generator createGifWithImages];
}


// MARK: - initialize methods
- (id)init {
	self = [super init];
	if (self) {
		progressHandler = nil;
		completedHandler = nil;
		
		arrayFrames = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)init:(NSURL *)videoURL  frameCount:(NSInteger)count delayTime:(double)delay
  progress:(ProgressHandler)progress completed:(CompletionHandler)completed
{
	self = [super init];
	if (self) {
		frameCount = count;
		delayPerFrame = delay;
		
		asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
		duration = asset.duration.value / asset.duration.timescale;
		
		if (count < 1) {
			frameCount = duration * 25;
		} else {
			frameCount = count;
		}
		
		if (delay == 0) {
			delayPerFrame = duration / (double)frameCount;
		} else {
			delayPerFrame = delay;
		}
		
		progressHandler = progress;
		completedHandler = completed;
	}
	
	return self;
}

- (id)init:(NSArray *)images delayTime:(double)delay
  progress:(ProgressHandler)progress completed:(CompletionHandler)completed
{
	self = [super init];
	if (self) {
		frameCount = images.count;
		
		if (delay == 0) {
			delayPerFrame = 1.0;
		} else {
			delayPerFrame = delay;
		}
		
		progressHandler = progress;
		completedHandler = completed;
		
		arrayFrames = [[NSMutableArray alloc] initWithArray:images];
	}
	
	return self;
}


// MARK: - private methods to process GIF
- (void)createGifWithImages {
	[NSThread detachNewThreadWithBlock:^{
		NSDictionary *fileProperties = @{
										 (__bridge id)kCGImagePropertyGIFDictionary: @{
												 (__bridge id)kCGImagePropertyGIFLoopCount: @0 // 0 means loop forever
												 },
										 (__bridge id)kCGImagePropertyGIFHasGlobalColorMap: @YES
										 };
		
		NSDictionary *frameProperties = @{
										  (__bridge id)kCGImagePropertyGIFDictionary: @{
												  (__bridge id)kCGImagePropertyGIFDelayTime: [NSNumber numberWithFloat:delayPerFrame] //float (not double!) in seconds
												  }
										  };
		
		// create gif file
		NSString *fileName = [NSString stringWithFormat:@"%@.gif", [[NSDate date] description]];
		NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
		
		CGImageDestinationRef dest = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, frameCount, nil);
		if (!dest) {
			[self fireError:[NSError errorWithDomain:@"gif create failed" code:100 userInfo:nil]];
			return;
		}
		
		for (int i = 0; i < frameCount; i ++) {
			// add frame image to the gif
			UIImage *img = arrayFrames[i];
			CGImageDestinationAddImage(dest, img.CGImage, (__bridge CFDictionaryRef)frameProperties);
			
			[self progressing:(1.0 / frameCount * i)];
		}
		
		CGImageDestinationSetProperties(dest, (__bridge CFDictionaryRef)fileProperties);
		
		// finalize the gif
		if (!CGImageDestinationFinalize(dest)) {
			[self fireError:[NSError errorWithDomain:@"finalized gif failed" code:100 userInfo:nil]];
		}
		CFRelease(dest);
		
		[self finished:fileURL];
	}];
}

- (void)createGifFromVideo {
	[NSThread detachNewThreadWithBlock:^{
		NSDictionary *fileProperties = @{
										 (__bridge id)kCGImagePropertyGIFDictionary: @{
												 (__bridge id)kCGImagePropertyGIFLoopCount: @0 // 0 means loop forever
												 },
										 (__bridge id)kCGImagePropertyGIFHasGlobalColorMap: @YES
										 };
		
		NSDictionary *frameProperties = @{
										  (__bridge id)kCGImagePropertyGIFDictionary: @{
												  (__bridge id)kCGImagePropertyGIFDelayTime: [NSNumber numberWithFloat:delayPerFrame] //float (not double!) in seconds
												  }
										  };
		
		// ensure the source media is a valid file
		if ([asset tracksWithMediaCharacteristic:AVMediaCharacteristicVisual].count <= 0) {
			[self fireError:[NSError errorWithDomain:@"wrong video" code:100 userInfo:nil]];
			return;
		}
		
		// create gif file
		NSString *fileName = [NSString stringWithFormat:@"%@.gif", [[NSDate date] description]];
		NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
		
		CGImageDestinationRef dest = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, frameCount, nil);
		if (!dest) {
			[self fireError:[NSError errorWithDomain:@"gif create failed" code:100 userInfo:nil]];
			return;
		}
		
		// retreive frame from video & add it to the gif file
		AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
		
		imgGenerator.appliesPreferredTrackTransform = YES;
		imgGenerator.requestedTimeToleranceAfter = CMTimeMakeWithSeconds(0.01, 600);
		imgGenerator.requestedTimeToleranceBefore = CMTimeMakeWithSeconds(0.01, 600);
		
		for (int i = 0; i < frameCount; i ++) {
			double second = duration * (double)i / (double)frameCount;
			CMTime time = CMTimeMakeWithSeconds(second, 600);
			
			NSError *error;
			CGImageRef imgRef = [imgGenerator copyCGImageAtTime:time actualTime:nil error:&error];
			
			// add frame image to the gif
			CGImageDestinationAddImage(dest, imgRef, (__bridge CFDictionaryRef)frameProperties);
			
			[self progressing:(1.0 / frameCount * i)];
		}
		
		CGImageDestinationSetProperties(dest, (__bridge CFDictionaryRef)fileProperties);
		
		// finalize the gif
		if (!CGImageDestinationFinalize(dest)) {
			[self fireError:[NSError errorWithDomain:@"finalized gif failed" code:100 userInfo:nil]];
		}
		CFRelease(dest);
		
		[self finished:fileURL];
	}];
}


// MARK: private methods
- (void)fireError:(NSError *)error {
	if (completedHandler) {
		completedHandler(error, nil);
	}
}

- (void)progressing:(double)progress {
	if (progressHandler) {
		progressHandler(progress);
	}
}

- (void)finished:(NSURL *)url {
	if (completedHandler) {
		completedHandler(nil, url);
	}
}

@end
