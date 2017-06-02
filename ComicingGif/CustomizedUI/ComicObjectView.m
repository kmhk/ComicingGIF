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
	}
	
	self.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.comicObject.scale, self.comicObject.scale);
	self.transform = CGAffineTransformRotate(self.transform, self.comicObject.angle);
	
	return self;
}

+ (ComicObjectView *)createComicViewWith:(NSArray *)array delegate:(id)userInfo {
	if (!array || !array.count) {
		NSLog(@"There is nothing comic objects");
		return nil;
	}
	
	// create background GIF from first object of comic object array
	ComicObjectView *backgroundView = [[ComicObjectView alloc] initWithComicObject:array.firstObject];
    
    NSMutableArray<ComicObjectView *> *penObjectsViewArray = [NSMutableArray new];
    
	for (NSInteger i = 1; i < array.count; i ++) {
		BaseObject *obj = array[i];
		ComicObjectView *comicView = [[ComicObjectView alloc] initWithComicObject:obj];
		comicView.parentView = backgroundView;
		comicView.delegate = userInfo;
        
        // For performance reasons it will be better to combine all drawings into single image view and add only this image view to the background
        if (obj.objType == ObjectPen) {
            [penObjectsViewArray addObject:comicView];
            // We don't need to add each drawing as a subview right away.
            continue;
        }
        
		[backgroundView addSubview:comicView];
	}
    
    // Generate single image view with all drawings. Nil – if there is no drawings in current comics item
    UIImageView *allDrawingsImageView = [self createSingleImageViewFromDrawingsArray:penObjectsViewArray];
    if (allDrawingsImageView) {
        // The drawings should be under any other enhensment (like Stickers)
        // If there is any subview available – insert drawing at first index.
        // If there are no subviews – just add drawing in a regular way
        if (backgroundView.subviews.count > 0) {
            [backgroundView insertSubview:allDrawingsImageView atIndex:0];
        } else {
            [backgroundView addSubview:allDrawingsImageView];
        }
    }
	
	return backgroundView;
}

- (void)playAnimate {
	UIView *view = [self viewWithTag:0x1000];
	if (view) {
		UIImageView *imgView = (UIImageView *)view;
		[imgView startAnimating];
	}
}


// MARK: - priviate create methods
- (void)createBaseImageView {
	BkImageObject *obj = (BkImageObject *)self.comicObject;
	self.frame = obj.frame;
	
    NSString *fileName1 = [NSString stringWithFormat:@"%@",[obj.fileURL lastPathComponent]];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName1]];
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    [self createImageViewWith:data frame:self.bounds bAnimate:YES];
}

- (void)createAnimationGIFView {
	StickerObject *obj = (StickerObject *)self.comicObject;
	self.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y, obj.frame.size.width, obj.frame.size.height);
	
	NSData *data = [NSData dataWithContentsOfURL:obj.stickerURL];
	/*
	 real inside content view's size is less (40, 40) than object view. because it needs to show tool bar of all comic objects
	 */
	[self createImageViewWith:data frame:CGRectMake(0, 0, obj.frame.size.width - W_PADDING, obj.frame.size.height - H_PADDING) bAnimate:YES];
}

- (void)createStickerView {
	StickerObject *obj = (StickerObject *)self.comicObject;
	self.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y, obj.frame.size.width, obj.frame.size.height);
	
	NSData *data = [NSData dataWithContentsOfURL:obj.stickerURL];
	/*
	 real inside content view's size is less (40, 40) than object view. because it needs to show tool bar of all comic objects
	 */
	[self createImageViewWith:data frame:CGRectMake(0, 0, obj.frame.size.width - W_PADDING, obj.frame.size.height - H_PADDING) bAnimate:NO];
}

- (void)createBubbleView {
	
}

- (void)createCaptionView {
	
}

