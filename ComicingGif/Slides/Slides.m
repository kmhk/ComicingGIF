//
//  Slides.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "Slides.h"

@implementation Slides

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"comicSlideId": @"comic_slide_id",
             @"slideImage": @"slide_image",
             @"slideStatus": @"slide_status",
             @"enhancements": @"enhancements",
             @"slideType": @"slide_type"
             };
}

+ (NSValueTransformer *)enhancementsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Enhancement class]];
}

@end
