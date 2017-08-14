//
//  PrivateConversationViewController.h
//  ComicApp
//
//  Created by ADNAN THATHIYA on 12/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicBookVC.h"
#import "Friend.h"

@interface PrivateConversationViewController : UIViewController<BookChangeDelegate, UITextFieldDelegate>

@property (nonatomic,strong) NSMutableDictionary *ComicBookDict;
@property (nonatomic,strong) Friend *friendObj;

@end
