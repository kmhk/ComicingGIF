//
//  ComicEnhancements.h
//  ComicMakingPage
//
//  Created by Ramesh on 10/02/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ComicEnhancements @end

@interface ComicEnhancements : JSONModel

@property (strong, nonatomic) NSString * enhancement_type;
@property (strong, nonatomic) NSString * enhancement_type_id;
@property (strong, nonatomic) NSString * is_custom;
@property (strong, nonatomic) NSString * position_top;
@property (strong, nonatomic) NSString * position_left;
@property (strong, nonatomic) NSString * z_index;
@property (strong, nonatomic) NSString * enhancement_text;
@property (strong, nonatomic) NSString * enhancement_file;
@end
