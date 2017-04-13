//
//  UIImage+Alpha.h
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 14/03/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;
@end
