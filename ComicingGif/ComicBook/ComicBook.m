//
//  ComicBook.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Subin Kurian. All rights reserved.
//

#import "ComicBook.h"
#import "TOC.h"
#import "Slides.h"
#import "CommentModel.h"
#import "Enhancement.h"
#import "ComicProperties.h"

@implementation ComicBook

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"comicId": @"comic_id",
             @"comicTitle": @"comic_title",
             @"comicChatId": @"comic_chat_id",
             @"message":@"message",
             @"comicType": @"comic_type",
             @"coverImage": @"cover_image",
             @"conversationId": @"conversation_id",
             @"status": @"status",
             @"thermostatAverage": @"thermostat_average",
             @"createdDate": @"created_date",
             @"toc": @"toc",
             @"slides": @"slides",
             @"userDetail": @"userDetail",
             @"comments": @"comments",
             @"friendShareCount": @"friend_share_count",
             @"groupShareCount": @"group_share_count",
             @"enhancements" : @"enhancements",
             @"comicProperties": @"comic_properties"
             };
}

+ (NSValueTransformer *)tocJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TOC class]];
}

+ (NSValueTransformer *)slidesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Slides class]];
}

+ (NSValueTransformer *)commentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CommentModel class]];
}

+ (NSValueTransformer *)userDetailJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:UserDetail.class];
}

+ (NSValueTransformer *)enhancementsJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Enhancement.class];
}

+ (NSValueTransformer *)comicPropertiesJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ComicProperties class]];
}

@end
