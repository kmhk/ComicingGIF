//  AppHelper.m
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "AppHelper.h"
#import "MainPageVC.h"
#import "Constants.h"
#import "DACircularProgressView.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "InviteScore.h"
#import "UIImage+GIF.h"

@implementation AppHelper

static UIViewController* currentVC;
static MainPageVC* mainControllerView;
static NSTimer *timer = nil;
static DACircularProgressView *progressView = nil;
static MBProgressHUD *HUD;
static AppHelper *_appHelper = nil;

+ (AppHelper *)initAppHelper {
    @synchronized(self)
    {
        if (_appHelper == nil)
        {
            _appHelper = [[AppHelper alloc] init];
        }
    }
    return _appHelper;
}

+(UIImage*)createPlaceHolderImage:(CGSize)imgSize{
    
    int randomNumber = 0 + rand() % ([ImagePlaceHolder_COLOUR count] -0);
    UIColor *color = [UIColor colorWithHexStr:[ImagePlaceHolder_COLOUR objectAtIndex: randomNumber]];
    UIImage *image = [UIImage alloc];
	
	@autoreleasepool {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    
    UIGraphicsEndImageContext();
	}
	
    return image;
}
+(NSString*) addParameterstoURL:(NSString*)URLString parameters:(NSDictionary*)dictParams {
    if(dictParams == nil)
        return URLString;
    NSString* _queryString = @"";
    NSEnumerator *enumerator = [dictParams keyEnumerator];
    
    BOOL isParamFount = TRUE;
    if ([URLString rangeOfString:@"?"].location == NSNotFound) {
        isParamFount = FALSE;
    }
    
    for(NSString *aKey in enumerator){
        
        NSString * paramValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[dictParams valueForKey:aKey],NULL,(CFStringRef)@"!*'();@&+$,/?%#[]~=_-.:",kCFStringEncodingUTF8 ));
        
        if (isParamFount == FALSE){
            _queryString = [_queryString stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",aKey,paramValue]];
            isParamFount = TRUE;
        }else{
            _queryString = [_queryString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",aKey,paramValue]];
        }
    }
    return [URLString stringByAppendingString:_queryString];
}
+(NSString*)getJsonStringFromDict:(NSDictionary*)dicObjt{

    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicObjt
                                                       options:0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+ (NSString *)stringByAddingURLEncoding :(NSString*)stringValue{
    @autoreleasepool {
        CFStringRef legalURLCharactersToBeEscaped = CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`\n\r");
        CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                            (CFStringRef)stringValue,
                                                                            NULL,
                                                                            legalURLCharactersToBeEscaped,
                                                                            kCFStringEncodingUTF8);
        if (encodedString) {
            return (__bridge NSString *)encodedString;
        }
        
        // TODO: Log a warning?
        return @"";
    }
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
	UIImage *newImage;
	
	@autoreleasepool {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	}
	
    return newImage;
}
+(NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
+(BOOL)isValidEmail:(NSString*)emailText{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailText];
}


//+(UIImage*)getImageFile:(NSString*)fileName{
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//    UIImage* imgFinal = [UIImage imageWithContentsOfFile:filePath];
//    
//    return imgFinal;
//}
/////Just harded value
//+ (BOOL)IsNetworkAvailable{
//    Reachability* reachability = [Reachability  reachabilityForInternetConnection];
//    [reachability startNotifier];
//    BOOL inetReachable = ![reachability currentReachabilityStatus] == NotReachable;
//    [reachability stopNotifier];
//    
//    reachability = nil;
//    return inetReachable;
//}

#pragma mark DropDown Messsage

//+(NSString*)getDeviceToken{
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"deivetoken"])
//        return [[NSUserDefaults standardUserDefaults] objectForKey:@"deivetoken"];
//    
//    return @"";
//}
//+(void)setDeviceToken:(NSString*)deviceToken{
//    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"deivetoken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//+(NSString*)getDeviceId{
//    return @"1";
//}
//+(NSString*)getDeviceCountry{
//    NSLocale *countryLocale = [NSLocale currentLocale];
//    NSString *countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
//    NSString *country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
//    return country;
//}

+(NSString*)MD5encryption:(NSString*)stringValue{
    // Create pointer to the string as UTF8
    const char *ptr = [stringValue UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}
+(void)showErrorDropDownMessage :(NSString*)messageTitle mesage:(NSString*)messageText{
    [RKDropdownAlert title:messageTitle message:messageText backgroundColor:[UIColor colorWithHexStr:@"99231F20"] textColor:[UIColor whiteColor]];
}
+(void)showWarningDropDownMessage :(NSString*)messageTitle mesage:(NSString*)messageText{
    [RKDropdownAlert title:messageTitle message:messageText backgroundColor:[UIColor colorWithHexStr:@"96F99E32"] textColor:[UIColor whiteColor]];
}
+(void)showSuccessDropDownMessage :(NSString*)messageTitle mesage:(NSString*)messageText{
    [RKDropdownAlert title:messageTitle message:messageText backgroundColor:[UIColor colorWithHexStr:@"962AACE2"] textColor:[UIColor whiteColor]];
}

+(void)showSuccessDropDownMessage :(NSString*)messageTitle mesage:(NSString*)messageText autoHideView:(BOOL)autoHideView{
    [RKDropdownAlert title:messageTitle message:messageText backgroundColor:[UIColor colorWithHexStr:@"962AACE2"] textColor:[UIColor whiteColor] time:0 autoHideView:NO];
}
+(void)hideAllDropMessages{
    [RKDropdownAlert dismissAllAlert];
}

#pragma mark Core Data

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

+(void)saveDataToFile:(NSMutableArray*)slideObj fileName:(NSString*)FileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.sav",FileName]];
    [slideObj writeToFile:filePath atomically:YES];
//    [[NSUserDefaults standardUserDefaults] setObject:slideObj forKey:FileName];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSMutableArray*)getDataFromFile :(NSString*)FileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.sav",FileName]];
    return [NSMutableArray arrayWithContentsOfFile:filePath];
//    return [[[NSUserDefaults standardUserDefaults] objectForKey:FileName] mutableCopy];
}

+(BOOL)deleteSlideFile :(NSString*)FileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.sav",FileName]];
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    //Delete Saved jpg images
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [paths objectAtIndex:0];
    NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    NSArray *jpgFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
    NSError *error = nil;
    for (NSString *file in jpgFiles) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
        }
    }
    
    if (success) {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark get & set

+(void)setFirstTimeSignUp:(NSString*)stringValue{
    [[NSUserDefaults standardUserDefaults] setValue:stringValue forKey:FirstTimeSignUp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getFirstTimeSignUp{
    if([[NSUserDefaults standardUserDefaults] objectForKey:FirstTimeSignUp])
        return [[NSUserDefaults standardUserDefaults] objectForKey:FirstTimeSignUp];
    
    return nil;
}
+(NSString*)getDeviceToken{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"deivetoken"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"deivetoken"];
    
    return @"";
}
+(void)setDeviceToken:(NSString*)deviceToken{
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"deivetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getDeviceId{
    return @"1";
}
+(NSString*)getDeviceCountry{
    NSLocale *countryLocale = [NSLocale currentLocale];
    NSString *countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    return country;
}

+(UIImage*)getImageFile:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIImage* imgFinal = [UIImage imageWithContentsOfFile:filePath];
    
    return imgFinal;
}

+(UIImage *)getGifFile:(NSString*)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
//    YYImage* imgFinal = [YYImage imageWithContentsOfFile:filePath];

    NSString *fileName1 = [NSString stringWithFormat:@"%@",[fileName lastPathComponent]];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName1]];
    
    NSData *gifData = [NSData dataWithContentsOfURL:fileURL];
    
    return [UIImage sd_animatedGIFWithData:gifData];
}

///Just harded value
+ (BOOL)IsNetworkAvailable{
    Reachability* reachability = [Reachability  reachabilityForInternetConnection];
    [reachability startNotifier];
    BOOL inetReachable = ![reachability currentReachabilityStatus] == NotReachable;
    [reachability stopNotifier];
    
    reachability = nil;
    return inetReachable;
}

+(void)setCurrentcomicId:(NSString*)comicId{
    [[NSUserDefaults standardUserDefaults] setValue:comicId forKey:@"CurrentcomicId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getCurrentLoginId{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    return @"-1";
}
+(void)setCurrentLoginId:(NSString*)userId{
    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setCurrentUserEmail:(NSString*)userId{
    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"emailId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setCurrentUser:(NSDictionary*)userObj{
    [[NSUserDefaults standardUserDefaults] setValue:userObj forKey:@"currentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self getCurrentUser];
}

-(CurrentUser*)getCurrentUser{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"])
    {
        NSDictionary* dUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
        self.cUser = nil;
        self.cUser = [[CurrentUser alloc] init];
        self.cUser.email = [dUser objectForKey:@"email"];
        self.cUser.last_name = [dUser objectForKey:@"last_name"];
        self.cUser.first_name = [dUser objectForKey:@"first_name"];
        self.cUser.profile_pic = [dUser objectForKey:@"profile_pic"];
        self.cUser.user_id = [dUser objectForKey:@"user_id"];
        self.cUser.login_id = [dUser objectForKey:@"login_id"];
        self.cUser.fb_id = [dUser objectForKey:@"fb_id"];
        self.cUser.insta_id = [dUser objectForKey:@"insta_id"];
        if ([dUser valueForKey:@"description"] != nil) {
            self.cUser.desc = [dUser objectForKey:@"description"];
        }
        return self.cUser;
    }
    return nil;
}

+(NSString*)getCurrentUserEmail{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"emailId"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"emailId"];
    return @"";
}

+(void)setAuthandNonceId:(NSString*)Auth Nonce:(NSString*)Nonce{
    if (Auth && ![Auth isEqualToString:@""] && Auth.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:Auth forKey:@"Authorization"];
    }
    if (Nonce && ![Nonce isEqualToString:@""] && Nonce.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:Nonce forKey:@"Nonce"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getNonceId{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Nonce"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"Nonce"];
//    return @"";
    return @"e9dfc803c2f8332494d34a5a0e6595fc";
}
+(NSString*)getAuthId{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Authorization"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"Authorization"];
//    return @"";
    return @"3fff2ea545e358d0c43660f36d5ed3b0";
}
+(NSString*)getCurrentcomicId{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentcomicId"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentcomicId"];
//    return @"1";
    return @"534";
}
+ (BOOL)isActiveUser{
    return (![[self getCurrentLoginId] isEqualToString:@"-1"] &&
            ![[self getCurrentUserEmail] isEqualToString:@""]);
}
+(NSString*)getDialCodeByisoCode:(NSString*)isoCode{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"iso == %@", isoCode];
    
    NSArray *matchingDicts = [parsedObject filteredArrayUsingPredicate:predicate];
    
    NSDictionary *dict = [matchingDicts lastObject];
    NSString* dial_code = [dict objectForKey:@"dial_code"];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    return dial_code;
}
+(NSString*)getCountryImageByisoCode:(NSString*)isoCode{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"iso == %@", isoCode];
    
    NSArray *matchingDicts = [parsedObject filteredArrayUsingPredicate:predicate];
    
    NSDictionary *dict = [matchingDicts lastObject];
    NSString* flag = [dict objectForKey:@"flag"];
    
    flag = [flag stringByReplacingOccurrencesOfString:@"#SERVER_URL#" withString:SERVER_URL];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    return flag;
}
+(NSString*)getGifLayerFilePath{    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingString:@"/"];
}
#pragma mark Handle Main Page

+(void)openMainPageviewController:(UIViewController*)vc{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle: [NSBundle mainBundle]];
    
    MainPageVC *controller = (MainPageVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"mainPageNavigation"];
    
    [vc presentViewController:controller animated:YES completion:nil];
    
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle: nil];
//    mainControllerView = (MainPageVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"MainPage"];
//    mainStoryboard = nil;
//    [vc presentViewController:mainControllerView animated:YES
//                   completion:^{
//                   }];
}
+(void)closeMainPageviewController:(UIViewController*)vc{
    [vc dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark showHUDLoader

+ (void)showHUDLoader:(BOOL)show
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc]initWithWindow:[[[UIApplication sharedApplication] delegate] window]];
    }
    [self showHUD:HUD overTheView:show];
}
+ (void)showHUDLoader:(MBProgressHUD *)HUD overTheView:(BOOL)show {
    HUD.labelText = @"Loading";
    HUD.labelColor = [UIColor whiteColor];
    HUD.customView = [self getCustomView];
    if (show) {
        [HUD show:YES];
        [self startAnimation];
    }
    else {
        [self finishProgress];
        [UIView animateWithDuration:0.3 delay:0.3
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^
         {
             [HUD hide:YES];
         } completion:NULL];
    }
}
+ (void)showHUD:(MBProgressHUD *)HUD overTheView:(BOOL)show {
    HUD.labelText = @"Loading";
    HUD.labelColor = [UIColor whiteColor];
    HUD.customView = [self getCustomView];
    if (show) {
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] addSubview:HUD];
        [HUD show:YES];
        [self startAnimation];
    }
    else {
        [self finishProgress];
        [UIView animateWithDuration:0.3 delay:0.3
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^
         {
             [HUD removeFromSuperview];
             
         } completion:NULL];
    }
}
+(UIView*)getCustomView{
    if (progressView) {
        progressView = nil;
    }
    progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    progressView.roundedCorners = NO;
    progressView.thicknessRatio = 10;
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
    imgView.frame = CGRectMake(0, 0, 90, 90);
    [imgView setBackgroundColor:[UIColor colorWithRed:0.007 green:0.007 blue:0.007 alpha:1]];
    imgView.layer.cornerRadius =  imgView.frame.size.width / 2;
    imgView.clipsToBounds = YES;
    imgView.layer.masksToBounds=YES;
    
    [progressView addSubview:imgView];
    imgView.center = CGPointMake(progressView.frame.size.width  / 2,progressView.frame.size.height / 2);
    
    return progressView;
}
+ (void)finishProgress
{
    CGFloat progress = 1;
    [progressView setProgress:progress animated:NO];
    progressView = nil;
    [self stopAnimation];
}
+ (void)progressChange
{
    CGFloat progress = progressView.progress + 0.01f;
    [progressView setProgress:progress animated:YES];
    if (progressView.progress >= 1.0f && [timer isValid]) {
        [progressView setProgress:0.f animated:YES];
    }
}
+ (void)startAnimation
{
    [self stopAnimation];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                             target:self
                                           selector:@selector(progressChange)
                                           userInfo:nil
                                            repeats:YES];
}
+ (void)stopAnimation
{
    timer==nil?nil:[timer invalidate];
    timer = nil;
}
+(NSString*)SaveImageFile:(NSData*)imageDataObj type:(NSString*)fileType{
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",UUID,fileType] ]; //Add the file name
    [imageDataObj writeToFile:filePath atomically:YES]; //Write the file
    imageDataObj = nil;
    return [NSString stringWithFormat:@"%@.%@",UUID,fileType];
}

#pragma mark DB

+(float)getCurrentScoreFromDB{
    NSManagedObjectContext *context = [[AppHelper initAppHelper] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"InviteScore"];
    NSError *error      = nil;
    NSArray *results    = [context executeFetchRequest:fetchRequest error:&error];
    if ([results count] == 0) {
        return 0;
    }else{
        NSString* scoreValue = ((InviteScore*)results[0]).scoreValue;
        CGFloat fScoreValue = [scoreValue floatValue];
        return fScoreValue;
    }
}

#pragma mark - invite methods

+ (BOOL)isNiceGiftBoxOpened
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"nice_box_opened"])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isAwesomeGiftBoxOpened
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"awesome_box_opened"])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isExoticGiftBoxOpened
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"exotic_box_opened"])
    {
        return YES;
    }
    
    return NO;
}

+ (void)willOpenNiceGiftbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"nice_box_opened"];
    [defaults synchronize];
}

+ (void)willOpenAwesomeGiftbox
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"awesome_box_opened"];
    [defaults synchronize];
}

+ (void)willOpenExoticGiftbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"exotic_box_opened"];
    [defaults synchronize];

}

@end
