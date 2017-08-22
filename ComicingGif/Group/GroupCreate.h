//
//  User.h
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "JSONModel.h"

@protocol GroupCreate @end

@interface GroupCreate : JSONModel

@property (strong, nonatomic) NSString *group_id;
@property (strong, nonatomic) NSString *group_title;

@end