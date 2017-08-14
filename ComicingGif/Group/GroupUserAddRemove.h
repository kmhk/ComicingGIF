//
//  User.h
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "JSONModel.h"

@protocol GroupUserAddRemove @end

@interface GroupUserAddRemove : JSONModel

@property (strong, nonatomic) NSMutableArray *users;

@end