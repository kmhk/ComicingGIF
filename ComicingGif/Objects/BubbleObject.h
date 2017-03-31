//
//  BubbleObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

@interface BubbleObject : BaseObject

// create bubble object with text and bubble image resource name
- (id)initWithText:(NSString *)txt bubble:(NSString *)name;

@end
