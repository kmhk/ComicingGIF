//
//  MainViewController.m
//  ComicMakingPage
//
//  Created by Ramesh on 15/02/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "MainViewController.h"
#import "AppHelper.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "CropRegisterViewController.h"
#import "OpenCuteStickersGiftBoxViewController.h"
#import "InviteViewController.h"

@interface MainViewController ()
{
    MPMoviePlayerViewController* playerViewController;
    MPMoviePlayerController *playerNotification;
}
@property (weak, nonatomic) IBOutlet UIView *introViewHolder;
@property (weak, nonatomic) IBOutlet UIView *viewInviteHolder;
@property (weak, nonatomic) InviteViewController *referInvite;
@property (strong, nonatomic) IBOutlet UIView *inviteContainerView;


@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"Registration" Attributes:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [AppHelper hideAllDropMessages];
    [self.view setAlpha:1];
    [super viewWillAppear:animated];
    
    /*UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    OpenCuteStickersGiftBoxViewController *controller = (OpenCuteStickersGiftBoxViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"OpenCuteStickersGiftBoxViewController"];
    [self presentViewController:controller animated:YES completion:nil];*/
    
    /*UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    InviteViewController *controller = (InviteViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
    [self presentViewController:controller animated:YES completion:nil];*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSignUpClick:(id)sender {
    if ([AppHelper getFirstTimeSignUp] == nil) {
        [self playVideo:@""];
//        [self addIntroVideo];
    }else{
        [self gotoRegisterPage];
    }
}

#pragma mark PublicMethods

-(void)getStickerListByCategory:(NSString*)strCategoryId CategoryName:(NSString*)ctName
{
    //NSMutableArray* listArray = [AppHelper getAllStickeyList];
    //[self.stickeyViewController getBind:listArray IsEnableSaveSticky:YES];
    //self.lblCategoryName.text = @"ALL";
    
}


- (void)openInviteView{
    
    [self.viewInviteHolder setHidden:NO];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.viewInviteHolder.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.viewInviteHolder.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2   animations:^{
                self.viewInviteHolder.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
            }];
        }];
    }];
    
    // InviteViewController *inviteVc = self.navigationController.childViewControllers[2]; //assuming you have only one child
    [self.referInvite getPhoneContact];
}

- (void)hideInviteView{
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.viewInviteHolder.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.viewInviteHolder.transform = CGAffineTransformIdentity;
            [self.viewInviteHolder setHidden:YES];
        }];
    }];
}

- (void) playVideo:(NSString *)fileName
{
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"introvideo" ofType:@"mp4"]];
    
    playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    playerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(movieFinishedCallback:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:[playerViewController moviePlayer]];
    
    [self.view addSubview:playerViewController.view];
    //play movie
    MPMoviePlayerController *player = [playerViewController moviePlayer];

    [self addSwipeEvent:player.view];
    
    [playerViewController.view setAlpha:0];
    //fade in
    [UIView animateWithDuration:2.0f animations:^{
        [playerViewController.view setAlpha:1];
    } completion:^(BOOL finished) {
        [player play];
        [AppHelper setFirstTimeSignUp:@"YES"];
    }];
}

// The call back
- (void) movieFinishedCallback:(NSNotification*) aNotification {
    playerNotification = [aNotification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:playerNotification];
    
    [playerNotification stop];
    
    [self.view setAlpha:0];
    //fade out
    [UIView animateWithDuration:0.1f animations:^{
    } completion:^(BOOL finished) {
        [self gotoRegisterPage];
//        [playerNotification.view removeFromSuperview];
//        playerNotification = nil;
//        [playerViewController removeFromParentViewController];
//        playerViewController = nil;
        [UIView animateWithDuration:0.0f animations:^{
        } completion:^(BOOL finished) {
            [playerNotification.view removeFromSuperview];
            playerNotification = nil;
            
            [playerViewController removeFromParentViewController];
            playerViewController = nil;
            
        }];
    }];
    
    // call autorelease the analyzer says call too many times
    // call release the analyzer says incorrect decrement
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self removeIntroVideo];
    [playerViewController moviePlayer].view.userInteractionEnabled= NO;
    return YES;
}

-(void)addSwipeEvent:(UIView*)subView{
    
    [subView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *recognizerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(SwipeRecognizer:)];
    recognizerSingleTap.numberOfTapsRequired = 1;
    recognizerSingleTap.delegate = self;
    [subView addGestureRecognizer:recognizerSingleTap];
}

- (void) SwipeRecognizer:(UISwipeGestureRecognizer *)sender {
}

-(void)introVideoDoneButtonClick:(UIButton *)button {
    [self removeIntroVideo];
    // Remove playerViewController.view
}
-(void)removeIntroVideo{
    //fade out
    [UIView animateWithDuration:0.5f animations:^{
//        [playerViewController.view setAlpha:0.0];
    } completion:^(BOOL finished) {
        [[playerViewController moviePlayer] stop];
//        [[[playerViewController moviePlayer] view] removeFromSuperview];
//        [self gotoRegisterPage];
    }];
}

-(void)gotoRegisterPage{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CropRegisterViewController *controller = (CropRegisterViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CropRegister"];
    [self.navigationController pushViewController:controller animated:YES];
    mainStoryboard = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
