//
//  RoundCapProgressView.m
//  ComicingGif
//
//  Created by Com on 29/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "RoundCapProgressView.h"

@interface RoundCapProgressView ()
{
	UIView *progressView;
}

@end


@implementation RoundCapProgressView

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.progress = 0.0;
		self.borderWidth = 0.0;
		self.filledColor = [UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
		
		self.cornerRect = UIRectCornerTopRight | UIRectCornerBottomRight;
		
		progressView = [[UIView alloc] initWithFrame:CGRectZero];
		progressView.backgroundColor = self.filledColor;
		[self addSubview:progressView];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.progress = 0.0;
		self.borderWidth = 0.0;
		self.filledColor = [UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
		
		self.cornerRect = UIRectCornerTopRight | UIRectCornerBottomRight;
		
		progressView = [[UIView alloc] initWithFrame:CGRectZero];
		progressView.backgroundColor = self.filledColor;
		[self addSubview:progressView];
	}
	
	return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGFloat w = rect.size.width * _progress;
	CGRect rtProgress = CGRectMake(_borderWidth, _borderWidth,  w-_borderWidth*2, rect.size.height-_borderWidth*2);
	
	[self.filledColor setFill];
	
	[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] setStroke];
	
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: rtProgress
											   byRoundingCorners: _cornerRect
													 cornerRadii: CGSizeMake(rect.size.height / 2, rect.size.height / 2)];
	path.lineWidth = _borderWidth;
	[path stroke];
	[path fill];
}


- (void)setProgress:(CGFloat)progress {
	if (progress > 1) {
		progress = 1.0;
	} else if (progress < 0.0) {
		progress = 0.0;
	}
	
	_progress = progress;
	
	[self setNeedsDisplay];
	
//	CGFloat w = self.frame.size.width * progress;
//	progressView.frame = CGRectMake(0, 0,  w, self.frame.size.height);
//	
//	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: progressView.bounds
//											   byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight
//													 cornerRadii: CGSizeMake(self.frame.size.height / 2, self.frame.size.height / 2)];
//	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//	maskLayer.path = path.CGPath;
//	progressView.layer.mask = maskLayer;
}

@end
