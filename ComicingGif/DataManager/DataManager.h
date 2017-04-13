//
//  DataManager.h
//  Inbox
//
//  Created by Vishnu Vardhan PV on 19/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Friend.h"

@interface DataManager : NSObject

@property (nonatomic, strong) NSArray *friendsArray;
@property (nonatomic, strong) NSArray *groupsArray;
@property (nonatomic, strong) NSArray *activeInboxArray;
@property (nonatomic, strong) Friend *friendObject;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@end
