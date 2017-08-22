//
//  ComicMakingAPIManager.h
//  ComicBook
//
//  Created by Ramesh on 16/03/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "BaseAPIManager.h"
#import "Utilities.h"
#import "ComicPage.h"
#import "ComicNetworking.h"
#import "ComicItem.h"

typedef void(^UploadCallBack)(id jsonResponse,BOOL isSucess);
typedef void(^SendCallBack)(id jsonResponse,BOOL isSucess);

@interface ComicMakingAPIManager : NSObject

@property (nonatomic, copy) UploadCallBack uploadCallback;
@property (nonatomic, copy) SendCallBack sendCallback;

+(void)postComicCreation :(id)json
                replyType:(ReplyType)replyType
                comicType:(ComicType)comicType
           FileNameToSave:(NSString*)fileNameToSave
          FriendOrGroupId:(NSString*)friendOrGroupId
                  ShareId:(NSString*)shareId
     handleUploadCallback:(SendCallBack)block;

+(void)sendComic:(ReplyType)replyType
  FileNameToSave:(NSString*)fileNameToSave
handleUploadCallback:(UploadCallBack)block;

@end
