//
//  CMCUser.h
//  ComicApp
//
//  Created by ADNAN THATHIYA on 01/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const UKeyID;
extern NSString *const UKeyImage;
extern NSString *const UKeyDetail;
extern NSString *const UKeyFirstName;
extern NSString *const UKeyLastName;
extern NSString *const UKeyRole;
extern NSString *const UKeyStatus;
extern NSString *const UKeyProfileImageURL;

@interface CMCUser : NSObject

@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) UIImage *imgProfile;
@property (strong, nonatomic) NSURL *profileImageURL;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo;

@end
