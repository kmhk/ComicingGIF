//
//  CaptionObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CaptionObject.h"

@interface CaptionObject()
@end


// MARK: -
@implementation CaptionObject

- (id)initWithText:(NSString *)text captionType:(CaptionObjectType)captionType {
    self = [self initWithText:text captionType:captionType andFrame:CGRectZero];
    return self;
}

- (id)initWithText:(NSString *)text captionType:(CaptionObjectType)captionType andFrame:(CGRect)frame {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.objType = ObjectCaption;
    self.frame = frame;
    
    self.text = text;
    self.type = captionType;
    return self;
}

- (BaseObject *)initFromDict:(NSDictionary *)dict {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSDictionary *baseDict = (NSDictionary *) dict[@"baseInfo"];
    self.objType = (ComicObjectType)[baseDict[@"type"] integerValue];
    self.angle = [baseDict[@"angle"] floatValue];
    self.scale = [baseDict[@"scale"] floatValue];
    self.frame = CGRectFromString(baseDict[@"frame"]);
    self.delayTimeInSeconds = [baseDict[@"delayTime"] floatValue];
    
    _text = dict[@"text"];
    _type = (CaptionObjectType) [dict[@"captionType"] integerValue];
    
    return self;
}

- (NSDictionary *)dictForObject {
    NSDictionary *dict = [super dictForObject];
    return @{
             @"baseInfo": dict,
             @"text": _text,
             @"captionType": @(_type)
             };
}

- (void)changeCaptionTypeTo:(CaptionObjectType)captionType {
    if (_type != captionType) {
        _type = captionType;
    }
}

@end
