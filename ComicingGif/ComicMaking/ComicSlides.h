//
//  ComicSlides.h
//  ComicMakingPage
//
//  Created by Ramesh on 10/02/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ComicEnhancements.h"

@protocol ComicSlides @end

@interface ComicSlides : JSONModel

@property (strong, nonatomic) NSString * slide_image;
@property (strong, nonatomic) NSString * slide_text;
@property (strong, nonatomic) NSMutableArray * enhancements;

@end
