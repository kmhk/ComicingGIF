//
//  CaptionObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CaptionObject.h"

@interface CaptionObject()
{
	NSString *text; // caption string
}
@end


// MARK: -
@implementation CaptionObject

- (id)initWithText:(NSString *)txt {
	self = [super init];
	if (self) {
		self.objType = ObjectCaption;
		text = txt;
	}
	
	return self;
}

@end
