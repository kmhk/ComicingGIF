//
//  ComicObjectSerialize.m
//  ComicingGif
//
//  Created by Com on 04/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicObjectSerialize.h"
#import "BaseObject.h"

static ComicObjectSerialize *gComicObjectSerializeObj;

@implementation ComicObjectSerialize

+ (void)setSavedIndex:(NSInteger)index {
	if (gComicObjectSerializeObj == nil) {
		gComicObjectSerializeObj = [[ComicObjectSerialize alloc] init];
	}
	
	gComicObjectSerializeObj.indexSaved = index;
}

+ (NSInteger)getSavedIndex {
	if (gComicObjectSerializeObj) {
		return gComicObjectSerializeObj.indexSaved;
	}
	
	return -1;
}

+ (void)saveObjectWithArray:(NSArray *)array {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slides.plist"];
	
	NSMutableArray *arrayAllSides = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
	if (!arrayAllSides) {
		arrayAllSides = [[NSMutableArray alloc] init];
	}
	
	NSMutableArray *arrayDict = [[NSMutableArray alloc] init];
	for (BaseObject *obj in array) {
		[arrayDict addObject:[obj dictForObject]];
	}
	
	if (!gComicObjectSerializeObj || gComicObjectSerializeObj.indexSaved < 0 || gComicObjectSerializeObj.indexSaved >= arrayAllSides.count) {
		[arrayAllSides addObject:arrayDict];
		[ComicObjectSerialize setSavedIndex:arrayAllSides.count - 1];
		
	} else {
		[arrayAllSides replaceObjectAtIndex:gComicObjectSerializeObj.indexSaved withObject:arrayDict];
	}
	
	[arrayAllSides writeToFile:filePath atomically:NO];
}


+ (NSArray *)loadComicSlide {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slides.plist"];
	return [NSArray arrayWithContentsOfFile:filePath];
}

@end
