//
//  AppConstants.h
//
//

/* API Calles */
//#define SERVER_PREFERENCE @"production"
#define SERVER_PREFERENCE @"dev"


#define SERVER_URL ([SERVER_PREFERENCE isEqualToString:@"production"] ? @"http://162.244.67.15/" : @"http://staging.comicing.cc/")
#define BASE_URL [SERVER_URL stringByAppendingFormat:@"api/"]

#define USER_BY_LOGINID  [BASE_URL stringByAppendingFormat:@"users/id/"]
#define GROUP_BY_USERID  [BASE_URL stringByAppendingFormat:@"groups/userId/"]
#define GROUPDETAILS_BY_USERID  [BASE_URL stringByAppendingFormat:@"groups/groupId/"]
#define GROUP_ADD_REMOVE_USER  [BASE_URL stringByAppendingFormat:@"groups/groupId/"]
#define GROUP_CREATE [BASE_URL stringByAppendingFormat:@"groups/"]
#define GROUP_UPDATE [BASE_URL stringByAppendingFormat:@"groups/groupId/"]
#define FRIENDS_BY_USERID  [BASE_URL stringByAppendingFormat:@"friends/id/"]
#define FRIENDS_ADD_USERID  [BASE_URL stringByAppendingFormat:@"friends/"]
#define SEARCH_BY_ID  [BASE_URL stringByAppendingFormat:@"users/loginId/"]
#define SEARCH_BY_EMAIL  [BASE_URL stringByAppendingFormat:@"users/email/"]
#define SEARCH_BY_MOBILE  [BASE_URL stringByAppendingFormat:@"users/mobile/"]
#define SHARE_COMIC [BASE_URL stringByAppendingFormat:@"comics/id/"]
#define REGISTER [BASE_URL stringByAppendingFormat:@"users"]
#define USER_UPDATE [BASE_URL stringByAppendingFormat:@"users/id/"]
#define LOGIN [BASE_URL stringByAppendingFormat:@"auth/"]
#define REGISTER_PHONECONTACT [BASE_URL stringByAppendingFormat:@"contacts/"]
#define PHONECONTACT_FRIENDS_LIST_BY_USERID [BASE_URL stringByAppendingFormat:@"contacts/id/"]

#define COMIC_CREATE [BASE_URL stringByAppendingFormat:@"comics/"]
#define COUNTRIES_ALL [BASE_URL stringByAppendingFormat:@"countries"]
#define IMAGE_UPLOADER @"imageUploader.php"
/* */

#define COUNTRIES_ALL  [BASE_URL stringByAppendingFormat:@"countries"]
/* */

//find out more about my life with comicing ! Add me at <username> www.AreYouComicing.com


#define INVITE_TEXT(str) str ? [NSString stringWithFormat:@"find out more about my life with Comicing!  Add me @%@ www.AreYouComicing.com", str] : @"find out more about my life with Comicing! www.AreYouComicing.com"

#define ImagePlaceHolder_COLOUR @[@"ffffff",@"ff3300",@"3399ff",@"ffcc33",@"33cc66",@"9966cc",@"ff3366",@"99cc00",@"3333cc",@"996633",@"000000"]

/*  */
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_3G (IS_IPHONE && SCREEN_MAX_LENGTH == 480)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define DOCUMENTS_FOLDER [NSTemporaryDirectory() stringByAppendingPathComponent:@"voiceRecorded"]

#define SKeySticker @"Sticker"

#define RegisterNotification_Sucess @"didRegisterNotification_Sucess"
#define RegisterNotification_Failed @"didRegisterNotification_Failes"
#define RegisterNotification_Receive @"receiveRemoteNotification"

#define TermsAndServiceURL  @"Comicing_Terms_of_Service"

#define FirstTimeSignUp @"FirstTimeSignUp"

/* Comic makeing */
/* Bubble tail Post nmae*/

#define TOPLEFT  @"TL"
#define TOPRIGHT @"TR"
#define BOTTOMLEFT  @"BL"
#define BOTTOMRIGHT  @""

/* */
#define SLIDE_MAXCOUNT  8

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESSER_THAN_OR_EQUAL_TO(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define GOOGLE_ANALYTICS_KEY @"UA-77039293-1"

/*Messages*/
#define ERROR_MESSAGE @"Oops!  Something went wrong"
#define DEFAULT_EMAIL @"comic@comicing.cc"
#define DEFAULT_PHONENUMBER @"0000000000"

#define DEFAULT_EMOJI @"UIKeyboardEmojiCategoryNature"

#define INVITE_POINT_PERINVITE 8
#define INVITE_POINT_50 50
#define INVITE_POINT_100 100
#define INVITE_POINT_200 200

// **********************  Slide Dimension listview ***************
#define WIDE_SLIDE_HEIGHT (IS_IPHONE_6P?100:IS_IPHONE_6?76:58)
//#define TALL_SMALL_SLIDE_HEIGHT (IS_IPHONE_6P?140:IS_IPHONE_6?127:115)

#define TALL_SMALL_SLIDE_HEIGHT (IS_IPHONE_6P?185:IS_IPHONE_6?162:130)
#define TALL_BIG_SLIDE_HEIGHT (IS_IPHONE_6P?425:IS_IPHONE_6?385:330)



// below height for cell

#define WIDE_SLIDE_HEIGHT_CELL (IS_IPHONE_6P?110:IS_IPHONE_6?98:88)
#define TALL_SMALL_SLIDE_HEIGHT_CELL (IS_IPHONE_6P?284:IS_IPHONE_6?257:210)
#define TALL_BIG_SLIDE_HEIGHT_CELL (IS_IPHONE_6P?580:IS_IPHONE_6?520:435)

#define ComicWidthIPhone5 330
#define ComicWidthIPhone6 385
#define ComicWidthIPhone6plus 425

#define kMaxItemsInComic 4

//
 //6plus height 414 × 736  375 × 667  320 × 480


typedef enum {
    Gif = 101,
    StaticImage = 102
} ComicSlideBaseLayer;


typedef enum {
    Purple = 1,
    Green,
    Yellow,
    Orange,
    NavyBlue,
    LightBlue,
    White,
    Pink
} ComicBookColorCode;





