//
//  RoundCapProgressView.h
//  ComicingGif
//
//  Created by Com on 29/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundCapProgressView : UIView

@property (nonatomic) CGFloat progress;

@property (nonnull) UIColor *filledColor;
@property (nonatomic) CGFloat borderWidth;

@property (nonatomic) UIRectCorner cornerRect;

@end
