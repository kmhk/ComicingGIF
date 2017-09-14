//
//  ImageObject.m
//  ComicingGif
//
//  Created by Sergii Gordiienko on 9/14/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ImageObject.h"

@implementation ImageObject

- (id)initWithURL:(NSURL *)url {
    self = [self init];
    if (self) {
        self.objType = ObjectBaseImage;
        self.fileURL = url;
    }
    return self;
}

@end
