//
//  CommentsAPIManager.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 24/12/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import "CommentsAPIManager.h"
#import "BaseAPIManager.h"
#import "Constants.h"

@implementation CommentsAPIManager

+ (void)postCommentForComicId:(NSString *)comicID
              WithCommentDict:(NSDictionary *)comments
             withSuccessBlock:(void(^)(id object))successBlock
                      andFail:(void(^)(NSError *errorMessage))failBlock {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, POST_COMMENTS_URL];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
    [commentsArray addObject:comments];
    [data setValue:commentsArray forKey:@"comments"];
    [data setValue:comicID forKey:@"comic_id"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:data forKey:@"data"];
    [BaseAPIManager postPublicRequestWithURLString:urlString
                                     withParameter:parameters
                                       withSuccess:^(id object) {
                                           successBlock(object);
                                       } andFail:^(id errorObj) {
                                           failBlock(errorObj);
                                       } showIndicator:YES];
}

@end
