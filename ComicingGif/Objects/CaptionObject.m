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
    
    NSDictionary *baseDict = (NSDictionary *) dict[kBaseInfoKey];
    self.objType = (ComicObjectType)[baseDict[kTypeKey] integerValue];
    self.angle = [baseDict[kAngleKey] floatValue];
    self.scale = ([baseDict[kScaleKey] floatValue]/100)*20 + [baseDict[kScaleKey] floatValue];
    self.frame = CGRectFromString(baseDict[kFrameKey]);
    self.delayTimeInSeconds = [baseDict[kDelayTimeKey] floatValue];
    
    _text = dict[kTextKey];
    _type = (CaptionObjectType) [dict[kCaptionTypeKey] integerValue];
    
    return self;
}

- (NSDictionary *)dictForObject {
    NSDictionary *dict = [super dictForObject];
    return @{
             kBaseInfoKey: dict,
             kTextKey: _text,
             kCaptionTypeKey: @(_type)
             };
}

- (void)changeCaptionTypeTo:(CaptionObjectType)captionType {
    if (_type != captionType) {
        _type = captionType;
    }
}

@end
