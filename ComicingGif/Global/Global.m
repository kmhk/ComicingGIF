//
//  Global.m
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 27/12/15.
//  Copyright © 2015 ADNAN THATHIYA. All rights reserved.
//

#import "Global.h"

@implementation Global

@synthesize isTakePhoto,deviceType,isBlackBoardOpen,placeholder_comic;

+ (Global *)global
{
    static Global *global = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      global = [[self alloc] init];
                  });
    
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

@end
