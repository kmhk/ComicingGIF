//
//  TOC.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface TOC : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *slideId;
@property (nonatomic, strong) NSString *slideThumb;

@end
