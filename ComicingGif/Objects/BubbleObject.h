//
//  BubbleObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

@interface BubbleObject : BaseObject

// bubble image resource name
@property (nonatomic) NSURL *bubbleURL;

// bubble text
@property (nonatomic) NSString *text;


// create bubble object with text and bubble image resource ID
- (id)initWithText:(NSString *)txt bubbleID:(NSString *)ID;


// create bubble object with text and bubble image URL
- (id)initWithText:(NSString *)txt bubbleURL:(NSString *)urlString;

@end
