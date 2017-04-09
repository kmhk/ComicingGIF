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
	}
	
	return self;
}


// MARK: - create objects
- (void)addObject:(BaseObject *)obj {
	[self.arrayObjects addObject:obj];
}


// MARK: - save / load objects
- (void)saveObject {
	[ComicObjectSerialize saveObjectWithArray:self.arrayObjects];
}

@end
