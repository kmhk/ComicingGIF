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

- (id)initWithResourceID:(NSString *)name isGif:(BOOL)flag {
	self = [super self];
	if (self) {
		self.objType = (flag == YES? ObjectAnimateGIF : ObjectSticker);
		self.resourceName = name;
		self.frame = [self retreiveBound];
	}
	
	return self;
}

- (CGRect)retreiveBound {
	CGRect rt;
	
	UIImage *img = [UIImage imageNamed:self.resourceName];
	
	CGSize szScreen = [[UIScreen mainScreen] bounds].size;
	if (img.size.width / img.size.height > szScreen.width / szScreen.height) {
		rt.size.width = (img.size.width < szScreen.width ? img.size.width : szScreen.width * 0.6);
		rt.size.height = rt.size.width * img.size.height / img.size.width;
		
	} else {
		rt.size.height = (img.size.height < szScreen.height ? img.size.height : szScreen.height * 0.6);
		rt.size.width = rt.size.height * img.size.width / img.size.height;
	}
	
	rt.origin.x = arc4random_uniform((szScreen.width - img.size.width) / 20) * 20;
	rt.origin.y = arc4random_uniform((szScreen.height - img.size.height) / 10) * 10;
	
	return rt;
}

@end
