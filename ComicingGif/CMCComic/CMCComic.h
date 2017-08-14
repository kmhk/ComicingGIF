//
//  CMCComic.h
//  ComicApp
//
//  Created by ADNAN THATHIYA on 01/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CMCUser;
@interface CMCComic : NSObject

@property (nonatomic, strong) UIImage *imgComic;
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) CMCUser *creator;

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;

- (instancetype)initWithDictionary:(NSDictionary *)comicInfo;

@end
