//
//  ComicObjectView.m
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicObjectView.h"
#import "ObjectHeader.h"
#import <ImageIO/ImageIO.h>


#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif


@interface ComicObjectView()
{
	UIPanGestureRecognizer *panGesture;
	UIRotationGestureRecognizer *rotateGesture;
	UIPinchGestureRecognizer *pinchGesture;
	
	NSMutableArray *arrayImages;
}
@end


// MARK: -
@implementation ComicObjectView

- (id)initWithComicObject:(BaseObject *)obj {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	self.comicObject = obj;
	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = YES;
	
	if (obj.objType == ObjectBaseImage) {
		[self createBaseImageView];
		
	} else if (obj.objType == ObjectAnimateGIF) {
		[self createAnimationGIFView];
		[self addGestures];
	
	} else if (obj.objType == ObjectSticker) {
		[self createStickerView];
		[self addGestures];
		
	} else if (obj.objType == ObjectBubble) {
		[self createBubbleView];
		[self addGestures];
		
	} else if (obj.objType == ObjectCaption) {
		[self createCaptionView];
		[self addGestures];
		
	} else if (obj.objType == ObjectPen) {
		[self createPenView];
		[self addGestures];
	}
	
	return self;
}

+ (ComicObjectView *)createComicViewWith:(NSArray *)array {
	if (!array || !array.count) {
		NSLog(@"There is nothing comic objects");
		return nil;
	}
	
	// create background GIF from first object of comic object array
	ComicObjectView *backgroundView = [[ComicObjectView alloc] initWithComicObject:array.firstObject];
	
	for (NSInteger i = 1; i < array.count; i ++) {
		BaseObject *obj = array[i];
		ComicObjectView *comicView = [[ComicObjectView alloc] initWithComicObject:obj];
		[backgroundView addSubview:comicView];
	}
	
	return backgroundView;
}


// MARK: - priviate create methods
- (void)createBaseImageView {
	BkImageObject *obj = (BkImageObject *)self.comicObject;
	self.frame = obj.frame;
	
	NSData *data = [NSData dataWithContentsOfURL:obj.fileURL];
	[self createImageViewWith:data frame:self.bounds bAnimate:YES];
}

- (void)createAnimationGIFView {
	StickerObject *obj = (StickerObject *)self.comicObject;
	self.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y, obj.frame.size.width + 44, obj.frame.size.height + 44);
	
	NSData *data = [NSData dataWithContentsOfURL:obj.stickerURL];
	[self createImageViewWith:data frame:CGRectMake(0, 0, obj.frame.size.width, obj.frame.size.height) bAnimate:YES];
}

- (void)createStickerView {
	StickerObject *obj = (StickerObject *)self.comicObject;
	self.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y, obj.frame.size.width + 44, obj.frame.size.height + 44);
	
	UIImage *image = [UIImage imageWithContentsOfFile:[obj.stickerURL absoluteString]];
	NSData *data = UIImagePNGRepresentation(image);
	[self createImageViewWith:data frame:CGRectMake(0, 0, obj.frame.size.width, obj.frame.size.height) bAnimate:NO];
}

- (void)createBubbleView {
	
}

- (void)createCaptionView {
	
}

- (void)createPenView {
	
}


// MARK: - private methods
- (void)addGestures {
	panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
	[self addGestureRecognizer:panGesture];
	
	pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)];
	[self addGestureRecognizer:pinchGesture];
	
	rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGestureHandler:)];
	[self addGestureRecognizer:rotateGesture];
}

- (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size {
	UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (void)createImageViewWith:(NSData *)data frame:(CGRect)rect bAnimate:(BOOL)flag {
	CGImageSourceRef srcImage = CGImageSourceCreateWithData(toCF data, nil);
	if (!srcImage) {
		NSLog(@"loading image failed");
	}
	
	size_t imgCount = CGImageSourceGetCount(srcImage);
	NSTimeInterval totalDuration = 0;
	NSNumber *frameDuration;
	
	arrayImages = [[NSMutableArray alloc] init];
	for (NSInteger i = 0; i < imgCount; i ++) {
		CGImageRef cgImg = CGImageSourceCreateImageAtIndex(srcImage, i, nil);
		if (!cgImg) {
			NSLog(@"loading %ldth image failed from the source", (long)i);
			continue;
		}
		
		UIImage *img = [self scaledImage:[UIImage imageWithCGImage:cgImg] size:rect.size];
		[arrayImages addObject:img];
		
		NSDictionary *property = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(srcImage, i, nil));
		NSDictionary *gifDict = property[fromCF kCGImagePropertyGIFDictionary];
		
		frameDuration = gifDict[fromCF kCGImagePropertyGIFUnclampedDelayTime];
		if (!frameDuration) {
			frameDuration = gifDict[fromCF kCGImagePropertyGIFDelayTime];
		}
		
		totalDuration += frameDuration.floatValue;
		
		CGImageRelease(cgImg);
	}
	
	CFRelease(srcImage);
	
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
	imgView.image = arrayImages.firstObject;
	imgView.autoresizingMask = 0B11111;
	imgView.userInteractionEnabled = YES;
	[self addSubview:imgView];
	
	imgView.animationImages = arrayImages;
	imgView.animationDuration = totalDuration;
	imgView.animationRepeatCount = (flag == YES? 0 : 1);
	[imgView startAnimating];
}


// MARK: - gesture handler implementations
- (void)panGestureHandler:(UIPanGestureRecognizer *)gesture {
	UIGestureRecognizerState state = [gesture state];
	
//	if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
	{
		CGPoint translation = [gesture translationInView:gesture.view];
		gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
		[gesture setTranslation:CGPointZero inView:gesture.view];
	}
}

- (void)pinchGestureHandler:(UIPinchGestureRecognizer *)gesture {
	UIGestureRecognizerState state = [gesture state];
	
//	if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
	{
		gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
		[gesture setScale:1.0];
	}
}

- (void)rotateGestureHandler:(UIRotationGestureRecognizer *)gesture {
	UIGestureRecognizerState state = [gesture state];
	
//	if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
	{
		CGFloat rotation = [gesture rotation];
		[gesture.view setTransform:CGAffineTransformRotate(gesture.view.transform, rotation)];
		[gesture setRotation:0];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
