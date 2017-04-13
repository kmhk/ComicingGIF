//
//  AvatarViewViewController.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+colorWithHexString.h"
#import "ComicNetworking.h"
#import "BaseModel.h"

@protocol SearchDelegate <NSObject>

@optional

-(void)openSearchViewController;
-(void)closeSearchViewController;
-(void)postFriendsSearchResponse:(NSDictionary*)response;

@end

@interface AvatarView : UIView <ComicNetworkingDelegate,UITextFieldDelegate>
{
    User* userObject;
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIButton *myFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchById;

@property (nonatomic, assign) id<SearchDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchById;

- (IBAction)searchButtonClick:(id)sender;


@end
