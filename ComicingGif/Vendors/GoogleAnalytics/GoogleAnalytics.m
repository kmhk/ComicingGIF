//
//  Analytics.m
//

#import "GoogleAnalytics.h"
#import "AppConstants.h"
#import "GoogleAnalyticsLibs.h"
#import "AppHelper.h"

static GoogleAnalytics *sharedGoogleAnalytics = nil;

@implementation GoogleAnalytics



+ (id)sharedGoogleAnalytics {
    @synchronized(self) {
        if (sharedGoogleAnalytics == nil)
            sharedGoogleAnalytics = [[self alloc] init];
    }
    return sharedGoogleAnalytics;
}

-(id)init {
    if((self = [super init])) {
    }
    return self;
}

-(void)initTracking{
    
    /*----------GoogleService Analytics Start Tracking-----------------------*/
    // Configure tracker from GoogleService-Info.plist.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:GOOGLE_ANALYTICS_KEY];
    
    // Provide unhandled exceptions reports.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Enable Remarketing, Demographics & Interests reports. Requires the libAdIdAccess library
    // and the AdSupport framework.
    // https://developers.google.com/analytics/devguides/collection/ios/display-features
    tracker.allowIDFACollection = NO;
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    /*----------GoogleService Analytics Start Tracking-----------------------*/
    
}
-(void)setUserId{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // You only need to set User ID on a tracker once. By setting it on the tracker, the ID will be
    // sent with all subsequent hits.
    [tracker set:kGAIUserId value:[AppHelper getCurrentLoginId]];
    [tracker set:kGAIClientId value:[AppHelper getCurrentLoginId]];
}
-(void)clearUserId{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // You only need to set User ID on a tracker once. By setting it on the tracker, the ID will be
    // sent with all subsequent hits.
    [tracker set:kGAIUserId
           value:nil];
}

-(void)logExceptions:(NSString*)exceptionsString{
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString * model = [[UIDevice currentDevice] model];
    NSString * version = [[UIDevice currentDevice] systemVersion];
    NSString * description = [NSString stringWithFormat:@"%@.%@.%@.",
                              model,
                              version,
                              exceptionsString];
    
    [tracker send:[[GAIDictionaryBuilder
                   createExceptionWithDescription:description
                   withFatal:0]  build]];
}


//-(void)setcustomDimension:(NSInteger)index{
//    
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    
//    NSString *dimensionValue = [AppHelper getCurrentLoginId];
//    [tracker set:[GAIFields customDimensionForIndex:1] value:dimensionValue];
//}

-(void)logEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label{
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    
#if TARGET_OS_SIMULATOR
#else
    //Set UserId
    [self setUserId];
    //Set customDimension
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:label          // Event label
                                                           value:nil] build]];    // Event value
#endif
}

-(void)logScreenEvent:(NSString*)screeName Attributes:(NSMutableDictionary*)attributes {
    
#if TARGET_OS_SIMULATOR
#else
    //Set UserId
    [self setUserId];
    //Set customDimension
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screeName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}


-(void)logUserEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label{
    
    [self logUserEvent:[AppHelper getCurrentLoginId] Category:category Action:action Label:label];
}

-(void)logUserEvent:(NSString*)userID Category:(NSString*)category Action:(NSString*)action Label:(NSString*)label{
    
#if TARGET_OS_SIMULATOR 
#else
    //Set UserId
    [self setUserId];
    //Set customDimension
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // This hit will be sent with the User ID value and be visible in User-ID-enabled views (profiles).
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category            // Event category (required)
                                                          action:action             // Event action (required)
                                                           label:label              // Event label
                                                           value:nil] build]];    // Event value
#endif
}

@end
