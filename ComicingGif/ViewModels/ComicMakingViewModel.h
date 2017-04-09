//
//  ComicMakingViewModel.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BaseObject;


@interface ComicMakingViewModel : NSObject

// array of all objects of BaseObject that added on this comic slide
@property (nonatomic) NSMutableArray *arrayObjects;


// add comic object to the array
- (void)addObject:(BaseObject *)obj;

// save slide objects to file
- (void)saveObject;

@end
