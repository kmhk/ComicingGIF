//
//  ComicShareView.m
//  ComicApp
//
//  Created by Ramesh on 18/01/16.
//  Copyright © 2016 Ramesh. All rights reserved.
//

#import "ComicShareView.h"
#import <QuartzCore/QuartzCore.h>

@interface ComicShareView ()

@end

@implementation ComicShareView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.img1ComicSlide4 = [[UIImageView alloc] init];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"ComicShareView" owner:self options:nil];
    }
    return self;
}

-(id)initWithShareImagesArray:(NSArray*)shareImageArray{
    self = [super init];
    if(self)
    {
    }
    
    return self;
}

-(UIImage*)getComicShareImage:(NSArray*)shareImageArray{
    self.comicShareImage = [self getComicShareImages:shareImageArray];
   // self.comicShareImage = [UIImage ScaletoFill:self.comicShareImage toSize:CGSizeMake(self.comicShareImage.size.width*4, self.comicShareImage.size.height*4)];
    return self.comicShareImage;
}

#pragma mark Methods

-(UIImage*)getComicShareImages:(NSArray*)imageArray{
    [self setShareImages:imageArray];
//    if (imageArray && [imageArray count] <=4)
//        switch ([imageArray count]) {
//            case 1:
//                return [self saveViewToImage:self.viewHolderSlide1];
//                break;
//            case 2:
//                return [self saveViewToImage:self.viewHolderSlide2];
//                break;
//            case 3:
//                return [self saveViewToImage:self.viewHolderSlide3];
//                break;
//            case 4:
//                return [self saveViewToImage:self.viewHolderSlide4];
//                break;
//            default:
//                return nil;
//                break;
//        }else if (imageArray && [imageArray count] >= 4){
//            return [self saveViewToImage:self.viewHolderSlide4];
//        }
//        else
//            return nil;
    if (imageArray && [imageArray count] <=4)
    switch ([imageArray count]) {
        case 1:
            return [self createSlide1Image];
            break;
        case 2:
            return [self createSlide2Image];
            break;
        case 3:
            return [self createSlide3Image];
            break;
        case 4:
            return [self createSlide4Image];
            break;
        default:
            return nil;
            break;
    }else if (imageArray && [imageArray count] >= 4){
        return [self createSlide4Image];
    }
    else
        return nil;
}


-(void)setShareImages:(NSArray*)imgArray{
    
    if (imgArray && [imgArray count] <=4)
        switch ([imgArray count]) {
            case 1:
            {
                [self.img1ComicSlide1 setImage:(UIImage*)[imgArray objectAtIndex:0]];
            }
                break;
            case 2:
            {
                [self.img1ComicSlide2 setImage:(UIImage*)[imgArray objectAtIndex:0]];
                [self.img2ComicSlide2 setImage:(UIImage*)[imgArray objectAtIndex:1]];
            }
                break;
            case 3:
            {
                [self.img1ComicSlide3 setImage:(UIImage*)[imgArray objectAtIndex:0]];
                [self.img2ComicSlide3 setImage:(UIImage*)[imgArray objectAtIndex:1]];
                [self.img3ComicSlide3 setImage:(UIImage*)[imgArray objectAtIndex:2]];
            }
                break;
            case 4:
            {
                [self.img1ComicSlide4 setImage:(UIImage*)[imgArray objectAtIndex:0]];
                [self.img2ComicSlide4 setImage:(UIImage*)[imgArray objectAtIndex:1]];
                [self.img3ComicSlide4 setImage:(UIImage*)[imgArray objectAtIndex:2]];
                [self.img4ComicSlide4 setImage:(UIImage*)[imgArray objectAtIndex:3]];
            }
                break;
            default:
                break;
        }else if (imgArray && [imgArray count] >= 4){
            [self.img1ComicSlide4 setImage:(UIImage*)[imgArray objectAtIndex:0]];
            [self.img2ComicSlide4 setImage:(UIImage*)[imgArray objectAtIndex:1]];
            [self.img3ComicSlide4 setImage:(UIImage*)[imgArray objectAtIndex:2]];
            [self.img4ComicSlide4 setImage:(UIImage*)[imgArray objectAtIndex:3]];
        }
}

-(UIImage*)imageWithView:(UIView *)view{
	UIImage *img;
	
	@autoreleasepool {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	}
	
    return img;
}

