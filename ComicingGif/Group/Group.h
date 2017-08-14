//
//  Group.h
//  Inbox
//
//  Created by Vishnu Vardhan PV on 20/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "Friend.h"

@interface Group : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *groupIcon;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *groupTitle;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSArray *members;

@property (nonatomic) BOOL isSelected;
@end
