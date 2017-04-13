//
//  User.h
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "JSONModel.h"
@protocol FriendSearchResult @end

@interface FriendSearchResult : JSONModel

@property (strong, nonatomic) NSString *login_id;
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *dob;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *profile_pic;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *user_id;
//@property (strong, nonatomic) NSString *user_type;
@property (strong, nonatomic) NSString *created_date;
@end