//
//  ComicNetworking.m
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "ComicNetworking.h"

@implementation ComicNetworking

static ComicNetworking *_sharedComicNetworking = nil;

+(ComicNetworking *) sharedComicNetworking
{
    @synchronized(self)
    {
        if (_sharedComicNetworking == nil)
        {
            _sharedComicNetworking = [[ComicNetworking alloc] init];
        }
    }
    return _sharedComicNetworking;
}

#pragma mark API Calles

-(void)userDetailsByLoginId:(NSString*) loginId completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingRKRequest:USER_BY_LOGINID singleParam:loginId QueryStringParameters:nil completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)getUserGroupsByUserId:(NSString*) loginId completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingRKRequest:GROUP_BY_USERID singleParam:loginId QueryStringParameters:nil completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)userFriendsByUserId:(NSString*) loginId completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingRKRequest:FRIENDS_BY_USERID singleParam:loginId QueryStringParameters:nil completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)searchById:(NSString*) loginId completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingRKRequest:SEARCH_BY_ID singleParam:loginId QueryStringParameters:nil completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)getGroupDetailsByUserId:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingRKRequest:GROUPDETAILS_BY_USERID singleParam:Id QueryStringParameters:nil completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)addRemoveUserFromGroup:(NSMutableDictionary*)paramData GroupId:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPUTRequest:GROUP_ADD_REMOVE_USER singleParam:Id QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)createGroup:(NSMutableDictionary*)paramData completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPOSTRequest:GROUP_CREATE singleParam:nil QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)updateGroup:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPUTRequest:GROUP_UPDATE singleParam:Id QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)addRemoveFriends:(NSMutableDictionary*)paramData completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPOSTRequest:FRIENDS_ADD_USERID singleParam:nil QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)shareComicImage:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPUTRequest:SHARE_COMIC singleParam:Id QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}

-(void)postRegister:(NSMutableDictionary*)paramData completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPOSTRequest:REGISTER singleParam:nil QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}
-(void)updateUserInfo:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPUTRequest:USER_UPDATE singleParam:Id QueryStringParameters:paramData completion:^(id json,id jsonResponse)
    {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error)
    {
        errorBlock(error);
    }];
}
-(void)postLogin:(NSMutableDictionary*)paramData completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
        [self handlingPOSTRequest:LOGIN singleParam:nil
            QueryStringParameters:paramData
                          headers:@{@"Content-Type" : @"application/json"}
                       completion:^(id json,id jsonResponse) {
            completeBlock(json,jsonResponse);
        } ErrorBlock:^(JSONModelError *error) {
            errorBlock(error);
        }];
    
//    [self handlingPOSTRequest:LOGIN singleParam:nil QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
//        completeBlock(json,jsonResponse);
//    } ErrorBlock:^(JSONModelError *error) {
//        errorBlock(error);
//    }];
}
-(void)postPhoneContactList:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPOSTRequest:REGISTER_PHONECONTACT singleParam:Id QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}

-(void)getComicingFriendsList:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    
    [self handlingRKRequest:PHONECONTACT_FRIENDS_LIST_BY_USERID singleParam:Id QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}

-(void)postComicCreation:(NSMutableDictionary*)paramData Id:(NSString*)Id completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPOSTRequest:COMIC_CREATE singleParam:Id QueryStringParameters:paramData completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}

