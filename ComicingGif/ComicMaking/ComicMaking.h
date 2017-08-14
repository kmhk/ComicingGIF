//
//  ComicMaking.h
//  ComicMakingPage
//
//  Created by Ramesh on 10/02/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ComicSlides.h"

@protocol ComicMaking @end

@interface ComicMaking : JSONModel

@property (strong, nonatomic) NSString * user_id;
@property (strong, nonatomic) NSString * comic_title;
@property (strong, nonatomic) NSString * comic_type;
@property (strong, nonatomic) NSString * conversation_id;
@property (strong, nonatomic) NSString * slide_count;
@property (strong, nonatomic) NSString * status;
@property (strong, nonatomic) NSMutableArray * slides;
@end
