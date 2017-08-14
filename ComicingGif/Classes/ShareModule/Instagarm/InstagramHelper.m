//
//  InstagramHelper.m
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "InstagramHelper.h"

@implementation InstagramHelper

{
    CompletionHandler _completionHandler;
}

-(void)shareIt:(UIViewController*)viewController
     ShareText:(NSString*)shareText
    ShareImage:(UIImage*)shareImage
completionHandler:(CompletionHandler)handler{
    
    _completionHandler = [handler copy];
    
    
    //Create an instance
    self.instagram = [[RCInstagram alloc] init];

    if ([RCInstagram isAppInstalled] && [RCInstagram isImageCorrectSize:shareImage]) {
        [self.instagram postImage:shareImage inView:viewController.view];
    }
    else {
        NSLog(@"Error Instagram is either not installed or image is incorrect size");
    }
    
    /*
    //Set the photo file name
    //The following will present various options including Instagram
    self.instagram.photoFileName = shareImage;
    //The following will only show Instagram as an option
    self.instagram.photoFileName = kInstagramOnlyPhotoFileName;
    
    //Checks to see user has the instagram app installed
    //Returns YES if user does have the app
    [MGInstagram isAppInstalled];
    
    //Post UIImage to Instagram
    //Presents an "openInMenu" model in the UIView specified
    //User is only given Instagram as an option
    [self.instagram postImage:shareImage inView:self.view];
    
    //You can also post with a caption!
    [self.instagram postImage:shareImage withCaption:shareText inView:self.view];
    
    //Checks if the UIImage is at least 612x612 pixels.
    //Instagram upscales photos below this resolution, so it is
    //recommended to ONLY allow for photos above 612x612 to ensure good quality.
    //However, this is your choice whether or not to check.
    //Returns YES if correct size
    [MGInstagram isImageCorrectSize:shareImage];
     */
    
}

@end
