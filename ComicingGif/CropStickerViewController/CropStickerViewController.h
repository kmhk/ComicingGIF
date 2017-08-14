//
//  CropStickerViewController.h
//  CommicMakingPage
//
//  Created by ADNAN THATHIYA on 06/12/15.
//  Copyright (c) 2015 jistin. All rights reserved.
//
#import <UIKit/UIKit.h>

//extern NSString *const SKeySticker;

@class CropStickerViewController;

@protocol CropStickerViewControllerDelegate <NSObject>

- (void)cropStickerViewController:(CropStickerViewController *)controll didSelectDoneWithImage:(UIImageView *)stickerImageView withBorderImage:(UIImage *)image;

- (void)cropStickerViewControllerWithCropCancel:(CropStickerViewController *)controll;

- (void)saveStickerWithWhiteBorderImage:(UIImage *)whiteImage;

@end

@interface CropStickerViewController : UIViewController

@property (nonatomic, weak) id<CropStickerViewControllerDelegate> delegate;

@property (nonatomic,assign) BOOL isRegView;

@property (weak, nonatomic) IBOutlet UIImageView *imgCropBackground;

@end
