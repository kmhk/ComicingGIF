//
//  RCTwitter.h
//  ComicMakingPage
//
//  Created by Ramesh on 11/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface RCTwitter : NSObject

typedef void (^CompletionHandler)(BOOL success);

-(void)sendTWMessanger:(UIViewController*)viewController
             ShareText:(NSString*)shareText
            ShareImage:(UIImage*)shareImage
              ShareUrl:(NSString*)shareurl
     completionHandler:(CompletionHandler)handler;

@end
