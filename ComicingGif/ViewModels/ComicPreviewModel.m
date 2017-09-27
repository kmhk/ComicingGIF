//
//  ComicPreviewModel.m
//  ComicingGif
//
//  Created by user on 5/10/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicPreviewModel.h"
#import "ComicObjectSerialize.h"
#import "BaseObject.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "TwitterVideoUpload.h"
#import "RoundCapProgressView.h"
#import <AVKit/AVKit.h>

@interface LayerAndAnimation : NSObject

@property (strong, nonatomic) CALayer *layer;
@property (strong, nonatomic) CAKeyframeAnimation *animation;
@property (assign, nonatomic) NSInteger layerCount;
- (instancetype)initWithLayer:(CALayer *)layer andAnimationObject:(CAKeyframeAnimation *)animation andLayerCount:(NSInteger)layerCount;

@end

@implementation LayerAndAnimation

- (instancetype)initWithLayer:(CALayer *)layer andAnimationObject:(CAKeyframeAnimation *)animation andLayerCount:(NSInteger)layerCount{
    self = [super init];
    if (self) {
        self.layer = layer;
        self.animation = animation;
        self.layerCount = layerCount;
    }
    return self;
}

@end

@interface ComicPreviewModel ()

@end

@implementation ComicPreviewModel
{
	CFTimeInterval objectDuration;
}

- (id)init {
	self = [super init];
	if (self) {

	}
	
	return self;
}

- (void)generateVideos:(void (^)(NSURL *))completedHandler {

    NSMutableArray *arraySlides = [NSMutableArray arrayWithArray:[ComicObjectSerialize loadComicSlide]];
	
	while (arraySlides.count > 0) {
		NSArray *arrayPresent;
		
		if (arraySlides.count > 4) {
			arrayPresent = [arraySlides subarrayWithRange:NSMakeRange(0, 4)];
			
		} else {
			arrayPresent = [NSArray arrayWithArray:arraySlides];
		}
		
		[arraySlides removeObjectsInArray:arrayPresent];
		[self createVideoFromSlide:arrayPresent handler:completedHandler];
	}
}

// MARK: - video generation methods
- (void)createVideoFromSlide:(NSArray *)arraySlides handler:(void (^)(NSURL *))completedHandler {
	NSLog(@"first %lu slides generated to 1 video", (unsigned long)arraySlides.count);
	
	NSArray *arrayFrames = [self getAlignView:arraySlides];
	if (!arraySlides) {
		NSLog(@"error format layout");
		return;
	}
	
	CFTimeInterval duration = AVCoreAnimationBeginTimeAtZero;
	
	// creating parent layer for merge
	CALayer *parentLayer = [CALayer new];
	parentLayer.frame = CGRectMake(0, 0, 800, 800); // 800x800 video
	
	// main video layer
	CALayer *videoLayer = [CALayer new];
	videoLayer.frame = CGRectMake(0, 0, 800, 800);
	[parentLayer addSublayer:videoLayer];
	
	// background layer
	[self createImageLayer:parentLayer rect:CGRectMake(0, 0, 800, 800) name:@"blackLayerImage.png"];
	[self createImageLayer:parentLayer rect:CGRectFromString(arrayFrames[0]) name:@"bkLayerImage.png"];
	
	// draw each slide layers
	for (int i = 0; i < arraySlides.count; i ++) {
		NSArray *arraySlide = arraySlides[i];
		
		objectDuration = AVCoreAnimationBeginTimeAtZero;
		
		// draw background image
		NSDictionary *dict = arraySlide[0];
		CGRect rt = CGRectFromString(arrayFrames[i+1]);
		NSURL *url = [NSURL URLWithString:dict[@"url"]];
		NSString *fileName1 = [NSString stringWithFormat:@"%@",[url lastPathComponent]];
		NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName1]];
		CALayer *bkLayer = [self createGifLayer:parentLayer
                                           rect:rt
											url:fileURL
										  delay:duration
                            delayFromSlideStart:0
										   flag:YES
                            shouldShowAlways:YES];
		
		for (int j = 1; j < arraySlide.count; j ++) {
			NSDictionary *slide = arraySlide[j];
			[self createComicObjectLayer:slide
							   baseLayer:bkLayer
								   delay:duration
                     delayFromSlideStart:[[slide[@"baseInfo"] objectForKey:@"delayTime"] floatValue]
								  rtRule:CGRectFromString([dict[@"baseInfo"] objectForKey:@"frame"])
								rtActual:CGRectFromString(arrayFrames[i+1])];
		}
		
		if (objectDuration <= 3) {
			duration += 3;
		} else {
			duration += objectDuration;
		}
	}

    // generate video
	AVMutableComposition *composition = [AVMutableComposition composition];
	AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
	AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
	
	CMTime nextTime = kCMTimeZero;
	
	videoComposition.renderSize = CGSizeMake(800, 800);
	videoComposition.frameDuration = CMTimeMake(1, 30);
	
	
	AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]]];
	AVAssetTrack *assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
	
	for (int i = 0; i < (duration/2 + 1); i ++) {
		[videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetVideoTrack atTime:nextTime error:nil];
		nextTime = CMTimeAdd(nextTime, asset.duration);
	}
	
	AVMutableVideoCompositionLayerInstruction *layerInstruction =
	[AVMutableVideoCompositionLayerInstruction
	 videoCompositionLayerInstructionWithAssetTrack:videoTrack];
	
	[layerInstruction setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
    NSLog(@"Duration: %f",duration);
	NSLog(@"asset duration == %f",CMTimeGetSeconds(asset.duration));
	NSLog(@"composition duration == %f",CMTimeGetSeconds(composition.duration));
	
	AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
	instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [composition duration]);
	instruction.layerInstructions = [NSArray arrayWithObjects:layerInstruction, nil];
	videoComposition.instructions = [NSArray arrayWithObjects:instruction, nil];
	
	videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
									  videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
	
	NSString *Directorypath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/VideoEditor"];
	NSLog(@"Directory Path = %@",Directorypath);
	if (![[NSFileManager defaultManager] fileExistsAtPath:Directorypath])
		[[NSFileManager defaultManager] createDirectoryAtPath:Directorypath withIntermediateDirectories:NO attributes:nil error:nil];
	
	NSString *outputPath = [Directorypath stringByAppendingPathComponent:@"camera.mov"];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
	}
	
	NSLog(@"path == %@",outputPath);
	
	NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
	
	 self.exporter1 = [[AVAssetExportSession alloc] initWithAsset:composition
																	   presetName:AVAssetExportPresetLowQuality];
    
	self.exporter1.outputURL=outputURL;
	self.exporter1.outputFileType = AVFileTypeQuickTimeMovie;
	self.exporter1.videoComposition = videoComposition;

