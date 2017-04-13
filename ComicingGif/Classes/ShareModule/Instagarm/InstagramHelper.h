//
//  InstagramHelper.h
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCInstagram.h"

@interface InstagramHelper :UIViewController

typedef void (^CompletionHandler)(BOOL success);

@property(nonatomic,strong) RCInstagram * instagram;

-(void)shareIt:(UIViewController*)viewController
         ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
 completionHandler:(CompletionHandler)handler;

@end
