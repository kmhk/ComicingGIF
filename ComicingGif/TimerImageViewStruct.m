//
//  TimerImageViewStruct.m
//  ComicingGif
//
//  Created by stplmacmini5 on 01/06/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "TimerImageViewStruct.h"
#import "CMCCaptionView.h"

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

- (void)adjustViewAppearanceWithDelay:(CGFloat)delay {
    if (self.objType != ObjectCaption) {
        return;
    }
    if (![self.view isKindOfClass:[CMCCaptionView class]]) {
        return;
    }
    // TODO: add caption support
//    CMCCaptionView *captionView = (CMCCaptionView *) self.view;
//    [captionView switchTextContentToPrimaryText:(delay < captionView.secondaryTextActivationTimeOffset)];
}

@end
