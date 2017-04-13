//
//  UserDetail.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface UserSearch : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *loginId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userTypeId;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *fb_id;
@property (nonatomic, strong) NSString *insta_id;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *friendCount;
@end
