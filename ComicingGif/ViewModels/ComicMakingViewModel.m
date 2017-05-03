//
//  ComicMakingViewModel.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicMakingViewModel.h"
#import "./../Objects/ObjectHeader.h"
#import "./../Utils/ComicObjectSerialize.h"


@implementation ComicMakingViewModel

- (id)init {
	self = [super init];
	if (self) {
		self.arrayObjects = [[NSMutableArray alloc] init];
		self.arrayRecents = [[NSMutableArray alloc] init];
	}
	
	return self;
}


// MARK: public methods
- (BOOL)isContainedAnimatedSticker {
	for (BaseObject *obj in self.arrayObjects) {
		if ((obj.objType == ObjectBaseImage && [((BkImageObject *)obj).fileURL.pathExtension.lowercaseString isEqualToString:@"gif"]) ||
			obj.objType == ObjectAnimateGIF) {
			return true;
		}
	}
	
	return false;
}


// MARK: - create objects
- (void)addObject:(BaseObject *)obj {
	[self.arrayObjects addObject:obj];
}

- (void)addRecentObject:(NSDictionary *)dict {
	for (NSDictionary *item in self.arrayRecents) {
		if ([dict[@"type"] integerValue] == [item[@"type"] integerValue] && [dict[@"id"] integerValue] == [item[@"id"] integerValue]) {
			[self.arrayRecents removeObject:item];
			[self.arrayRecents insertObject:dict atIndex:0];
			return;
		}
	}
	
	[self.arrayRecents insertObject:dict atIndex:0];
}

- (NSArray *)getRecentObjects:(ComicObjectType)type {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d", type];
	return [self.arrayRecents filteredArrayUsingPredicate:predicate];
}


// MARK: - save / load objects
- (void)saveObject {
	[ComicObjectSerialize saveObjectWithArray:self.arrayObjects];
}

@end
