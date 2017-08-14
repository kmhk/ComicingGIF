//
//  CustomView.m
//  KCTest
//
//  Created by Vishnu Vardhan PV on 28/12/15.
//  Copyright © 2015 Vishnu Vardhan PV. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (id)initWithAudioUrl:(NSString *)url {
    self.backgroundColor = [UIColor clearColor];
    self.audioUrl = [NSURL URLWithString:url];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
    //        [self configureAudioPlayer];
    //    });
//    [self configureAudioPlayer];
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
//    [self.backgroundMusicPlayer play];
    if(self.playAudio) {
        self.playAudio ();
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Triggered when touch is released
    //    if (self.isTouchDown) {
    NSLog(@"touches ended");
    //        self.touchDown = NO;
    //    }
//    [self.backgroundMusicPlayer pause];
    if(self.pauseAudio) {
        self.pauseAudio ();
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Triggered if touch leaves view
    //    if (self.isTouchDown) {
    NSLog(@"touches cancelled");
    //        self.touchDown = NO;
    //    }
//    [self.backgroundMusicPlayer pause];
    if(self.pauseAudio) {
        self.pauseAudio ();
    }
}

- (void)configureAudioPlayer {
    // Create audio player with background music
    //    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf"];
    //    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    //    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    //    [self.backgroundMusicPlayer play];
    
    
    /////
    //    NSURL *url = [NSURL URLWithString:@"http://68.169.44.163/sounds/comics/slides/56dbc70542dba"];
    [self handleDataDownloadFromUrl:self.audioUrl withCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        __strong __typeof(self)strongSelf = self;
        if(connectionError == nil) {
            NSData *downloadedAudioData = data;
            if (!downloadedAudioData) {
                NSLog(@"not downloaded");
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error;
                    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithData:downloadedAudioData error:&error];
                    [self.backgroundMusicPlayer setDelegate:self];
                    self.backgroundMusicPlayer.numberOfLoops = 0;
                    //                    [self.backgroundMusicPlayer play];
                    
                });
            }
        }
    }];
    
}

- (void)handleDataDownloadFromUrl:(NSURL *)url
            withCompletionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               handler(response, data, connectionError);
                           }];
}

@end
