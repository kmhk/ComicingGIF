//
//  FriendsListView.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+colorWithHexString.h"
#import "FriendsListTableViewCell.h"
#import "ComicNetworking.h"
#import "BaseModel.h"

@protocol FriendListDelegate <NSObject>

@optional

- (void)selectedRow:(id)object;
- (void)selectedRow:(id)object param:(id)objectList;
- (void)openMessageComposer:(NSArray*)sendNumbers messageText:(NSString*)messageTextValue;

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset withTableView:(UITableView *)tableView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView withTableView:(UITableView *)tableView;;

@end

@interface FriendsListView : UIView<UITableViewDataSource,UITableViewDelegate,ComicNetworkingDelegate>
{
//    NSMutableArray* friendsArray;
    NSArray *alphabetsSectionTitles;
    NSArray *saveAlphabetsSectionTitles;

    NSArray* groupMembersList;
    NSMutableDictionary* friendsDictWithAlpabets;
    
    NSMutableArray* contactList;
    NSMutableArray* contactNumber;
    NSArray* temContactList;
    NSMutableArray *searchArray;
    NSMutableArray *saveContactList;
    NSMutableArray *selectedFriends;
    
    
    NSMutableDictionary *searchUsers;
    NSMutableDictionary *saveFriendsDictWithAlpabets;
    
    CGPoint pointNow;
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITableView *friendsListTableView;
@property (strong, nonatomic) IBOutlet FriendsListTableViewCell *tabCell;
@property (weak, nonatomic) IBOutlet UILabel *headerName;
@property (strong, nonatomic) NSString * selectedActionName;
@property (nonatomic, assign) id<FriendListDelegate> delegate;
@property (assign, nonatomic) BOOL enableSectionTitles;
@property (assign, nonatomic) BOOL enableSelection;
@property (assign, nonatomic) BOOL enableInvite;
@property (assign, nonatomic) BOOL hideTickByDefault;
@property (strong,nonatomic)  NSMutableArray* friendsArray;
@property (weak, nonatomic) IBOutlet UIView *tableHolderView;


@property (nonatomic) BOOL isTitleLabelHide;

@property (nonatomic) BOOL isOnlyInviteFriends;


-(void)getFriendsByUserId;
-(void)searchFriendsById:(NSMutableArray*)list;
-(void)getFriendsByUserId:(NSArray*)groupMembers;

- (void)searchFriendByString:(NSString *)searchString;
- (void)reloadAllData;
- (void)hideIndex;
-(void)friendslistResponse:(NSDictionary *)response;
-(void)friendsSearchResponse:(NSDictionary *)response;
@end
