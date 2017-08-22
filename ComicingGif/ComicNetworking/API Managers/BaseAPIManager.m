//
//  BaseAPIManager.m
//  Inbox
//
//  Created by Vishnu Vardhan PV on 19/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "BaseAPIManager.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "GoogleAnalytics.h"

NSString * const CONTENT_TYPE_JSON = @"text/html";

@implementation BaseAPIManager

#pragma mark Request with mutliple parame callback 

+ (void)getRequestWithURL:(NSString *)urlString
            withParameter:(id)parameters
              withSuccess:(void(^)(id object,AFHTTPRequestOperation* operationObjet))successBlock
                  andFail:(void(^)(id errorObj))failBlock
            showIndicator:(BOOL)shouldShowIndicator{
    
    [AppHelper showHUDLoader:shouldShowIndicator];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:CONTENT_TYPE_JSON];
    //Adding Authorization
    if ([AppHelper getAuthId] && ![[AppHelper getAuthId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getAuthId] forHTTPHeaderField:@"Authorization"];
    }
    //Adding Nonce
    if ([AppHelper getNonceId] && ![[AppHelper getNonceId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getNonceId] forHTTPHeaderField:@"Nonce"];
    }
    manager.operationQueue.maxConcurrentOperationCount = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager GET:urlString
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation,id responseObject) {
             [AppHelper showHUDLoader:NO];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             successBlock(responseObject,operation);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [[GoogleAnalytics sharedGoogleAnalytics] logExceptions:operation.responseString];
             [AppHelper showHUDLoader:NO];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             failBlock(error);
         }];
    
}
+ (void) postPublicRequestWith:(NSString *)urlString
                          withParameter:(id)parameters
                            withSuccess:(void(^)(id object,AFHTTPRequestOperation* operationObjet))successBlock
                                andFail:(void(^)(id errorObj))failBlock
                          showIndicator:(BOOL)shouldShowIndicator {
    [AppHelper showHUDLoader:shouldShowIndicator];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:CONTENT_TYPE_JSON];
    //Adding Authorization
    if ([AppHelper getAuthId] && ![[AppHelper getAuthId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getAuthId] forHTTPHeaderField:@"Authorization"];
    }
    //Adding Nonce
    if ([AppHelper getNonceId] && ![[AppHelper getNonceId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getNonceId] forHTTPHeaderField:@"Nonce"];
    }
    manager.operationQueue.maxConcurrentOperationCount = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager POST:urlString
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         [AppHelper showHUDLoader:NO];
         successBlock(responseObject,operation);
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSString* strg = [self jsonString:operation.responseString];
         [[GoogleAnalytics sharedGoogleAnalytics] logExceptions:operation.responseString];
         [AppHelper showHUDLoader:NO];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         if (strg && ![strg isEqualToString:@""]) {
             NSData *data = [strg dataUsingEncoding:NSUTF8StringEncoding];
             id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             successBlock(json,operation);
         }else{
             failBlock(error);
         }
     }];
}

