//
//  InviteViewController.h
//  StickeyBoard
//
//  Created by Ramesh on 04/07/16.
//  Copyright © 2016 Comicing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "UICountingLabel.h"
#import "ComicNetworking.h"

@interface InviteViewController : UIViewController <ComicNetworkingDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UINavigationController *parentViewController;
@property (nonatomic, strong) MainViewController *delegate;

-(void)getPhoneContact;

@end
