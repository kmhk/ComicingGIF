//
//  MainPage3SlideCell.m
//  ComicBook
//
//  Created by ADNAN THATHIYA on 03/07/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "MainPage3SlideCell.h"
#import <AVFoundation/AVFoundation.h>
#import "Enhancement.h"
#import "CustomView.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Slides.h"

@interface MainPage3SlideCell()<AVAudioPlayerDelegate>
{
    UIView *audioView;
    UIImageView *img;
    CGFloat audioViewHeight;
    CGFloat imgHeight;
    AVAudioPlayer *player;
}

@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (strong, nonatomic) NSMutableArray *audioDurationSecondsArray;
@property (strong, nonatomic) NSMutableArray *downloadedAudioDataArray;
@property (strong, nonatomic) NSMutableArray *audioUrlArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstant;

@end

@implementation MainPage3SlideCell
@synthesize btnUser, profileImageView, lblComicTitle, btnBubble, btnTwitter, btnFacebook, viewComicBook;

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutCell];
}

-(void)layoutCell
{
    [self layoutIfNeeded];
    
    [viewComicBook layoutIfNeeded];
    
    [btnFacebook layoutIfNeeded];
    [btnTwitter layoutIfNeeded];
    [btnBubble layoutIfNeeded];

    
    /*btnUser.layer.cornerRadius = CGRectGetHeight(btnUser.frame) / 2;
    btnUser.clipsToBounds = YES;
    profileImageView.layer.cornerRadius = CGRectGetHeight(profileImageView.frame) / 2;
    profileImageView.clipsToBounds = YES;*/
    CGFloat heiWei;
    
    if (IS_IPHONE_5)
    {
        heiWei = 34;
        _mUserName.font = [_mUserName.font fontWithSize:8.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:8.f];
        self.lblTime.font = [self.lblTime.font fontWithSize:8.f];
        
        self.heightConstraint.constant = 0;
        self. widthConstant.constant = -2;
        
    }
    else if (IS_IPHONE_6)
    {
        heiWei = 35;
        _mUserName.font = [_mUserName.font fontWithSize:9.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:9.f];
        self.lblTime.font = [self.lblTime.font fontWithSize:9.f];
        
        self.heightConstraint.constant = -0;
        self. widthConstant.constant = -1;


    }
    else if (IS_IPHONE_6P)
    {
        heiWei = 36;
        _mUserName.font = [_mUserName.font fontWithSize:10.f];
        self.lblDate.font = [self.lblDate.font fontWithSize:10.f];
        self.lblTime.font = [self.lblTime.font fontWithSize:10.f];

        self.heightConstraint.constant = 0;
        self. widthConstant.constant = 0;


    }
    
    _const_Width.constant = heiWei;
    _const_Height.constant = heiWei;
    btnUser.layer.cornerRadius = heiWei / 2;
    btnUser.layer.masksToBounds = YES;
    profileImageView.layer.cornerRadius = heiWei / 2;
    profileImageView.layer.masksToBounds = YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    if(IS_IPHONE_5)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
    }
    else if(IS_IPHONE_6)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:28];
        
    }
    else if(IS_IPHONE_6P)
    {
        lblComicTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:29];
    }

    _imgvSlide1.layer.borderColor = [UIColor blackColor].CGColor;
    _imgvSlide1.layer.borderWidth = 1.5;

    _imgvSlide2.layer.borderColor = [UIColor blackColor].CGColor;
    _imgvSlide2.layer.borderWidth = 1.5;

    _imgvSlide3.layer.borderColor = [UIColor blackColor].CGColor;
    _imgvSlide3.layer.borderWidth = 1.5;

//    viewComicBook.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setComic:(ComicBook *)comicInfo
{
    [self setAudioView];

    int count = 0;
    for (Slides *slide in comicInfo.slides)
    {
        if (count == 0)
        {
            [self addAudioButton:slide withFrame:_imgvSlide1.frame];

        }
        else if (count == 1)
        {
            [self addAudioButton:slide withFrame:_imgvSlide2.frame];

        }
        else
        {
            [self addAudioButton:slide withFrame:_imgvSlide3.frame];

        }
        count ++;
    }
    
}

- (void)setAudioView
{
    if(IS_IPHONE_5)
    {
        audioViewHeight=40;
        imgHeight = 30;
    }
    else if(IS_IPHONE_6)
    {
        audioViewHeight= 50;
        imgHeight = 40;
    }
    else if(IS_IPHONE_6P)
    {
        audioViewHeight= 60;
        imgHeight = 50;
    }
    
    audioView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewComicBook.frame.size.height - 60, self.viewComicBook.frame.size.width, audioViewHeight)];
    [audioView setBackgroundColor:[UIColor colorWithRed:241/255.0f green:199/255.0f blue:27/255.0f alpha:0.7]];
    img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, imgHeight, imgHeight)];
    [img setImage:[UIImage imageNamed:@"mic_play"]];
    [audioView addSubview:img];
}

