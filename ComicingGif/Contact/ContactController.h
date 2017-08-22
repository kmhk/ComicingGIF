//
//  ContactController.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarView.h"
#import "SectionDividerView.h"
#import "GroupsSection.h"
#import "FriendsListView.h"
#import "AppHelper.h"
#import "GroupViewController.h"
#import "ComicNetworking.h"
#import "BaseModel.h"
#import "SearchViewController.h"
#import "SendPageViewController.h"
#import "FooterView.h"
#import <MessageUI/MessageUI.h>

@interface ContactController : UIViewController<GroupDelegate,ComicNetworkingDelegate,SearchDelegate,FriendListDelegate, MFMessageComposeViewControllerDelegate>
{
    CGRect friendsFrame;
    NSMutableDictionary* selectedDict;
}
/* properties */

@property (weak, nonatomic) IBOutlet AvatarView *avView;
@property (weak, nonatomic) IBOutlet SectionDividerView *headerView1;
@property (weak, nonatomic) IBOutlet SectionDividerView *headerView2;
@property (weak, nonatomic) IBOutlet GroupsSection *groupSection;
@property (weak, nonatomic) IBOutlet FriendsListView *friendsList;

@property (weak, nonatomic) IBOutlet FooterView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *btnAddButton;
- (IBAction)btnAddButtonClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;

/*End properties */

@end
