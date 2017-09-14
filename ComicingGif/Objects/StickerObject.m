//
//  StickerObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "StickerObject.h"


@interface StickerObject()
@end


// MARK: -
@implementation StickerObject

- (id)initWithResourceID:(NSString *)ID isGif:(BOOL)flag {
	self = [super init];
	if (self) {
		self.objType = (flag == YES? ObjectAnimateGIF : ObjectSticker);
		self.stickerURL = [[NSBundle mainBundle] URLForResource:ID withExtension:@""];
		self.frame = [self retreiveBound];
	}
	
	return self;
}


- (id)initWithURL:(NSString *)urlString isGif:(BOOL)flag {
	self = [super init];
	if (self) {
		self.objType = (flag == YES? ObjectAnimateGIF : ObjectSticker);
		self.stickerURL = [NSURL fileURLWithPath:urlString];
		self.frame = [self retreiveBound];
	}
	
	return self;
}


- (CGRect)retreiveBound {
	CGRect rt;
	
	UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.stickerURL]];
	
	CGSize szScreen = [[UIScreen mainScreen] bounds].size;
	if (img.size.width / img.size.height > szScreen.width / (szScreen.height / 4)) {
		rt.size.width = (img.size.width < szScreen.width ? img.size.width : szScreen.width * 0.4);
		rt.size.height = rt.size.width * img.size.height / img.size.width;
		
	} else {
		rt.size.height = (img.size.height < szScreen.height / 4 ? img.size.height : szScreen.height / 4 * 0.8);
		rt.size.width = rt.size.height * img.size.width / img.size.height;
	}
	
	rt.origin.x = rt.size.width / 2 + arc4random_uniform((szScreen.width - rt.size.width) / 2);//arc4random_uniform((szScreen.width - rt.size.width) / 20) * 20 + 20;
	rt.origin.y = rt.size.height / 2 + arc4random_uniform((szScreen.height - rt.size.height) / 2);//arc4random_uniform((szScreen.height / 2 - rt.size.height) / 10) * 10 + 20;
	rt.size.width += W_PADDING; // adding W_PADDING for area of showing comic object tool
	rt.size.height += H_PADDING; // adding H_PADDING for area of showing comic object tool
	
	return rt;
}


// override functions inherrited from the BaseObject
- (NSDictionary *)dictForObject {
	NSDictionary *dict = [super dictForObject];
	
	return @{kBaseInfoKey: dict,
			 kURLKey		: self.stickerURL.absoluteString
			 };
}

- (BaseObject *)initFromDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		NSDictionary *baseDict = (NSDictionary *)dict[kBaseInfoKey];
		
		self.objType = (ComicObjectType)[baseDict[kTypeKey] integerValue];
		self.frame = CGRectFromString(baseDict[kFrameKey]);
		
		NSBundle *bundle = [NSBundle mainBundle] ;
		NSString *strFileName = [[dict objectForKey:kURLKey] lastPathComponent];
		self.stickerURL = [bundle URLForResource:strFileName withExtension:@""];
		
		self.angle = [baseDict[kAngleKey] floatValue];
		self.scale = [baseDict[kScaleKey] floatValue];
        self.delayTimeInSeconds = [baseDict[kDelayTimeKey] floatValue];
	}
	
	return self;
}


@end
