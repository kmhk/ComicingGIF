//
//  GIFGenerator.h
//  ComicingGif
//
//  Created by Com on 25/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ProgressHandler)(double progress);
typedef void(^CompletionHandler)(NSError *error, NSURL *url);


// MARK: - GIFGenerator definition
@interface GIFGenerator : NSObject

+ (void)generateGIF:(NSURL *)videoURL frameCount:(NSInteger)count delayTime:(double)delay
		   progress:(ProgressHandler)progressing
		  completed:(CompletionHandler)completed;

+ (void)generateGIF:(NSArray *)images delayTime:(double)delay
		   progress:(ProgressHandler)progressing
		  completed:(CompletionHandler)completed;

@end
