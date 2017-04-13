//
//  BubbleViewItem.h
//  ComicMakingPage
//
//  Created by Ramesh on 03/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppConstants.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface BubbleViewItem : UIView<AVAudioRecorderDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate>
{
    AVAudioRecorder *recorder;
    AVAudioSession *audioSession;
//    BOOL isNotRecording;
    NSURL *temporaryRecFile;
//    AVAudioPlayer *player;
}


@property (nonatomic, strong) NSString *recorderFilePath;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic , strong) UIButton *audioImageButton;
@property(nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UITextView* txtBuble;
@property (nonatomic,strong)UIButton* imagebtn;
-(void)recordAction;
-(BOOL)isPlayVoice;
-(void)playAction;
- (void)stopRecording;
-(float)playDuration;
-(void)pauseAction;
@end
