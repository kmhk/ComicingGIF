//
//  ShareModule.h
//  ComicMakingPage
//
//  Created by Ramesh on 10/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCiMessage.h"
#import "RCWhatsApp.h"
#import "RCFaceBook.h"
#import "RCInstagram.h"
#import  "RCTwitter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ShareHelper : NSObject<MFMessageComposeViewControllerDelegate>

//Share Type
typedef enum ShapeType : NSUInteger {
    FACEBOOK,
    TWITTER,
    WHATSAPP,
    MESSAGE,
    INSTAGRAM,
    FACEBOOKMESSANGER
} ShapeType;

typedef void (^ShareHelperHandlerBlock)(BOOL status);

@property(nonatomic,strong) UIViewController *parentviewcontroller;
@property (nonatomic, strong) RCInstagram *instagram;
@property (nonatomic, strong) RCWhatsApp *whatsApp;

+(ShareHelper *) shareHelperInit;

-(void)shareAction:(ShapeType)shareType
         ShareText:(NSString*)shareText
          videoUrl:(NSString*)videoUrl
        completion:(ShareHelperHandlerBlock)completeBlock;

-(void)shareAction:(ShapeType)shareType
         ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
          videoUrl:(NSString*)videoUrl
        completion:(ShareHelperHandlerBlock)completeBlock;

-(void)shareAction:(ShapeType)shareType
         ShareText:(NSString*)shareText
        ShareImage:(UIImage*)shareImage
          ShareUrl:(NSString*)shareUrl
          videoUrl:(NSString*)videoUrl
        completion:(ShareHelperHandlerBlock)completeBlock;

@end
