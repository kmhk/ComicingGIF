//
//  ComicBook.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "UserDetail.h"

@interface ComicBook : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *comicId;
@property (nonatomic, strong) NSString *comicTitle;
@property (nonatomic, strong) NSString *comicType;
@property (nonatomic, strong) NSString *comicChatId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *coverImage;
@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *thermostatAverage;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *friendShareCount;
@property (nonatomic, strong) NSString *groupShareCount;
@property (nonatomic, strong) NSArray *toc;
@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) UserDetail *userDetail;
@property (nonatomic, strong) NSString *periodCode;
@property (nonatomic, strong) NSArray *enhancements;
@property (nonatomic, strong) NSDictionary *comicProperties;

@end
