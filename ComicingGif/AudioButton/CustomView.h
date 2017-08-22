//
//  CustomView.h
//  KCTest
//
//  Created by Vishnu Vardhan PV on 28/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^ PlayAudio) (void);
typedef void (^ PauseAudio) (void);

@interface CustomView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (strong, nonatomic) NSURL *audioUrl;
@property (strong, nonatomic) PlayAudio playAudio;
@property (strong, nonatomic) PauseAudio pauseAudio;

- (id)initWithAudioUrl:(NSString *)url;

@end
