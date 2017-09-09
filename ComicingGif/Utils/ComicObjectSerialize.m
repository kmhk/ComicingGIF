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
        NSArray *oldSlideArray = arrayAllSides[gComicObjectSerializeObj.indexSaved];
        [self deleteOldSlideArrayData:oldSlideArray basedOnSlideArray:arrayDict];
        [arrayAllSides replaceObjectAtIndex:gComicObjectSerializeObj.indexSaved withObject:arrayDict];
}
	
	[arrayAllSides writeToFile:filePath atomically:NO];
}

+ (void)deleteOldSlideArrayData:(NSArray *)oldSlideArray basedOnSlideArray:(NSArray *)newSlideArray {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.baseInfo.type == %@", @(ObjectBaseImage)];
    
    NSDictionary *baseSlideDictOld = [[oldSlideArray filteredArrayUsingPredicate:predicate] firstObject];
    NSDictionary *baseSlideDictNew = [[newSlideArray filteredArrayUsingPredicate:predicate] firstObject];
    
    if (baseSlideDictOld) {
        NSString *gifPathOld = baseSlideDictOld[kURLKey];
        NSString *gifPathNew = baseSlideDictNew[kURLKey];
        // Delete old slide base GIF file from local storage if new one is different
        if (gifPathOld && ![gifPathOld isEqualToString:gifPathNew]) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            [fileManager removeItemAtURL:[NSURL URLWithString:gifPathOld]
                                   error:&error];
            if (error) {
                NSLog(@"Error deleting slide gif: %@", [error localizedDescription]);
            }
        }
    }
}

+ (NSArray *)loadComicSlide {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slides.plist"];
	return [NSArray arrayWithContentsOfFile:filePath];
}

@end
