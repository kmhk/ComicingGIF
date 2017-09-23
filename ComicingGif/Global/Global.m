//
//  Global.m
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 27/12/15.
//  Copyright © 2015 ADNAN THATHIYA. All rights reserved.
//

#import "Global.h"
#import "CBComicItemModel.h"

const NSInteger kPickedImageFrequence = 3;

@implementation Global

@synthesize isTakePhoto,deviceType,isBlackBoardOpen,placeholder_comic;

static Global *global = nil;

+ (Global *)global
{
	if (global == nil) {
		global = [[self alloc] init];
	}
    
    return global;
}

- (instancetype)init
{
    if (self = [super init])
    {
        deviceType = [self identifyDeviceType];
        
        placeholder_comic = [UIImage imageNamed:@"placeholder-comic"];
    }
    
    return self;
}

- (ScreenSizeType)identifyDeviceType
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if(screenSize.height == 480)
    {
        return ScreenSizeTypeIPhone4;
    }
    else if(screenSize.height == 568)
    {
        return ScreenSizeTypeIPhone5;
    }
    else if (screenSize.height == 667)
    {
        return ScreenSizeTypeIPhone6;
    }
    else if (screenSize.height == 736)
    {
        return ScreenSizeTypeIPhone6p;
    }
    
    return ScreenSizeTypeUnknown;
}

+ (UIColor *)getColorForComicBookColorCode:(ComicBookColorCode)comicBookColorCode {
    if (comicBookColorCode == Purple) {
        return [UIColor colorWithRed:130/255.f green:98/255.f blue:165/255.f alpha:1.f];
    } else if (comicBookColorCode == Green) {
        return [UIColor colorWithRed:83/255.f green:173/255.f blue:65/255.f alpha:1.f];
    } else if (comicBookColorCode == Yellow) {
        return [UIColor colorWithRed:255/255.f green:248/255.f blue:165/255.f alpha:1.f];
    } else if (comicBookColorCode == Orange) {
        return [UIColor colorWithRed:235/255.f green:108/255.f blue:10/255.f alpha:1.f];
    } else if (comicBookColorCode == NavyBlue) {
        return [UIColor colorWithRed:33/255.f green:77/255.f blue:162/255.f alpha:1.f];
    } else if (comicBookColorCode == LightBlue) {
        return [UIColor colorWithRed:0/255.f green:156/255.f blue:238/255.f alpha:1.f];
    } else if (comicBookColorCode == Pink) {
        return [UIColor colorWithRed:220/255.f green:39/255.f blue:128/255.f alpha:1.f];
    } else {
        return [UIColor whiteColor]; // Default white
    }
}

+ (UIImage *)getImageForColorCode:(ComicBookColorCode)comicBookColorCode andDirection:(Direction)direction {
    NSString *imageDirection;
    if (direction == Top) {
        imageDirection = @"Top";
    } else if (direction == Left) {
        imageDirection = @"Left";
    } else if (direction == Bottom) {
        imageDirection = @"Bottom";
    } else if (direction == Right) {
        imageDirection = @"Right";
    }
    
    NSString *colorName;
    if (comicBookColorCode == Purple) {
        colorName = @"Purple";
    } else if (comicBookColorCode == Green) {
        colorName = @"Green";
    } else if (comicBookColorCode == Yellow) {
        colorName = @"Yellow";
    } else if (comicBookColorCode == Orange) {
        colorName = @"Orange";
    } else if (comicBookColorCode == NavyBlue) {
        colorName = @"NBlue";
    } else if (comicBookColorCode == LightBlue) {
        colorName = @"LBlue";
    } else if (comicBookColorCode == Pink) {
        colorName = @"Pink";
    } else {
        colorName = @"White"; // Default white
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@",colorName, imageDirection];
    return [UIImage imageNamed:imageName];
}

- (CGRect)preferedScaleRect {
    static CGRect preferedScale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize windowSize = [UIScreen mainScreen].bounds.size;
        preferedScale = CGRectMake(0.0, 0.0, windowSize.width/2, windowSize.height/2);
    });
    return preferedScale;
}

- (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size {
#if 1
	if (!image) {
		return nil;
	}
	
	UIImage *newImage;
	
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	
//    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	CGContextRestoreGState(ctx);
	
    UIGraphicsEndImageContext();
	
    return newImage;
#else
	
	// mix video image and screen image
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef contextRef = CGBitmapContextCreate(NULL /*pxData.mutableBytes*/,
													image.size.width, image.size.height,
													8,
													0 /*targetSize.width * 4*/,
													rgbColorSpace,
													kCGImageAlphaNoneSkipFirst);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, size.width, size.height), image.CGImage);
	
	CGImageRef imgRef1 = CGBitmapContextCreateImage(contextRef);
	UIImage *result = [UIImage imageWithCGImage:imgRef1];
	
	CGImageRelease(imgRef1);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(rgbColorSpace);
	
	return result;
#endif
}

- (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size withInterpolationQuality:(CGInterpolationQuality)interpolation {
#if 1
	if (!image) {
		return nil;
	}
	
	UIImage *newImage;
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 1);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	
//    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), /*interpolation*/kCGInterpolationNone);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	CGContextRestoreGState(ctx);
	
	UIGraphicsEndImageContext();
	
    return newImage;
#else
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef contextRef = CGBitmapContextCreate(NULL /*pxData.mutableBytes*/,
													image.size.width, image.size.height,
													8,
													0 /*targetSize.width * 4*/,
													rgbColorSpace,
													kCGImageAlphaNoneSkipFirst);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, size.width, size.height), image.CGImage);
	
	CGImageRef imgRef1 = CGBitmapContextCreateImage(contextRef);
	UIImage *result = [UIImage imageWithCGImage:imgRef1];
	
	CGImageRelease(imgRef1);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(rgbColorSpace);
	
	return result;
#endif
}

+ (double)positive:(double)number {
    return number<0?-number:number;
}

+ (CGSize)getSizeOfComicSlideWithModel:(CBComicItemModel *)model {
    CGSize size;
    if(model.imageOrientation == COMIC_IMAGE_ORIENTATION_LANDSCAPE){
        size = [Global getWideSlideSize];
    }else if(model.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF){
        size = [Global getTallSmallSlideSize];
    }else {
        size = [Global getTallBigSlideSize];
    }
    
    NSInteger comicImageTopConstraint = 5; //5 top constraint is also added in xib
    size.height += comicImageTopConstraint;
    return size;
}

+ (CGSize)getTallBigSlideSize {
    return CGSizeMake(LargeTallSlideWidth, ((LargeTallSlideWidth) * (TallSlideWidthToHeightRatio)));
}

+ (CGSize)getTallSmallSlideSize {
    return CGSizeMake(SmallTallSlideWidth, ((SmallTallSlideWidth) * (TallSlideWidthToHeightRatio)));
}

+ (CGSize)getWideSlideSize {
    return CGSizeMake(WideSlideWidth, ((WideSlideWidth) * (WideSlideWidthToHeightRatio)));
}

+ (NSInteger)getWidthOfSlideAsPerUIImplemented {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = screenHeight - 0.092 * screenHeight; //0.092 is the proportion of height of bottom bar(black view) to main view in comic making screen
    
    return height/TallSlideWidthToHeightRatio;
}

@end
