//
//  MZCroppableView.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "MZCroppableView.h"
#import "UIBezierPath-Points.h"
#import "AppConstants.h"
#import "Global.h"
#import "UIImage+Alpha.h"
#import "UIImage+Trim.h"
#import "UIImage+resize.h"

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]
@interface MZCroppableView()

@property (strong, nonatomic) NSMutableArray *allPoints;

@end


@implementation MZCroppableView
@synthesize allPoints;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithImageView:(UIImageView *)imageView
{
    self = [super initWithFrame:imageView.frame];
    
    if (self)
    {
        allPoints = [[NSMutableArray alloc] init];
        
        NSArray *animationArray=[NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"scissor1.png"],
                                 [UIImage imageNamed:@"scissor2.png"],
                                 [UIImage imageNamed:@"scissor3.png"],
                                 [UIImage imageNamed:@"scissor4.png"],
                                 [UIImage imageNamed:@"scissor5.png"],
                                 [UIImage imageNamed:@"scissor6.png"],
                                 nil];
        animationView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,33, 30)];
        animationView.backgroundColor = [UIColor clearColor];
        animationView.animationImages = animationArray;
        animationView.animationDuration = .5;
        animationView.animationRepeatCount = 0;
        [animationView startAnimating];
        [self addSubview:animationView];
        animationView.hidden = true;
        
        self.lineWidth = 5.0f;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        self.croppingPath = [[UIBezierPath alloc] init];
        [self.croppingPath setLineWidth:self.lineWidth];
        [self.croppingPath setLineJoinStyle:kCGLineJoinRound];

        //        [self.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"boy.png"]] CGColor]];///just add image name and create image with dashed or doted drawing and add here
        
        const CGFloat dashPattern[] = {10,10,10,10}; //make your pattern here
        [self.croppingPath setLineDash:dashPattern count:4 phase:3];
        [self.croppingPath setLineCapStyle:kCGLineCapRound];
//
        //        [self.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"point.png"]] CGColor]];///just add image name and create image with dashed or doted drawing and add here
        
        //        self.lineColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"point.png"]];
        //        self.lineColor = [UIColor greenColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetLineWidth(context, 100);
    //    CGFloat dashes[] = {1,1};
    //    CGContextSetLineDash(context, 2.0, dashes, 2);
    //    CGContextMoveToPoint(context, 0, self.bounds.size.height * 0.5);
    //    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height * 0.5);
    //    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    //
    //    CGContextStrokePath(context);
    
    
    // Drawing code
    [self.lineColor setStroke];
    [self.croppingPath stroke];
}


#pragma mark - My Methods -
+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2
{
    CGSize scaledSize = rect2.size;
    
    float scaleFactor = 1.0;
    
    CGFloat widthFactor  = rect2.size.width / rect1.size.width;
    CGFloat heightFactor = rect2.size.height / rect1.size.width;
    
    if (widthFactor < heightFactor)
        scaleFactor = widthFactor;
    else
        scaleFactor = heightFactor;
    
    scaledSize.height = rect1.size.height *scaleFactor;
    scaledSize.width  = rect1.size.width  *scaleFactor;
    
    return CGRectMake(rect2.origin.x, rect2.origin.y,rect2.size.width, rect2.size.height);
}


+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}
+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}



