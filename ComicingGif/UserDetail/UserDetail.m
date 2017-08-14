//
//  UserDetail.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "UserDetail.h"

@implementation UserDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"userId": @"user_id",
             @"firstName": @"first_name",
             @"lastName": @"last_name",
             @"profilePic": @"profile_pic"
             };
}

@end
