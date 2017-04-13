//
//  CBComicItemModel.h
//  ComicBook
//
//  Created by Atul Khatri on 04/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ComicPage.h"
#import "AppConstants.h"

typedef enum {
    COMIC_ITEM_ORIENTATION_PORTRAIT,
    COMIC_ITEM_ORIENTATION_LANDSCAPE
}ComicItemOrientation;

typedef enum {
    COMIC_IMAGE_ORIENTATION_UNKNOWN = 101,
    COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF,
    COMIC_IMAGE_ORIENTATION_PORTRAIT_FULL,
    COMIC_IMAGE_ORIENTATION_LANDSCAPE
}ComicImageOrientation;

@interface CBComicItemModel : NSObject
//- (instancetype)initWithTimestamp:(NSNumber*)timestamp baseLayer:(ComicSlideLayerType)comicSlideLayerType staticImage:(UIImage*)image animatedImage:(UIImage*)animatedImage orientation:(ComicItemOrientation)orientation;
- (instancetype)initWithTimestamp:(NSNumber*)timestamp comicPage:(ComicPage *)comicPage;

@property (nonatomic, strong) NSNumber* timestamp;
@property (nonatomic, strong) UIImage* baseLayerImage;
@property (nonatomic, strong) UIImage* baseLayerGif;
@property (nonatomic, assign) ComicSlideBaseLayer comicSlideBaseLayer;
@property (nonatomic, assign) ComicItemOrientation itemOrientation;
@property (nonatomic, assign) ComicImageOrientation imageOrientation;
@property (nonatomic, assign) BOOL isBaseLayerGif;

@property(nonatomic, strong) ComicPage *comicPage;

- (void)replaceWithNewModel:(CBComicItemModel *)newModel;

@end
