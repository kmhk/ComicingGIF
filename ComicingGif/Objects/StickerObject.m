//
//  StickerObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "StickerObject.h"


@interface StickerObject()
{
	NSString *resourceName;	// sticker or gif resource name
}
@end


// MARK: -
@implementation StickerObject

- (id)initWithResourceID:(NSString *)name {
	self = [super self];
	if (self) {
		self.objType = ObjectSticker;
		resourceName = name;
	}
	
	return self;
}

@end