- (UIImage *)smoothImage:(UIImage *)img
{
   // UIImage * img =[UIImage imageWithData:[NSData dataWithContentsOfFile:[[[NSBundle mainBundle ] resourcePath ] stringByAppendingPathComponent:@"AliasImage.png" ] ] ];
    CGRect imageRect = CGRectMake( 0 , 0 , img.size.width + 4 , img.size.height + 4 );
    
    UIGraphicsBeginImageContext( imageRect.size );
    [img drawInRect:CGRectMake( imageRect.origin.x + 2 , imageRect.origin.y + 2 , imageRect.size.width - 4 , imageRect.size.height - 4 ) ];
    CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)transparentBorderImage:(NSUInteger)borderSize withImage:(UIImage *)originalImage {
    // If the image does not have an alpha layer, add one
    UIImage *image = [originalImage imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(originalImage.CGImage),
                                                0,
                                                CGImageGetColorSpace(originalImage.CGImage),
                                                CGImageGetBitmapInfo(originalImage.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, originalImage.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [originalImage newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextClearRect(bitmap,CGRectMake(0, 0, image.size.width, image.size.height));
    CGContextRelease(bitmap);
    CFRelease(borderImageRef);
    CFRelease(maskImageRef);
    CFRelease(transparentBorderImageRef);
//    CGImageRelease(borderImageRef);
//    CGImageRelease(maskImageRef);
//    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

- (BOOL)bezierPath:(UIBezierPath*)bezierPath containsPoint:(CGPoint)point
{
    CGRect bezierRect = bezierPath.bounds;
    
    if( bezierRect.origin.x < point.x && bezierRect.origin.x + bezierRect.size.width > point.x &&
       bezierRect.origin.y < point.y && bezierRect.origin.y + bezierRect.size.height > point.y ){
        return YES;
    }
    return NO;
}

bool lineSegmentsIntersect(CGPoint L1P1, CGPoint L1P2, CGPoint L2P1, CGPoint L2P2)
{
    float x1 = L1P1.x, x2 = L1P2.x, x3 = L2P1.x, x4 = L2P2.x;
    float y1 = L1P1.y, y2 = L1P2.y, y3 = L2P1.y, y4 = L2P2.y;
    
    float bx = x2 - x1;
    float by = y2 - y1;
    float dx = x4 - x3;
    float dy = y4 - y3;
    
    float b_dot_d_perp = bx * dy - by * dx;
    
    if(b_dot_d_perp == 0) {
        return NO;
    }
    
    float cx = x3 - x1;
    float cy = y3 - y1;
    float t = (cx * dy - cy * dx) / b_dot_d_perp;
    
    if(t < 0 || t > 1) {
        return NO;
    }
    
    float u = (cx * by - cy * bx) / b_dot_d_perp;
    
    if(u < 0 || u > 1) {
        return NO;
    }
    
    return YES;
}


- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image
{
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    UIBezierPath *aPath;
    
    aPath = [UIBezierPath bezierPath];
    aPath.miterLimit = -10;
    aPath.flatness = 0;
    
    NSArray *points = [self.croppingPath points];
    NSLog(@"==2");
    
    // Set the starting point of the shape.
    CGPoint p1 = [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
    
    NSInteger totalCount = points.count;
    
    NSInteger minusIndexes = (totalCount/1.2);
    
    NSInteger lastIndexes = totalCount - minusIndexes;
    
    NSInteger checkIndexes = totalCount - lastIndexes;
    
//    if (lineSegmentsIntersect(lineOnePointOne,lineOnePointTwo,lineTwoPointOne,lineTwoPointTwo)){
//        //segments intersect
//    } else {
//        //segments did not intersect
//    }
    
    for (uint i=1; i<points.count; i++)
    {
        CGPoint p = [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];

   //     NSString *checkPoint = NSStringFromCGPoint(p);
        
        if ([aPath containsPoint:p])
        {
            if (i > checkIndexes)
            {
                break;
            }
        }

      //  [allPoints addObject:checkPoint];
        
        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
    }
    NSLog(@"==3");
    aPath = [self smoothedPathWithGranularity:50 withPath:aPath];
    [aPath addClip];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
        
        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
        
        [aPath closePath];
        [aPath fill];
    }
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSLog(@"==4");
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [image.image drawAtPoint:CGPointZero];
    }
    
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"==5");
    CGRect croppedRect = aPath.bounds;
    
    croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath.bounds);//This because mask become inverse of the actual image;
    
    croppedRect.origin.x = croppedRect.origin.x*2;
    croppedRect.origin.y = croppedRect.origin.y*2;
    croppedRect.size.width = croppedRect.size.width*2;
    croppedRect.size.height = croppedRect.size.height*2;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        
        if ([[UIScreen mainScreen] bounds].size.height >= 669)
        {
            croppedRect.size.width = croppedRect.size.width*4;
            croppedRect.size.height = croppedRect.size.height*4;
        }
    }
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
    
    maskedImage = [UIImage imageWithCGImage:imageRef];
    NSLog(@"==6");
    return maskedImage;
}

