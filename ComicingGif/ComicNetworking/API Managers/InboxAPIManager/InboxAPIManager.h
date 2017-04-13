//
//  InboxAPIManager.h
//  CurlDemo
//
//  Created by ADNAN THATHIYA on 23/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InboxAPIManager : NSObject

+ (void)getActiveFriendsForUserID:(NSString *)userID
                     SuccessBlock:(void(^)(id object))successBlock
                          andFail:(void(^)(NSError *errorMessage))failBlock;

+ (void)getFriendsForUserID:(NSString *)userID
               SuccessBlock:(void(^)(id object))successBlock
                    andFail:(void(^)(NSError *errorMessage))failBlock;

@end