- (void)addAudioButton:(Slides *)slide withFrame:(CGRect)frame {
    
    /*
     Enhancement *en = [[Enhancement alloc] init];
     en.enhancementFile = @"http://68.169.44.163/sounds/comics/slides/56dbc70542dba";
     en.xPos = @"50.0";
     en.yPos = @"75.0";
     
     Enhancement *en1 = [[Enhancement alloc] init];
     en1.enhancementFile = @"http://68.169.44.163/sounds/comics/slides/56dbc70542dba";
     en1.xPos = @"150.0";
     en1.yPos = @"75.0";
     
     Enhancement *en2 = [[Enhancement alloc] init];
     en2.enhancementFile = @"http://www.noiseaddicts.com/samples_1w72b820/4927.mp3";
     en2.xPos = @"250.0";
     en2.yPos = @"75.0";
     
     NSArray *t = @[en, en1, en2];
     slide.enhancements = t;
     
     // http://www.noiseaddicts.com/samples_1w72b820/4927.mp3
     // http://68.169.44.163/sounds/comics/slides/56dbc70542dba
     */
    
    self.audioUrlArray = [[NSMutableArray alloc] initWithCapacity:slide.enhancements.count];
    self.audioDurationSecondsArray = [[NSMutableArray alloc] initWithCapacity:slide.enhancements.count];
    self.downloadedAudioDataArray = [[NSMutableArray alloc] initWithCapacity:slide.enhancements.count];
    for (int i = 0; i < slide.enhancements.count; i ++) {
        [self.downloadedAudioDataArray addObject:[NSNull null]];
    }
    for(Enhancement *enhancement in slide.enhancements) {
        [self.audioUrlArray addObject:[NSURL URLWithString:enhancement.enhancementFile]];
        [self performSelectorInBackground:@selector(getTheAudioLength:) withObject:[NSNumber numberWithInteger:[slide.enhancements indexOfObject:enhancement]]];
        [self configureAudioPlayer:[slide.enhancements indexOfObject:enhancement]];
        CustomView *audioButton = [[CustomView alloc] init];
        audioButton.tag = [slide.enhancements indexOfObject:enhancement];
        
        audioButton.backgroundColor = [UIColor redColor];
        
        
        //        [audioButton setFrame:CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], 32, 25)];
        float xfactor = [AppDelegate application].dataManager.viewWidth/frame.size.width;
        float yfactor = [AppDelegate application].dataManager.viewHeight/frame.size.height;
        
        if(xfactor == 1 && yfactor == 1)
        {
            xfactor = 0.75;
            yfactor = 0.75;
        }
        
        float originX = xfactor * [enhancement.xPos floatValue];
        float originY = yfactor * [enhancement.yPos floatValue];
        float sizeX = xfactor * [enhancement.width floatValue];
        float sizeY = yfactor * [enhancement.height floatValue];
        
        NSLog(@"%@", NSStringFromCGRect(CGRectMake(originX, originY, sizeX, sizeY)));
        NSLog(@"%@", NSStringFromCGRect(CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], [enhancement.width floatValue], [enhancement.height floatValue])));
        // originX and originY are currently middle points. So changing it to origin.
        originX = originX - sizeX/2;
        originY = originY - sizeY/2;
        [audioButton setFrame:CGRectMake(originX + frame.origin.x - 20, originY + frame.origin.y - 20, 100, 100)];
        //        [audioButton setBackgroundColor:[UIColor yellowColor]];
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 25)];
        //        imageView.image = [UIImage imageNamed:@"bubbleAudioPlay"];
        //        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        //        [audioButton addSubview:imageView];
        __weak __typeof(self)weakSelf = self;
        __weak __typeof(audioButton)weakAudioButton = audioButton;
        audioButton.playAudio = ^{
            [weakSelf playAudio:weakAudioButton.tag];
        };
        audioButton.pauseAudio = ^{
            [weakSelf pauseAudio];
        };
        [self.viewComicBook addSubview:audioButton];
    }
}

