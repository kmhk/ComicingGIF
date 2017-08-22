//
//  PrivateConversationAPIManager.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 22/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivateConversationAPIManager : NSObject

+ (void)getPrivateConversationWithFriendId:(NSString *)friendId
                             currentUserId:(NSString *)currentUserId
                              SuccessBlock:(void(^)(id object))successBlock
                                   andFail:(void(^)(NSError *errorMessage))failBlock;

+ (void)postPrivateConversationV2CommentWithFriendId:(NSString *)friendId
                                           shareText: (NSString *)shareText
                                       currentUserId:(NSString *)currentUserId
                                        SuccessBlock:(void(^)(id object))successBlock
                                             andFail:(void(^)(NSError *errorMessage))failBlock;

+ (void)putSeenStatusWithOwnerId:(NSString *)friendId
                          userId: (NSString *)userId
                    SuccessBlock:(void(^)(id object))successBlock
                         andFail:(void(^)(NSError *errorMessage))failBlock;

@end
