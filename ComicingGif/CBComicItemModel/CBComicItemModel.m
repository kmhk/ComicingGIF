//
//  CBComicItemModel.m
//  ComicBook
//
//  Created by Atul Khatri on 04/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBComicItemModel.h"

@implementation CBComicItemModel

//- (instancetype)initWithTimestamp:(NSNumber *)timestamp baseLayer:(ComicSlideLayerType)comicSlideLayerType staticImage:(UIImage *)image animatedImage:(UIImage *)animatedImage orientation:(ComicItemOrientation)orientation {
//    self = [super init];
//    if (self) {
//        _timestamp= timestamp;
//        _staticImage = image;
//        _animatedImage = animatedImage;
//        _comicSlideLayerType = comicSlideLayerType;
//        _itemOrientation= orientation;
//    }
//    return self;
//}

- (instancetype)initWithTimestamp:(NSNumber *)timestamp comicPage:(ComicPage *)comicPage {
    self = [super init];
    if (self) {
        _comicPage = comicPage;
        _isBaseLayerGif = [[comicPage.gifLayerPath lowercaseString] hasSuffix:@".gif"];
        _timestamp= timestamp;
        _itemOrientation = [comicPage.slideType isEqualToString:slideTypeTall]? COMIC_ITEM_ORIENTATION_PORTRAIT: COMIC_ITEM_ORIENTATION_LANDSCAPE;
        _comicSlideBaseLayer = _isBaseLayerGif? Gif: StaticImage;
        
    }
    return self;
}

- (void)replaceWithNewModel:(CBComicItemModel *)newModel {
    _comicPage = newModel.comicPage;
    _isBaseLayerGif = [[newModel.comicPage.gifLayerPath lowercaseString] hasSuffix:@".gif"];
    _itemOrientation = [newModel.comicPage.slideType isEqualToString:slideTypeTall]? COMIC_ITEM_ORIENTATION_PORTRAIT: COMIC_ITEM_ORIENTATION_LANDSCAPE;
    _comicSlideBaseLayer = _isBaseLayerGif? Gif: StaticImage;
}

//- (instancetype)initWithTimestamp:(NSNumber*)timestamp image:(UIImage*)image orientation:(ComicItemOrientation)orientation{
//    self = [super init];
//    if (self) {
//        _timestamp= timestamp;
//        _image= image;
//        _itemOrientation= orientation;
//    }
//    return self;
//}
@end
