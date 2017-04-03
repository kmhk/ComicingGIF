//
//  BubbleObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BubbleObject.h"


@interface BubbleObject()
@end


// MARK: -
@implementation BubbleObject

- (id)initWithText:(NSString *)txt bubble:(NSString *)name {
	self = [super init];
	if (self) {
		self.objType = ObjectBubble;
		self.text = txt;
		self.bubbleName = name;
	}
	
	return self;
}

@end
