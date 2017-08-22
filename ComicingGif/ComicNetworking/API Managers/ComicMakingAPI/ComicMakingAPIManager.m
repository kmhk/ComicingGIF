//
//  ComicMakingAPIManager.m
//  ComicBook
//
//  Created by Ramesh on 16/03/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "ComicMakingAPIManager.h"

@implementation ComicMakingAPIManager
@synthesize uploadCallback,sendCallback;

+(void)sendComic:(ReplyType)replyType FileNameToSave:(NSString*)fileNameToSave handleUploadCallback:(UploadCallBack)block{
    
    NSMutableArray* comicSlides = [AppHelper getDataFromFile:fileNameToSave];
    NSMutableArray* paramArray = [[NSMutableArray alloc] init];
    for (NSData* data in comicSlides) {
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        ComicPage* cmPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //check is gif layer
        if (cmPage.gifLayerPath && cmPage.gifLayerPath.length > 0) {
            NSString* sContentsPath = [[AppHelper getGifLayerFilePath] stringByAppendingString:cmPage.gifLayerPath];
            NSData *gifData = [NSData dataWithContentsOfFile: sContentsPath];
            [dataDic setObject:gifData forKey:@"gifImage"];
            NSData* slideTypeData = [@"gifImage" dataUsingEncoding:NSUTF8StringEncoding];
            [dataDic setObject:slideTypeData forKey:@"SlideImageType"];
            [paramArray addObject:dataDic];
            
        }else{
            NSData *imageData = UIImagePNGRepresentation([AppHelper getImageFile:cmPage.printScreenPath]);
            [dataDic setObject:imageData forKey:@"SlideImage"];
            NSData* slideTypeData = [@"slideImage" dataUsingEncoding:NSUTF8StringEncoding];
            [dataDic setObject:slideTypeData forKey:@"SlideImageType"];
            [paramArray addObject:dataDic];
        }
    }
    NSLog(@"Start uploading");
    if(replyType == FriendReply) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartFriendReplyComicAnimation" object:nil];
    } else if(replyType == GroupReply) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartGroupReplyComicAnimation" object:nil];
    }
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking UploadComicImage:paramArray completeBlock:^(id json, id jsonResponse) {
        block(json,YES);
    } ErrorBlock:^(JSONModelError *error) {
        block(nil,NO);
    }];
}

+(void)postComicCreation :(id)json
                replyType:(ReplyType)replyType
                comicType:(ComicType)comicType
           FileNameToSave:(NSString*)fileNameToSave
          FriendOrGroupId:(NSString*)friendOrGroupId
                  ShareId:(NSString*)shareId
     handleUploadCallback:(SendCallBack)block{
    NSMutableArray* comicSlides = [AppHelper getDataFromFile:fileNameToSave];
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking postComicCreation:[self createSendParams:[json objectForKey:@"slides"]
                                               comicSlides:comicSlides
                                                 replyType:replyType
                                                 comicType:comicType
                                                   shareId:shareId
                                           friendOrGroupId:friendOrGroupId]
     
                                 Id:nil completion:^(id json,id jsonResposeHeader) {
                                     
                                     [AppHelper setCurrentcomicId:[json objectForKey:@"data"]];
                                     if(comicType != ReplyComic) {
                                         block(json,YES);
                                     } else {
                                         [cmNetWorking shareComicImage:[self setPutParamets:friendOrGroupId
                                                                             ReplyTypeValue:replyType
                                                                               ComicShareId:[json objectForKey:@"data"]]
                                                                    Id:[json objectForKey:@"data"] completion:^(id json, id jsonResponse) {
                                                                        block(json,YES);
                                                                        if (json) {
                                                                            if(replyType == FriendReply) {
                                                                                
                                                                            } else if(replyType == GroupReply) {
                                                                            }
                                                                            if (fileNameToSave) {
                                                                                [AppHelper deleteSlideFile:fileNameToSave];
                                                                            }
                                                                        }else{
                                                                            [AppHelper showErrorDropDownMessage:@"something went wrong !" mesage:@""];
                                                                        }
                                                                        
                                                                    } ErrorBlock:^(JSONModelError *error) {
                                                                        block(nil,NO);
                                                                    }];
                                     }
                                     
                                 } ErrorBlock:^(JSONModelError *error) {
                                     block(nil,NO);
                                 }];
}

