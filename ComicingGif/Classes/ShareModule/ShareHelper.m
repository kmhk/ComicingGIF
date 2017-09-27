//
//  ShareModule.m
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "ShareHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Accounts/Accounts.h>
#import "SocialVideoHelper.h"

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

-(void)shareAction:(ShapeType)shareType
         ShareText:(NSString*)shareText
          videoUrl:(NSString*)videoUrl
        completion:(ShareHelperHandlerBlock)completeBlock{
    _handlerBlock = [completeBlock copy];
    
    [self doShare:shareType ShareText:shareText ShareImage:nil ShareUrl:nil videoUrl:videoUrl completion:completeBlock];
    
}
-(void)shareAction:(ShapeType)shareType ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
          videoUrl:(NSString*)videoUrl
        completion:(ShareHelperHandlerBlock)completeBlock{
    
    [self doShare:shareType ShareText:shareText ShareImage:shareImage ShareUrl:nil videoUrl:videoUrl completion:completeBlock];
    _handlerBlock = [completeBlock copy];
    
}
-(void)shareAction:(ShapeType)shareType ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
          ShareUrl:(NSString*)shareUrl
          videoUrl:(NSString*)videoUrl
        completion:(ShareHelperHandlerBlock)completeBlock{
    
    [self doShare:shareType ShareText:shareText ShareImage:shareImage ShareUrl:shareUrl videoUrl:videoUrl completion:completeBlock];
    _handlerBlock = [completeBlock copy];
    
}

-(void)doShare:(ShapeType)shareType ShareText:(NSString*)shareText
    ShareImage:(UIImage*)shareImage
      ShareUrl:(NSString*)shareUrl
      videoUrl:(NSString*)videoUrl
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
            if (!videoUrl.length) {
                RCFaceBook* fbHelper = [[RCFaceBook alloc] init];
                [fbHelper shareFBImage:self.parentviewcontroller ShareText:shareText ShareImage:shareImage ShareUrl:shareUrl completionHandler:completeBlock];
            } else {
                
                
                ACAccountStore *accountStore = [[ACAccountStore alloc] init];
                ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
                id options = @{
                               ACFacebookAppIdKey: @"1914116368831002",
                               ACFacebookPermissionsKey: @[ @"email",@"publish_actions"],
                               ACFacebookAudienceKey: ACFacebookAudienceEveryone
                               };
                [accountStore requestAccessToAccountsWithType:facebookAccountType
                                                      options:options
                                                   completion:^(BOOL granted, NSError *error) {
                                                       if (granted) {
                                                           ACAccount *fbAccount = [[accountStore accountsWithAccountType:facebookAccountType] lastObject];
                                                           
                                                           [SocialVideoHelper uploadFacebookVideo:[NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]] comment:@"" account:fbAccount withCompletion:^(BOOL success, NSString *errorMessage) {
                                                               if (success) {
                                                                   [Global showAlertWithTitle:@"" andMessage:@"Video uploaded successfully."];
                                                               }
                                                           }];

                                                       } else {
                                                           [Global showAlertWithTitle:@"" andMessage:@"Please login to Facebook first"];
                                                       }
                                                   }];
                
                
                
                
                