- (UIImage *)deleteBackgroundOfImageWithBorder:(UIImageView *)image
{
    NSArray *points = [self.croppingPath points];
  
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    UIBezierPath *aPath;
    
    aPath = [UIBezierPath bezierPath];
    aPath.miterLimit = -10;
    aPath.flatness = 0;
    
    NSInteger totalCount = points.count;
    
    NSInteger minusIndexes = (totalCount/1.2);
    
    NSInteger lastIndexes = totalCount - minusIndexes;
    
    NSInteger checkIndexes = totalCount - lastIndexes;
    NSLog(@"==8");
    // Set the starting point of the shape.
    CGPoint p1 = [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
    
    for (uint i=1; i<points.count; i++)
    {
        CGPoint p = [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
        
        if ([aPath containsPoint:p])
        {
            if (i > checkIndexes)
            {
               break;
            }
         }
        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
    }

    if (IS_IPHONE_5)
    {
        aPath = [self smoothedPathWithGranularity:100 withPath:aPath];
    }
    else if (IS_IPHONE_6)
    {
        aPath = [self smoothedPathWithGranularity:80 withPath:aPath];
    }
    else if (IS_IPHONE_6P)
    {
        aPath = [self smoothedPathWithGranularity:60 withPath:aPath];
    }

    
    NSLog(@"==9");
    
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
       
        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
        
        [aPath closePath];
        [aPath fill];
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"==10");
    
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    {
        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );

        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [image.image drawAtPoint:CGPointZero];
    }
    
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"==11");
    maskedImage = [self transparentBorderImage:1 withImage:maskedImage];
    
    // white border
    
    CGFloat lineWidth;
    
    if (IS_IPHONE_5)
    {
        lineWidth = 5;
    }
    else if (IS_IPHONE_6)
    {
        lineWidth = 7;
    }
    else if (IS_IPHONE_6P)
    {
        lineWidth = 10;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );

        [[UIColor whiteColor] setStroke];
        
        [aPath setLineWidth:10];
        
        [aPath closePath];
        [aPath stroke];
    }
    
    UIImage *borderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"==12");
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );

        [[UIColor whiteColor] setFill];
        UIRectFill(rect);
    }
    
    UIImage *whiteImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"==13");
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, borderImage.CGImage);
        [whiteImage drawAtPoint:CGPointZero];
    }
    
    UIImage *whiteflippedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"==14");
    whiteflippedImage = [self transparentBorderImage:1 withImage:whiteflippedImage];
    
    maskedImage = [self drawImage:whiteflippedImage inImage:maskedImage atPoint:CGPointMake(0, 0)];
    NSLog(@"==15");
   // self.imgCropedSection = maskedImage;
    
    CGRect croppedRect = aPath.bounds;
    
    croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath.bounds);//This because mask become inverse of the actual image;
    
    croppedRect = CGRectMake(CGRectGetMinX(croppedRect) - 30,
                             CGRectGetMinY(croppedRect) - 30,
                             CGRectGetWidth(croppedRect) + 60,
                             CGRectGetHeight(croppedRect) + 60);
    
    if (IS_IPHONE_5)
    {
        croppedRect.origin.x = croppedRect.origin.x*2;
        croppedRect.origin.y = croppedRect.origin.y*2;
        croppedRect.size.width = croppedRect.size.width*2;
        croppedRect.size.height = croppedRect.size.height*2;
    }
    else if (IS_IPHONE_6)
    {
        croppedRect.origin.x = croppedRect.origin.x*2;
        croppedRect.origin.y = croppedRect.origin.y*2;
        croppedRect.size.width = croppedRect.size.width*4;
        croppedRect.size.height = croppedRect.size.height*4;
    }
    else if (IS_IPHONE_6P)
    {
        croppedRect.origin.x = croppedRect.origin.x*2;
        croppedRect.origin.y = croppedRect.origin.y*2;
        croppedRect.size.width = croppedRect.size.width*6;
        croppedRect.size.height = croppedRect.size.height*6;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
    
    maskedImage = [UIImage imageWithCGImage:imageRef];
    
    maskedImage = [self transparentBorderImage:2 withImage:maskedImage];
    NSLog(@"==16");
    return maskedImage;
}
//
//- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
//    
//    CGImageRef maskRef = maskImage.CGImage;
//    
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
//                                        CGImageGetHeight(maskRef),
//                                        CGImageGetBitsPerComponent(maskRef),
//                                        CGImageGetBitsPerPixel(maskRef),
//                                        CGImageGetBytesPerRow(maskRef),
//                                        CGImageGetDataProvider(maskRef), NULL, false);
//    
//    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
//    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
//    
//    CGImageRelease(mask);
//    CGImageRelease(maskedImageRef);
//    
//    // returns new image with mask applied
//    return maskedImage;
//}

//- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    CGImageRef maskImageRef = [maskImage CGImage];
//    
//    // create a bitmap graphics context the size of the image
//    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
//    CGColorSpaceRelease(colorSpace);
//    
//    if (mainViewContentContext==NULL)
//        return NULL;
//    
//    CGFloat ratio = 0;
//    
//    ratio = maskImage.size.width/ image.size.width;
//    
//    if(ratio * image.size.height < maskImage.size.height) {
//        ratio = maskImage.size.height/ image.size.height;
//    }
//    
//    CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
//    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
//
//    
////    CGRect rect2  = {{0,0},{image.size.width, image.size.height}};
//    
//    
//    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
//    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
//    
//    
//    // Create CGImageRef of the main view bitmap content, and then
//    // release that bitmap context
//    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
//    CGContextRelease(mainViewContentContext);
//    
//    UIImage *theImage = [UIImage imageWithCGImage:newImage];
//    
//    CGImageRelease(newImage);
//    
//    // return the image
//    return theImage;
//}

