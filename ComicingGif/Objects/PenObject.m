//
//  PenObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "PenObject.h"

NSString * const kBrushSizeKey      = @"brush-size";
NSString * const kColorKey          = @"color";
NSString * const kCoordinatesKey    = @"coordinates";
NSString * const kRedKey            = @"red";
NSString * const kGreenKey          = @"green";
NSString * const kBlueKey           = @"blue";
NSString * const kAlphaKey          = @"alpha";
NSString * const kXCoordinateKey    = @"x";
NSString * const kYCoordinatekey    = @"y";

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
    
    NSDictionary *baseDict = (NSDictionary *)dict[kBaseInfoKey];
    self.objType = (ComicObjectType)[baseDict[kTypeKey] integerValue];
    self.frame = CGRectFromString(baseDict[kFrameKey]);
    self.angle = [baseDict[kAngleKey] floatValue];
    self.scale = [baseDict[kScaleKey] floatValue];
    self.delayTimeInSeconds = [baseDict[kDelayTimeKey] floatValue];
    
    _brushSize = [dict[kBrushSizeKey] floatValue];
    _color = [self colorFromDictionary:dict[kColorKey]];
    _coordinates = [self coordinatesFromCoordinatesArray:dict[kCoordinatesKey]];
    
    return self;
}

- (NSDictionary *)dictForObject {
    NSDictionary *dict = [super dictForObject];
    NSDictionary *colorDictionary = [self dictionaryForColor:_color];
    NSMutableArray<NSDictionary *> *coordinatesStringArray = [self arrayForCoordinates:_coordinates];

    return @{
             kBaseInfoKey: dict,
             kBrushSizeKey: @(_brushSize),
             kColorKey: colorDictionary,
             kCoordinatesKey: coordinatesStringArray
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
             kRedKey: @(red),
             kGreenKey: @(green),
             kBlueKey: @(blue),
             kAlphaKey: @(alpha)
             };
}

- (UIColor *)colorFromDictionary:(NSDictionary *)colorDictionary {
    if (!colorDictionary) {
        NSLog(@"Color dictionary is invalid. Can't convert to color");
        return [UIColor redColor];
    }
    
    CGFloat red = [colorDictionary[kRedKey] floatValue];
    CGFloat green = [colorDictionary[kGreenKey] floatValue];
    CGFloat blue = [colorDictionary[kBlueKey] floatValue];
    CGFloat alpha = [colorDictionary[kAlphaKey] floatValue];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSMutableArray<NSDictionary *> *)arrayForCoordinates:(NSMutableArray<NSValue *> *)coordinates {
    NSMutableArray<NSDictionary *> *coordinatesArray = [NSMutableArray new];
    for (NSValue *valuePoint in coordinates) {
        CGPoint point = [valuePoint CGPointValue];
        NSDictionary *pointDictionary = @{kXCoordinateKey: @(point.x), kYCoordinatekey: @(point.y)};
        [coordinatesArray addObject:pointDictionary];
    }
    return coordinatesArray;
}

- (NSMutableArray<NSValue *> *)coordinatesFromCoordinatesArray:(NSMutableArray<NSDictionary *> *)coordinatesArray {
    NSMutableArray<NSValue *> *coordinatesValueArray = [NSMutableArray new];
    for (NSDictionary *pointDictionary in coordinatesArray) {
        CGFloat x = [pointDictionary[kXCoordinateKey] floatValue];
        CGFloat y = [pointDictionary[kYCoordinatekey] floatValue];
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [coordinatesValueArray addObject:pointValue];
    }
    return coordinatesValueArray;
}

@end
