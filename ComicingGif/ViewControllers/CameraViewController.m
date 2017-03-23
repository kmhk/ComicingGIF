//
//  CameraViewController.m
//  ComicingGif
//
//  Created by Com on 22/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CameraViewController.h"


@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgviewToggle;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewRecording;

@property (weak, nonatomic) IBOutlet UIButton *btnChangeScene;

@end


@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.viewModel = [[CameraViewModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// MARK: - button actions

- (IBAction)closeBtnTapped:(id)sender {
}

- (IBAction)changeCameraTapped:(id)sender {
}

- (IBAction)changeSceneTappep:(id)sender {
}

@end