-(void)saveView :(UIView*)currentView{
    
    UIImage* imgProcessShareImage = [self imageWithView:currentView];
    
    NSData *imageData = UIImagePNGRepresentation(imgProcessShareImage);
    
    //Just to test
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
    
    NSLog(@"File Path %@",filePath);
    [imageData writeToFile:filePath atomically:YES]; //Write the file
    
}

-(UIImage*)saveViewToImage:(UIView*)currentView{
    
    UIImage* imgProcessShareImage = [self imageWithView:currentView];
    
    return imgProcessShareImage;
    
}

#pragma marke Slide 1

-(UIImage*)createSlide1Image{
    // return [self saveViewToImage:self.viewHolderSlide1];
    [self giveBorderToView:self.img1ComicSlide1 OfWidth:3.2f];
    return [self saveViewToImage:self.viewHolderSlide1];
}
-(void)giveBorderToView:(UIImageView *)view OfWidth:(CGFloat)width
{
    [view.layer setBorderColor: [[UIColor blackColor] CGColor]];
    view.layer.masksToBounds = YES;
    [view.layer setBorderWidth: width];
}
#pragma mark 2 Slide

-(UIImage*)createSlide2Image{
    
//    //Masking Slide -1
//    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
//    maskLayer1.frame = self.img1ComicSlide2.bounds;
//    
//    UIBezierPath *aPath = [UIBezierPath bezierPath];
//    [aPath moveToPoint:CGPointMake(0,0)];
//    [aPath addLineToPoint:CGPointMake(210,0)];
//    [aPath addLineToPoint:CGPointMake(231,377)];
//    [aPath addLineToPoint:CGPointMake(0,397)];
//    
//    [aPath closePath];
//    maskLayer1.path = [aPath CGPath];
//    
//    // Add mask
//    self.img1ComicSlide2.layer.mask = maskLayer1;
//    
//    
//    //Masking Slide -2
//    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
//    maskLayer2.frame = self.img2ComicSlide2.bounds;
//    
//    UIBezierPath *aPath2 = [UIBezierPath bezierPath];
//    [aPath2 moveToPoint:CGPointMake(230,0)];
//    [aPath2 addLineToPoint:CGPointMake(230,360)];
//    [aPath2 addLineToPoint:CGPointMake(29,374)];
//    [aPath2 addLineToPoint:CGPointMake(6,0)];
//    
//    [aPath2 closePath];
//    maskLayer2.path = [aPath2 CGPath];
//    
//    self.img2ComicSlide2.layer.mask = maskLayer2;
    [self giveBorderToView:self.img1ComicSlide2 OfWidth:3.2f];
    [self giveBorderToView:self.img2ComicSlide2 OfWidth:3.2f];

    return [self saveViewToImage:self.viewHolderSlide2];
}


#pragma mark 3 Slide

-(UIImage*)createSlide3Image{
    
//    //Masking Slide -1
//    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
//    maskLayer1.frame = self.img1ComicSlide3.bounds;
//    
//    UIBezierPath *aPath = [UIBezierPath bezierPath];
//    [aPath moveToPoint:CGPointMake(0,0)];
//    [aPath addLineToPoint:CGPointMake(170,0)];
//    [aPath addLineToPoint:CGPointMake(188,298)];
//    [aPath addLineToPoint:CGPointMake(0,313)];
//    
//    [aPath closePath];
//    maskLayer1.path = [aPath CGPath];
//    
//    // Add mask
//    self.img1ComicSlide3.layer.mask = maskLayer1;
//    
//    
//    //Masking Slide -2
//    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
//    maskLayer2.frame = self.img2ComicSlide3.bounds;
//    
//    UIBezierPath *aPath2 = [UIBezierPath bezierPath];
//    [aPath2 moveToPoint:CGPointMake(188,0)];
//    [aPath2 addLineToPoint:CGPointMake(188,286)];
//    [aPath2 addLineToPoint:CGPointMake(24,296)];
//    [aPath2 addLineToPoint:CGPointMake(10,0)];
//    
//    [aPath2 closePath];
//    maskLayer2.path = [aPath2 CGPath];
//    
//    self.img2ComicSlide3.layer.mask = maskLayer2;
//    
//    
//    //Masking Slide - 3
//    CAShapeLayer *maskLayer3 = [CAShapeLayer layer];
//    maskLayer3.frame = self.img3ComicSlide3.bounds;
//    
//    UIBezierPath *aPath3 = [UIBezierPath bezierPath];
//    [aPath3 moveToPoint:CGPointMake(188,0)];
//    [aPath3 addLineToPoint:CGPointMake(188,295)];
//    [aPath3 addLineToPoint:CGPointMake(6,288)];
//    [aPath3 addLineToPoint:CGPointMake(0,0)];
//    
//    [aPath3 closePath];
//    maskLayer3.path = [aPath3 CGPath];
//    
//    self.img3ComicSlide3.layer.mask = maskLayer3;
    
    [self giveBorderToView:self.img1ComicSlide3 OfWidth:2];
    [self giveBorderToView:self.img2ComicSlide3 OfWidth:2];
    [self giveBorderToView:self.img3ComicSlide3 OfWidth:2];
    return [self saveViewToImage:self.viewHolderSlide3];
}

