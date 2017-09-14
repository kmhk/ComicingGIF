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
    CFTimeInterval duration;
    
    ProgressHandler _progressHandler;
    CompletionHandler _completedHandler;
    FirstFrameHandler _firstFrameHandler;
    NSInteger frameCount;
    double delayPerFrame;
}
@property (strong, nonatomic) NSMutableArray <UIImage *> *arrayFrames;
@end


// MARK: -
@implementation GIFGenerator

// MARK: - global static methods
+ (void)generateGIF:(NSURL *)videoURL frameCount:(NSInteger)count delayTime:(double)delay
           progress:(ProgressHandler)progressing
  firstFrameHandler:(FirstFrameHandler)firstFrameHandler
          completed:(CompletionHandler)completed
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        GIFGenerator *generator = [[GIFGenerator alloc] init:videoURL
                                                  frameCount:count
                                                   delayTime:delay
                                                    progress:progressing
                                           firstFrameHandler:firstFrameHandler
                                                   completed:completed];
        
        [generator createGifFromVideo];
    });
}

+ (void)generateGIF:(NSArray *)images delayTime:(double)delay
           progress:(ProgressHandler)progressing
  firstFrameHandler:(FirstFrameHandler)firstFrameHandler
          completed:(CompletionHandler)completed
{
    GIFGenerator *generator = [[GIFGenerator alloc] init:images
                                               delayTime:delay
                                                progress:progressing
                                       firstFrameHandler:firstFrameHandler
                                               completed:completed];
    
    [generator createGifWithImages];
}


// MARK: - initialize methods
- (id)init {
    self = [super init];
    if (self) {
        _progressHandler = nil;
        _firstFrameHandler = nil;
        _completedHandler = nil;
        
        _arrayFrames = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)         init:(NSURL *)videoURL
         frameCount:(NSInteger)count
          delayTime:(double)delay
           progress:(ProgressHandler)progress
  firstFrameHandler:(FirstFrameHandler)firstFrameHandler
          completed:(CompletionHandler)completed
{
    self = [self init];
    if (self) {
        frameCount = count;
        delayPerFrame = delay;
        
        asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        duration = (double)asset.duration.value / (double)asset.duration.timescale;
        
        if (count < 1) {
            frameCount = duration * 30;
        } else {
            frameCount = count;
        }
        
        if (delay == 0) {
            delayPerFrame = duration / (double)frameCount;
        } else {
            delayPerFrame = delay;
        }
        
        _progressHandler = progress;
        _firstFrameHandler = firstFrameHandler;
        _completedHandler = completed;
    }
    
    return self;
}

- (id)init:(NSArray *)images delayTime:(double)delay
  progress:(ProgressHandler)progress
firstFrameHandler:(FirstFrameHandler)firstFrameHandler
 completed:(CompletionHandler)completed
{
    self = [super init];
    if (self) {
        frameCount = images.count;
        
        if (delay == 0) {
            delayPerFrame = 1.0;
        } else {
            delayPerFrame = delay;
        }
        
        _progressHandler = progress;
        _completedHandler = completed;
        _firstFrameHandler = firstFrameHandler;
        
        _arrayFrames = [[NSMutableArray alloc] initWithArray:images];
    }
    
    return self;
}


// MARK: - private methods to process GIF
- (void)createGifWithImages {
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
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd_MM_yyyy_HH_mm_ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.gif", dateString];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    
    CGImageDestinationRef dest = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, frameCount, nil);
    if (!dest) {
        [self fireError:[NSError errorWithDomain:@"gif create failed" code:100 userInfo:nil]];
        return;
    }
    
    [self didReceiveFirstFrame:[self.arrayFrames firstObject]];
    
    for (int i = 0; i < frameCount; i ++) {
        // add frame image to the gif
        UIImage *img = self.arrayFrames[i];
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
}

- (void)createGifFromVideo {
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
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd_MM_yyyy_HH_mm_ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.gif", dateString];
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
    
    NSMutableArray *times = [[NSMutableArray alloc] initWithCapacity:frameCount];
    for (int i = 0; i < frameCount; i ++) {
        double second = duration * (double)i / (double)frameCount;
        CMTime time = CMTimeMakeWithSeconds(second, 600);
        [times addObject:[NSValue valueWithCMTime:time]];
    }
    __block NSInteger createdFrameCount = 0;
    __weak GIFGenerator * weakSelf = self;
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times
                                       completionHandler:^(CMTime requestedTime,
                                                           CGImageRef  _Nullable image,
                                                           CMTime actualTime,
                                                           AVAssetImageGeneratorResult result,
                                                           NSError * _Nullable error) {
                                           CGImageDestinationAddImage(dest, image, (__bridge CFDictionaryRef)frameProperties);
                                           [self progressing:(1.0 / frameCount * createdFrameCount)];
                                           
                                           UIImage *frameImage = [UIImage imageWithCGImage:image];
                                           if (frameImage) {
                                               [weakSelf.arrayFrames addObject:[UIImage imageWithCGImage:image]];
                                           }
                                           
                                           if (error) {
                                               [self fireError:[NSError errorWithDomain:@"finalized gif failed" code:100 userInfo:nil]];
                                           } else if (createdFrameCount == 0) {
                                               [self didReceiveFirstFrame:[weakSelf.arrayFrames firstObject]];
                                           } else if (createdFrameCount == frameCount - 1) {
                                               CGImageDestinationSetProperties(dest, (__bridge CFDictionaryRef)fileProperties);
                                               
                                               // finalize the gif
                                               if (!CGImageDestinationFinalize(dest)) {
                                                   [self fireError:[NSError errorWithDomain:@"finalized gif failed" code:100 userInfo:nil]];
                                               }
                                               CFRelease(dest);
                                               
                                               [self finished:fileURL];
                                           }
                                           createdFrameCount++;
                                       }];
}

// MARK: private methods
- (void)fireError:(NSError *)error {
    if (_completedHandler) {
        _completedHandler(error, nil, self.arrayFrames, duration);
    }
}

- (void)progressing:(double)progress {
    if (_progressHandler) {
        _progressHandler(progress);
    }
}

- (void)didReceiveFirstFrame:(UIImage *)firstFrame {
    if (_firstFrameHandler) {
        _firstFrameHandler(firstFrame);
    }
}

- (void)finished:(NSURL *)url {
    if (_completedHandler) {
        _completedHandler(nil, url, self.arrayFrames, duration);
    }
}

@end