-(void)getCountries :(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock{
    [self handlingRKRequest:COUNTRIES_ALL singleParam:@"" QueryStringParameters:nil completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}

-(void)UploadComicImage:(NSMutableArray*)comicImageArray
          completeBlock:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock) errorBlock{
    
    
//    [BaseAPIManager postPublicRequestWith:IMAGE_UPLOADER
//                            withParameter:comicImageArray
//                              withSuccess:^(id object, AFHTTPRequestOperation *operationObjet) {
//                                completeBlock(object,nil);
//                            } andFail:^(id errorObj) {
//                                errorBlock((JSONModelError*)errorObj);
//                            } showIndicator:YES];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
//    manager.responseSerializer = [AFJSONResponseSerializer
//                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    

//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8", nil];

//    manager.responseSerializer = responseSerializer;
    manager.responseSerializer = [AFHTTPResponseSerializer  serializer];

//    NSDictionary *parameters = @{@"submit": @"true"};
    AFHTTPRequestOperation *op = [manager POST:IMAGE_UPLOADER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 1; i<= [comicImageArray count]; i++) {
            
            NSDictionary* imgDic = [comicImageArray objectAtIndex:(i-1)];
            if ([imgDic objectForKey:@"SlideImage"]) {
                //do not put image inside parameters dictionary as I did, but append it!
                [formData appendPartWithFileData:[imgDic objectForKey:@"SlideImage"]
                                            name:[NSString stringWithFormat:@"slide%i",i]
                                        fileName:[NSString stringWithFormat:@"SlideImage%i.jpeg",i]
                                        mimeType:@"image/jpeg"];
                
                //do not put image inside parameters dictionary as I did, but append it!
                [formData appendPartWithFormData:[imgDic objectForKey:@"SlideImageType"]
                                            name:[NSString stringWithFormat:@"type_slide%i",i]];
            }
            if ([imgDic objectForKey:@"gifImage"]) {
                [formData appendPartWithFileData:[imgDic objectForKey:@"gifImage"]
                                            name:[NSString stringWithFormat:@"slide%i",i]
                                        fileName:[NSString stringWithFormat:@"SlideImage%i.fig",i]
                                        mimeType:@"image/gif"];
                
                //do not put image inside parameters dictionary as I did, but append it!
                [formData appendPartWithFormData:[imgDic objectForKey:@"SlideImageType"]
                                            name:[NSString stringWithFormat:@"type_slide%i",i]];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString * jsonString = [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding];
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
//        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        [AppHelper showHUDLoader:NO];
        if (json) {
            completeBlock(json,nil);
        }else{
            [AppHelper showErrorDropDownMessage:ERROR_MESSAGE mesage:@""];
            errorBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppHelper showHUDLoader:NO];
        [AppHelper showErrorDropDownMessage:ERROR_MESSAGE mesage:@""];
        errorBlock((JSONModelError*)error);
    }];
    //Changed NO to YES, it should be Yes.
    [AppHelper showHUDLoader:YES];
    [op start];
    
    
//    NSMutableDictionary *parameters_new = [[NSMutableDictionary alloc] init];
//    for (int i = 1; i<= [comicImageArray count]; i++) {
//        
//        NSDictionary* imgDic = [comicImageArray objectAtIndex:(i-1)];
//        if ([imgDic objectForKey:@"SlideImage"]) {
//            //do not put image inside parameters dictionary as I did, but append it!
//            
//            [parameters_new setObject:[imgDic objectForKey:@"SlideImage"] forKey:[NSString stringWithFormat:@"slide%i",i]];
//            [parameters_new setObject:@"slideImage" forKey:[NSString stringWithFormat:@"type_slide%i",i]];
//        }
//    }
//    [parameters_new setObject:@"true" forKey:@"submit"];
    
    
//            [BaseAPIManager postPublicRequestWith:@"http://162.244.67.15/imageUploader.php"
//                                    withParameter:parameters_new
//                                      withSuccess:^(id object, AFHTTPRequestOperation *operationObjet) {
//                                        completeBlock(object,nil);
//                                    } andFail:^(id errorObj) {
//                                        errorBlock((JSONModelError*)errorObj);
//                                    } showIndicator:YES];

    
}
#pragma mark Common

-(void)requestCallBack :(NSDictionary *)json
           jsonResponse:(NSDictionary *)jsonResponseHeader
                 Error :(JSONModelError *) err url:(NSString*)url
             completion:(ComicNetworkingBlock)completeBlock
             ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    if (err) {
        [AppHelper showErrorDropDownMessage:ERROR_MESSAGE mesage:@""];
        errorBlock(err);
        return;
    }else if(json && [json objectForKey:@"data"])
    {
        //Yes , there is some data
        completeBlock(json,jsonResponseHeader);
        return;
    }else if(json && !([[json objectForKey:@"result"] isEqualToString:@"success"] ||
                       [[json objectForKey:@"result"] isEqualToString:@"sucess"]))
    {
        //Yes , there is an error
        //        [AppHelper showErrorDropDownMessage:@"something went wrong !" mesage:@""];
        errorBlock(err);
        return;
    }
    else{
        completeBlock(json,jsonResponseHeader);
        return;
    }
}
-(void)handlingPOSTRequest:(NSString*)url
               singleParam:(NSString*)singleParam
     QueryStringParameters:(NSMutableDictionary*)params
                   headers:(NSMutableDictionary*)headersParams
                completion:(ComicNetworkingBlock)completeBlock
                ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    
    if (singleParam) {
        url = [url  stringByAppendingString:singleParam];
    }
    if (![AppHelper IsNetworkAvailable]) {
        [AppHelper showErrorDropDownMessage:@"No internet" mesage:@"Please connect your internet and try again."];
        return;
    }
    
    [BaseAPIManager postPublicRequestWith:url
                            withParameter:params
                              withSuccess:^(id object, AFHTTPRequestOperation *operationObjet) {
                                  NSDictionary* responseDataDict = nil;
                                  if (operationObjet.responseData != nil) {
                                      responseDataDict = [NSJSONSerialization JSONObjectWithData:operationObjet.responseData
                                                                                         options:kNilOptions
                                                                                           error:nil];
                                  }
                                  [self requestCallBack:object
                                           jsonResponse:operationObjet.response.allHeaderFields
                                                  Error:nil
                                                    url: url
                                             completion:^(id json,id jsonResponse) {
                                                 completeBlock(json,jsonResponse);
                                             } ErrorBlock:^(JSONModelError *error) {
                                                 errorBlock(error);
                                             }];
                              } andFail:^(id errorObj) {
                                  [self requestCallBack:nil jsonResponse:nil Error:errorObj url:url completion:^(id json,id jsonResponse) {
                                      completeBlock(json,jsonResponse);
                                  } ErrorBlock:^(JSONModelError *error) {
                                      errorBlock(error);
                                  }];
                              } showIndicator:YES];
    
    //    [JSONHTTPClient postJSONFromURLWithString:url
    //                                       params:nil
    //                                   BodyString:params != nil ? [AppHelper getJsonStringFromDict:params]:nil
    //                                      headers:headersParams
    //                                   completion:^(id json,id jsonResponse, JSONModelError *err,NSString* requestUrl) {
    //                                       [self requestCallBack:json jsonResponse:jsonResponse Error:err url:requestUrl completion:^(id json,id jsonResponse) {
    //                                           completeBlock(json,jsonResponse);
    //                                       } ErrorBlock:^(JSONModelError *error) {
    //                                           errorBlock(error);
    //                                       }];
    //                                   }];
    
}
-(void)handlingPOSTRequest:(NSString*)url singleParam:(NSString*)singleParam QueryStringParameters:(NSMutableDictionary*)params completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    [self handlingPOSTRequest:url singleParam:singleParam QueryStringParameters:params headers:nil completion:^(id json,id jsonResponse) {
        completeBlock(json,jsonResponse);
    } ErrorBlock:^(JSONModelError *error) {
        errorBlock(error);
    }];
}

