//
//  ComicPreviewModel.h
//  ComicingGif
//
//  Created by user on 5/10/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ComicPreviewModel : NSObject

@property (assign) UIViewController *parentVC;

- (void)generateVideos:(void (^)(NSURL *))completedHandler;

@end
