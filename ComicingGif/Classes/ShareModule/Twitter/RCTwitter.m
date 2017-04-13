//
//  RCTwitter.m
//  ComicMakingPage
//
//  Created by Ramesh on 11/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "RCTwitter.h"

@implementation RCTwitter
{
    CompletionHandler _completionHandler;
}

-(void)sendTWMessanger:(UIViewController*)viewController
             ShareText:(NSString*)shareText
            ShareImage:(UIImage*)shareImage
            ShareUrl:(NSString*)shareurl
     completionHandler:(CompletionHandler)handler{
    
    _completionHandler = [handler copy];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:shareText];
        if (shareImage) {
            [tweetSheet addImage:shareImage];
        }
        if (shareurl) {
            [tweetSheet addURL: [NSURL URLWithString:shareurl]];
        }
        [viewController presentViewController:tweetSheet animated:YES completion:nil];
    }else if([[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://app"]]){
     
        
    }
}

@end
