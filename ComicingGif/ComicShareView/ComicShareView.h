//
//  ComicShareView.h
//  ComicApp
//
//  Created by Ramesh on 18/01/16.
//  Copyright © 2016 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+resize.h"

@interface ComicShareView : UIView

#pragma mark Slide 4
@property (strong, nonatomic) IBOutlet UIImageView *img1ComicSlide4;
@property (strong, nonatomic) IBOutlet UIImageView *img2ComicSlide4;
@property (strong, nonatomic) IBOutlet UIImageView *img3ComicSlide4;
@property (strong, nonatomic) IBOutlet UIImageView *img4ComicSlide4;
@property (weak, nonatomic) IBOutlet UIImageView *imgComicLogo4;


#pragma mark Slide 3
@property (strong, nonatomic) IBOutlet UIImageView *img1ComicSlide3;
@property (strong, nonatomic) IBOutlet UIImageView *img2ComicSlide3;
@property (strong, nonatomic) IBOutlet UIImageView *img3ComicSlide3;

#pragma mark Slide 2
@property (strong, nonatomic) IBOutlet UIImageView *img1ComicSlide2;
@property (strong, nonatomic) IBOutlet UIImageView *img2ComicSlide2;

#pragma mark Slide 1
@property (strong, nonatomic) IBOutlet UIImageView *img1ComicSlide1;


@property (strong, nonatomic) IBOutlet UIView *viewHolderSlide1;
@property (strong, nonatomic) IBOutlet UIView *viewHolderSlide2;
@property (strong, nonatomic) IBOutlet UIView *viewHolderSlide3;
@property (strong, nonatomic) IBOutlet UIView *viewHolderSlide4;

@property (strong, nonatomic) UIImage *comicShareImage;


-(id)initWithShareImagesArray:(NSArray*)shareImageArray;
-(UIImage*)getComicShareImage:(NSArray*)shareImageArray;
@end
