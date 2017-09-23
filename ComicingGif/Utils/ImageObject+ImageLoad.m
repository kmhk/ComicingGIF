//
//  ImageObject+ImageLoad.m
//  ComicingGif
//
//  Created by Sergii Gordiienko on 9/23/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ImageObject+ImageLoad.h"
#import "Global.h"
#import "BkImageObject.h"

@implementation ImageObject (ImageLoad)

- (void)loadImageFramesWithCompletion:(void(^)(NSArray <UIImage *> *images, NSTimeInterval duration))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSTimeInterval totalDuration = 0;
            NSURL *fileURL = self.fileURL;
            if ([self isKindOfClass:[BkImageObject class]]) {
                NSString *filename = self.fileURL.lastPathComponent;
                fileURL =  [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:filename]];
            }
            NSData *data = [NSData dataWithContentsOfURL:fileURL];
            
            CGImageSourceRef srcImage = CGImageSourceCreateWithData(toCF data, nil);
            if (!srcImage) {
                NSLog(@"loading image failed");
            }
            
            size_t imgCount = CGImageSourceGetCount(srcImage);
            NSNumber *frameDuration;
            
            NSMutableArray *arrayImages = [[NSMutableArray alloc] initWithCapacity:imgCount];
            for (NSInteger i = 0; i < imgCount; i ++) {
                CGImageRef cgImg = CGImageSourceCreateImageAtIndex(srcImage, i, nil);
                if (!cgImg) {
                    NSLog(@"loading %ldth image failed from the source", (long)i);
                    continue;
                }
                
                UIImage *img = [UIImage imageWithCGImage:cgImg];
                [arrayImages addObject:img];
                
                NSDictionary *property = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(srcImage, i, nil));
                NSDictionary *gifDict = property[fromCF kCGImagePropertyGIFDictionary];
                
                frameDuration = gifDict[fromCF kCGImagePropertyGIFUnclampedDelayTime];
                if (!frameDuration) {
                    frameDuration = gifDict[fromCF kCGImagePropertyGIFDelayTime];
                }
                
                totalDuration += frameDuration.floatValue;
                
                CGImageRelease(cgImg);
            }
            
            CFRelease(srcImage);
            self.frameImages = arrayImages;
            self.duration = (totalDuration == 0 ? 5 : totalDuration) ;
            
            if (completionBlock) {
                completionBlock(arrayImages, totalDuration);
            }
        }
    });
}

- (void)scaleFrameImages:(void(^)(NSArray <UIImage *> *images))completionBlock {
    void (^scaleBlock)(NSArray *, NSTimeInterval) = ^(NSArray<UIImage *> *images, NSTimeInterval duration) {
        self.scaledFrameImages = [self scaleImages:images];
        if (completionBlock) {
            completionBlock(self.scaledFrameImages);
        }
    };
    
    if (self.frameImages.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            scaleBlock(self.frameImages, self.duration);
        });
    } else {
        [self loadImageFramesWithCompletion:scaleBlock];
    }
}

- (NSArray <UIImage *> *)scaleImages:(NSArray <UIImage *> *)images {
    NSMutableArray *scalledImages = [[NSMutableArray alloc] init];
    @autoreleasepool {
        for (NSInteger i = 0; i < images.count; i += kPickedImageFrequence) {
            UIImage *scalledImage = [[Global global] scaledImage:images[i]
                                                            size:[Global global].preferedScaleRect.size withInterpolationQuality:kCGInterpolationDefault];
            if (scalledImage) {
                [scalledImages addObject:scalledImage];
            }
        }
    }
    return scalledImages;
}

@end
