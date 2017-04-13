//
//  FriendsAPIManager.m
//  Inbox
//
//  Created by Vishnu Vardhan PV on 19/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "FriendsAPIManager.h"
#import "Constants.h"
#import "BaseAPIManager.h"

@implementation FriendsAPIManager

+ (void)getTheListOfFriendsForTheUserID:(NSString *)userID
                  withSuccessBlock:(void(^)(id object))successBlock
                           andFail:(void(^)(NSError *errorMessage))failBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, GET_FRIENDS_URL, userID];
    [BaseAPIManager getRequestWithURLString:urlString
                                withParameter:nil
                                  withSuccess:^(id object) {
                                      successBlock(object);
                                  } andFail:^(id errorObj) {
                                      failBlock(errorObj);
                                  } showIndicator:YES];
}

+ (void)makeFirendOrUnfriendForUserId:(NSString *)friendId
                           WithStatus:(NSString *)status
                        CurrentUserId:(NSString *)currentUserId
                     withSuccessBlock:(void(^)(id object))successBlock
                              andFail:(void(^)(NSError *errorMessage))failBlock {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, GET_FRIENDS_URL,currentUserId];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
    [friendDict setValue:friendId forKey:@"friend_id"];
    [friendDict setValue:status forKey:@"status"];
    NSMutableArray *friendsArray = [[NSMutableArray alloc] init];
    [friendsArray addObject:friendDict];
    [data setValue:friendsArray forKey:@"friends"];
    [data setValue:currentUserId forKey:@"user_id"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:data forKey:@"data"];
    [BaseAPIManager putRequestWithURLString:urlString
                              withParameter:parameters
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:YES];
}

+ (void)getTheListOfFriendsByID:(NSString *)searchText
               withSuccessBlock:(void(^)(id object))successBlock
                        andFail:(void(^)(NSError *errorMessage))failBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, SEARCH_USER_Id, searchText];
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:YES];
}

+ (void)getUserProfileByID:(NSString *)loginID
          withSuccessBlock:(void (^)(id))successBlock
                   andFail:(void (^)(NSError *))failBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, @"users/", loginID];
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:YES];
}


@end
