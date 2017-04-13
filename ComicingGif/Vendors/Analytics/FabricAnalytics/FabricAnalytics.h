
#import <Foundation/Foundation.h>

@interface FabricAnalytics : NSObject {

}

+(id)sharedFabricAnalytics;
-(id)init;

-(void)logEvent:(NSString*)eventName Attributes:(NSMutableDictionary*)attributes;
@end
