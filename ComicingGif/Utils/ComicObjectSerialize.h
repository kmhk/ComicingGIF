//
//  ComicObjectSerialize.h
//  ComicingGif
//
//  Created by Com on 04/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicObjectSerialize : NSObject

@property (nonatomic) NSInteger indexSaved;
@property (nonatomic) NSInteger indexDeleted;

+ (void)setSavedIndex:(NSInteger)index;
+ (NSInteger)getSavedIndex;

+ (void)setDeletedIndex:(NSInteger)index;
+ (NSInteger)getDeletedIndex;

+ (void)saveObjectWithArray:(NSArray *)array;
+ (void)deleteObjectAtIndex:(NSInteger)index;
+ (NSArray *)loadComicSlide;

@end
