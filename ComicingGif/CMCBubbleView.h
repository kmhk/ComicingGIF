//
//  CMCBubbleView.h
//  ComicingGif
//
//  Created by Ahmed Sulaiman on 6/5/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleObject.h"
#import "ComicObjectView.h"

#define BUBBLE_ROOT_VIEW_OFFSET 40

@protocol CMCBubbleViewDelegate <NSObject>
@required
//- (void)bubbleTypeSubiconDidClickWithSenderView:(id)sender
//                                  andBubbleType:(BubbleObjectType)bubbleType;
- (void)bubbleTypeSubiconDidClickWithSelectedBubbleType:(BubbleObjectType)bubbleType
                                         andCurrentText:(NSString *)bubbleText
                                   forCurrentBubbleView:(id)sender
                                            andRootView:(id)comicObjectView;
@end

@protocol CMCBubbleTextViewDelegate <NSObject>
@required
- (void)bubbleTextDidChange:(NSString *)text;
@end

@interface CMCBubbleView : UIView

@property (nonatomic) BubbleObjectType currentBubbleType; // TODO: use bubble type to deternime correct spacing between elements.
@property (nonatomic) BubbleObjectDirection currentBubbleDirection;
@property (nonatomic) id<CMCBubbleViewDelegate> bubbleDelegate;
@property (nonatomic) id<CMCBubbleTextViewDelegate> bubbleTextDelegate;

- (instancetype)initWithFrame:(CGRect)frame
           andBubbleDirection:(BubbleObjectDirection)bubbleDirection;

- (void)setBubbleImage:(UIImage *)bubbleImage;
- (void)setBubbleText:(NSString *)bubbleText;
- (void)showBubbleTypesIcons;
- (void)activateTextField;

- (void)hidePlusIcon;
- (void)hideBubbleSubicons;
- (void)stopShowingBubbleTypesIcons;

@end
