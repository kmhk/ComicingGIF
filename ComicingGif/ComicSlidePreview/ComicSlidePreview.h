//
//  ComicSlidePreview.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 17/07/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComicSlidePreview;

@protocol ComicSlidePreviewDelegate <NSObject>

@optional

- (void)didFrameChange:(ComicSlidePreview*)view withFrame:(CGRect)frame;

@end

@interface ComicSlidePreview : UIViewController

@property (nonatomic, assign) id<ComicSlidePreviewDelegate> delegate;
@property (nonatomic, strong) UIView *viewWhiteBorder;
@property (strong, nonatomic) UIImageView *bookBackground;

-(id)initWithFrame:(CGRect)frame;
- (void)setupComicSlidePreview:(NSArray *)slides;

@end
