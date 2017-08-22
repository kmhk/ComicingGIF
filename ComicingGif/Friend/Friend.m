//
//  Friend.m
//  Inbox
//
//  Created by Vishnu Vardhan PV on 19/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "Friend.h"

@implementation Friend

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"country" : @"country",
             @"dob" : @"dob",
             @"email" : @"email",
             @"firstName" : @"first_name",
             @"lastName" : @"last_name",
             @"friendId" : @"friend_id",
             @"mobile" : @"mobile",
             @"profilePic" : @"profile_pic",
             @"status" : @"status",
             @"role" : @"role",
             @"userId" : @"user_id",
             @"loginId" : @"login_id",
             @"userType" : @"user_type"
             };
}


//"comic_delivery_id": "23",
//"type": "G5",
//"share_type": "G",
//"group_id": "group_id",
//"group_title": "MyFirst Group2",
//"group_icon": "http:\/\/68.169.44.163\/groupIcons\/55b7983720aa0",
//"user_id": "",
//"first_name": "",
//"last_name": "",
//"login_id": "",
//"profile_pic": ""

@end
