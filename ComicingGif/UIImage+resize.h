//
//  UIImage+resize.h
//
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_resize)
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;
+(UIImage *)ScaletoFill:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)normalResImageForAsset:(UIImage *)image;
@end
