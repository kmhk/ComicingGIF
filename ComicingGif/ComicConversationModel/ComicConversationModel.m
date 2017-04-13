//
//  ComicsModel.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 06/01/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "ComicConversationModel.h"
#import "ComicBook.h"
#import "DateLabel.h"
#import "ComicConversationBook.h"

@implementation ComicConversationModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // properties defined in header < : > key in JSON Dictionary
    return @{
             @"books": @"Books",
             @"pagination": @"pagination",
             @"dateLabels": @"date_labels",
             @"shareId": @"lastShareId",
             @"totalCount": @"total_count"
             };
}

+ (NSValueTransformer *)booksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ComicConversationBook class]];
}

+ (NSValueTransformer *)dateLabelsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[DateLabel class]];
}

+ (NSValueTransformer *)paginationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Pagination.class];
}

@end