//-(UIImage*)Sample :(UIBezierPath*)aPath_WB image:(UIImageView *)image{
//@autoreleasepool {
//    CGRect rect = CGRectZero;
//    rect.size = image.image.size;
//    
//    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
//    {
//        [[UIColor blackColor] setFill];
//        UIRectFill(rect);
//        [[UIColor whiteColor] setFill];
//        
//        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationDefault );
//        
//        [aPath_WB fill];
//        [aPath_WB closePath];
//    }
//    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsPopContext();
//    UIGraphicsEndImageContext();
//    NSLog(@"==4");
//    UIImage *maskedImage = [self maskImage:image.image withMask:mask];
//    NSLog(@"==5");
//    maskedImage =  [maskedImage imageByTrimmingTransparentPixels];
//    return maskedImage;
//}
//}
-(void)saveImagetoFolder:(UIImage*)image FileName:(NSString*)fName{
    NSData *pngData = UIImagePNGRepresentation(image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fName == nil?@"image.png":fName]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    NSLog(@"File Path :%@",filePath);
}

-(UIImage*)cropUsingPath :(UIBezierPath*)aPath_WB Rect:(CGRect)rect image:(UIImage *)image{
    UIBezierPath *path = aPath_WB;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef  context    = CGBitmapContextCreate(nil, rect.size.width, rect.size.height, 8, 4*rect.size.width, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextDrawImage(context, rect, image.CGImage);
    //Clear Object
    CGColorSpaceRelease( colorSpace );
    UIImage *cropedImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return cropedImage;
}

-(UIImage*)Sample :(UIBezierPath*)aPath_WB image:(UIImageView *)image{
    @autoreleasepool {
        CGRect rect = CGRectZero;
        rect.size = image.image.size;
        
        [aPath_WB closePath];
        
//        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
//        {
//            [[UIColor blackColor] setFill];
//            UIRectFill(rect);
//            [[UIColor whiteColor] setFill];
//            
//            CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
//            
//            [aPath_WB fill];
//            [aPath_WB closePath];
//        }
//        UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsPopContext();
//        UIGraphicsEndImageContext();
//        NSLog(@"==4");
//        [self saveImagetoFolder:mask];
//        UIImage *maskedImage = [self maskImage:image.image withMask:mask];
        UIImage *maskedImage = [self cropUsingPath:aPath_WB Rect:rect image:image.image];
        NSLog(@"==5");
//        CGRect croppedRect = aPath_WB.bounds;
//        
//        croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath_WB.bounds);//This because mask become inverse of the actual image;
//        
//        croppedRect.origin.x = croppedRect.origin.x*2;
//        croppedRect.origin.y = croppedRect.origin.y*2;
//        croppedRect.size.width = croppedRect.size.width*2;
//        croppedRect.size.height = croppedRect.size.height*2;
//        
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
//        {
//            
//            if ([[UIScreen mainScreen] bounds].size.height >= 669)
//            {
//                croppedRect.size.width = croppedRect.size.width*4;
//                croppedRect.size.height = croppedRect.size.height*4;
//            }
//        }
//        
//        
//        CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
//        
//        maskedImage = [UIImage imageWithCGImage:imageRef];
//        NSLog(@"==6");
//        [self saveImagetoFolder:maskedImage];
        return maskedImage;

    }
}
- (UIImage *)cropImage:(UIImage*)image toRect:(CGRect)rect {
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    // determine the orientation of the image and apply a transformation to the crop rectangle to shift it to the correct position
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(rect, rectTransform);
    // use the rect to crop the image
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, transformedCropSquare);
    // create a new UIImage and set the scale and orientation appropriately
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    // memory cleanup
    CGImageRelease(imageRef);
    
    return result;
}