- (void)playAudio:(NSInteger)tag {
    if(self.downloadedAudioDataArray.count > tag && ![[self.downloadedAudioDataArray objectAtIndex:tag] isEqual:[NSNull null]]) {
        NSLog(@"STEP: 1 : play audio");
        NSError *error;
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithData:[self.downloadedAudioDataArray objectAtIndex:tag] error:&error];
        [self.backgroundMusicPlayer setDelegate:self];
        self.backgroundMusicPlayer.numberOfLoops = 0;
        [self.backgroundMusicPlayer play];
        [self showAudioAnimation:tag];
    } else {
        NSLog(@"STEP: 2 : play audio");
        [self showTemperoryAudioAnimation:tag];
        [self performSelectorInBackground:@selector(getTheAudioLength:) withObject:[NSNumber numberWithInteger:tag]];
        [self configureAudioPlayerAndPlay:tag withCompletionHandler:^(BOOL success) {
            NSLog(@"STEP: 6 : successfully received data");
            NSLog(@"STEP: 7 : recursion play");
            [self playAudio:tag];
        }];
    }
}

- (void)showAudioAnimation:(NSInteger)tag
{
    CGFloat audioViewY;
    if(IS_IPHONE_5)
    {
        audioViewY = self.viewComicBook.frame.size.height - 55;
    }
    else if(IS_IPHONE_6)
    {
        audioViewY = self.viewComicBook.frame.size.height - 70;
    }
    else if(IS_IPHONE_6P)
    {
        audioViewY = self.viewComicBook.frame.size.height - 80;
    }
    
    [audioView setFrame:CGRectMake(0, audioViewY, 50, audioViewHeight)];
    [self.viewComicBook addSubview:audioView];
    audioView.alpha = 1;
    img.alpha = 1;
    
    [UIView animateWithDuration:[[self.audioDurationSecondsArray objectAtIndex:tag] floatValue] delay:.2 usingSpringWithDamping:.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [audioView setFrame:CGRectMake(0, audioViewY, self.viewComicBook.frame.size.width, audioViewHeight)];
        audioView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)showTemperoryAudioAnimation:(NSInteger)tag {
    CGFloat audioViewY;
    if(IS_IPHONE_5) {
        audioViewY = self.viewComicBook.frame.size.height - 55;
    } else if(IS_IPHONE_6) {
        audioViewY = self.viewComicBook.frame.size.height - 70;
    } else if(IS_IPHONE_6P) {
        audioViewY = self.viewComicBook.frame.size.height - 80;
    }
    [audioView setFrame:CGRectMake(0, audioViewY, 50, audioViewHeight)];
    [self.viewComicBook addSubview:audioView];
    audioView.alpha = 1;
    img.alpha = 1;
    [UIView animateWithDuration:0 delay:.2 usingSpringWithDamping:.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //        [audioView setFrame:CGRectMake(0, audioViewY, self.view.frame.size.width, audioViewHeight)];
        audioView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)pauseAudio {
    [self.backgroundMusicPlayer stop];
    [self hideAudioAnimation];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.backgroundMusicPlayer stop];
    [self hideAudioAnimation];
}

- (void)hideAudioAnimation {
    [UIView animateWithDuration:2 delay:.2 usingSpringWithDamping:.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //        [audioView setFrame:CGRectMake(0, self.view.frame.size.height - 80, 0, 60)];
        audioView.alpha = 0;
        img.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

- (void)getTheAudioLength:(NSNumber *)index {
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[self.audioUrlArray objectAtIndex:[index intValue]] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    audioDurationSeconds += 1; // add extra 1 second
    [self.audioDurationSecondsArray addObject:[NSNumber numberWithFloat:audioDurationSeconds]];
}
- (void)configureAudioPlayer:(NSUInteger)index {
    //    NSURL *url = [NSURL URLWithString:@"http://68.169.44.163/sounds/comics/slides/56dbc70542dba"];
    [self handleDataDownloadFromUrl:[self.audioUrlArray objectAtIndex:index] withCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError == nil) {
            [self.downloadedAudioDataArray removeObjectAtIndex:index];
            [self.downloadedAudioDataArray insertObject:data atIndex:index];
            if (!data) {
                NSLog(@"not downloaded");
            } else {
            }
        }
    }];
}

- (void)configureAudioPlayerAndPlay:(NSUInteger)index
              withCompletionHandler:(void (^)(BOOL success)) handler {
    NSLog(@"STEP: 3 : download data");
    //    NSURL *url = [NSURL URLWithString:@"http://68.169.44.163/sounds/comics/slides/56dbc70542dba"];
    [self handleDataDownloadFromUrl:[self.audioUrlArray objectAtIndex:index] withCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError == nil) {
            [self.downloadedAudioDataArray removeObjectAtIndex:index];
            [self.downloadedAudioDataArray insertObject:data atIndex:index];
            if (!data) {
                NSLog(@"STEP: 4 : not downloaded");
                handler(NO);
            } else {
                NSLog(@"STEP: 5 : downloaded");
                handler(YES);
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