//                ACAccountStore *account_store = [[ACAccountStore alloc] init];
//                ACAccountType *account_type_facebook = [account_store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//                // A.
//                NSArray *accounts = [account_store accountsWithAccountType:account_type_facebook];
//                // B.
//                if (accounts.count > 0) {
//                    NSString *account_id = ((ACAccount *)[accounts lastObject]).identifier;
//                    ACAccount *account = [account_store accountWithIdentifier:account_id];
//                    ACAccountType *account_type_twitter = [account_store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//                    account.accountType = account_type_twitter;
//                    
//                    [SocialVideoHelper uploadTwitterVideo:[NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]] comment:@"" account:account withCompletion:^(BOOL success, NSString *errorMessage) {
//                        if (success) {
//                            [Global showAlertWithTitle:@"" andMessage:@"Video uploaded successfully."];
//                        }
//                    }];
//                } else {
//                    [Global showAlertWithTitle:@"" andMessage:@"Please login to Facebook first"];
//                }
            }
        }
            break;
        case TWITTER:{
            if (!videoUrl.length) {
                RCTwitter* twHelper = [[RCTwitter alloc] init];
                [twHelper sendTWMessanger:self.parentviewcontroller ShareText:shareText ShareImage:shareImage ShareUrl:shareUrl completionHandler:completeBlock];
            } else {
                
                ACAccountStore *account_store = [[ACAccountStore alloc] init];
                ACAccountType *account_type_twitter = [account_store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                
                [account_store requestAccessToAccountsWithType:account_type_twitter options:nil
                                              completion:^(BOOL granted, NSError *error) {
                     if (granted == YES)
                     {
                         // Get account and communicate with Twitter API
                         NSArray *arrayOfAccounts = [account_store
                                                     accountsWithAccountType:account_type_twitter];
                         
                         if ([arrayOfAccounts count] > 0)
                         {
                                ACAccount *account = [arrayOfAccounts lastObject];//[account_store accountWithIdentifier:account_id];
                                 ACAccountType *account_type_twitter = [account_store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                                 account.accountType = account_type_twitter;
                                 
                                 [SocialVideoHelper uploadTwitterVideo:[NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]] comment:@"" account:account withCompletion:^(BOOL success, NSString *errorMessage) {
                                     if (success) {
                                         [Global showAlertWithTitle:@"" andMessage:@"Video uploaded successfully."];
                                     }
                                 }];
                             } else {
                                 [Global showAlertWithTitle:@"" andMessage:@"Please login to Twitter first"];
                             }
                     }
                     else
                     {
                         [Global showAlertWithTitle:@"" andMessage:@"Please give access to twitter."];

                         return;
                     }
                 }];
                
               
                
                
//                BOOL status = [[TwitterVideoUpload instance] setVideo:videoUrl];
//                if (status == FALSE) {
//                    [Global showAlertWithTitle:@"" andMessage:@"Failed reading video file"];
//                    return;
//                }
//                
//                status = [[TwitterVideoUpload instance] upload:^(NSString* errorString)
//                          {
//                              NSString* printStr = [NSString stringWithFormat:@"Share video %@: %@", videoUrl,
//                                                    (errorString == nil) ? @"Success" : errorString];
//                              //                          [self addText:printStr];
//                          }];
//                
//                
//                if (status == FALSE) {
//                    [Global showAlertWithTitle:@"" andMessage:@"No Twitter account. Please add twitter account to Settings app."];
//                }
            }
            
        }
            break;
        default:
        case INSTAGRAM:{
            self.instagram = [[RCInstagram alloc] init];
            if ([RCInstagram isAppInstalled] ){//&& [RCInstagram isImageCorrectSize:shareImage]) {
                
//                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString *documentsDirectory = [paths objectAtIndex:0];
//                NSString *path = [documentsDirectory stringByAppendingPathComponent:@"youVideo.mp4"];
//                NSURL *movieURL = [NSURL fileURLWithPath:path];
//                
//                
//                ALAssetsLibrary* library = [[[ALAssetsLibrary alloc] init];
//                [library writeVideoAtPathToSavedPhotosAlbum:movieURL
//                                            completionBlock:^(NSURL *assetURL, NSError *error){/*notify of completion*/}];
                
                NSString *caption = @"Caption";
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:shareUrl] completionBlock:^(NSURL *assetURL, NSError *error) {
                    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@",[assetURL absoluteString].stringByRemovingPercentEncoding,caption.stringByRemovingPercentEncoding]];
                    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                        [[UIApplication sharedApplication] openURL:instagramURL];
                    }
                }];
                
//                NSString *appURL = [NSString stringWithFormat:@"instagram://library?AssetPath=%@",shareUrl];//,[videocaption stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
//                [appURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appURL]]) {
//                    [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:appURL]];
//                }
//                [self.instagram postImage:shareImage inView:self.parentviewcontroller.view];
            }
            else {
                NSLog(@"Error Instagram is either not installed or image is incorrect size");
                [Global showAlertWithTitle:@"Instagram" andMessage:@"Instagram is not installed on your device"];
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