- (UIImage *)deleteBackgroundOfImageWithBorder:(UIImageView *)image withOutBorderImage:(UIImage **)imgWithOutBorder
{
    NSArray *points = [self.croppingPath points];
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    UIBezierPath *aPath;
    
    aPath = [UIBezierPath bezierPath];
    aPath.miterLimit = -10;
    aPath.flatness = 0;
    
    NSInteger totalCount = points.count;
    
    NSInteger minusIndexes = (totalCount/1.2);
    
    NSInteger lastIndexes = totalCount - minusIndexes;
    
    NSInteger checkIndexes = totalCount - lastIndexes;
    // Set the starting point of the shape.
    CGPoint p1 = [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
    
    for (uint i=1; i<points.count; i++)
    {
        CGPoint p = [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
        
        if ([aPath containsPoint:p])
        {
            if (i > checkIndexes)
            {
                break;
            }
        }
        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
    }
    
    UIBezierPath *aPath_WB = [aPath copy];
    aPath_WB = [self smoothedPathWithGranularity:50 withPath:aPath_WB];
    
    if (IS_IPHONE_5)
    {
        aPath = [self smoothedPathWithGranularity:100 withPath:aPath];
    }
    else if (IS_IPHONE_6)
    {
        aPath = [self smoothedPathWithGranularity:80 withPath:aPath];
    }
    else if (IS_IPHONE_6P)
    {
        aPath = [self smoothedPathWithGranularity:60 withPath:aPath];
    }
    NSLog(@"==9");
    *imgWithOutBorder = [self Sample:aPath_WB image:image];
    return *imgWithOutBorder;
    /*UIImage *maskedImage = [self cropUsingPath:aPath Rect:rect image:image.image];
    
    maskedImage = [self transparentBorderImage:1 withImage:maskedImage];
    
    // white border
    
    CGFloat lineWidth;
    
    if (IS_IPHONE_5)
    {
        lineWidth = 5;
    }
    else if (IS_IPHONE_6)
    {
        lineWidth = 7;
    }
    else if (IS_IPHONE_6P)
    {
        lineWidth = 10;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
        
        [[UIColor whiteColor] setStroke];
        
        [aPath setLineWidth:10];
        
        [aPath closePath];
        [aPath stroke];
    }
    
    UIImage *borderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
        
        [[UIColor whiteColor] setFill];
        UIRectFill(rect);
    }
    
    UIImage *whiteImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, borderImage.CGImage);
        [whiteImage drawAtPoint:CGPointZero];
    }
    
    UIImage *whiteflippedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    whiteflippedImage = [self transparentBorderImage:1 withImage:whiteflippedImage];
    
    // -----------------
    
    maskedImage = [self drawImage:whiteflippedImage inImage:maskedImage atPoint:CGPointMake(0, 0)];
    
    maskedImage =  [maskedImage imageByTrimmingTransparentPixelsRequiringFullOpacity:YES trimTop:YES];
    *imgWithOutBorder =  [*imgWithOutBorder imageByTrimmingTransparentPixelsRequiringFullOpacity:YES trimTop:YES];
    return maskedImage;*/
}

//- (UIImage *)deleteBackgroundOfImageWithBorder:(UIImageView *)image withOutBorderImage:(UIImage **)imgWithOutBorder
//{
//    NSArray *points = [self.croppingPath points];
//    
//    
//    CGRect rect = CGRectZero;
//    rect.size = image.image.size;
//    
//    UIBezierPath *aPath;
//    
//    aPath = [UIBezierPath bezierPath];
//    aPath.miterLimit = -10;
//    aPath.flatness = 0;
//    
//    NSInteger totalCount = points.count;
//    
//    NSInteger minusIndexes = (totalCount/1.2);
//    
//    NSInteger lastIndexes = totalCount - minusIndexes;
//    
//    NSInteger checkIndexes = totalCount - lastIndexes;
//    NSLog(@"==8");
//    // Set the starting point of the shape.
//    CGPoint p1 = [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
//    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
//    
//    for (uint i=1; i<points.count; i++)
//    {
//        CGPoint p = [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
//        
//        if ([aPath containsPoint:p])
//        {
//            if (i > checkIndexes)
//            {
//                break;
//            }
//        }
//        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
//    }
//    
//    UIBezierPath *aPath_WB = [aPath copy];
//    aPath_WB = [self smoothedPathWithGranularity:50 withPath:aPath_WB];
//    
//    if (IS_IPHONE_5)
//    {
//        aPath = [self smoothedPathWithGranularity:100 withPath:aPath];
//    }
//    else if (IS_IPHONE_6)
//    {
//        aPath = [self smoothedPathWithGranularity:80 withPath:aPath];
//    }
//    else if (IS_IPHONE_6P)
//    {
//        aPath = [self smoothedPathWithGranularity:60 withPath:aPath];
//    }
//    
//    NSLog(@"==9");
//    *imgWithOutBorder = [self Sample:aPath_WB image:image];
//    
//    //Start With Border Process
//    @autoreleasepool {
//    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
//    {
//        [[UIColor blackColor] setFill];
//        UIRectFill(rect);
//        [[UIColor whiteColor] setFill];
//        
//        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationDefault );
//        
//        [aPath closePath];
//        [aPath fill];
//    }
//    
//    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSLog(@"==10");
//    
//    UIImage *maskedImage = [self maskImage:image.image withMask:mask];
//    maskedImage = [self transparentBorderImage:1 withImage:maskedImage];
//    
//    NSLog(@"==11.5");
//    // white border
//    
//    CGFloat lineWidth;
//    
//    if (IS_IPHONE_5)
//    {
//        lineWidth = 5;
//    }
//    else if (IS_IPHONE_6)
//    {
//        lineWidth = 7;
//    }
//    else if (IS_IPHONE_6P)
//    {
//        lineWidth = 10;
//    }
//    
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
//    {
//        CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationDefault );
//        
//        [[UIColor whiteColor] setStroke];
//        
//        [aPath setLineWidth:20];
//        
//        [aPath closePath];
//        [aPath stroke];
//    }
//    
//    UIImage *borderImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    NSLog(@"==14");
//    NSLog(@"==14.1");
//    UIImage * whiteflippedImage = [self transparentBorderImage:2 withImage:borderImage];
//    NSLog(@"==14.2");
//    maskedImage = [self drawImage:whiteflippedImage inImage:maskedImage atPoint:CGPointMake(0, 0)];
//    NSLog(@"==15");
//      
//    maskedImage = [self transparentBorderImage:2 withImage:maskedImage];
//    maskedImage =  [maskedImage imageByTrimmingTransparentPixels];
//    
//    return maskedImage;
//        }
//}


-(UIImage *)smoothImageBorder:(UIImage *)input{
    
    CIContext *context_ = [CIContext contextWithOptions:nil];
    
    UIImage *defaultImage_=input;
    
    CIImage *inputImage = [CIImage imageWithCGImage:[defaultImage_ CGImage]];
    
    //Apply CIBloom that makes soft edges and adds glow to image
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithDouble:1.5] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithDouble:20] forKey:@"inputIntensity"];

    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context_ createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return resultImage;
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height
{
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
void getPointsFromBezier1(void *info, const CGPathElement *element)
{
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    // Retrieve the path element type and its points
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    // Add the points if they're available (per type)
    if (type != kCGPathElementCloseSubpath)
    {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) &&
            (type != kCGPathElementMoveToPoint))
            [bezierPoints addObject:VALUE(1)];
    }
    if (type == kCGPathElementAddCurveToPoint)
        [bezierPoints addObject:VALUE(2)];
}

