//
//  ShareModule.m
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "ShareHelper.h"

@implementation ShareHelper
{
    ShareHelperHandlerBlock _handlerBlock;
}

static ShareHelper *_shareHelper = nil;

+(ShareHelper *) shareHelperInit
{
    @synchronized(self)
    {
        if (_shareHelper == nil)
        {
            _shareHelper = [[ShareHelper alloc] init];
        }
    }
    return _shareHelper;
}

-(void)shareAction:(ShapeType)shareType ShareText:(NSString*)shareText
        completion:(ShareHelperHandlerBlock)completeBlock{
    _handlerBlock = [completeBlock copy];
    
    [self doShare:shareType ShareText:shareText ShareImage:nil ShareUrl:nil completion:completeBlock];
    
}
-(void)shareAction:(ShapeType)shareType ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
        completion:(ShareHelperHandlerBlock)completeBlock{
    
    [self doShare:shareType ShareText:shareText ShareImage:shareImage ShareUrl:nil completion:completeBlock];
    _handlerBlock = [completeBlock copy];
    
}
-(void)shareAction:(ShapeType)shareType ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
          ShareUrl:(NSString*)shareUrl
        completion:(ShareHelperHandlerBlock)completeBlock{
    
    [self doShare:shareType ShareText:shareText ShareImage:shareImage ShareUrl:shareUrl completion:completeBlock];
    _handlerBlock = [completeBlock copy];
    
}

-(void)doShare:(ShapeType)shareType ShareText:(NSString*)shareText
    ShareImage:(UIImage*)shareImage
      ShareUrl:(NSString*)shareUrl
    completion:(ShareHelperHandlerBlock)completeBlock{
    
    switch (shareType) {
        case MESSAGE:{
            RCiMessage* imessage = [[RCiMessage alloc] init];
            [imessage sendMessage:self.parentviewcontroller
						ShareText:shareText
					   ShareVideo:[NSURL URLWithString:shareUrl]
				completionHandler:completeBlock
				completionHandler:^(MFMessageComposeViewController *controller) {
                controller.messageComposeDelegate = self;
                [self.parentviewcontroller presentViewController:controller animated:YES completion:nil];
            }];
        }
        break;
        case WHATSAPP:{
            self.whatsApp = [[RCWhatsApp alloc] init];
            if ([RCWhatsApp isAppInstalled]) {
                [self.whatsApp postImage:shareImage inView:self.parentviewcontroller.view];
            }
            else {
                NSLog(@"Error Instagram is either not installed or image is incorrect size");
            }
        }
        break;
        case FACEBOOKMESSANGER:{
            RCFaceBook* fbHelper = [[RCFaceBook alloc] init];
            [fbHelper sendFbMessanger:self.parentviewcontroller
                            ShareText:shareText
                           ShareImage:shareImage
                            isSticker:YES
                    completionHandler:completeBlock];
        }
            break;
        case FACEBOOK:{
            RCFaceBook* fbHelper = [[RCFaceBook alloc] init];
            [fbHelper shareFBImage:self.parentviewcontroller ShareText:shareText ShareImage:shareImage ShareUrl:shareUrl completionHandler:completeBlock];
        }
            break;
        case TWITTER:{
            RCTwitter* twHelper = [[RCTwitter alloc] init];
            [twHelper sendTWMessanger:self.parentviewcontroller ShareText:shareText ShareImage:shareImage ShareUrl:shareUrl completionHandler:completeBlock];
             
        }
            break;
        default:
        case INSTAGRAM:{
            self.instagram = [[RCInstagram alloc] init];
            if ([RCInstagram isAppInstalled] && [RCInstagram isImageCorrectSize:shareImage]) {
                [self.instagram postImage:shareImage inView:self.parentviewcontroller.view];
            }
            else {
                NSLog(@"Error Instagram is either not installed or image is incorrect size");
            }
        }
            break;
    }
}

#pragma mark delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self.parentviewcontroller dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch (result)
    {
        case MessageComposeResultCancelled:
        case MessageComposeResultFailed:
        {
            if (_handlerBlock) {
                _handlerBlock(NO);
            }
        }
            break;
        case MessageComposeResultSent:{
            if (_handlerBlock) {
                _handlerBlock(YES);
            }
        }
            break;
        default:
            break;
    }
}

@end
