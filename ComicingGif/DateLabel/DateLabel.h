//
//  DateLabel.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 09/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface DateLabel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *active;

@end
