//
//  ComicConversationBook.m
//  ComicBook
//
//  Created by Ramesh on 08/07/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "ComicConversationBook.h"
#import "ComicBook.h"

@implementation ComicConversationBook

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"conversationType": @"conversation_type",
             @"shareId": @"share_id",
             @"coversation": @"coversation",
             @"chatStatus":@"chat_status"
             };
}

+ (NSValueTransformer *)coversationJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ComicBook class]];
}

@end
