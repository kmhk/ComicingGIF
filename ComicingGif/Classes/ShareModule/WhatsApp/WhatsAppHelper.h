//
//  WhatsAppHelper.h
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface WhatsAppHelper : NSObject <UIDocumentInteractionControllerDelegate>
{
    UIImage* _img;
}
typedef void (^CompletionHandler)(BOOL success);

@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;


-(void)sendMessage:(UIViewController*)viewController
         ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
 completionHandler:(CompletionHandler)handler;

@end