//    if ([self.delegate respondsToSelector:@selector(imageThumbnailGenerated:)]) {
//        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//        generator.appliesPreferredTrackTransform=TRUE;
//        
//        CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
//        
//        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
//            if (result != AVAssetImageGeneratorSucceeded) {
//                NSLog(@"couldn't generate thumbnail, error:%@", error);
//            }
//                [self.delegate imageThumbnailGenerated:[UIImage imageWithCGImage:im]] ;
//        };
//        
//        CGSize maxSize = CGSizeMake(320, 180);
//        generator.maximumSize = maxSize;
//        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
//    }

	[self.exporter1 exportAsynchronouslyWithCompletionHandler:^{
		switch ([self.exporter1 status]) {
			case AVAssetExportSessionStatusFailed:
				NSLog(@"Export failed: %@", [[self.exporter1 error] description]);
				break;
			case AVAssetExportSessionStatusCancelled:
				NSLog(@"Export canceled");
				break;
			default:
				NSLog(@"Finished");
				completedHandler(outputURL);
				
//				[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//					PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputURL];
//					
//					NSLog(@"%@", changeRequest.description);
//				} completionHandler:^(BOOL success, NSError *error) {
//					if (success) {
//						NSLog(@"saved down");
//					} else {
//						NSLog(@"something wrong %@", error.localizedDescription);
//					}
//					
//					AVPlayer *player = [AVPlayer playerWithURL:outputURL];
//					AVPlayerViewController *playerViewController = [AVPlayerViewController new];
//					playerViewController.player = player;
//					[_parentVC presentViewController:playerViewController animated:YES completion:nil];
//				}];

//                [((ComicSharingViewController *)self.parentVC) saveVideoWithURL:outputURL];
				break;
		}
	}];
}


