//
//  MainViewController.h
//  ComicMakingPage
//
//  Created by Ramesh on 15/02/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIGestureRecognizerDelegate>

-(void)getStickerListByCategory:(NSString*)strCategoryId CategoryName:(NSString*)ctName;
- (void)hideInviteView;
- (void)openInviteView;

@end
