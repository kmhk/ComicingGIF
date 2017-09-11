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


NSString * const kTypeKey = @"type";
NSString * const kFrameKey = @"frame";
NSString * const kAngleKey = @"angle";
NSString * const kScaleKey = @"scale";
NSString * const kDelayTimeKey = @"delayTime";
NSString * const kBaseInfoKey = @"baseInfo";
NSString * const kURLKey = @"url";
NSString * const kTextKey = @"text";
NSString * const kCaptionTypeKey = @"captionType";

@interface BaseObject()

@end

// MKAR: -
@implementation BaseObject

- (id)init {
	self = [super init];
	if (self) {
		self.angle = 0.0;
		self.scale = 1.0;
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
		BubbleObject *obj = [[BubbleObject alloc] initWithText:sender[kTextKey] bubbleID:sender[@"bubble"]];
		return obj;
		
	} else if (type == ObjectPen) {
		PenObject *obj = [[PenObject alloc] init];
		return obj;
		
	} else if (type == ObjectCaption) {
        CaptionObject *obj = [[CaptionObject alloc] initWithText:sender[kTextKey]
                                                     captionType:[sender[kCaptionTypeKey] integerValue]];
		return obj;
	}
	
	return nil;
}

- (NSDictionary *)dictForObject {
	return @{kTypeKey      : @(self.objType),
			 kFrameKey     : NSStringFromCGRect(self.frame),
			 kAngleKey     : @(self.angle),
			 kScaleKey     : @(self.scale),
             kDelayTimeKey : @(self.delayTimeInSeconds)
			 };
}

- (BaseObject *)initFromDict:(NSDictionary *)dict {
	ComicObjectType type = (ComicObjectType)[[dict[kBaseInfoKey] objectForKey:kTypeKey] integerValue];
	
	if (type == ObjectBaseImage) {
		BkImageObject *obj = [[BkImageObject alloc] initFromDict:dict];
		return obj;
		
	} else if (type == ObjectAnimateGIF) {
		StickerObject *obj = [[StickerObject alloc] initFromDict:dict];
		return obj;
		
	} else if (type == ObjectSticker) {
		StickerObject *obj = [[StickerObject alloc] initFromDict:dict];
		return obj;
		
	} else if (type == ObjectPen) {
        PenObject *penObject = [[PenObject alloc] initFromDict:dict];
        return penObject;
    } else if (type == ObjectBubble) {
        BubbleObject *bubbleObject = [[BubbleObject alloc] initFromDict:dict];
        return bubbleObject;
    } else if (type == ObjectCaption) {
        CaptionObject *captionObject = [[CaptionObject alloc] initFromDict:dict];
        return captionObject;
    }
	
	return nil;
}

@end