+ (void) putRequestWithURL:(NSString *)urlString
                   withParameter:(id)parameters
                     withSuccess:(void(^)(id object,AFHTTPRequestOperation* operationObjet))successBlock
                         andFail:(void(^)(id errorObj))failBlock
                   showIndicator:(BOOL)shouldShowIndicator {
    [AppHelper showHUDLoader:shouldShowIndicator];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:CONTENT_TYPE_JSON];
    //Adding Authorization
    if ([AppHelper getAuthId] && ![[AppHelper getAuthId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getAuthId] forHTTPHeaderField:@"Authorization"];
    }
    //Adding Nonce
    if ([AppHelper getNonceId] && ![[AppHelper getNonceId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getNonceId] forHTTPHeaderField:@"Nonce"];
    }
    manager.operationQueue.maxConcurrentOperationCount = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager PUT:urlString
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         [AppHelper showHUDLoader:NO];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//         successBlock(responseObject,responseObject);
         successBlock(responseObject,operation);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSString* strg = [self jsonString:operation.responseString];
         [[GoogleAnalytics sharedGoogleAnalytics] logExceptions:operation.responseString];
         [AppHelper showHUDLoader:NO];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         if (strg && ![strg isEqualToString:@""]) {
             NSData *data = [strg dataUsingEncoding:NSUTF8StringEncoding];
             id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             successBlock(json,operation);
         }else{
             failBlock(error);
         }
     }];
}
+(NSString*)jsonString:(NSString*)s{
    NSRange r1 = [s rangeOfString:@"{"];
    NSRange r2 = [s rangeOfString:@"}"];
    if (r1.length == 0 ||
        r2.length == 0 ) {
        return @"";
    }
    NSRange rSub = NSMakeRange((r1.location -1 ) + r1.length, (r2.location - r1.location - r1.length) + 2);
    return [s substringWithRange:rSub];
}
+ (void) getRequestWithURLString:(NSString *)urlString
                   withParameter:(id)parameters
                     withSuccess:(void(^)(id object))successBlock
                         andFail:(void(^)(id errorObj))failBlock
                   showIndicator:(BOOL)shouldShowIndicator {
//    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithWindow:[[[UIApplication sharedApplication] delegate] window]];
//    if (shouldShowIndicator == true) {
//        [BaseAPIManager showHUD:HUD overTheView:YES];
//    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:CONTENT_TYPE_JSON];
    //Adding Authorization
    if ([AppHelper getAuthId] && ![[AppHelper getAuthId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getAuthId] forHTTPHeaderField:@"Authorization"];
    }
    //Adding Nonce
    if ([AppHelper getNonceId] && ![[AppHelper getNonceId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getNonceId] forHTTPHeaderField:@"Nonce"];
    }
    NSLog(@"URL : %@",urlString);
    NSLog(@"Nonce : %@",[AppHelper getNonceId]);
    NSLog(@"Authorization : %@",[AppHelper getAuthId]);
    
    manager.operationQueue.maxConcurrentOperationCount = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager GET:urlString
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation,id responseObject) {
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             
             if ([[responseObject valueForKey:@"result"] isEqualToString:@"failed"])
             {
                 
                 successBlock(nil);
             }
             else
             {
                 successBlock(responseObject);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [[GoogleAnalytics sharedGoogleAnalytics] logExceptions:operation.responseString];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             failBlock(error);
         }];
}

+ (void) postPublicRequestWithURLString:(NSString *)urlString
                          withParameter:(id)parameters
                            withSuccess:(void(^)(id object))successBlock
                                andFail:(void(^)(id errorObj))failBlock
                          showIndicator:(BOOL)shouldShowIndicator {
    [AppHelper showHUDLoader:shouldShowIndicator];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:CONTENT_TYPE_JSON];
    //Adding Authorization
    if ([AppHelper getAuthId] && ![[AppHelper getAuthId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getAuthId] forHTTPHeaderField:@"Authorization"];
    }
    //Adding Nonce
    if ([AppHelper getNonceId] && ![[AppHelper getNonceId] isEqualToString:@""]) {
        [manager.requestSerializer setValue:[AppHelper getNonceId] forHTTPHeaderField:@"Nonce"];
    }
    manager.operationQueue.maxConcurrentOperationCount = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager POST:urlString
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         [AppHelper showHUDLoader:NO];
         successBlock(responseObject);
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[GoogleAnalytics sharedGoogleAnalytics] logExceptions:operation.responseString];
         [AppHelper showHUDLoader:NO];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         failBlock(error);
     }];
}

+ (void) putRequestWithURLString:(NSString *)urlString
                   withParameter:(id)parameters
                     withSuccess:(void(^)(id object))successBlock
                         andFail:(void(^)(id errorObj))failBlock
                   showIndicator:(BOOL)shouldShowIndicator {
    [AppHelper showHUDLoader:shouldShowIndicator];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:CONTENT_TYPE_JSON];
    manager.operationQueue.maxConcurrentOperationCount = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager PUT:urlString
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation,id responseObject)
    {
         [AppHelper showHUDLoader:NO];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        successBlock(responseObject);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[GoogleAnalytics sharedGoogleAnalytics] logExceptions:operation.responseString];
         [AppHelper showHUDLoader:NO];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         failBlock(error);
     }];
}



@end
