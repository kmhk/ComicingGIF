//
//  ProfilePicView.h
//  ComicApp
//
//  Created by Ramesh on 10/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfilePicDelegate <NSObject>

@optional

-(void)getProfilePicRequest;

@end

@interface ProfilePicView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *headText;
@property (weak, nonatomic) IBOutlet UIView *toolHolderView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnCut;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelectedImage;
@property (nonatomic, assign) id<ProfilePicDelegate> delegate;
- (IBAction)btnDoneClick:(id)sender;

@end
