//
//  CommentsAPIManager.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 24/12/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsAPIManager : NSObject

+ (void)postCommentForComicId:(NSString *)comicID
              WithCommentDict:(NSDictionary *)comments
             withSuccessBlock:(void(^)(id object))successBlock
                      andFail:(void(^)(NSError *errorMessage))failBlock;

@end