- (CFTimeInterval)createComicObjectLayer:(NSDictionary *)dict baseLayer:(CALayer *)baseLayer delay:(CFTimeInterval)delay delayFromSlideStart:(CFTimeInterval)delayFromSlideStart rtRule:(CGRect)rtRule rtActual:(CGRect)rtActual {
	CGRect rt = [self getBound:CGRectFromString([dict[@"baseInfo"] objectForKey:@"frame"]) ruleRT:rtRule actualRT:rtActual];
	
	if ([[dict[@"baseInfo"] objectForKey:@"type"] integerValue] == ObjectAnimateGIF) {
		NSURL *url = [NSURL URLWithString:dict[@"url"]];
		NSString *fileName = [NSString stringWithFormat:@"%@",[url lastPathComponent]];
		NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@""]];
        CGFloat delayTime = [[dict[@"baseInfo"] objectForKey:@"delayTime"] floatValue];
		[self createGifLayer:baseLayer rect:rt url:fileURL delay:delay delayFromSlideStart:delayFromSlideStart flag:NO shouldShowAlways:!delayTime];
		
	} else if ([[dict[@"baseInfo"] objectForKey:@"type"] integerValue] == ObjectSticker) {
		NSURL *url = [NSURL URLWithString:dict[@"url"]];
		NSString *fileName = [NSString stringWithFormat:@"%@",[url lastPathComponent]];
		[self createImageLayer:baseLayer rect:rt name:fileName];
	}
	
	return objectDuration;
}

- (CALayer *)createImageLayer:(CALayer *)parent rect:(CGRect)rect name:(NSString *)rcID {
    
	CALayer *layer = [CALayer new];
	layer.frame = rect;
	
	UIImage *image = [UIImage imageNamed:rcID];
	layer.contents = (id)[image CGImage];
	
	[parent addSublayer:layer];
	
	return layer;
}


- (CALayer *)createGifLayer:(CALayer *)parent rect:(CGRect)rect url:(NSURL *)url delay:(CFTimeInterval)delay delayFromSlideStart:(CFTimeInterval)delayFromSlideStart flag:(BOOL)drawBorder shouldShowAlways:(BOOL)shouldShowAlways {
	CALayer *layer = [CALayer new];
	layer.frame = rect;
	
	[self startGifAnimationWithURL:url inLayer:layer delay:delay delayFromSlideStart:delayFromSlideStart flag:drawBorder shouldShowAlways:shouldShowAlways];
	[parent addSublayer:layer];
	
	return layer;
}


- (void)startGifAnimationWithURL:(NSURL *)url inLayer:(CALayer *)layer delay:(CFTimeInterval)delay delayFromSlideStart:(CFTimeInterval)delayFromSlideStart flag:(BOOL)drawBorder shouldShowAlways:(BOOL)shouldShowAlways
{
	CALayer *subLayer = [CALayer new];
	subLayer.frame = layer.bounds;
	
    // creating animation layer
	CAKeyframeAnimation * animation = [self animationForGifWithURL:url delay:delay delayFromSlideStart:delayFromSlideStart flag:drawBorder shouldShowAlways:shouldShowAlways];
	[subLayer addAnimation:animation forKey:@"contents"];

	// set first frame to main layer to show image before animation
//	layer.contents = (id)animation.values[0];
	[layer addSublayer:subLayer];
}

- (CGImageRef)resizeCGImage:(CGImageRef)image toScale:(int)scale flag:(BOOL)drawBorder {
	NSInteger width = CGImageGetWidth(image) / scale;
	NSInteger height = CGImageGetWidth(image) / scale;
	
	// create context, keeping original image properties
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();//CGImageGetColorSpace(image);
	CGContextRef context = CGBitmapContextCreate(NULL, width, height,
												 8,//CGImageGetBitsPerComponent(image),
												 0,//CGImageGetBytesPerRow(image),
												 colorspace,
												 kCGImageAlphaPremultipliedLast//CGImageGetAlphaInfo(image)
												 );
	CGColorSpaceRelease(colorspace);
	
	
	if (context == NULL)
		return nil;
	
	// draw image to context (resizing it)
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
	
	if (drawBorder) {
		// draw border rectangle
		CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
		CGContextStrokeRect(context, CGRectMake(1, 1, width-2, height-2));
	}
	
	// extract resulting image from context
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	
	return imgRef;
}

