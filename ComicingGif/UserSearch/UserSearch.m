//
//  UserDetail.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "UserSearch.h"

@implementation UserSearch

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"userId": @"user_id",
             @"status": @"status",
             @"loginId": @"login_id",
             @"firstName": @"first_name",
             @"lastName": @"last_name",
             @"email": @"email",
             @"password": @"password",
             @"userTypeId": @"user_type_id",
             @"profilePic": @"profile_pic",
             @"dob": @"dob",
             @"country": @"country",
             @"mobile": @"mobile",
             @"createdDate":@"created_date",
             @"fb_id": @"fb_id",
             @"insta_id": @"insta_id",
             @"desc": @"description",
             @"friendCount": @"friends_count"
             };
}

@end