- (void)createPenView {
	PenObject *penObject = (PenObject *) self.comicObject;
    self.frame = CGRectMake(penObject.frame.origin.x,
                            penObject.frame.origin.y,
                            penObject.frame.size.width,
                            penObject.frame.size.height);
    UIColor *color = penObject.color;
    CGFloat brushSize = penObject.brushSize;
    NSArray<NSValue *> *coordinates = penObject.coordinates;
    [self createDrawingWithCoordinates:coordinates
                                 color:color
                          andBrushSize:brushSize];
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

+ (UIImageView *)createSingleImageViewFromDrawingsArray:(inout NSMutableArray<ComicObjectView *> *)penObjectsViewArray {
    
    if (!penObjectsViewArray || penObjectsViewArray.count == 0) {
        return nil;
    }
    
    ComicObjectView *firstComicObjectView = penObjectsViewArray.firstObject;
    
    UIImageView *finalDrawingImageView = [[UIImageView alloc] initWithFrame:firstComicObjectView.frame];
    
    UIGraphicsBeginImageContext(finalDrawingImageView.frame.size);
    [finalDrawingImageView.image drawInRect:CGRectMake(0, 0,
                                                       finalDrawingImageView.frame.size.width,
                                                       finalDrawingImageView.frame.size.height)
                                  blendMode:kCGBlendModeNormal
                                      alpha:1.0];
    for (ComicObjectView *drawingComicObjectView in penObjectsViewArray) {
        if (!drawingComicObjectView ||
            drawingComicObjectView.subviews.count != 1 ||
            ![drawingComicObjectView.subviews.firstObject isMemberOfClass:[UIImageView class]]) {
            continue;
        }
        UIImageView *drawingImageView = (UIImageView *) drawingComicObjectView.subviews.firstObject;
        
        [drawingImageView.image drawInRect:CGRectMake(0, 0,
                                                      drawingImageView.frame.size.width,
                                                      drawingImageView.frame.size.height)
                                 blendMode:kCGBlendModeNormal
                                     alpha:1.0];
        [drawingImageView removeFromSuperview];
    }
    finalDrawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [penObjectsViewArray removeAllObjects];
    
    return finalDrawingImageView;
}

- (void)createDrawingWithCoordinates:(NSArray<NSValue *> *)coordinates
                               color:(UIColor *)color
                        andBrushSize:(CGFloat)brushSize {
    UIImageView *drawingImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:drawingImageView];
    
    if (coordinates.count < 2) {
        // There Should be at least 2 points in a single drawing object
        return;
    }
    
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    CGPoint lastPoint = [coordinates.firstObject CGPointValue];
    
    for (int i = 1; i < coordinates.count; i++) {
        CGPoint currentPoint = [coordinates[i] CGPointValue];
        
        UIGraphicsBeginImageContext(drawingImageView.frame.size);
        [drawingImageView.image drawInRect:CGRectMake(0, 0, drawingImageView.frame.size.width, drawingImageView.frame.size.height)];
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brushSize);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [drawingImageView setAlpha:1.0];
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
    
    UIGraphicsBeginImageContext(drawingImageView.frame.size);
    
    [drawingImageView.image drawInRect:CGRectMake(0, 0, drawingImageView.frame.size.width, drawingImageView.frame.size.height)
                             blendMode:kCGBlendModeNormal
                                 alpha:1.0];
    drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
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
	imgView.tag = 0x1000;
	[self addSubview:imgView];
	
	imgView.animationImages = arrayImages;
	imgView.animationDuration = totalDuration;
	imgView.animationRepeatCount = 1;//(flag == YES? 0 : 1);
	[imgView startAnimating];
}


// MARK: - gesture handler implementations
- (void)panGestureHandler:(UIPanGestureRecognizer *)gesture {
	UIGestureRecognizerState state = [gesture state];
    CGPoint point = [gesture locationInView:self.parentView];
	
	if (CGRectContainsRect(self.parentView.bounds, CGRectMake(point.x - 10, point.y - 10, 20, 20)) == true) {
        CGPoint translation = [gesture translationInView:gesture.view];
        gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
        [gesture setTranslation:CGPointZero inView:gesture.view];
        self.comicObject.frame = self.frame;
		
		[self.delegate saveObject];
		
	} else {
		if (state == UIGestureRecognizerStateEnded) {
			NSLog(@"removing object");
			[self.delegate removeObject:self];
		}
	}
}

- (void)pinchGestureHandler:(UIPinchGestureRecognizer *)gesture {
//	UIGestureRecognizerState state = [gesture state];
	
//	if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
	{
		gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
		[gesture setScale:1.0];
		
//		NSLog(@"pinched: %f, %f", gesture.view.transform.a, gesture.view.transform.d);
		self.comicObject.scale = gesture.view.transform.a;
		
		[self.delegate saveObject];
	}
}

- (void)rotateGestureHandler:(UIRotationGestureRecognizer *)gesture {
//	UIGestureRecognizerState state = [gesture state];
	
//	if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
	{
		CGFloat rotation = [gesture rotation];
		[gesture.view setTransform:CGAffineTransformRotate(gesture.view.transform, rotation)];
		[gesture setRotation:0];
		
		self.comicObject.angle = atan2f(gesture.view.transform.b, gesture.view.transform.a);
		
		[self.delegate saveObject];
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
