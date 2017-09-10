//
//  UIImage+UIImage_resize.m
//  Papyrus
//
//  Created by Jeethu Rao on 1/4/12.
//  Copyright (c) 2012 Trellisys. All rights reserved.
//

#import "UIImage+resize.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CIImage.h>

#define ASPECT_RATIO(x) (x.height/x.width)

@implementation UIImage (UIImage_resize)

+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size {
	float imgAr = ASPECT_RATIO(image.size);
	float rectAr = ASPECT_RATIO(size);
	float scaleFactor = rectAr > imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
	CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    float xpos = (size.width-scaledSize.width)/2;
	
	UIImage *scaledImage;
	
	@autoreleasepool {
    UIGraphicsBeginImageContext(size); 
    [image drawInRect:CGRectMake(xpos, 0, scaledSize.width, scaledSize.height )];
    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	}
	
    return scaledImage;
}

+ (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
	
	UIImage *newImage;
	
	@autoreleasepool {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);  
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
//    CGContextRelease(context);
    UIGraphicsEndImageContext();
	}
	
    return newImage;
}

+(UIImage *)ScaletoFill:(UIImage *)image toSize:(CGSize)size {
    float imgAr = ASPECT_RATIO(image.size);
    float rectAr = ASPECT_RATIO(size);
    
    //tried fixing this by changing the if condition
    float scaleFactor = rectAr < imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
    CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    
    float ypos = (size.height-scaledSize.height)/2;
    float xpos = (size.width-scaledSize.width)/2;
	
	UIImage *scaledImage;
	
	@autoreleasepool {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(xpos,ypos, scaledSize.width, scaledSize.height )];
    
    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	}
	
    return scaledImage;
}

+(UIImage *)normalResImageForAsset:(UIImage *)image
{
    // Convert ALAsset to UIImage
//    UIImage *image = [self highResImageForAsset:asset];
    
    // Determine output size
    CGFloat maxSize = 1024.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        } else {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
	
	UIImage *newImage;
	
	@autoreleasepool {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	}
	
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
//    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.0f);
//    UIImage *processedImage = [UIImage imageWithData:imageData];
    
//    return processedImage;
    return newImage;
}
@end