#pragma mark 4 Slide

-(UIImage*)createSlide4Image{
    
//    //Masking Slide -1
//    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
//    maskLayer1.frame = self.img1ComicSlide4.bounds;
//    
//    UIBezierPath *aPath = [UIBezierPath bezierPath];
//    [aPath moveToPoint:CGPointMake(0,0)];
//    [aPath addLineToPoint:CGPointMake(156,0)];
//    [aPath addLineToPoint:CGPointMake(156,246)];
//    [aPath addLineToPoint:CGPointMake(0,259)];
//    
//    [aPath closePath];
//    maskLayer1.path = [aPath CGPath];
//    
//    // Add mask
//    self.img1ComicSlide4.layer.mask = maskLayer1;
//    
//    
//    //Masking Slide -2
//    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
//    maskLayer2.frame = self.img2ComicSlide4.bounds;
//    
//    UIBezierPath *aPath2 = [UIBezierPath bezierPath];
//    [aPath2 moveToPoint:CGPointMake(155,0)];
//    [aPath2 addLineToPoint:CGPointMake(155,240)];
//    [aPath2 addLineToPoint:CGPointMake(0,246)];
//    [aPath2 addLineToPoint:CGPointMake(0,0)];
//    
//    [aPath2 closePath];
//    maskLayer2.path = [aPath2 CGPath];
//    
//    self.img2ComicSlide4.layer.mask = maskLayer2;
//    
//    
//    //Masking Slide - 3
//    CAShapeLayer *maskLayer3 = [CAShapeLayer layer];
//    maskLayer3.frame = self.img3ComicSlide4.bounds;
//    
//    UIBezierPath *aPath3 = [UIBezierPath bezierPath];
//    [aPath3 moveToPoint:CGPointMake(0,256)];
//    [aPath3 addLineToPoint:CGPointMake(154,256)];
//    [aPath3 addLineToPoint:CGPointMake(154,4)];
//    [aPath3 addLineToPoint:CGPointMake(0,14)];
//    
//    [aPath3 closePath];
//    maskLayer3.path = [aPath3 CGPath];
//    
//    self.img3ComicSlide4.layer.mask = maskLayer3;
//    
//    
//    //Masking Slide - 4
//    CAShapeLayer *maskLayer4 = [CAShapeLayer layer];
//    maskLayer4.frame = self.img4ComicSlide4.bounds;
//    
//    UIBezierPath *aPath4 = [UIBezierPath bezierPath];
//    [aPath4 moveToPoint:CGPointMake(155,256)];
//    [aPath4 addLineToPoint:CGPointMake(0,256)];
//    [aPath4 addLineToPoint:CGPointMake(5,4)];
//    [aPath4 addLineToPoint:CGPointMake(155,0)];    
//
////    [aPath4 moveToPoint:CGPointMake(155,259)];
////    [aPath4 addLineToPoint:CGPointMake(155,0)];
////    [aPath4 addLineToPoint:CGPointMake(5,4)];
////    [aPath4 addLineToPoint:CGPointMake(0,256)];
//    
//    [aPath4 closePath];
//    maskLayer4.path = [aPath4 CGPath];
//    
//    self.img4ComicSlide4.layer.mask = maskLayer4;
//    
//    
//    self.imgComicLogo4.transform=CGAffineTransformMakeRotation(M_PI / -30);

    [self giveBorderToView:self.img1ComicSlide4 OfWidth:1.7f];
    [self giveBorderToView:self.img2ComicSlide4 OfWidth:1.7f];
    [self giveBorderToView:self.img3ComicSlide4 OfWidth:1.7f];
    [self giveBorderToView:self.img4ComicSlide4 OfWidth:1.7f];
    
    return [self saveViewToImage:self.viewHolderSlide4];
}

@end
