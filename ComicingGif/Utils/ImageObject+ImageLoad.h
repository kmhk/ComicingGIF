//
//  ImageObject+ImageLoad.h
//  ComicingGif
//
//  Created by Sergii Gordiienko on 9/23/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ImageObject.h"
#import <UIKit/UIKit.h>

@interface ImageObject (ImageLoad)
/// Load base frames in background thread and call completion when ready
- (void)loadImageFramesWithCompletion:(void(^)(NSArray <UIImage *> *images, NSTimeInterval duration))completionBlock;
/// Scale base grames in background thread (load them from file if they are not availabled)
- (void)scaleFrameImages:(void(^)(NSArray <UIImage *> *images))completionBlock;
@end
