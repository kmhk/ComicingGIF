//
//  AppDelegate.h
//  ComicingGif
//
//  Created by Com on 22/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)application;
@property (strong, nonatomic) DataManager *dataManager;
@property (nonatomic) BOOL isShownFriendImage;

@end

