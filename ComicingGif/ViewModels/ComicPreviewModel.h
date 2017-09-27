//
//  ComicPreviewModel.h
//  ComicingGif
//
//  Created by user on 5/10/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ComicSharingViewController.h"
#import <AVFoundation/AVFoundation.h>

@protocol ComicPreviewModelDelegate <NSObject>

- (void)imageThumbnailGenerated:(UIImage *)image;

@end

@interface ComicPreviewModel : NSObject

@property (assign) UIViewController *parentVC;
@property (strong, nonatomic) AVAssetExportSession *exporter1;

- (void)generateVideos:(void (^)(NSURL *))completedHandler;

@property (weak, nonatomic) id<ComicPreviewModelDelegate>delegate;

@end
