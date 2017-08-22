//
//  CommentModel.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 24/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"commentText": @"comment_text",
             @"commentType": @"comment_type",
             //@"firstName": @"first_name",
             //@"lastName": @"last_name",
             @"profilePic": @"profile_pic",
             @"userId": @"user_id",
             @"status": @"status"
             };
}

@end
