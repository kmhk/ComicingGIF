//
//  CurrentUser.h
//  ComicBook
//
//  Created by Ramesh on 27/03/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@protocol CurrentUser @end

@interface CurrentUser : JSONModel

@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *profile_pic;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *login_id;
@property (strong, nonatomic) NSString *fb_id;
@property (strong, nonatomic) NSString *insta_id;
@property (strong, nonatomic) NSString *desc;
@end
