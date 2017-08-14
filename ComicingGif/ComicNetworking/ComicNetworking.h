//
//  ComicNetworking.h
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONHTTPClient.h"
#import "AppHelper.h"
#import "BaseAPIManager.h"

@protocol ComicNetworkingDelegate <NSObject>
@optional

@end

@interface ComicNetworking : NSObject

@property (nonatomic,assign)   id<ComicNetworkingDelegate> delegate;

typedef void (^ComicNetworkingBlock)(id json,id jsonResponse);
typedef void (^ComicNetworkingFailBlock)(JSONModelError* error);

+(ComicNetworking *) sharedComicNetworking;
-(void)userDetailsByLoginId:(NSString*) loginId completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)getUserGroupsByUserId:(NSString*) loginId completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)userFriendsByUserId:(NSString*) loginId completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)searchById:(NSString*) loginId completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)getGroupDetailsByUserId:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)addRemoveUserFromGroup:(NSMutableDictionary*)paramData GroupId:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)createGroup:(NSMutableDictionary*)paramData completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)updateGroup:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock;
-(void)addRemoveFriends:(NSMutableDictionary*)paramData completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)shareComicImage:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)postRegister:(NSMutableDictionary*)paramData completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock;
-(void)postLogin:(NSMutableDictionary*)paramData completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock;
-(void)postPhoneContactList:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock;
-(void)getComicingFriendsList:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock;
-(void)postComicCreation:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock;
-(void)updateUserInfo:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock;

-(void)getCountries :(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;
-(void)UploadComicImage:(NSMutableArray*)comicImageArray
          completeBlock:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock;

@end
