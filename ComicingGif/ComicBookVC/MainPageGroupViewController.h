//
//  GroupViewController.h
//  ComicApp
//
//  Created by ADNAN THATHIYA on 31/10/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicBookVC.h"
#import "Group.h"

@interface MainPageGroupViewController : UIViewController<BookChangeDelegate, UITextFieldDelegate>

@property (nonatomic,strong) NSMutableDictionary *ComicBookDict;
@property (nonatomic,strong) Group *groupObj;
@property (nonatomic,strong) NSString *shareId;

@end
