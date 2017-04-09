//
//  ComicObjectSerialize.m
//  ComicingGif
//
//  Created by Com on 04/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicObjectSerialize.h"
#import "BaseObject.h"

@implementation ComicObjectSerialize

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
	[arrayAllSides addObject:arrayDict];
	
	[arrayAllSides writeToFile:filePath atomically:NO];
}


+ (NSArray *)loadComicSlide:(NSInteger)index {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slides.plist"];
	
	NSArray *arrayAllSides = [NSArray arrayWithContentsOfFile:filePath];
	return arrayAllSides[index];
}

@end
