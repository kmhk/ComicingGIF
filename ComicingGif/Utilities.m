//
//  Utilities.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 24/12/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import "Utilities.h"
#import <objc/runtime.h>
#import "Constants.h"
#import "Reachability.h"
#import "AppDelegate.h"

@implementation Utilities

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NSString *)getDateStringForParam:(NSString *)param {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    if([param isEqualToString:NOW]) {
//        comps.day = 0;
        return @"Now";
    } else if([param isEqualToString:ONE_WEEK]) {
        comps.day = -7;
    } else if([param isEqualToString:ONE_MONTH]) {
        comps.day = -30;
    } else if([param isEqualToString:THREE_MONTHS]) {
        comps.day = -90;
    }
    NSDate *previousDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"MMM yyyy"];
    [dateFormat setDateFormat:@"MMM"];

    NSString *monthAndYear = [dateFormat stringFromDate:previousDate];
    return monthAndYear;
}

+ (BOOL)isReachable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if ([reachability currentReachabilityStatus] != NotReachable) {
        return true;
    } else {
        return false;
    }
}

+ (Friend *)getTheFriendObjForUserID:(NSString *)userId {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userId == \"%@\"", userId];
    NSArray *result = [[AppDelegate application].dataManager.friendsArray filteredArrayUsingPredicate:pred];
    if(result.count > 0) {
        Friend *friend = result[0];
        return friend;
    }
    return nil;
}

@end
