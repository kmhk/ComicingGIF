//
//  CameraViewController.h
//  ComicingGif
//
//  Created by Com on 22/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CameraViewModel.h"

@interface CameraViewController : UIViewController
<
CameraViewModelDelegate,
MFMailComposeViewControllerDelegate
>
{
	
}

@property (nonatomic) CameraViewModel *viewModel;
@property BOOL isVerticalCamera;
@end
