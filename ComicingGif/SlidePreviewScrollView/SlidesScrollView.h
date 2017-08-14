//
//  SlidesScrollView.h
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 23/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicPage.h"
#import "ComicSlidePreview.h"
#import "SlidePreviewScrollView.h"

extern const CGFloat comicSlidePreviewWidth5;
extern const CGFloat comicSlidePreviewWidth6;
extern const CGFloat comicSlidePreviewWidth6plus;

enum
{
    AddButtonTypeWide,
    AddButtonTypeLong
};

typedef NSUInteger AddButtonType;

@class SlidesScrollView;

@protocol SlidesScrollViewDelegate <NSObject>

- (void)slidesScrollView:(SlidesScrollView *)scrollview didSelectAtIndexPath:(NSInteger)index withView:(UIView *)view;
- (void)slidesScrollView:(SlidesScrollView *)scrollview didSelectAddButtonAtIndex:(NSInteger)index withView:(UIView *)view withType:(AddButtonType)type;
- (void)slidesScrollView:(SlidesScrollView *)scrollview didSelectAddButtonAtIndex:(NSInteger)index withView:(UIView *)view pusWithAnimation:(BOOL)isPushAnimation;
- (void)slidesScrollView:(SlidesScrollView *)scrollview didRemovedAtIndexPath:(NSInteger)index;
- (void)returnAddedView:(UIView *)view;
- (void)saveSlideTitle:(NSString*)strValue slideIndex:(NSInteger)slideIndex;

@end

@interface SlidesScrollView : UIScrollView<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIView *slideView;
@property NSUInteger maximumComicCount;
@property NSInteger setAddButtonIndex;
@property BOOL isStillSaving;
@property (strong, nonatomic) UIScrollView *previewScrollView;
@property (nonatomic, strong) SlidePreviewScrollView *viewPreviewScrollSlide;
@property (nonatomic, strong) ComicSlidePreview *viewPreviewSlide;
@property (nonatomic, strong) UIButton *btnPlusSlide;
@property (nonatomic, strong) UIButton *btnWidePlusSlide;

@property (strong, nonatomic) NSMutableArray *listViewImages;
@property (strong, nonatomic) NSMutableArray *allSlidesView;
@property (strong, nonatomic) NSMutableArray *timelineTimeArray;
@property (strong, nonatomic) NSMutableArray *timelineBubbleArray;
@property (strong, nonatomic) NSMutableArray *slideTitleArray;
@property (nonatomic, strong) UIView *timelineView;

- (void)addViewAtIndex:(NSInteger)index withComicSlide:(ComicPage *)comicSlide;
- (void)reloadComicAtIndex:(NSInteger)index withComicSlide:(ComicPage *)comicSlide;
//- (void)reloadComicImageAtIndex:(NSInteger)index withComicSlide:(UIImage *)printScreen;
- (void)reloadComicImageAtIndex:(NSInteger)index withComicSlide:(UIImage *)printScreen withComicSlide:(NSMutableArray *)comicSlide;
//- (void)addSlideButtonAtIndex:(NSInteger)index;
- (void)btnAddSlideTap:(UIButton *)sender;
- (void)addPlusButton :(NSInteger)index;
- (void)pushAddSlideTap:(UIButton *)sender animation:(BOOL)isPushWithAnimation;
- (void)addTimeLineView;
- (void)setAddButtonFrame:(UIButton *)sender ButtonIndex:(int)btnIndex;
- (void)setScrollViewContectSizeByLastIndex:(NSInteger)index;
- (void)refreshPreview:(NSInteger)index withImages:(NSArray *)slides;
-(UIImage*)getImageFile:(NSString*)fileName;
- (void)addArrowImage:(NSInteger)index;

@property (nonatomic, weak) id<SlidesScrollViewDelegate> slidesScrollViewDelegate;


@end
