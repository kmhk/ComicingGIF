//
//  BkImageObject.m
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BkImageObject.h"


@interface BkImageObject()
{
	NSURL *fileURL;		// file url of background GIF or Image
}

@end


// MARK: -
@implementation BkImageObject

- (id)initWithURL:(NSURL *)url {
	self = [super init];
	if (self) {
		self.objType = ObjectBaseImage;
		fileURL = url;
	}
	
	return self;
}

@end
