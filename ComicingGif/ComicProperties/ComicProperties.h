//
//  ComicProperties.h
//  ComicBook
//
//  Created by Amit on 22/02/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface ComicProperties : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *fontColor;
@property (nonatomic, strong) NSString *fontSize;
@property (nonatomic, strong) NSString *fontName;

@end
