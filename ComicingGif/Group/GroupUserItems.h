//
//  User.h
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "JSONModel.h"

@protocol GroupUserItems @end

@interface GroupUserItems : JSONModel

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSString *status;

@end