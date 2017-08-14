//
//  ComicProperties.m
//  ComicBook
//
//  Created by Amit on 22/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "ComicProperties.h"

@implementation ComicProperties

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"fontColor": @"font_color",
             @"fontSize": @"font_size",
             @"fontName": @"font_name"
             };
}

@end
