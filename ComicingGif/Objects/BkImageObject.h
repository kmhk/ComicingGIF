//
//  BkImageObject.h
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ImageObject.h"

extern NSString * const kIsTallKey;

@interface BkImageObject : ImageObject

@property (nonatomic) BOOL isTall;

// create background gif/image object by url
- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url isTall:(BOOL)isTall;

@end
