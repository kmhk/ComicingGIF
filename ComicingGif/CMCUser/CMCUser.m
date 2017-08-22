//
//  CMCUser.m
//  ComicApp
//
//  Created by ADNAN THATHIYA on 01/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import "CMCUser.h"
#import "Constants.h"

NSString *const UKeyID      = @"user_id";
NSString *const UKeyImage   = @"profile_pic";
NSString *const UKeyDetail  = @"user";

NSString *const UKeyFirstName = @"first_name";
NSString *const UKeyLastName = @"last_name";
NSString *const UKeyRole = @"role";
NSString *const UKeyStatus = @"status";
NSString *const UKeyProfileImageURL = @"profile_pic";

@implementation CMCUser

@synthesize ID,name,imgProfile,firstName,lastName,role,status,profileImageURL;

#pragma mark - Init Methods
- (instancetype)initWithDictionary:(NSDictionary *)userInfo
{
    self = [super init];
    
    if(self)
    {
        ID              = @([[NSString stringWithFormat:@"%@", userInfo[UKeyID]] integerValue]);
        //  imgProfile      = [UIImage imageNamed:userInfo[UKeyImage]];
        firstName       = [NSString stringWithFormat:@"%@",userInfo[UKeyFirstName]];
        lastName        = [NSString stringWithFormat:@"%@",userInfo[UKeyLastName]];
        role            = [NSString stringWithFormat:@"%@",userInfo[UKeyRole]];
        status          = [NSString stringWithFormat:@"%@",userInfo[UKeyStatus]];
        profileImageURL = [NSURL URLWithString:userInfo[UKeyImage]];
    }
    
    return self;
}

@end
