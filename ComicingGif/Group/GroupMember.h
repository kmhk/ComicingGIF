//
//  User.h
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "JSONModel.h"

@protocol GroupMember @end

@interface GroupMember : JSONModel

@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *profile_pic;
@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSString *user_id;


@end