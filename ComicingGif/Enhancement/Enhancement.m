//
//  Enhancement.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/03/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "Enhancement.h"

@implementation Enhancement

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"enhancementId": @"slide_enhancement_id",
             @"enhancementText": @"enhancement_text",
             @"enhancementType": @"enhancement_type",
             @"enhancementFile": @"enhancement_file",
             @"xPos": @"position_left",
             @"yPos": @"position_top",
             @"width": @"width",
             @"height": @"height",
             @"zIndex": @"z_index"
             };
}

@end
