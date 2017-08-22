//
//  ComicMakingViewModel.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"


@interface ComicMakingViewModel : NSObject

// array of all objects of BaseObject that added on this comic slide
@property (nonatomic) NSMutableArray *arrayObjects;


// array of recent objects. All elements are NSDictionary type
@property (nonatomic) NSMutableArray *arrayRecents;


- (BOOL)isContainedAnimatedSticker;

// add comic object to the array
- (void)addObject:(BaseObject *)obj;
- (void)addRecentObject:(NSDictionary *)dict;
- (NSArray *)getRecentObjects:(ComicObjectType)type;

// save slide objects to file
- (void)saveObject;

@end
