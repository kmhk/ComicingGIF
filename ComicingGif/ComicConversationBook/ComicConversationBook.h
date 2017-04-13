//
//  ComicConversationBook.h
//  ComicBook
//
//  Created by Ramesh on 08/07/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "Pagination.h"
#import "ComicsModel.h"

@interface ComicConversationBook : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *shareId;
@property (nonatomic, strong) NSString *conversationType;
@property (nonatomic, strong) NSArray *coversation;
@property (nonatomic, strong) NSString *chatStatus;

@end
