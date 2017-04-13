//
//  TOC.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "TOC.h"

@implementation TOC

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"slideId": @"slide_id",
             @"slideThumb": @"slide_thumb"
             };
}

@end
