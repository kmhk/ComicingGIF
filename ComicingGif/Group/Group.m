//
//  Group.m
//  Inbox
//
//  Created by Vishnu Vardhan PV on 20/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "Group.h"

@implementation Group

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"groupIcon" : @"group_icon",
             @"groupId" : @"group_id",
             @"groupTitle" : @"group_title",
             @"role" : @"role",
             @"status" : @"status",
             @"members" : @"members"
             };
}

+ (NSValueTransformer *)membersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Friend class]];
}

@end
