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
	NSMutableArray *arrayAllSides = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"all slides"]];
	if (!arrayAllSides) {
		arrayAllSides = [[NSMutableArray alloc] init];
	}
	
	NSMutableArray *arrayDict = [[NSMutableArray alloc] init];
	for (BaseObject *obj in array) {
		[arrayDict addObject:[obj dictForObject]];
	}
	[arrayAllSides addObject:arrayDict];
	
	// write array
	[[NSUserDefaults standardUserDefaults] setObject:arrayAllSides forKey:@"all slides"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSArray *)loadComicSlide:(NSInteger)index {
	NSArray *arrayAllSides = [[NSUserDefaults standardUserDefaults] objectForKey:@"all slides"];
	return arrayAllSides[index];
}

@end
