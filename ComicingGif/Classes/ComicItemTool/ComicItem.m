//
//  ComicItemTools.m
//  ComicMakingPage
//
//  Created by Ramesh on 25/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "ComicItem.h"
#import "AppConstants.h"
#import "AppHelper.h"

#pragma mark - ComicItemSticker

@implementation ComicItemSticker

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.frame = frame;
    }
    return self;
}

-(id)addItemWithImage:(id)sticker{
    
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.image = sticker;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self)
    {
        self.image = [UIImage imageWithData:[decoder decodeObjectForKey:@"stickerimage"]];
        self.frame = CGRectFromString([decoder decodeObjectForKey:@"stickerFrame"]);
        self.bounds = CGRectFromString([decoder decodeObjectForKey:@"stickerBounds"]);
        self.angle = [[decoder decodeObjectForKey:@"stickerAngle"] floatValue];
        self.scaleValueX = [[decoder decodeObjectForKey:@"stickerScaleX"] floatValue];
        self.scaleValueY = [[decoder decodeObjectForKey:@"stickerScaleY"] floatValue];
        self.tX = [[decoder decodeObjectForKey:@"stickerTX"] floatValue];
        self.tY = [[decoder decodeObjectForKey:@"stickerTY"] floatValue];
        
    }
    
    return [self initWithFrame:[self frame]];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"stickerimage"];
    [aCoder encodeObject:NSStringFromCGRect(self.frame) forKey:@"stickerFrame"];
    [aCoder encodeObject:NSStringFromCGRect(self.bounds) forKey:@"stickerBounds"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self rotation]] forKey:@"stickerAngle"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self xscale]] forKey:@"stickerScaleX"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self yscale]] forKey:@"stickerScaleY"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self tx]] forKey:@"stickerTX"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self ty]] forKey:@"stickerTY"];
}

- (CGFloat) xscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat) yscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (CGFloat) rotation
{
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}

- (CGFloat) tx
{
    CGAffineTransform t = self.transform;
    return t.tx;
}

- (CGFloat) ty
{
    CGAffineTransform t = self.transform;
    return t.ty;
}

@end


#pragma mark - ComicItemExclamation

@implementation ComicItemExclamation

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.frame = frame;
    }
    return self;
}

-(id)addItemWithImage:(id)sticker{
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.image = sticker;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self)
    {
        self.image = [UIImage imageWithData:[decoder decodeObjectForKey:@"exclamationimage"]];
        self.frame = CGRectFromString([decoder decodeObjectForKey:@"exclamationFrame"]);
        self.bounds = CGRectFromString([decoder decodeObjectForKey:@"exclamationBounds"]);
        self.angle = [[decoder decodeObjectForKey:@"exclamationAngle"] floatValue];
        self.scaleValueX = [[decoder decodeObjectForKey:@"exclamationScaleX"] floatValue];
        self.scaleValueY = [[decoder decodeObjectForKey:@"exclamationScaleY"] floatValue];
        self.tX = [[decoder decodeObjectForKey:@"exclamationTX"] floatValue];
        self.tY = [[decoder decodeObjectForKey:@"exclamationTY"] floatValue];
    }
    
    return [self initWithFrame:[self frame]];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"exclamationimage"];
    [aCoder encodeObject:NSStringFromCGRect(self.frame) forKey:@"exclamationFrame"];
    [aCoder encodeObject:NSStringFromCGRect(self.bounds) forKey:@"exclamationBounds"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self rotation]] forKey:@"exclamationAngle"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self xscale]] forKey:@"exclamationScaleX"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self yscale]] forKey:@"exclamationScaleY"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.transform.tx] forKey:@"exclamationTX"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.transform.ty] forKey:@"exclamationTY"];
}

- (CGFloat) xscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat) yscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (CGFloat) rotation
{
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}

- (CGFloat) tx
{
    CGAffineTransform t = self.transform;
    return t.tx;
}

- (CGFloat) ty
{
    CGAffineTransform t = self.transform;
    return t.ty;
}

@end

#pragma mark - ComicItemAnimatedSticker

@implementation ComicItemAnimatedSticker

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.frame = frame;
    }
    return self;
}

