//
//  InviteScore.h
//  StickeyBoard
//
//  Created by Ramesh on 05/07/16.
//  Copyright © 2016 Comicing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ActiveInbox : NSManagedObject

@property (nonatomic, retain) NSString *comic_delivery_id;
@property (nonatomic, assign) NSString *isRead;
@property (nonatomic, retain) NSString *share_type;
@property (nonatomic, retain) NSString *user_id;

@end
