//
//  Pagination.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Pagination : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *first;
@property (nonatomic, strong) NSString *current;
@property (nonatomic, strong) NSString *last;
@property (nonatomic, strong) NSString *next;
@property (nonatomic, strong) NSString *pageCount;
@property (nonatomic, strong) NSString *itemCountPerPage;

@end
