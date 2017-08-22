//
//  AppHelper.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppConstants.h"
#import "UIColor+colorWithHexString.h"
#import <CommonCrypto/CommonDigest.h>
#import "RKDropdownAlert.h"
#import "Reachability.h"
#import "UIButton+Property.h"
#import "UIImageView+Downloader.h"
#import "MainPageVC.h"
#import "StyledPullableView.h"
#import "MBProgressHUD.h"
#import "BaseModel.h"
#import <CoreData/CoreData.h>
#import "GoogleAnalytics.h"
#import "YYImage.h"

@interface AppHelper : NSObject<UIGestureRecognizerDelegate>
{
    UIViewController* currentVC;
    MainPageVC* mainControllerView;
    StyledPullableView *pullDownView;
}

@property (strong, nonatomic) CurrentUser* cUser;

#pragma mark Init
+ (AppHelper *)initAppHelper;

+(UIImage*)createPlaceHolderImage:(CGSize)imgSize;
+(NSString*) addParameterstoURL:(NSString*)URLString parameters:(NSDictionary*)dictParams;
+(NSString*)getJsonStringFromDict:(NSDictionary*)dicObjt;
+(NSString *)encodeToBase64String:(UIImage *)image;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(NSString*)getDeviceCountry;
+(NSString*)getDeviceId;
+(NSString*)getDeviceToken;
+(NSString*)MD5encryption:(NSString*)stringValue;
+(void)showErrorDropDownMessage :(NSString*)messageTitle mesage:(NSString*)messageText;
+(void)showWarningDropDownMessage :(NSString*)messageTitle mesage:(NSString*)messageText;
+(void)showSuccessDropDownMessage :(NSString*)messageTitle mesage:(NSString*)messageText;
+(void)showSuccessDropDownMessage :(NSString*)messageTitle mesage:(NSString*)messageText autoHideView:(BOOL)autoHideView;
+(void)hideAllDropMessages;
+(NSString*)getCurrentLoginId;
+(NSString*)getCurrentcomicId;
+(void)setAuthandNonceId:(NSString*)Auth Nonce:(NSString*)Nonce;
+(NSString*)getNonceId;
+(NSString*)getAuthId;
+(void)setCurrentcomicId:(NSString*)comicId;
+ (BOOL)IsNetworkAvailable;
+(BOOL)isValidEmail:(NSString*)emailText;
+(UIImage*)getImageFile:(NSString*)fileName;
+(YYImage *)getGifFile:(NSString*)fileName;
+(void)setDeviceToken:(NSString*)deviceToken;
+(void)setCurrentLoginId:(NSString*)userId;
+(void)setCurrentUserEmail:(NSString*)userId;
+(void)setCurrentUser:(NSDictionary*)userObj;
-(CurrentUser*)getCurrentUser;
+(NSString*)getCurrentUserEmail;
+ (BOOL)isActiveUser;
+(NSString*)getDialCodeByisoCode:(NSString*)isoCode;
+(NSString*)getCountryImageByisoCode:(NSString*)isoCode;
+(void)setFirstTimeSignUp:(NSString*)stringValue;
+(NSString*)getFirstTimeSignUp;
+(NSString*)getGifLayerFilePath;
#pragma mark Swipeevents
//+(void)addSwipeDownGesture:(UIViewController*)vc;
//-(void)AddToMainView: (UIViewController*) parentViewContent;
+(void)openMainPageviewController:(UIViewController*)vc;
+(void)closeMainPageviewController:(UIViewController*)vc;
+(NSString*)SaveImageFile:(NSData*)imageDataObj type:(NSString*)fileType;

#pragma mark Core Data

- (NSManagedObjectContext *)managedObjectContext;

+(void)saveDataToFile:(NSMutableArray*)slideObj fileName:(NSString*)FileName;
+(NSMutableArray*)getDataFromFile :(NSString*)FileName;
+(BOOL)deleteSlideFile :(NSString*)FileName;

#pragma mark showHUDLoader
+ (void)showHUDLoader:(BOOL)show;

#pragma mark - invite methods

+ (BOOL)isNiceGiftBoxOpened;
+ (BOOL)isAwesomeGiftBoxOpened;
+ (BOOL)isExoticGiftBoxOpened;

+ (void)willOpenNiceGiftbox;
+ (void)willOpenAwesomeGiftbox;
+ (void)willOpenExoticGiftbox;

@end
