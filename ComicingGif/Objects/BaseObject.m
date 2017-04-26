//
//  BaseObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"
#import "BkImageObject.h"
#import "StickerObject.h"
#import "BubbleObject.h"
#import "CaptionObject.h"
#import "PenObject.h"


@interface BaseObject()

@end


// MKAR: -
@implementation BaseObject

- (id)init {
	self = [super init];
	if (self) {
	}
	
	return self;
}

+ (BaseObject *)comicObjectWith:(ComicObjectType)type userInfo:(id)sender {
	if (type == ObjectBaseImage) {
		BkImageObject *obj = [[BkImageObject alloc] initWithURL:sender];
		return obj;
		
	} else if (type == ObjectAnimateGIF) {
		StickerObject *obj = [[StickerObject alloc] initWithResourceID:sender isGif:YES];
		return obj;
		
	} else if (type == ObjectSticker) {
		StickerObject *obj = [[StickerObject alloc] initWithResourceID:sender isGif:NO];
		return obj;
		
	} else if (type == ObjectBubble) {
		BubbleObject *obj = [[BubbleObject alloc] initWithText:sender[@"text"] bubbleID:sender[@"bubble"]];//[[BubbleObject alloc] initWithText:sender[@"text"] bubble:sender[@"bubble"]];
		return obj;
		
	} else if (type == ObjectPen) {
		PenObject *obj = [[PenObject alloc] init];
		return obj;
		
	} else if (type == ObjectCaption) {
//		CaptionObject *obj = [[CaptionObject alloc] initWithText:sender];
//		return obj;
	}
	
	return nil;
}

- (NSDictionary *)dictForObject {
	return @{@"type"	: @(self.objType),
			 @"frame"	: NSStringFromCGRect(self.frame),
			 @"angle"	: @(self.angle)
			 };
}

- (BaseObject *)initFromDict:(NSDictionary *)dict {
	ComicObjectType type = (ComicObjectType)[[dict[@"baseInfo"] objectForKey:@"type"] integerValue];
	
	if (type == ObjectBaseImage) {
		BkImageObject *obj = [[BkImageObject alloc] initFromDict:dict];
		return obj;
		
	} else if (type == ObjectAnimateGIF) {
		StickerObject *obj = [[StickerObject alloc] initFromDict:dict];
		return obj;
		
	} else if (type == ObjectSticker) {
		StickerObject *obj = [[StickerObject alloc] initFromDict:dict];
		return obj;
		
	} else {
		
	}
	
	return nil;
}

@end
