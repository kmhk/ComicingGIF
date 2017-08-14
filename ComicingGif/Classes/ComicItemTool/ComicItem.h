//
//  ComicItemTools.h
//  ComicMakingPage
//
//  Created by Ramesh on 25/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BubbleViewItem.h"


#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppConstants.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "YYAnimatedImageView.h"
#import "UIImageView+AnimatedGif.h"
#import "YLImageView.h"
#import "UIImage+GIF.h"

typedef enum {
    ComicSticker,
    ComicExclamation,
    ComicBubble,
    ComicCaption,
    ComicAnimatedSticker,
    ComicAnimatedComponent
} ComicItemType;

@protocol ComicItem <NSObject>


-(id)addItemWithImage:(id)sticker;

@end


#pragma mark - ComicItemSticker

@interface ComicItemSticker : UIImageView<ComicItem> {}

@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) CGFloat scaleValueX;
@property (assign, nonatomic) CGFloat scaleValueY;
@property (assign, nonatomic) CGFloat tX;
@property (assign, nonatomic) CGFloat tY;
@end

#pragma mark - ComicItem Animated Sticker

@interface ComicItemAnimatedSticker : UIImageView<ComicItem> {}
//@interface ComicItemAnimatedSticker : YYAnimatedImageView<ComicItem> {}

//@property (strong, nonatomic) NSString* animatedStickerName;
//@property (assign, nonatomic) CGFloat startDelay;
//@property (assign, nonatomic) CGFloat endDelay;
//@property (assign, nonatomic) CGFloat angle;
//@property (assign, nonatomic) CGFloat scaleValueX;
//@property (assign, nonatomic) CGFloat scaleValueY;
//@property (assign, nonatomic) CGFloat tX;
//@property (assign, nonatomic) CGFloat tY;
@property (assign, nonatomic) CGRect objFrame;
//@property (assign, nonatomic) CGRect frameOfInstruction;
//@property (assign, nonatomic) CGRect imageOfInstruction;
@property (strong, nonatomic) NSString* combineAnimationFileName;
@property (strong, nonatomic) NSString* bubbleString;
@property (strong, nonatomic) NSMutableArray* animatedComponentArray;
@end

#pragma mark - ComicItem Animated Sticker

@interface ComicItemAnimatedComponent : YYAnimatedImageView<ComicItem> {}

@property (strong, nonatomic) NSString* animatedStickerName;
@property (assign, nonatomic) CGFloat startDelay;
@property (assign, nonatomic) CGFloat endDelay;
@property (assign, nonatomic) CGRect objFrame;

@end

#pragma mark - ComicItemExclamation

@interface ComicItemExclamation : UIImageView<ComicItem> {}

@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) CGFloat scaleValueX;
@property (assign, nonatomic) CGFloat scaleValueY;
@property (assign, nonatomic) CGFloat tX;
@property (assign, nonatomic) CGFloat tY;

@end

#pragma mark - ComicItemBubble

@interface ComicItemBubble : UIView<ComicItem> {
        AVAudioRecorder *recorder;
        AVAudioSession *audioSession;
        NSURL *temporaryRecFile;
}
@property (strong, nonatomic) NSString* bubbleString;
@property (nonatomic, strong) NSString *recorderFilePath;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic , strong) UIButton *audioImageButton;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UITextView* txtBuble;
@property (nonatomic,strong)UIButton* imagebtn;

@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) CGFloat scaleValueX;
@property (assign, nonatomic) CGFloat scaleValueY;
@property (assign, nonatomic) CGFloat tX;
@property (assign, nonatomic) CGFloat tY;

-(void)recordAction;
-(BOOL)isPlayVoice;
-(void)playAction;
- (void)stopRecording;
-(float)playDuration;
-(void)pauseAction;

@end

#pragma mark - ComicCaption

@interface ComicItemCaption : UIView<ComicItem> {
    
}

@property (strong,nonatomic)UIImageView* bgImageView;
@property(strong,nonatomic) UITextView* txtCaption;
@property(strong,nonatomic) UIButton* plusButton;
@property (strong,nonatomic) UIView* dotHolder;
@property (strong,nonatomic) NSString* tintColourString;

@end

