//
//  WhatsAppHelper.m
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "WhatsAppHelper.h"

@implementation WhatsAppHelper

-(void)sendMessage:(UIViewController*)viewController
         ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
 completionHandler:(CompletionHandler)handler{
    
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",shareText]];

    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]){
    
        UIImage     * iconImage = shareImage;
        NSString    * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmptmpimg.wai"];
        _img = shareImage;
        
        [UIImageJPEGRepresentation(iconImage, 1.0) writeToFile:savePath atomically:YES];
        
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        self.documentInteractionController.UTI = @"net.whatsapp.image";
        self.documentInteractionController.delegate = nil;
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:viewController.view animated: YES];
    }
}


- (void)performActivity {
    
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
//    [self activityDidFinish:YES];
}

-(void)activityDidFinish:(BOOL)success {

}

@end
