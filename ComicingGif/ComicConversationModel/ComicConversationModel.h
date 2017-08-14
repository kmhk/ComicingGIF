//
//  ComicsModel.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "Pagination.h"

@interface ComicConversationModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *books;
@property (nonatomic, strong) NSArray *dateLabels;
@property (nonatomic, strong) Pagination *pagination;
@property (nonatomic, strong) NSString *shareId;
@property (nonatomic, strong) NSString *totalCount;

@end
