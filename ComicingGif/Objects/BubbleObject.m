//
//  BubbleObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BubbleObject.h"


@interface BubbleObject()
{
	NSString *bubbleName; // bubble image resource name
	NSString *text; // bubble text
}
@end


// MARK: -
@implementation BubbleObject

- (id)initWithText:(NSString *)txt bubble:(NSString *)name {
	self = [super init];
	if (self) {
		self.objType = ObjectBubble;
		text = txt;
		bubbleName = name;
	}
	
	return self;
}

@end
