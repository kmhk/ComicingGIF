//
//  CameraViewModel.m
//  ComicingGif
//
//  Created by Com on 23/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CameraViewModel.h"

@interface CameraViewModel()

@end


@implementation CameraViewModel

- (id)init {
	self = [super init];
	if (self) {
		self.recorder = [[SCRecorder alloc] init];
	}
	
	return self;
}

@end
