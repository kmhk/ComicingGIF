//
//  ComicImage.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 18/08/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Enhancement;

@interface ComicImage : NSObject

//Slide Type
typedef enum ComicImageType : NSUInteger {
    NORMAL,
    WIDE
} ComicImageType;

typedef enum ComicBaseLayerType : NSUInteger {
    GIF,
    STATICIMAGE
} ComicBaseLayerType;

@property(nonatomic,strong) NSString* imageName;
@property (strong, nonatomic) UIImage *image;
@property(nonatomic,assign) ComicImageType comicImageType;
@property (nonatomic, strong) NSString *baseLayerURL;

@property(nonatomic,assign) ComicBaseLayerType comicBaseLayerType;

@property(strong, nonatomic) NSArray <Enhancement *> *enhancements;

@end