-(id)addItemWithImage:(id)sticker{
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.image = sticker;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if (self)
    {
        self.image = [UIImage imageWithData:[decoder decodeObjectForKey:@"animatedStickerimage"]];
        self.frame = CGRectFromString([decoder decodeObjectForKey:@"animatedStickerObjFrame"]);
        self.bounds = CGRectFromString([decoder decodeObjectForKey:@"animatedStickerBounds"]);
        self.objFrame = CGRectFromString([decoder decodeObjectForKey:@"animatedStickerObjFrame"]);
        self.combineAnimationFileName = [decoder decodeObjectForKey:@"combineAnimationFileName"];
        
//        self.angle = [[decoder decodeObjectForKey:@"animatedStickerAngle"] floatValue];
//        self.scaleValueX = [[decoder decodeObjectForKey:@"animatedStickerScaleX"] floatValue];
//        self.scaleValueY = [[decoder decodeObjectForKey:@"animatedStickerScaleY"] floatValue];
//        self.tX = [[decoder decodeObjectForKey:@"animatedStickerTX"] floatValue];
//        self.tY = [[decoder decodeObjectForKey:@"animatedStickerTY"] floatValue];
//        self.animatedStickerName  = [decoder decodeObjectForKey:@"animatedStickerName"];
//        self.startDelay = [[decoder decodeObjectForKey:@"startDelay"] floatValue];
//        self.endDelay = [[decoder decodeObjectForKey:@"endDelay"] floatValue];
    }
    for (ComicItemAnimatedComponent* objComp in [self subviews]) {
        [objComp removeFromSuperview];
    }
    
    return [self initWithFrame:[self frame]];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
//    self.objFrame = self.frame;
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:NSStringFromCGRect(self.frame) forKey:@"animatedStickerFrame"];
    [aCoder encodeObject:NSStringFromCGRect(self.bounds) forKey:@"animatedStickerBounds"];
    [aCoder encodeObject:NSStringFromCGRect(self.objFrame) forKey:@"animatedStickerObjFrame"];
    [aCoder encodeObject:self.combineAnimationFileName forKey:@"combineAnimationFileName"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"animatedStickerimage"];
    
//    [aCoder encodeObject:self.animatedStickerName forKey:@"animatedStickerName"];
//    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self rotation]] forKey:@"animatedStickerAngle"];
//    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.startDelay] forKey:@"startDelay"];
//    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.endDelay] forKey:@"startDelay"];
//    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self xscale]] forKey:@"animatedStickerScaleX"];
//    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self yscale]] forKey:@"animatedStickerScaleY"];
//    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.transform.tx] forKey:@"animatedStickerTX"];
//    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.transform.ty] forKey:@"animatedStickerTY"];
//    [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"animatedStickerimage"];
}

- (CGFloat) xscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat) yscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (CGFloat) rotation
{
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}

- (CGFloat) tx
{
    CGAffineTransform t = self.transform;
    return t.tx;
}

- (CGFloat) ty
{
    CGAffineTransform t = self.transform;
    return t.ty;
}

@end

#pragma mark - ComicItemAnimatedComponent

@implementation ComicItemAnimatedComponent

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.frame = frame;
    }
    return self;
}

-(id)addItemWithImage:(id)sticker{
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.image = sticker;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if (self)
    {
        self.image = [UIImage imageWithData:[decoder decodeObjectForKey:@"animatedStickerimage"]];
        self.frame = CGRectFromString([decoder decodeObjectForKey:@"animatedStickerObjFrame"]);
        self.bounds = CGRectFromString([decoder decodeObjectForKey:@"animatedStickerBounds"]);
        self.objFrame = CGRectFromString([decoder decodeObjectForKey:@"animatedStickerObjFrame"]);
        
        
        //        self.angle = [[decoder decodeObjectForKey:@"animatedStickerAngle"] floatValue];
        //        self.scaleValueX = [[decoder decodeObjectForKey:@"animatedStickerScaleX"] floatValue];
        //        self.scaleValueY = [[decoder decodeObjectForKey:@"animatedStickerScaleY"] floatValue];
        //        self.tX = [[decoder decodeObjectForKey:@"animatedStickerTX"] floatValue];
        //        self.tY = [[decoder decodeObjectForKey:@"animatedStickerTY"] floatValue];
                self.animatedStickerName  = [decoder decodeObjectForKey:@"animatedStickerName"];
                self.startDelay = [[decoder decodeObjectForKey:@"startDelay"] floatValue];
                self.endDelay = [[decoder decodeObjectForKey:@"endDelay"] floatValue];
    }
    
    return [self initWithFrame:[self frame]];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    //    self.objFrame = self.frame;
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:NSStringFromCGRect(self.frame) forKey:@"animatedStickerFrame"];
    [aCoder encodeObject:NSStringFromCGRect(self.bounds) forKey:@"animatedStickerBounds"];
    [aCoder encodeObject:NSStringFromCGRect(self.objFrame) forKey:@"animatedStickerObjFrame"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"animatedStickerimage"];
    
        [aCoder encodeObject:self.animatedStickerName forKey:@"animatedStickerName"];
    //    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self rotation]] forKey:@"animatedStickerAngle"];
        [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.startDelay] forKey:@"startDelay"];
        [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.endDelay] forKey:@"endDelay"];
    //    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self xscale]] forKey:@"animatedStickerScaleX"];
    //    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self yscale]] forKey:@"animatedStickerScaleY"];
    //    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.transform.tx] forKey:@"animatedStickerTX"];
    //    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.transform.ty] forKey:@"animatedStickerTY"];
    //    [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"animatedStickerimage"];
}

