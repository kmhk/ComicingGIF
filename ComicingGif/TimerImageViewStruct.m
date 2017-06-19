//
//  TimerImageViewStruct.m
//  ComicingGif
//
//  Created by stplmacmini5 on 01/06/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "TimerImageViewStruct.h"

@implementation TimerImageViewStruct

- (instancetype)initWithImageView:(UIImageView *)imageView delayTime:(CGFloat)delayTime andObjectType:(ComicObjectType)objType {
    self = [super init];
    if (self) {
        self.imageView = imageView;
        self.delayTimeOfImageView = delayTime;
        self.objType = objType;
    }
    
    return self;
}

@end
