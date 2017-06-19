//
//  TimerImageViewStruct.h
//  ComicingGif
//
//  Created by stplmacmini5 on 01/06/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseObject.h"

@interface TimerImageViewStruct : NSObject

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, assign) CGFloat delayTimeOfImageView;
@property(nonatomic, assign) ComicObjectType objType;

- (instancetype)initWithImageView:(UIImageView *)imageView delayTime:(CGFloat)delayTime andObjectType:(ComicObjectType)objType;

@end
