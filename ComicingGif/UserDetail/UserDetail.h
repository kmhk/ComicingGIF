//
//  UserDetail.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface UserDetail : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *profilePic;

@end
