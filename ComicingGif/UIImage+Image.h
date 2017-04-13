//
//  UIImage+Image.h
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 26/12/15.
//  Copyright © 2015 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;

- (UIImage *)compressWithMaxSize:(CGSize)maxSize andQuality:(CGFloat)quality;
- (UIImage *)cropedImagewithCropRect:(CGRect)cropRect;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize inRect:(CGRect)rect;

- (UIImage *)normalResImageWithImage:(UIImage *)image;
- (UIImage *)compressImage:(UIImage *)image;

+(UIImage *)ScaletoFill:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)image:(UIImage *)image scaledCopyOfSize:(CGSize)newSize;

- (UIImage*)scaleByFactor:(float)scaleFactor;
+ (UIImage *) imageWithView:(UIView *)view paque:(BOOL)isOpaque;
+ (UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius;
+(UIImage*)fixrotation:(UIImage *)image;
+(void)saveImagetoFolder:(UIImage*)image FileName:(NSString*)fName;
@end
