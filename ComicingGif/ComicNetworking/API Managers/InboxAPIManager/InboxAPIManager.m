//
//  InboxAPIManager.m
//  CurlDemo
//
//  Created by ADNAN THATHIYA on 23/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "InboxAPIManager.h"
#import "Constants.h"
#import "BaseAPIManager.h"

@implementation InboxAPIManager

+ (void)getActiveFriendsForUserID:(NSString *)userID
                     SuccessBlock:(void(^)(id object))successBlock
                          andFail:(void(^)(NSError *errorMessage))failBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, INBOXAPI, userID];
   
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:NO];
}

+ (void)getFriendsForUserID:(NSString *)userID
                     SuccessBlock:(void(^)(id object))successBlock
                          andFail:(void(^)(NSError *errorMessage))failBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, GET_FRIENDS_URL, userID];
    
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:NO];
}

@end
