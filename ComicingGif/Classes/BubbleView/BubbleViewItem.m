//
//  BubbleViewItem.m
//  ComicMakingPage
//
//  Created by Ramesh on 03/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "BubbleViewItem.h"

@implementation BubbleViewItem

@synthesize recorderFilePath,player;

#pragma mark AudioAction

-(BOOL)isPlayVoice{
    if (recorderFilePath)
        return YES;
    else
        return NO;
}

- (void)recordAction{
    if (audioSession == nil) {
        audioSession =[AVAudioSession sharedInstance];
    }
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    else{
        
            if ([self startRecording].length != 0)
            {
                NSError *err = nil;
                if(err){
                    return;
                }
                temporaryRecFile = [NSURL fileURLWithPath:[self startRecording]];
                NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
                
                [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
                [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
                [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
                
                [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
                [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
                [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
                
                err = nil;
                recorder = [[ AVAudioRecorder alloc] initWithURL:temporaryRecFile settings:recordSetting error:&err];
                if(!recorder){
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle: @"Warning"
                                               message: [err localizedDescription]
                                              delegate: nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                //prepare to record
                [recorder setDelegate:self];
                [recorder prepareToRecord];
                recorder.meteringEnabled = YES;
                
                // start recording
//                [recorder recordForDuration:(NSTimeInterval) 10];
                [recorder record];
            }
            else
            {
                NSLog(@"not recording");
                [recorder stop];
            }
    }
}

- (void)pauseAction{
    [recorder pause];
}

-(float)playDuration{
    if(!recorderFilePath)
        return 0.0;
    
    NSError* error;
    NSURL *filePath = [NSURL fileURLWithPath:recorderFilePath isDirectory:NO];
    
    player =[[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:&error];
    [player setDelegate:self];
    [player prepareToPlay];
    
    long seconds = lroundf(player.duration); // Since modulo operator (%) below needs int or long
    float secs = seconds % 60;
    return secs;
}

- (void)playAction {
    if(!recorderFilePath)
        recorderFilePath = [NSString stringWithFormat:@"%@.caf", DOCUMENTS_FOLDER] ;
    
    if (!player) {
        NSError* error;
        NSURL *filePath = [NSURL fileURLWithPath:recorderFilePath isDirectory:NO];
        player =[[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:&error];
        [player setDelegate:self];
        [player prepareToPlay];
    }
    [player play];
    
}
- (NSString *)startRecording{
    
    if (audioSession == nil) {
        audioSession = [AVAudioSession sharedInstance];
    }
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        return @"";
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        return @"";
    }
    // Create a new dated file
    // we need to add extra identifier for each sound
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    recorderFilePath = [NSString stringWithFormat:@"%@_%@.caf",DOCUMENTS_FOLDER,timestamp] ;
    return recorderFilePath;
}

- (void)stopRecording{
    if (player) {
        [player pause];
    }
    [recorder stop];
    
//    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
//    NSError *err = nil;
//    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
//    if(!audioData)
//        return;
//    
//    NSFileManager *fm = [NSFileManager defaultManager];
//    
//    err = nil;
////    [fm removeItemAtPath:[url path] error:&err];
//    if(err)
//        return;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
}
- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"ERROR IN DECODE: %@\n", error);
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error
{
    NSLog(@"ERROR IN DECODE: %@\n", error);
}
@end
