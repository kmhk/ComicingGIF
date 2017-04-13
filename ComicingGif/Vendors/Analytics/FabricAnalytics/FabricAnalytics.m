#import "FabricAnalytics.h"
#import "AppConstants.h"
#import <Crashlytics/Answers.h>

static FabricAnalytics *sharedFabricAnalytics = nil;

@implementation FabricAnalytics



+ (id)sharedFabricAnalytics {
    @synchronized(self) {
        if (sharedFabricAnalytics == nil)
            sharedFabricAnalytics = [[self alloc] init];
    }
    return sharedFabricAnalytics;
}

-(id)init {
    if((self = [super init])) {
    }
    return self;
}

-(void)logEvent:(NSString*)eventName Attributes:(NSMutableDictionary*)attributes {
    [Answers logCustomEventWithName:eventName customAttributes:attributes];
}

@end
