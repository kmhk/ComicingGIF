//
//  Analytics.h
//

#import <Foundation/Foundation.h>

@interface GoogleAnalytics : NSObject {

}

+(id)sharedGoogleAnalytics;
-(id)init;
-(void)initTracking;
-(void)logUserEvent:(NSString*)userID Category:(NSString*)category Action:(NSString*)action Label:(NSString*)label;
-(void)logScreenEvent:(NSString*)screeName Attributes:(NSMutableDictionary*)attributes;
-(void)logEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label;
-(void)logUserEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label;
-(void)logExceptions:(NSString*)exceptionsString;
@end
