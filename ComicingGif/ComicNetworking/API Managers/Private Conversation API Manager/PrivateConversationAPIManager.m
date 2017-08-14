//
//  PrivateConversationAPIManager.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 22/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "PrivateConversationAPIManager.h"
#import "Constants.h"
#import "BaseAPIManager.h"
#import "AppHelper.h"

@implementation PrivateConversationAPIManager

// http://68.169.44.163/api/conversations/userId/2/ownerId/1

+ (void)getPrivateConversationWithFriendId:(NSString *)friendId
                             currentUserId:(NSString *)currentUserId
                              SuccessBlock:(void(^)(id object))successBlock
                                   andFail:(void(^)(NSError *errorMessage))failBlock {
    NSString *urlString = [NSString stringWithFormat:@"%@conversationsv2/userId/%@/ownerId/%@", BASE_URL,currentUserId,friendId];
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:YES];
}

+ (void)postPrivateConversationV2CommentWithFriendId:(NSString *)friendId
                                           shareText: (NSString *)shareText
                                       currentUserId:(NSString *)currentUserId
                                        SuccessBlock:(void(^)(id object))successBlock
                                             andFail:(void(^)(NSError *errorMessage))failBlock
{
    NSDictionary *POST_shareParams = [self postShareParamsWithText:shareText currentUserId:currentUserId];
    
    [BaseAPIManager postPublicRequestWithURLString:COMIC_CREATE
                                     withParameter:POST_shareParams
                                       withSuccess:^(id object) {
                                           
                                           //-------------------
                                           NSNumber *comicId = [object valueForKey:@"data"];
                                           
                                           NSString *comicIdString = [NSString stringWithFormat:@"%@", comicId];//MY COMIC ID IS NSNUMBERv >> SO I AM COVERTING TO STRING
                                           
                                           NSDictionary *PUT_shareParams = [self putShareParamsWithId:comicIdString currentUserId:currentUserId friendId:friendId];
                                           
                                           [BaseAPIManager putRequestWithURL:COMIC_CREATE
                                                               withParameter:PUT_shareParams
                                                                 withSuccess:^(id object, AFHTTPRequestOperation *operationObjet) {
                                                                     successBlock(object);
                                                                 } andFail:^(id errorObj) {
                                                                     failBlock(errorObj);
                                                                 } showIndicator:YES];
                                           //-------------------
                                           
                                           
                                       } andFail:^(id errorObj) {
                                           failBlock(errorObj);
                                       } showIndicator:YES];
    
}

+ (void)putSeenStatusWithOwnerId:(NSString *)friendId
                          userId: (NSString *)userId
                    SuccessBlock:(void(^)(id object))successBlock
                         andFail:(void(^)(NSError *errorMessage))failBlock
{
    NSDictionary *PUT_seenParams = [self putSeenParamsWithFriendId:friendId userId:userId];
    
    NSString *urlString = [NSString stringWithFormat:@"%@conversationsv2/", BASE_URL];

    [BaseAPIManager putRequestWithURLString:urlString
                              withParameter:PUT_seenParams
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:NO];
}

+ (nullable NSDictionary *)postShareParamsWithText: (NSString *)shareText
                                     currentUserId: (NSString *)currentUserId
{
    if (shareText.length > 0 &&
        currentUserId.length > 0)
    {
        return @{@"data":@{@"is_comic":@0,
                           @"share_text": shareText,
                           @"status": @1,
                           @"user_id": currentUserId}
                 };
    }
    
    return nil;
}

+ (nullable NSDictionary *)putShareParamsWithId: (NSString *)comicId
                                  currentUserId: (NSString *)currentUserId
                                       friendId: (NSString *)friendId
{
    if (comicId.length > 0 &&
        currentUserId.length > 0 &&
        friendId.length > 0)
    {
        return @{@"data":@{@"comic_id":comicId,
                           @"is_comic":@0,
                           @"friendShares":@[@{@"friend_id":friendId, @"status":@1}],
                           @"user_id" : currentUserId}};
    }
    
    return nil;
}

+ (nullable NSDictionary *)putSeenParamsWithFriendId: (NSString *)friendId
                                  userId: (NSString *)userId
{
    if (friendId.length > 0 &&
        userId.length > 0)
    {
        return @{@"data": @{@"method":@"seen_update",
                            @"request":@{@"userId": userId,
                                         @"ownerId":friendId,
                                         @"seen_by":userId}}};
    }
    
    return nil;
}

@end
