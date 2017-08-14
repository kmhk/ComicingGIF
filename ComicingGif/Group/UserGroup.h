//
//  User.h
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "JSONModel.h"

@protocol UserGroup @end

@interface UserGroup : JSONModel

#define GROUP_MEMBER @"1"
#define GROUP_OWNER @"2"

@property (strong, nonatomic) NSString *group_id;
@property (strong, nonatomic) NSString *group_title;
@property (strong, nonatomic) NSString *group_icon;
//@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSMutableArray *members;

//// below property is used for select/unselect group cell
//@property (nonatomic) BOOL isSelected;

@end