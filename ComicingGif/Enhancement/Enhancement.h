//
//  Enhancement.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/03/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Enhancement : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *enhancementId;
@property (nonatomic, strong) NSString *enhancementText;
@property (nonatomic, strong) NSString *enhancementType;
@property (nonatomic, strong) NSString *enhancementFile;
@property (nonatomic, strong) NSString *xPos;
@property (nonatomic, strong) NSString *yPos;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, assign) NSInteger zIndex;

@end
