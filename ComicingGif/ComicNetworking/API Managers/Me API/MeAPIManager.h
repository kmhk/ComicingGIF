//
//  MeAPIManager.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 22/01/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeAPIManager : NSObject

+ (void)getTimelineWithPageNumber:(NSUInteger)page
                   timelinePeriod:(NSString *)period
                        direction:(NSString *)direction
                    currentUserId:(NSString *)currentUserId
                     SuccessBlock:(void(^)(id object))successBlock
                          andFail:(void(^)(NSError *errorMessage))failBlock;

@end
