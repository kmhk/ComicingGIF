//
//  CMCCaptionView.h
//  ComicingGif
//
//  Created by Ahmed Sulaiman on 6/24/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptionObject.h"

#define CAPTION_INNER_OFFSET 15

@protocol CMCCaptionViewDelegate <NSObject>
@required
- (void)captionTypeSubiconDidClickWithSelectedCaptionType:(CaptionObjectType)type
                                           andCurrentText:(NSString *)text
                                    forCurrentCaptionView:(id)sender
                                              andRootView:(id)comicObjectView;
@end

@protocol CMCCaptionTextViewDelegate <NSObject>
@required
- (void)captionTextDidChange:(NSString *)text;
@end

@interface CMCCaptionView : UIView

@property (nonatomic) CaptionObjectType currentCaptionType;
@property (nonatomic) id<CMCCaptionViewDelegate> captionDelegate;
@property (nonatomic) id<CMCCaptionTextViewDelegate> captionTextDelegate;

- (instancetype)initWithFrame:(CGRect)frame
               andCaptionType:(CaptionObjectType)captionType;

- (void)setCaptionText:(NSString *)text;

- (void)showCaptionTypeIcons;
- (void)activateTextField;
- (void)deactivateTextField;

- (void)hidePlusIcon;
- (void)hideCaptionSubicons;
- (void)stopShowingCaptionTypeIcons;

@end
