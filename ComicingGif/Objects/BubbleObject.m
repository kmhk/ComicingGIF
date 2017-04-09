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

- (id)initWithText:(NSString *)txt bubbleID:(NSString *)ID {
	self = [super init];
	if (self) {
		self.objType = ObjectBubble;
		self.text = txt;
		self.bubbleURL = [[NSBundle mainBundle] URLForResource:ID withExtension:@""];
	}
	
	return self;
}

- (id)initWithText:(NSString *)txt bubbleURL:(NSString *)urlString {
	self = [super init];
	if (self) {
		self.objType = ObjectBubble;
		self.text = txt;
		self.bubbleURL = [NSURL fileURLWithPath:urlString];
	}
	
	return self;
}

@end