-(void)handlingPUTRequest:(NSString*)url singleParam:(NSString*)singleParam QueryStringParameters:(NSMutableDictionary*)params completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    url = [url  stringByAppendingString:singleParam];
    if (![AppHelper IsNetworkAvailable]) {
        [AppHelper showErrorDropDownMessage:@"No internet" mesage:@"Please connect your internet and try again."];
        return;
    }
    [BaseAPIManager putRequestWithURL:url withParameter:params withSuccess:^(id object, AFHTTPRequestOperation *operationObjet) {
        NSDictionary* responseDataDict = nil;
        if (operationObjet != nil) {
            responseDataDict = [NSJSONSerialization JSONObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:operationObjet]
                                                               options:kNilOptions
                                                                 error:nil];
        }
        [self requestCallBack:object
                 jsonResponse:operationObjet.response.allHeaderFields
                        Error:nil
                          url:url
                   completion:^(id json,id jsonResponse) {
                       completeBlock(json,jsonResponse);
                   } ErrorBlock:^(JSONModelError *error) {
                       errorBlock(error);
                   }];
    } andFail:^(id errorObj) {
        [self requestCallBack:nil
                 jsonResponse:nil
                        Error:errorObj
                          url:url
                   completion:^(id json,id jsonResponse) {
                       completeBlock(json,jsonResponse);
                   } ErrorBlock:^(JSONModelError *error) {
                       errorBlock(error);
                   }];
    } showIndicator:YES];
    
    //    [JSONHTTPClient putJSONFromURLWithString:url
    //                                      params:nil
    //                                  BodyString:params != nil ? [AppHelper getJsonStringFromDict:params]:nil
    //                                  completion:^(id json,id jsonResponse, JSONModelError *err,NSString* requestUrl) {
    //                                      [self requestCallBack:json jsonResponse:jsonResponse  Error:err url:requestUrl completion:^(id json,id jsonResponse) {
    //                                          completeBlock(json,jsonResponse);
    //                                      } ErrorBlock:^(JSONModelError *error) {
    //                                          errorBlock(error);
    //                                      }];
    //                                  }];
}
//-(void)handlingRKRequest:(NSString*)url singleParam:(NSString*)singleParam QueryStringParameters:(NSMutableDictionary*)params completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
//{
//    url = [url  stringByAppendingString:singleParam];
//    if (![AppHelper IsNetworkAvailable]) {
//                [AppHelper showErrorDropDownMessage:@"No internet" mesage:@"Please connect your internet and try again."];
//        return;
//    }
//    [JSONHTTPClient getJSONFromURLWithString:url params:params
//                                  completion:^(id json, id jsonResponse,JSONModelError *err,NSString* requestUrl) {
//                                      [self requestCallBack:json jsonResponse:jsonResponse Error:err url:requestUrl completion:^(id json,id jsonResponse) {
//                                          completeBlock(json,jsonResponse);
//                                      } ErrorBlock:^(JSONModelError *error) {
//                                          errorBlock(error);
//                                      }];
//    }];
//}