NSArray *pointsFromBezierPath(UIBezierPath *bpath)
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(bpath.CGPath, (__bridge void *)points, getPointsFromBezier1);
    return points;
}

- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity withPath:(UIBezierPath *)path;
{
    NSMutableArray *points = [pointsFromBezierPath(path) mutableCopy];
    
    if (points.count < 4) return [path copy];
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    
    UIBezierPath *smoothedPath = [path copy];
    [smoothedPath removeAllPoints];
    
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++)
    {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    return smoothedPath;
}

- (float)findDistance:(CGPoint)point lineA:(CGPoint)lineA lineB:(CGPoint)lineB
{
    CGPoint v1 = CGPointMake(lineB.x - lineA.x, lineB.y - lineA.y);
    CGPoint v2 = CGPointMake(point.x - lineA.x, point.y - lineA.y);
    float lenV1 = sqrt(v1.x * v1.x + v1.y * v1.y);
    float lenV2 = sqrt(v2.x * v2.x + v2.y * v2.y);
    float angle = acos((v1.x * v2.x + v1.y * v2.y) / (lenV1 * lenV2));
    return sin(angle) * lenV2;
}


- (NSArray *)catmullRomSplineAlgorithmOnPoints:(NSArray *)points segments:(int)segments
{
    long count = [points count];
    if(count < 4) {
        return points;
    }
    
    float b[segments][4];
    {
        // precompute interpolation parameters
        float t = 0.0f;
        float dt = 1.0f/(float)segments;
        for (int i = 0; i < segments; i++, t+=dt) {
            float tt = t*t;
            float ttt = tt * t;
            b[i][0] = 0.5f * (-ttt + 2.0f*tt - t);
            b[i][1] = 0.5f * (3.0f*ttt -5.0f*tt +2.0f);
            b[i][2] = 0.5f * (-3.0f*ttt + 4.0f*tt + t);
            b[i][3] = 0.5f * (ttt - tt);
        }
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    {
        int i = 0; // first control point
        [resultArray addObject:[points objectAtIndex:0]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            CGPoint pointIp2 = [[points objectAtIndex:(i + 2)] CGPointValue];
            float px = (b[j][0]+b[j][1])*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = (b[j][0]+b[j][1])*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    
    for (int i = 1; i < count-2; i++) {
        // the first interpolated point is always the original control point
        [resultArray addObject:[points objectAtIndex:i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [[points objectAtIndex:(i - 1)] CGPointValue];
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            CGPoint pointIp2 = [[points objectAtIndex:(i + 2)] CGPointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    
    {
        long i = count-2; // second to last control point
        [resultArray addObject:[points objectAtIndex:i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [[points objectAtIndex:(i - 1)] CGPointValue];
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + (b[j][2]+b[j][3])*pointIp1.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + (b[j][2]+b[j][3])*pointIp1.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    // the very last interpolated point is the last control point
    [resultArray addObject:[points objectAtIndex:(count - 1)]];
    
    return resultArray;
}

//- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image
//{
//    NSArray *temppoints = [self.croppingPath points];
//    
//    NSArray *points = [self catmullRomSplineAlgorithmOnPoints:temppoints segments:30];
//    
//    CGRect rect = CGRectZero;
//    rect.size = image.image.size;
//    
//    UIBezierPath *aPath;
//    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
//    {
//        [[UIColor blackColor] setFill];
//        UIRectFill(rect);
//        [[UIColor whiteColor] setFill];
//        
//        aPath = [UIBezierPath bezierPath];
//        aPath.miterLimit = -10;
//        aPath.flatness = 0;
//        
//        // Set the starting point of the shape.
//        CGPoint p1 = [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
//        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
//        
//        for (uint i=1; i<points.count; i++)
//        {
//            CGPoint p = [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
//            
//            if ([aPath containsPoint:p])
//            {
//                break;
//            }
//            
//            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
//        }
//        [aPath closePath];
//        [aPath fill];
//    }
//    
//    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
//    
//    {
//        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
//        [image.image drawAtPoint:CGPointZero];
//    }
//    
//    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    
////    NSArray *temppoints = [self.croppingPath points];
////    
////    NSArray *points = [self catmullRomSplineAlgorithmOnPoints:temppoints segments:60];
////    
////    CGRect rect = CGRectZero;
////    rect.size = image.image.size;
////    
////    UIBezierPath *aPath;
////    aPath = [UIBezierPath bezierPath];
////    aPath.flatness = 0;
////    aPath.miterLimit = -100;
////    
////  //  rect = CGRectMake(0, 0, CGRectGetWidth(rect) + 50, CGRectGetHeight(rect) + 50);
////    
////    CGPoint p1 = [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
////    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
////    
////    for (uint i=1; i<points.count; i++)
////    {
////        CGPoint p = [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
////        
////        if ([aPath containsPoint:p])
////        {
////            break;
////        }
////        
////        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
////    }
////    
////    aPath = [self smoothedPathWithGranularity:60 withPath:aPath];
////    
////    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
////    {
////        [[UIColor blackColor] setFill];
////        UIRectFill(rect);
////        [[UIColor whiteColor] setFill];
////        
////        [aPath closePath];
////        [aPath fill];
////    }
////    
////    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    
////    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
////    {
////        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
////        [image.image drawAtPoint:CGPointZero];
////    }
////    
////    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
//    
//    //--------- white color border
//    
////    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
////    {
////        [[UIColor whiteColor] setStroke];
////        
////        [aPath setLineWidth:4];
////        
////        [aPath closePath];
////        [aPath stroke];
////    }
////    
////    UIImage *borderImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    
////    
////    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
////    {
////         [[UIColor whiteColor] setFill];
////         UIRectFill(rect);
////    }
////    
////    UIImage *whiteImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    
////    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
////    {
////        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, borderImage.CGImage);
////        [whiteImage drawAtPoint:CGPointZero];
////    }
////    
////    UIImage *whiteflippedImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
//    
//    //---------------
//    
//    
//    // ------ grey color
//    
////    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
////    {
////        [[UIColor colorWithRed:209/255.0f green:211/255.0f blue:212/255.0f alpha:1] setStroke];
////        
////        [aPath setLineWidth:15];
////        
////        [aPath closePath];
////        [aPath stroke];
////    }
////    
////    UIImage *greyborderImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    
////    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
////    {
////        [[UIColor colorWithRed:209/255.0f green:211/255.0f blue:212/255.0f alpha:1] setFill];
////        UIRectFill(rect);
////    }
////    
////    UIImage *greyImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    
////    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
////    {
////        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, greyborderImage.CGImage);
////        [greyImage drawAtPoint:CGPointZero];
////    }
////    
////    UIImage *greyflippedImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
//  
//    // ----------------
//    
//   // UIImage *imageWithGrey = [self drawImage:greyflippedImage inImage:maskedImage atPoint:CGPointMake(0, 0)];
//    
//    
//  //
//    maskedImage = [self drawImage:whiteflippedImage inImage:maskedImage atPoint:CGPointMake(0, 0)];
//    
// //   maskedImage = [self drawImage:imageWithWhite inImage:imageWithGrey atPoint:CGPointMake(0, 0)];
//    
//    CGRect croppedRect = aPath.bounds;
//    
//    croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath.bounds);//This because mask become inverse of the actual image;
//    
//    croppedRect = CGRectMake(CGRectGetMinX(croppedRect) - 30,
//                             CGRectGetMinY(croppedRect) - 30,
//                             CGRectGetWidth(croppedRect) + 60,
//                             CGRectGetHeight(croppedRect) + 60);
//    if (IS_IPHONE_5)
//    {
//        croppedRect.origin.x = croppedRect.origin.x*2;
//        croppedRect.origin.y = croppedRect.origin.y*2;
//        croppedRect.size.width = croppedRect.size.width*2;
//        croppedRect.size.height = croppedRect.size.height*2;
//    }
//    else if (IS_IPHONE_6)
//    {
//        croppedRect.origin.x = croppedRect.origin.x*2;
//        croppedRect.origin.y = croppedRect.origin.y*2;
//        croppedRect.size.width = croppedRect.size.width*4;
//        croppedRect.size.height = croppedRect.size.height*4;
//    }
//    else if (IS_IPHONE_6P)
//    {
//        croppedRect.origin.x = croppedRect.origin.x*2;
//        croppedRect.origin.y = croppedRect.origin.y*2;
//        croppedRect.size.width = croppedRect.size.width*6;
//        croppedRect.size.height = croppedRect.size.height*6;
//    }
//
//    CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
//    
//    maskedImage = [UIImage imageWithCGImage:imageRef];
//    
//    UIImage *shadowImage = [self imageWithShadowForImage:maskedImage];
//    
//    return shadowImage;
//}

- (UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
//
//    UIImage *image = nil;
//    
//    CGSize newImageSize = CGSizeMake(MAX(fgImage.size.width, bgImage.size.width), MAX(fgImage.size.height, bgImage.size.height));
//    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
//        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
//    } else {
//        UIGraphicsBeginImageContext(newImageSize);
//    }
//    [fgImage drawAtPoint:point];
//    [bgImage drawAtPoint:point];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
}


#pragma mark - Touch Methods -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"tappEnder"] != nil)
    {
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"tappEnder"] isEqualToString:@"not"])
        {
            
            animationView.hidden = false;
            
            UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
            [self.croppingPath moveToPoint:[mytouch locationInView:self]];

            [allPoints addObject:[NSValue valueWithCGPoint:[mytouch locationInView:self]]];
        }
    }
    else
    {
        animationView.hidden = false;
        
        UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
        [self.croppingPath moveToPoint:[mytouch locationInView:self]];
        [allPoints addObject:[NSValue valueWithCGPoint:[mytouch locationInView:self]]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint nowPoint = [[touches anyObject] locationInView:self];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self];
    
    if( nowPoint.x <= prevPoint.x && nowPoint.y <= prevPoint.y)
    {
        animationView.transform = CGAffineTransformMakeRotation(.5); //rotation in radians
        
        //        NSLog(@"1");
    }
    else if( nowPoint.x >= prevPoint.x && nowPoint.y >= prevPoint.y)
    {
        animationView.transform = CGAffineTransformMakeRotation(-.5); //rotation in radians
        
        //        NSLog(@"2");
        
    }
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"tappEnder"] != nil)
    {
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"tappEnder"] isEqualToString:@"not"])
        {
            UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
            
            CGPoint touchLocation = [mytouch locationInView:self];
            
            // move the image view
            animationView.center = touchLocation;
            
            [self.croppingPath addLineToPoint:[mytouch locationInView:self]];
            [allPoints addObject:[NSValue valueWithCGPoint:[mytouch locationInView:self]]];
            [self setNeedsDisplay];
        }
    }
    else
    {
        UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
        
        CGPoint touchLocation = [mytouch locationInView:self];
        
        // move the image view
        animationView.center = touchLocation;
        [self.croppingPath addLineToPoint:[mytouch locationInView:self]];
        [allPoints addObject:[NSValue valueWithCGPoint:[mytouch locationInView:self]]];
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    animationView.hidden = true;
    [[NSUserDefaults standardUserDefaults]setObject:@"not" forKey:@"tappEnder"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cropFinished"
     object:self];
    
    [self.delegate didFinishedTouch];
}

@end
