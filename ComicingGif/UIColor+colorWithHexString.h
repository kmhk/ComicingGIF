
//  UIColor+UIColor colorWithHexStr.h
//

#import <UIKit/UIKit.h>

@interface UIColor (colorWithHexStr)

+ (UIColor *) colorWithHexStr: (NSString *) hexString ;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
+(BOOL)isLightColorWithColor:(UIColor*)color;
+(BOOL)isLightColorWithHexString: (NSString *) hexString;
+(UIColor *)averageColor:(UIImage*)image;
+ (UIColor *)colorAtPixel:(CGPoint)point image:(UIImage*)image;
+ (NSString *)hexStringFromColor:(UIColor *)color;
+(unsigned)getIntValueFromColor:(UIColor*)color;
@end



