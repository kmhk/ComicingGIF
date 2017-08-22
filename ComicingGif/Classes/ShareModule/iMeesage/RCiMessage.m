//
//  RCiMessage.m
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "RCiMessage.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation RCiMessage
{
    CompletionHandler _completionHandler;
}

-(void)sendMessage:(UIViewController*)viewController
                  ShareText:(NSString*)shareText
                 ShareImage:(UIImage*)shareImage
          completionHandler:(CompletionHandler)handler
 completionHandler:(ProcessHandler)pHandler{
    
    MFMessageComposeViewController* messageComposer = [[MFMessageComposeViewController alloc]init];
    [messageComposer setSubject:@"My Subject"];

    if ([MFMessageComposeViewController canSendAttachments]) {
        
        NSString* uti = (NSString*)kUTTypeMessage;
        NSData *exportData = UIImagePNGRepresentation(shareImage);
        [messageComposer addAttachmentData:exportData typeIdentifier:uti filename:@"Check.png"];
        
    }
    if ([MFMessageComposeViewController canSendText]) {
            [messageComposer setBody:shareText];
    }
    
    pHandler(messageComposer);
}

-(void)sendMessage:(UIViewController*)viewController
		 ShareText:(NSString*)shareText
		ShareVideo:(NSURL*)shareVideo
 completionHandler:(CompletionHandler)handler
 completionHandler:(ProcessHandler)pHandler {
	MFMessageComposeViewController* messageComposer = [[MFMessageComposeViewController alloc]init];
	[messageComposer setSubject:@"My Subject"];
	
	if ([MFMessageComposeViewController canSendAttachments]) {
		
		NSString* uti = (NSString*)kUTTypeMessage;
		NSData *exportData = [NSData dataWithContentsOfURL:shareVideo];
		[messageComposer addAttachmentData:exportData typeIdentifier:uti filename:@"comic.mp4"];
		
	}
	if ([MFMessageComposeViewController canSendText]) {
		[messageComposer setBody:shareText];
	}
	
	pHandler(messageComposer);
}

@end
