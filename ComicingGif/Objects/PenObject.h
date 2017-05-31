//
//  PenObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

@interface PenObject : BaseObject

/**
 All coordinates for single drawing object (`PenObject` in this case)
 */
@property (nonatomic) NSMutableArray<NSValue *> *coordinates;

/**
 Selected color for single drawing object. Each atomic drawing object has its own selected color
 */
@property (nonatomic) UIColor *color;

/**
 Size of the brush for single drawing object
 */
@property (nonatomic) CGFloat brushSize;

/**
 Create new `PenObject` based on specific properties

 @param coordinates All coordinates for single drawing object (`PenObject` in this case)
 @param color Selected color for single drawing object. Each atomic drawing object has its own selected color
 @param brushSize Size of the brush for single drawing object
 @param frame Frame of the single drawing object. Could be a whole screen frame.
 @return New instance of filled PenObject
 */
- (id)initWithDrawingCoordintaes:(NSMutableArray *)coordinates
                   selectedColor:(UIColor *)color
                       brushSize:(CGFloat)brushSize
                        andFrame:(CGRect)frame;

@end
