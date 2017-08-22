//
//  BaseAPIManager.h
//  Inbox
//
//  Created by Vishnu Vardhan PV on 19/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BaseAPIManager : NSObject

+ (void) getRequestWithURLString:(NSString *)urlString
                   withParameter:(id)parameters
                     withSuccess:(void(^)(id object))successBlock
                         andFail:(void(^)(id errorObj))failBlock
                   showIndicator:(BOOL)shouldShowIndicator;

+ (void) postPublicRequestWithURLString:(NSString *)urlString
                          withParameter:(id)parameters
                            withSuccess:(void(^)(id object))successBlock
                                andFail:(void(^)(id errorObj))failBlock
                          showIndicator:(BOOL)shouldShowIndicator;

+ (void) putRequestWithURLString:(NSString *)urlString
                   withParameter:(id)parameters
                     withSuccess:(void(^)(id object))successBlock
                         andFail:(void(^)(id errorObj))failBlock
                   showIndicator:(BOOL)shouldShowIndicator;

+ (void)getRequestWithURL:(NSString *)urlString
                   withParameter:(id)parameters
                     withSuccess:(void(^)(id object,AFHTTPRequestOperation* operationObjet))successBlock
                        andFail:(void(^)(id errorObj))failBlock
                  showIndicator:(BOOL)shouldShowIndicator;

+ (void) postPublicRequestWith:(NSString *)urlString
                 withParameter:(id)parameters
                   withSuccess:(void(^)(id object,AFHTTPRequestOperation* operationObjet))successBlock
                       andFail:(void(^)(id errorObj))failBlock
                 showIndicator:(BOOL)shouldShowIndicator;

+ (void) putRequestWithURL:(NSString *)urlString
             withParameter:(id)parameters
               withSuccess:(void(^)(id object,AFHTTPRequestOperation* operationObjet))successBlock
                   andFail:(void(^)(id errorObj))failBlock
             showIndicator:(BOOL)shouldShowIndicator;

//+ (void)showHUDLoader:(MBProgressHUD *)HUD overTheView:(BOOL)show;

@end