@end

#pragma mark - ComicItemBubble

@implementation ComicItemBubble

@synthesize recorderFilePath,player;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.frame = frame;
    }
    return self;
}

-(id)addItemWithImage:(id)sticker{
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    return self;
}

#pragma mark ComicItemBubble - AudioAction

-(BOOL)isPlayVoice{
    if (recorderFilePath)
    return YES;
    else
    return NO;
}

- (void)recordAction{
    
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"VoiceRecord" Action:@"Create" Label:@""];
    
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
    [player setVolume: 1.0];
    [player play];
    
}
- (NSString *)startRecording{
    
    if (audioSession == nil) {
        audioSession = [AVAudioSession sharedInstance];
    }
    NSError *setOverrideError;
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        return @"";
    }
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&setOverrideError];
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

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
}
- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"ERROR IN DECODE: %@\n", error);
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error{
    NSLog(@"ERROR IN DECODE: %@\n", error);
}
- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.imageView = [decoder decodeObjectForKey:@"imageView"];
        
        if (SYSTEM_VERSION_LESSER_THAN_OR_EQUAL_TO(@"9")) {
            self.imageView.image = [UIImage imageWithData:[decoder decodeObjectForKey:@"bubbleimage"]];
        }else{
            self.imageView.image = [decoder decodeObjectForKey:@"bubbleimage"];
        }
        self.recorderFilePath = [decoder decodeObjectForKey:@"recorderFilePath"];
        self.audioImageButton = [decoder decodeObjectForKey:@"audioImageButton"];
        self.txtBuble = [decoder decodeObjectForKey:@"txtBuble"];
        self.imagebtn = [decoder decodeObjectForKey:@"imagebtn"];
        self.bubbleString = [decoder decodeObjectForKey:@"bubbleString"];
        
        self.angle = [[decoder decodeObjectForKey:@"bubbleAngle"] floatValue];
        self.scaleValueX = [[decoder decodeObjectForKey:@"bubbleScaleX"] floatValue];
        self.scaleValueY = [[decoder decodeObjectForKey:@"bubbleScaleY"] floatValue];
        self.tX = [[decoder decodeObjectForKey:@"bubbleTX"] floatValue];
        self.tY = [[decoder decodeObjectForKey:@"bubbleTY"] floatValue];
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    if (SYSTEM_VERSION_LESSER_THAN_OR_EQUAL_TO(@"9")) {
        [aCoder encodeObject:UIImagePNGRepresentation(self.imageView.image) forKey:@"bubbleimage"];
    }else{
        [aCoder encodeObject:self.imageView.image forKey:@"bubbleimage"];
    }
    [aCoder encodeObject:self.recorderFilePath forKey:@"recorderFilePath"];
    [aCoder encodeObject:self.audioImageButton forKey:@"audioImageButton"];
    [aCoder encodeObject:self.imageView forKey:@"imageView"];
    [aCoder encodeObject:self.txtBuble forKey:@"txtBuble"];
    [aCoder encodeObject:self.imagebtn forKey:@"imagebtn"];
    [aCoder encodeObject:self.bubbleString forKey:@"bubbleString"];
    
    [aCoder encodeObject:NSStringFromCGRect(self.bounds) forKey:@"bubbleBounds"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self rotation]] forKey:@"bubblenAngle"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self xscale]] forKey:@"bubbleScaleX"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", [self yscale]] forKey:@"bubbleScaleY"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.transform.tx] forKey:@"bubbleTX"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.transform.ty] forKey:@"bubbleTY"];
}

-(void)dealloc
{
//    self.txtBuble = nil;
}

- (CGFloat) xscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat) yscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (CGFloat) rotation
{
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}

- (CGFloat) tx
{
    CGAffineTransform t = self.transform;
    return t.tx;
}

- (CGFloat) ty
{
    CGAffineTransform t = self.transform;
    return t.ty;
}

@end

#pragma mark - ComicItemCaption

@implementation ComicItemCaption

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.frame = frame;
    }
    return self;
}
-(id)addItemWithImage:(id)sticker{
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.bgImageView = [decoder decodeObjectForKey:@"bgImageView"];
        self.txtCaption = [decoder decodeObjectForKey:@"txtCaption"];
        self.plusButton = [decoder decodeObjectForKey:@"plusButton"];
        self.dotHolder = [decoder decodeObjectForKey:@"dotHolder"];
        self.tintColourString = [decoder decodeObjectForKey:@"tintColourString"];
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.tintColourString forKey:@"tintColourString"];
    [aCoder encodeObject:self.bgImageView forKey:@"bgImageView"];
    [aCoder encodeObject:self.txtCaption forKey:@"txtCaption"];
    [aCoder encodeObject:self.plusButton forKey:@"plusButton"];
    [aCoder encodeObject:self.dotHolder forKey:@"dotHolder"];
}

@end