+(NSMutableDictionary*)createSendParams :(NSMutableArray*)slideArray
                            comicSlides :(NSMutableArray*)comicSlides
                               replyType:(ReplyType)replyType
                               comicType:(ComicType)comicType
                                 shareId:(NSString*)shareId
                         friendOrGroupId:(NSString*)friendOrGroupId{
    
    if (slideArray == nil && [slideArray count] > 0)
        return nil;
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* comicMakeDic = [[NSMutableDictionary alloc] init];
    
    [comicMakeDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"]; // Hardcoded now
    [comicMakeDic setObject:@"" forKey:@"comic_title"];
    
    if(comicType == ReplyComic) {
        [comicMakeDic setObject:@"CS" forKey:@"comic_type"];
        [comicMakeDic setObject:(shareId == nil ?@"0":shareId) forKey:@"share_id"];
    } else {
        [comicMakeDic setObject:@"CM" forKey:@"comic_type"]; // COMIC MAKING
    }
    
    [comicMakeDic setObject:@"0" forKey:@"conversation_id"];
    [comicMakeDic setObject:@"1" forKey:@"status"];
    
    //Slide Array
    NSMutableArray* slides = [[NSMutableArray alloc] init];
    
    for (int i=0; i< [comicSlides count]; i++)
    {
        NSData* data = [comicSlides objectAtIndex:i];
        ComicPage* cmPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (i == 0 && cmPage.titleString && cmPage.titleString.length >0) {
            [comicMakeDic setObject:cmPage.titleString forKey:@"comic_title"];
        }
        
        //ComicSlides Object
        NSMutableDictionary* cmSlide = [[NSMutableDictionary alloc] init];
        
        //Comic Slide image url obj
        NSDictionary* urlSlides = [slideArray objectAtIndex:i];
        
        //ComicSlides Object
        [cmSlide setObject:[urlSlides valueForKeyPath:@"url.slide_image"] forKey:@"slide_image"];
        [cmSlide setObject:[urlSlides valueForKeyPath:@"url.slide_thumb"] forKey:@"slide_thumb"];
        [cmSlide setObject:@"" forKey:@"slide_text"];
        [cmSlide setObject:@"url" forKey:@"slide_image_type"];
        
        NSMutableArray* enhancements = [[NSMutableArray alloc] init];
        //Check is AUD is avalilabe
        //check is gif layer
        if (cmPage.gifLayerPath && cmPage.gifLayerPath.length > 0) {
            //check if 2nd layer
            if (cmPage.printScreenPath) {
                //Yes there is a Audio
                //ComicSlides Object
                
                NSMutableDictionary* cmEng = [[NSMutableDictionary alloc] init];
                [cmEng setObject:@"STATICIMAGE" forKey:@"enhancement_type"];
                [cmEng setObject:@"1" forKey:@"enhancement_type_id"];
                [cmEng setObject:@"1" forKey:@"is_custom"];
                [cmEng setObject:@"" forKey:@"enhancement_text"];
                NSData *imageData = UIImagePNGRepresentation([AppHelper getImageFile:cmPage.printScreenPath]);
                [cmEng setObject:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
                          forKey:@"enhancement_file"];
                [cmEng setObject:@"png" forKey:@"enhancement_file_type"];
                UIImage * midLayerImage = [AppHelper getImageFile:cmPage.printScreenPath];
                
                [cmEng setObject:[NSString stringWithFormat:@"%f",0.0] forKey:@"position_top"];
                [cmEng setObject:[NSString stringWithFormat:@"%f",0.0] forKey:@"position_left"];
                [cmEng setObject:[NSString stringWithFormat:@"%.02f",midLayerImage.size.width] forKey:@"width"];
                [cmEng setObject:[NSString stringWithFormat:@"%.02f",midLayerImage.size.height] forKey:@"height"];
                [cmEng setObject:@"1" forKey:@"z_index"];
                
                [enhancements addObject:cmEng];
            }
        }
        
        for (int i = 0; i < cmPage.subviews.count; i ++)
        {
            id imageView = cmPage.subviews[i];
            CGRect myRect = [cmPage.subviewData[i] CGRectValue];
            //Check is ComicItemBubble
            if([imageView isKindOfClass:[ComicItemBubble class]])
            {
                if ([((ComicItemBubble*)imageView) isPlayVoice]) {
                    //Yes there is a Audio
                    //ComicSlides Object
                    NSMutableDictionary* cmEng = [[NSMutableDictionary alloc] init];
                    [cmEng setObject:@"AUD" forKey:@"enhancement_type"];
                    [cmEng setObject:@"1" forKey:@"enhancement_type_id"];
                    [cmEng setObject:@"1" forKey:@"is_custom"];
                    [cmEng setObject:@"" forKey:@"enhancement_text"];
                    NSData* audioData = [[NSData alloc] initWithContentsOfFile:((ComicItemBubble*)imageView).recorderFilePath];
                    [cmEng setObject:[audioData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
                              forKey:@"enhancement_file"];
                    [cmEng setObject:@"mp3" forKey:@"enhancement_file_type"];
                    
                    CGFloat midPointX = myRect.origin.x + (myRect.size.width/2);
                    CGFloat midPointY = myRect.origin.y + (myRect.size.height/2);
                    
                    [cmEng setObject:[NSString stringWithFormat:@"%f",midPointY] forKey:@"position_top"];
                    [cmEng setObject:[NSString stringWithFormat:@"%f",midPointX] forKey:@"position_left"];
                    [cmEng setObject:[NSString stringWithFormat:@"%.02f",myRect.size.width] forKey:@"width"];
                    [cmEng setObject:[NSString stringWithFormat:@"%.02f",myRect.size.height] forKey:@"height"];
                    [cmEng setObject:@"1" forKey:@"z_index"];
                    
                    [enhancements addObject:cmEng];
                }
            }
            if([imageView isKindOfClass:[ComicItemAnimatedSticker class]])
            {
                //                if ([((ComicItemBubble*)imageView) isPlayVoice]) {
                //Yes there is a Audio
                //ComicSlides Object
                NSMutableDictionary* cmEng = [[NSMutableDictionary alloc] init];
                [cmEng setObject:@"GIF" forKey:@"enhancement_type"];
                [cmEng setObject:@"1" forKey:@"enhancement_type_id"];
                [cmEng setObject:@"1" forKey:@"is_custom"];
                [cmEng setObject:@"" forKey:@"enhancement_text"];
                
                // UIImage* imgGif = [UIImage sd_animatedGIFNamed:((ComicItemAnimatedSticker*)imageView).animatedStickerName];
                
                //CGDataProviderRef provider = CGImageGetDataProvider(imgGif.CGImage);
                //NSData* gifData = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
                
                if (((ComicItemAnimatedSticker*)imageView).combineAnimationFileName) {
                    //it had image,
                    NSString *animationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    animationPath = [[animationPath stringByAppendingPathComponent:((ComicItemAnimatedSticker*)imageView).combineAnimationFileName] stringByAppendingString:@".gif"];
                    
                    NSData *gifData = [NSData dataWithContentsOfFile:animationPath];
                    
                    [cmEng setObject:[gifData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
                              forKey:@"enhancement_file"];
                    [cmEng setObject:@"gif" forKey:@"enhancement_file_type"];
                    
                }
                
                
                CGFloat midPointX = myRect.origin.x;
                CGFloat midPointY = myRect.origin.y;
                
                [cmEng setObject:[NSString stringWithFormat:@"%f",midPointY] forKey:@"position_top"];
                [cmEng setObject:[NSString stringWithFormat:@"%f",midPointX] forKey:@"position_left"];
                [cmEng setObject:[NSString stringWithFormat:@"%.02f",myRect.size.width] forKey:@"width"];
                [cmEng setObject:[NSString stringWithFormat:@"%.02f",myRect.size.height] forKey:@"height"];
                [cmEng setObject:@"1" forKey:@"z_index"];
                
                [enhancements addObject:cmEng];
                //                }
            }
            if (enhancements && [enhancements count] > 0) {
                [cmSlide setObject:enhancements forKey:@"enhancements"];
            }
        }
        
        if ([cmPage.slideType isEqualToString:slideTypeWide])
        {
            [cmSlide setObject:@"1" forKey:@"slide_type"];
            
        }
        else
        {
            [cmSlide setObject:@"0" forKey:@"slide_type"];
            
        }
        
        
        
        [slides addObject:cmSlide];
        cmPage = nil;
        cmSlide = nil;
    }
    [comicMakeDic setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[slides count]]
                     forKey:@"slide_count"];
    [comicMakeDic setObject:slides forKey:@"slides"];
    [dataDic setObject:comicMakeDic forKey:@"data"];
    
    return dataDic;
}

+(NSMutableDictionary*)setPutParamets :(NSString*)shareUserId ReplyTypeValue:(ReplyType)type ComicShareId:(NSString*)comic_id{
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    [userDic setObject:comic_id forKey:@"comic_id"];
    [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"];
    NSMutableArray* arrayObj = [[NSMutableArray alloc] init];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(type == FriendReply){
        [dict setValue:shareUserId forKey:@"friend_id"];
        [dict setValue:@"1" forKey:@"status"];
        
        [arrayObj addObject:dict];
        [userDic setObject:arrayObj forKey:@"friendShares"];
        
        arrayObj = nil;
        dict = nil;
    }
    else if(type == GroupReply){
        
        [dict setValue:shareUserId forKey:@"group_id"];
        [dict setValue:@"1" forKey:@"status"];
        
        [arrayObj addObject:dict];
        
        
        [userDic setObject:arrayObj forKey:@"groupShares"];
        
        arrayObj = nil;
        dict = nil;
    }
    
    [dataDic setObject:userDic forKey:@"data"];
    return dataDic;
}

@end
