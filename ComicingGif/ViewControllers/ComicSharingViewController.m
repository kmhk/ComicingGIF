//
//  ComicSharingViewController.m
//  ComicingGif
//
//  Created by user on 5/17/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicSharingViewController.h"
#import "ComicPreviewModel.h"
#import "ShareHelper.h"
#import "UIImage+Image.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>


@interface ComicSharingViewController ()
{
	ComicPreviewModel *viewModel;
	
	NSURL *videoURL;
	AVPlayer *avPlayer;
}

@property (weak, nonatomic) IBOutlet UIView *preview;

@end



@implementation ComicSharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	viewModel = [[ComicPreviewModel alloc] init];
	viewModel.parentVC = self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[viewModel generateVideos:^(NSURL *url) {
		videoURL = url;
		
		avPlayer = [AVPlayer playerWithURL:videoURL];
		avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
		
		AVPlayerLayer *videoLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
		videoLayer.frame = self.preview.bounds;
		videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
		[self.preview.layer addSublayer:videoLayer];
		
		[avPlayer play];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeBtnTapped:(id)sender {
//	[self dismissViewControllerAnimated:YES completion:nil];
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnTapped:(id)sender {
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
		
		NSLog(@"%@", changeRequest.description);
	} completionHandler:^(BOOL success, NSError *error) {
		if (success) {
			NSLog(@"saved down");
		} else {
			NSLog(@"something wrong %@", error.localizedDescription);
		}
		
		UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"Saved to library successfully" preferredStyle:UIAlertControllerStyleAlert];
		[controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
		[self presentViewController:controller animated:YES completion:nil];
	}];
}

- (IBAction)facebookBtnTapped:(id)sender {
	[self doShareTo:FACEBOOK ShareImage:[UIImage imageNamed:@"comicBookBackground"] url:videoURL];
}

- (IBAction)twitterBtnTapped:(id)sender {
	[self doShareTo:TWITTER ShareImage:[UIImage imageNamed:@"comicBookBackground"] url:videoURL];
}

- (IBAction)instagramBtnTapped:(id)sender {
	[self doShareTo:INSTAGRAM ShareImage:[UIImage imageNamed:@"comicBookBackground"] url:videoURL];
}

-(void)doShareTo :(ShapeType)type ShareImage:(UIImage*)imgShareto url:(NSURL *)url {
	
	//    UIImage* imgProcessShareImage = [self createImageWithLogo:imgShareto];
	
	imgShareto = [self createImageWithLogo:imgShareto];
	
	//    NSData *imageData = UIImagePNGRepresentation(imgShareto);
	//    UIImage *image =[UIImage imageWithData:imageData];
	
	//    UIImage* img = [self getnewImage:image];
	//Just to test
	
	//    UIBezierPath *path = [UIBezierPath bezierPath];
	//        UIGraphicsBeginImageContextWithOptions([image size], YES, [image scale]);
	//
	//        [image drawAtPoint:CGPointZero];
	//
	//        CGContextRef ctx = UIGraphicsGetCurrentContext();
	//        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
	//        [path fill];
	//
	//
	//        UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
	//        UIGraphicsEndImageContext();
	
	//        UIImageWriteToSavedPhotosAlbum(imgShareto, nil, nil, nil);
	//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
	//        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
	//        [imageData writeToFile:filePath atomically:YES]; //Write the file
	//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	//        NSLog(@"File Path :%@",filePath);
	
	/* Commented for testing*/
//	ShareHelper* sHelper = [ShareHelper shareHelperInit];
//	sHelper.parentviewcontroller = self;
//	[sHelper shareAction:type
//			   ShareText:@""
//			  ShareImage:imgShareto
//				ShareUrl:url.absoluteString
//			  completion:^(BOOL status) {
//				  
//			  }];
}

-(UIImage*)createImageWithLogo:(UIImage*)imgActualImage{
	
	//lets fix the share sticker size
	//w = 110;
	//h = 155;
	
	//Selected image adding to imageview
	UIImageView *imageViewSticker = [[UIImageView alloc] initWithImage:imgActualImage];
	imageViewSticker.frame = CGRectMake(50, 50, 110, 155);
	[imageViewSticker setContentMode:UIViewContentModeScaleAspectFit];
	
	//get logo
	UIImage* imgStickerLogo = [UIImage imageNamed:@"ShareStickerLogo"];
	
	
	//lets fix the share footer logo size
	//w = 133;
	//h = 28;
	
	//Selected image adding to imageview
	UIImageView *imageViewStLogo = [[UIImageView alloc] initWithImage:imgStickerLogo];
	imageViewStLogo.frame = CGRectMake(38, 225, 133, 28);
	[imageViewStLogo setContentMode:UIViewContentModeScaleAspectFit];
	
	//Calculating Framesize
	UIView* viewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 293)];
	[viewHolder setClipsToBounds:YES];
	
	[viewHolder setBackgroundColor:[UIColor clearColor]];
	[viewHolder addSubview:imageViewSticker];
	[viewHolder addSubview:imageViewStLogo];
	
	//Generating image
	UIImage* imgShareTo = [UIImage imageWithView:viewHolder paque:NO];
	
	viewHolder = nil;
	imageViewSticker = nil;
	
	//---------------------
	//uncomment to check the file type and quality
	/*NSData *pngData = UIImagePNGRepresentation(imgShareTo);
	 
	 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
	 NSString *filePath = [documentsPath stringByAppendingPathComponent:@"wa_image.png"]; //Add the file name
	 [pngData writeToFile:filePath atomically:YES]; //Write the file*/
	//---------------------
	
	
	return imgShareTo;
}

@end