-(void)handlingRKRequest:(NSString*)url singleParam:(NSString*)singleParam QueryStringParameters:(NSMutableDictionary*)params completion:(ComicNetworkingBlock)completeBlock ErrorBlock:(ComicNetworkingFailBlock)errorBlock
{
    url = [url  stringByAppendingString:singleParam];
    if (![AppHelper IsNetworkAvailable]) {
        [AppHelper showErrorDropDownMessage:@"No internet" mesage:@"Please connect your internet and try again."];
        return;
    }
    [BaseAPIManager getRequestWithURL:url withParameter:params withSuccess:^(id object, AFHTTPRequestOperation *operationObjet) {
        
        NSDictionary* responseDataDict = nil;
        if (operationObjet.responseData != nil) {
            responseDataDict = [NSJSONSerialization JSONObjectWithData:operationObjet.responseData
                                                               options:kNilOptions
                                                                 error:nil];
        }
        
        [self requestCallBack:object jsonResponse:responseDataDict  Error:nil url:nil completion:^(id json,id jsonResponse) {
            completeBlock(json,jsonResponse);
        } ErrorBlock:^(JSONModelError *error) {
            errorBlock(error);
        }];
    } andFail:^(id errorObj) {
        [self requestCallBack:nil jsonResponse:nil  Error:errorObj url:nil completion:^(id json,id jsonResponse) {
            completeBlock(json,jsonResponse);
        } ErrorBlock:^(JSONModelError *error) {
            errorBlock(error);
        }];
    } showIndicator:YES];
}
@end
