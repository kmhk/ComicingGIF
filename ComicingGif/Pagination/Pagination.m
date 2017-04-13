//
//  Pagination.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "Pagination.h"

@implementation Pagination

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"first": @"first",
             @"current": @"current",
             @"last": @"last",
             @"next": @"next",
             @"pageCount": @"pageCount",
             @"itemCountPerPage": @"itemCountPerPage"
             };
}

@end
