//
//  PenObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "PenObject.h"

@implementation PenObject

- (id)initWithDrawingCoordintaes:(NSMutableArray *)coordinates
                   selectedColor:(UIColor *)color
                       brushSize:(CGFloat)brushSize
                        andFrame:(CGRect)frame {
    self = [super init];
    if (!self) {
        return nil;
    }
    _coordinates = coordinates;
    _color = color;
    _brushSize = brushSize;
    self.objType = ObjectPen;
    self.frame = frame;
    
    return self;
}

- (BaseObject *)initFromDict:(NSDictionary *)dict {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSDictionary *baseDict = (NSDictionary *)dict[@"baseInfo"];
    self.objType = (ComicObjectType)[baseDict[@"type"] integerValue];
    self.frame = CGRectFromString(baseDict[@"frame"]);
    self.angle = [baseDict[@"angle"] floatValue];
    self.scale = [baseDict[@"scale"] floatValue];
    
    _brushSize = [dict[@"brush-size"] floatValue];
    _color = [self colorFromDictionary:dict[@"color"]];
    _coordinates = [self coordinatesFromCoordinatesArray:dict[@"coordinates"]];
    
    return self;
}

- (NSDictionary *)dictForObject {
    NSDictionary *dict = [super dictForObject];
    NSDictionary *colorDictionary = [self dictionaryForColor:_color];
    NSMutableArray<NSDictionary *> *coordinatesStringArray = [self arrayForCoordinates:_coordinates];

    return @{
             @"baseInfo": dict,
             @"brush-size": @(_brushSize),
             @"color": colorDictionary,
             @"coordinates": coordinatesStringArray
             };
}

- (NSDictionary *)dictionaryForColor:(UIColor *)color {
    if (!color) {
        NSLog(@"Color is invalid. Can't convert to dictionary");
        return [NSMutableDictionary new];
    }
    
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return @{
             @"red": @(red),
             @"green": @(green),
             @"blue": @(blue),
             @"alpha": @(alpha)
             };
}

- (UIColor *)colorFromDictionary:(NSDictionary *)colorDictionary {
    if (!colorDictionary) {
        NSLog(@"Color dictionary is invalid. Can't convert to color");
        return [UIColor redColor];
    }
    
    CGFloat red = [colorDictionary[@"red"] floatValue];
    CGFloat green = [colorDictionary[@"green"] floatValue];
    CGFloat blue = [colorDictionary[@"blue"] floatValue];
    CGFloat alpha = [colorDictionary[@"alpha"] floatValue];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSMutableArray<NSDictionary *> *)arrayForCoordinates:(NSMutableArray<NSValue *> *)coordinates {
    NSMutableArray<NSDictionary *> *coordinatesArray = [NSMutableArray new];
    for (NSValue *valuePoint in coordinates) {
        CGPoint point = [valuePoint CGPointValue];
        NSDictionary *pointDictionary = @{@"x": @(point.x), @"y": @(point.y)};
        [coordinatesArray addObject:pointDictionary];
    }
    return coordinatesArray;
}

- (NSMutableArray<NSValue *> *)coordinatesFromCoordinatesArray:(NSMutableArray<NSDictionary *> *)coordinatesArray {
    NSMutableArray<NSValue *> *coordinatesValueArray = [NSMutableArray new];
    for (NSDictionary *pointDictionary in coordinatesArray) {
        CGFloat x = [pointDictionary[@"x"] floatValue];
        CGFloat y = [pointDictionary[@"y"] floatValue];
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [coordinatesValueArray addObject:pointValue];
    }
    return coordinatesValueArray;
}

@end
