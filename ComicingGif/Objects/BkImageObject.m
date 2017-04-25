//
//  BkImageObject.m
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BkImageObject.h"


@interface BkImageObject()

@end


// MARK: -
@implementation BkImageObject

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.objType = ObjectBaseImage;
        self.fileURL = url;
        self.frame = [self retreiveBound];
    }
    
    return self;
}

- (id)initWithURL:(NSURL *)url isTall:(BOOL)isTall{
    self = [super init];
    if (self) {
        self.objType = ObjectBaseImage;
        self.fileURL = url;
        self.isTall = isTall;
        self.frame = [self retreiveBound];
    }
    
    return self;
}

- (CGRect)retreiveBound {
	CGRect rt;
	
    NSString *fileName1 = [NSString stringWithFormat:@"%@",[self.fileURL lastPathComponent]];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName1]];
        
	NSData *data = [NSData dataWithContentsOfURL:fileURL];
	UIImage *img = [UIImage imageWithData:data];
	
	CGSize szScreen = [[UIScreen mainScreen] bounds].size;
	if (img.size.width / img.size.height > szScreen.width / szScreen.height) {
		rt.size.width = (img.size.width < szScreen.width ? img.size.width : szScreen.width * 0.3);
		rt.size.height = rt.size.width * img.size.height / img.size.width;
		
	} else {
		rt.size.height = (img.size.height < szScreen.height ? img.size.height : szScreen.height * 0.3);
		rt.size.width = rt.size.height * img.size.width / img.size.height;
	}
	
	rt.origin.x = arc4random_uniform((szScreen.width - img.size.width) / 20) * 20;
	rt.origin.y = arc4random_uniform((szScreen.height - img.size.height) / 10) * 10;
	
	return rt;
}

// override functions inherrited from the BaseObject
- (NSDictionary *)dictForObject {
	NSDictionary *dict = [super dictForObject];
	
	return @{@"baseInfo": dict,
			 @"url"		: self.fileURL.absoluteString,
             @"isTall"  : [NSNumber numberWithBool:self.isTall]
			 };
}

- (BaseObject *)initFromDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		NSDictionary *baseDict = (NSDictionary *)dict[@"baseInfo"];
		
		self.objType = (ComicObjectType)[baseDict[@"type"] integerValue];
		self.fileURL = [NSURL URLWithString:dict[@"url"]];
        self.isTall = [dict[@"isTall"] boolValue];
		self.frame = CGRectFromString(baseDict[@"frame"]);
		self.angle = [baseDict[@"angle"] floatValue];
		self.scale = [baseDict[@"scale"] floatValue];
	}
	
	return self;
}

@end
