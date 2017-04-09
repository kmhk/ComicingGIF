//
//  CaptionObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

@interface CaptionObject : BaseObject

// caption string
@property (nonatomic) NSString *text;

// caption color
@property (nonatomic) UIColor *color;


// create caption object with text
- (id)initWithText:(NSString *)txt color:(UIColor *)color;

@end
