//
//  BkImageObject.h
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

@interface BkImageObject : BaseObject

@property (nonatomic) NSURL *fileURL;

// create background gif/image object by url
- (id)initWithURL:(NSURL *)url;

@end