- (CAKeyframeAnimation *)animationForGifWithURL:(NSURL *)url delay:(CFTimeInterval)delay delayFromSlideStart:(CFTimeInterval)delayFromSlideStart flag:(BOOL)drawBorder shouldShowAlways:(BOOL)shouldShowAlways
{
    delay += delayFromSlideStart;
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	NSMutableArray * frames = [NSMutableArray new];
	NSMutableArray *delayTimes = [NSMutableArray new];
	
	CGFloat totalTime = 0.0;
//	CGFloat gifWidth;
//	CGFloat gifHeight;
	
	CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
	
	// get frame count
	size_t frameCount = CGImageSourceGetCount(gifSource);
	for (size_t i = 0; i < frameCount; ++i)
	{
		// get each frame
		CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
//		[frames addObject:(__bridge id)frame];
		CGImageRef resizedFrame = [self resizeCGImage:frame toScale:2 flag:((i!=0) && drawBorder)];
		[frames addObject:(__bridge id)resizedFrame];
		CGImageRelease(frame);
		CGImageRelease(resizedFrame);
		
		// get gif info with each frame
		NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
//		NSLog(@"kCGImagePropertyGIFDictionary %@", [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary]);
		
		// get gif size
//		gifWidth = [[dict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
//		gifHeight = [[dict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
		
		// kCGImagePropertyGIFDictionary中kCGImagePropertyGIFDelayTime，kCGImagePropertyGIFUnclampedDelayTime值是一样的
		NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
		NSNumber *frameDuration = [gifDict valueForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime];
		if (!frameDuration) {
			frameDuration = [gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime];
		}
		
		[delayTimes addObject:frameDuration];
		
		totalTime = totalTime + frameDuration.floatValue;
	}
	
	if (frames.count == 1) {
		CGImageRef newFrame = [self resizeCGImage:(__bridge CGImageRef)(frames[0]) toScale:1 flag:YES];
		[frames addObject:(__bridge id)newFrame];
		CGImageRelease(newFrame);
		
		[delayTimes addObject:delayTimes.firstObject];
		totalTime += totalTime;
	}
	
	if (gifSource)
	{
		CFRelease(gifSource);
	}
	
	NSMutableArray *times = [[NSMutableArray alloc] init];
	CGFloat currentTime = 0;
	NSInteger count = delayTimes.count;
	for (int i = 0; i < count; ++i)
	{
		[times addObject:[NSNumber numberWithFloat:(currentTime / totalTime)]];
		currentTime += [[delayTimes objectAtIndex:i] floatValue];
	}
	
	animation.beginTime = delay;/*AVCoreAnimationBeginTimeAtZero*/
	animation.keyTimes = times;
	animation.values = frames;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	animation.duration = totalTime;
    if (!shouldShowAlways) {
        animation.fillMode = kCAFillModeForwards;
    } else {
        animation.fillMode = kCAFillModeBoth;
    }
    animation.removedOnCompletion = NO;
	animation.repeatCount = 1;

	
	if (objectDuration < (totalTime + delay)) {
		objectDuration = (totalTime + delay);
	}
//	duration += totalTime;
	
	return animation;
}



// MARK: - private methods
- (CGRect)getBound:(CGRect)rt ruleRT:(CGRect)rtRule actualRT:(CGRect)rtActual {
	CGRect rtResult;
	
	rtResult.size.width = rtActual.size.width * rt.size.width / rtRule.size.width;
	rtResult.size.height = rtActual.size.height * rt.size.height / rtRule.size.height;
	rtResult.origin.x = rtActual.size.width * rt.origin.x / rtRule.size.width;
	rtResult.origin.y = rtActual.size.height * (rtRule.size.height - rt.origin.y - rt.size.height) / rtRule.size.height;
	
	return rtResult;
}

- (NSArray *)getAlignView:(NSArray *)arraySlides {
	NSInteger tag = 0;
	for (int i = 0; i < arraySlides.count; i ++) {
		NSArray *slide = arraySlides[i];
		if ([[slide[0] objectForKey:@"isTall"] boolValue] == YES) {
			tag = tag * 10 + 1;
		} else {
			tag = tag * 10 + 2;
		}
	}
	
	NSMutableArray *arrayFrames = [[NSMutableArray alloc] init];
	
	NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"layoutView" owner:nil options:nil];
	for (UIView *view in views) {
		if (view.tag == tag) {
			for (int i = 0; i < view.subviews.count; i ++) {
				UIView *layoutView;
				if (tag < 10) {
					layoutView = view.subviews[i];
				} else {
					layoutView = [view viewWithTag:i];
				}
				CGRect rt = layoutView.frame;
				rt.origin.y = layoutView.superview.frame.size.height - rt.size.height - rt.origin.y;
				[arrayFrames addObject:NSStringFromCGRect(rt)];
			}
			
			return arrayFrames;
		}
	}
	
	return nil;
}


@end
