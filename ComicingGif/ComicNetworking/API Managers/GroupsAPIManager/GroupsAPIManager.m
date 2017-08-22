//
//  GroupsAPIManager.m
//  Inbox
//
//  Created by Vishnu Vardhan PV on 20/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "GroupsAPIManager.h"
#import "Constants.h"
#import "BaseAPIManager.h"


@implementation GroupsAPIManager

+ (void)getTheListOfGroupsForTheUserID:(NSString *)userID
                      withSuccessBlock:(void(^)(id object))successBlock
                               andFail:(void(^)(NSError *errorMessage))failBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, GET_GROUPS_URL, userID];
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:YES];
}

+ (void)getListOfGroupMemberForGroupID:(NSString *)groupID
                      withSuccessBlock:(void(^)(id object))successBlock
                               andFail:(void(^)(NSError *errorMessage))failBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL,GET_GROUPS_MEMBER , groupID];
    
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object)
     {
         successBlock(object);
         
     } andFail:^(id errorObj) {
         failBlock(errorObj);
     } showIndicator:YES];
}

+ (void)getListComicsOfGroupForGroupID:(NSString *)groupID
                      withSuccessBlock:(void(^)(id object))successBlock
                               andFail:(void(^)(NSError *errorMessage))failBlock
{
    //NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, GET_GROUPS_COMICS, groupID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", BASE_URL, @"conversationsv2/groupId/", groupID];
    
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object)
     {
         successBlock(object);
         
     } andFail:^(id errorObj) {
         failBlock(errorObj);
     } showIndicator:YES];
}

+ (void)postGroupConversationV2CommentWithGroupID:(NSString *)groupID
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
                                           
                                           NSDictionary *PUT_shareParams = [self putShareParamsWithId:comicIdString currentUserId:currentUserId groupID:groupID];
                                           
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

+ (void)putSeenStatusWithGroupID:(NSString *)groupID
                          userId: (NSString *)userId
                    SuccessBlock:(void(^)(id object))successBlock
                         andFail:(void(^)(NSError *errorMessage))failBlock
{

    NSDictionary *PUT_seenParams = [self putSeenParamsWithGroupId:groupID userId:userId];
    
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
                                       groupID: (NSString *)groupID
{
    if (comicId.length > 0 &&
        currentUserId.length > 0 &&
        groupID.length > 0)
    {
        return @{@"data":@{@"comic_id":comicId,
                           @"is_comic":@0,
                           @"groupShares":@[@{@"group_id":groupID,@"status":@1}],
                           @"user_id" : currentUserId}};
    }
    
    return nil;
}

+ (nullable NSDictionary *)putSeenParamsWithGroupId: (NSString *)groupId
                                              userId: (NSString *)userId
{
    if (groupId.length > 0 &&
        userId.length > 0)
    {
        return @{@"data": @{@"method" : @"seen_update",
                            @"request": @{@"groupId": groupId,
                                     @"seen_by": userId}}};
    }
    
    return nil;
}

@end
