//
//  SendPageViewController.h
//  ComicApp
//
//  Created by Ramesh on 27/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsListView.h"
#import "ComicImageListView.h"
#import "GroupsSection.h"
#import "HeaderView.h"
#import "ShareHelper.h"
#import "ComicShareView.h"
#import "UIImage+resize.h"
#import "InviteFriendsView.h"

@interface SendPageViewController : UIViewController<ComicNetworkingDelegate,GroupDelegate,FriendListDelegate,InviteFriendsViewDelegate,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray* shareGroupsArray;
    NSMutableArray* shareFriendsArray;
    NSMutableArray* imageArray;
}

@property (weak, nonatomic) IBOutlet HeaderView *headerView;
@property (weak, nonatomic) IBOutlet FriendsListView *friendsListView;
//@property (weak, nonatomic) IBOutlet ComicImageListView *comicImageList;
@property (weak, nonatomic) IBOutlet UILabel *lblGroup;
@property (weak, nonatomic) IBOutlet GroupsSection *groupsView;
@property (weak, nonatomic) IBOutlet UILabel *lblFriends;
@property (weak, nonatomic) IBOutlet UIView *viewShare;
@property (weak, nonatomic) IBOutlet UIView *viewPublic;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIView *viewPrivateTop;

@property (weak, nonatomic) IBOutlet InviteFriendsView *viewInvite;
@property (weak, nonatomic) IBOutlet UIView *viewInviteSuper;

//@property (weak, nonatomic) NSString HeaderView *headerView;

@property (nonatomic) NSString* comicSlideFileName;

@property (strong, nonatomic) IBOutlet ComicShareView *comicShareViewView;

- (IBAction)backButtonClick:(id)sender;

- (IBAction)btnEveryOnceClick:(id)sender;
- (IBAction)btnShareComic:(id)sender;

@end
