//
//  Global.h
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 27/12/15.
//  Copyright © 2015 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppConstants.h"

@class CBComicItemModel;

#define GlobalObject [Global global]

typedef NS_ENUM(NSInteger, ScreenSizeType)
{
    ScreenSizeTypeUnknown  = 0,
    ScreenSizeTypeIPhone4  = 1,
    ScreenSizeTypeIPhone5  = 2,
    ScreenSizeTypeIPhone6  = 3,
    ScreenSizeTypeIPhone6p = 4
};

typedef enum {
    Top,
    Left,
    Bottom,
    Right
} Direction;

@interface Global : NSObject
    
    @property (nonatomic) BOOL isTakePhoto;
    @property (nonatomic) BOOL isBlackBoardOpen;
    
+ (Global *)global;
+ (UIColor *)getColorForComicBookColorCode:(ComicBookColorCode)comicBookColorCode;
+ (UIImage *)getImageForColorCode:(ComicBookColorCode)comicBookColorCode andDirection:(Direction)direction;
    
    @property ScreenSizeType deviceType;
    @property (strong, nonatomic) NSMutableArray *slides;
    
    @property (strong, nonatomic) UIImage *placeholder_comic;
    @property (nonatomic) BOOL isUserEnterSecondTime;
    
- (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size;
- (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size withInterpolationQuality:(CGInterpolationQuality)interpolation;
    
+ (double)positive:(double)number;
+ (CGSize)getSizeOfComicSlideWithModel:(CBComicItemModel *)model;
+ (CGSize)getTallBigSlideSize;
+ (CGSize)getTallSmallSlideSize;
+ (CGSize)getWideSlideSize;
+ (NSInteger)getWidthOfSlideAsPerUIImplemented;
    
    @end
