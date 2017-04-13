//
//  MeAPIManager.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 22/01/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "MeAPIManager.h"
#import "Constants.h"
#import "BaseAPIManager.h"

@implementation MeAPIManager

+ (void)getTimelineWithPageNumber:(NSUInteger)page
                   timelinePeriod:(NSString *)period
                        direction:(NSString *)direction
                    currentUserId:(NSString *)currentUserId
                     SuccessBlock:(void(^)(id object))successBlock
                          andFail:(void(^)(NSError *errorMessage))failBlock {
    NSString *urlString;
    if(period.length == 0) {
        urlString = [NSString stringWithFormat:@"%@timeline/userId/%@/page/%lu/itemcount/10/startFrom/%@", BASE_URL,currentUserId, (unsigned long)page,period];
    } else {
        urlString = [NSString stringWithFormat:@"%@timeline/userId/%@/page/%lu/itemcount/10/startFrom/%@/direction/%@", BASE_URL,currentUserId, (unsigned long)page,period, direction];
    }
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:YES];
}

@end
