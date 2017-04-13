//
//  Friend.h
//  Inbox
//
//  Created by Vishnu Vardhan PV on 19/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Friend : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *friendId;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *loginId;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *fb_id;
@property (nonatomic, strong) NSString *insta_id;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic) BOOL isSelected;

@end
