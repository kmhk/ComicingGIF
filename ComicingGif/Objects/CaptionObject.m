//
//  CaptionObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CaptionObject.h"

@interface CaptionObject()
@end


// MARK: -
@implementation CaptionObject

- (id)initWithText:(NSString *)txt color:(UIColor *)color {
	self = [super init];
	if (self) {
		self.objType = ObjectCaption;
		self.text = txt;
		self.color = color;
	}
	
	return self;
}

@end
