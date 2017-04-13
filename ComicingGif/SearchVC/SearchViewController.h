//
//  SearchViewController.h
//  ComicApp
//
//  Created by Ramesh on 27/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarView.h"
#import "FriendsListView.h"
#import "BaseModel.h"
#import "ComicNetworking.h"

@interface SearchViewController : UIViewController<SearchDelegate,FriendListDelegate,ComicNetworkingDelegate>
{
    NSMutableDictionary* selectedDict;
}
@property (weak, nonatomic) IBOutlet AvatarView *avView;
@property (weak, nonatomic) IBOutlet FriendsListView *friendListView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriends;

- (IBAction)backButtonClick:(id)sender;
- (IBAction)btnAddFriendClick:(id)sender;

@end
