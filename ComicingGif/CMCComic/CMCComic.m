//
//  CMCComic.m
//  ComicApp
//
//  Created by ADNAN THATHIYA on 01/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import "CMCComic.h"
#import "Constants.h"
#import "CMCUser.h"

@implementation CMCComic

@synthesize ID,name,imgComic,creator,date,time;

#pragma mark - Init Methods

- (instancetype)initWithDictionary:(NSDictionary *)comicInfo
{
    self = [super init];
    
    if(self)
    {
        ID              = @([[NSString stringWithFormat:@"%@", comicInfo[CKeyID]] integerValue]);
        
        name            = comicInfo[CKeyName];
        imgComic        = [UIImage imageNamed:comicInfo[CKeyImage]];
        
        creator = [[CMCUser alloc] initWithDictionary:comicInfo[UKeyDetail]];
        date            = comicInfo[CKeyDate];
        time            = comicInfo[CKeyTime];
        
    }
    
    return self;
}


@end
