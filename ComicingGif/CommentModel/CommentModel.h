//
//  CommentModel.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 24/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface CommentModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *commentType;
@property (nonatomic, strong) NSString *commentText;
@property (nonatomic, strong) NSString *referenceId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *status;

@end
