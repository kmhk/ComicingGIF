//
//  DateLabel.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 09/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "DateLabel.h"

@implementation DateLabel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"label": @"label",
             @"code": @"code",
             @"active": @"active"
             };
}

@end
