//
//  GroupsAPIManager.h
//  Inbox
//
//  Created by Vishnu Vardhan PV on 20/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupsAPIManager : NSObject

+ (void)getTheListOfGroupsForTheUserID:(NSString *)userID
                      withSuccessBlock:(void(^)(id object))successBlock
                               andFail:(void(^)(NSError *errorMessage))failBlock;

+ (void)getListOfGroupMemberForGroupID:(NSString *)groupID
                      withSuccessBlock:(void(^)(id object))successBlock
                               andFail:(void(^)(NSError *errorMessage))failBlock;

+ (void)getListComicsOfGroupForGroupID:(NSString *)groupID
                      withSuccessBlock:(void(^)(id object))successBlock
                               andFail:(void(^)(NSError *errorMessage))failBlock;

+ (void)postGroupConversationV2CommentWithGroupID:(NSString *)groupID
                                           shareText: (NSString *)shareText
                                       currentUserId:(NSString *)currentUserId
                                        SuccessBlock:(void(^)(id object))successBlock
                                             andFail:(void(^)(NSError *errorMessage))failBlock;

+ (void)putSeenStatusWithGroupID:(NSString *)groupID
                          userId: (NSString *)userId
                    SuccessBlock:(void(^)(id object))successBlock
                         andFail:(void(^)(NSError *errorMessage))failBlock;

@end
