//
//  ComicsAPIManager.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "ComicsAPIManager.h"
#import "Constants.h"
#import "BaseAPIManager.h"

@implementation ComicsAPIManager

+ (void)getTheComicsWithPage:(NSUInteger)page andCategory:(NSString *)category SuccessBlock:(void(^)(id object))successBlock
                     andFail:(void(^)(NSError *errorMessage))failBlock
{
    NSString *urlString;
    if (category.length == 0) {
        urlString = [NSString stringWithFormat:@"%@comics/page/%lu/itemCount/10/", BASE_URL, (unsigned long)page];
    } else {
        urlString = [NSString stringWithFormat:@"%@comics/page/%lu/itemCount/10/tag/%@", BASE_URL, (unsigned long)page, category];
    }
    
    [BaseAPIManager getRequestWithURLString:urlString
                              withParameter:nil
                                withSuccess:^(id object) {
                                    successBlock(object);
                                } andFail:^(id errorObj) {
                                    failBlock(errorObj);
                                } showIndicator:YES];
}


+ (void)getTheComicsWithSuccessBlock:(void(^)(id object))successBlock
                               andFail:(void(^)(NSError *errorMessage))failBlock
{
  
}

+ (void)setFlagForComic:(NSDictionary *)comic withSuccessBlock:(void(^)(id object))successBlock
                andFail:(void(^)(NSError *errorMessage))failBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@comics/", BASE_URL];

    
    [BaseAPIManager postPublicRequestWith:urlString withParameter:comic withSuccess:^(id object, AFHTTPRequestOperation *operationObjet) {
        successBlock(object);

    } andFail:^(id errorObj) {
        failBlock(errorObj);

    } showIndicator:YES];
}




@end
