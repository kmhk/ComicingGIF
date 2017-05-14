//
//  RCiMessage.h
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface RCiMessage : NSObject

typedef void (^CompletionHandler)(BOOL success);
typedef void (^ProcessHandler)(MFMessageComposeViewController* controller);

@property(nonatomic,retain) UIViewController *parentviewcontroller;

-(void)sendMessage:(UIViewController*)viewController
         ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
 completionHandler:(CompletionHandler)handler
 completionHandler:(ProcessHandler)pHandler;

-(void)sendMessage:(UIViewController*)viewController
		 ShareText:(NSString*)shareText
		ShareVideo:(NSURL*)shareVideo
 completionHandler:(CompletionHandler)handler
 completionHandler:(ProcessHandler)pHandler;

@end
