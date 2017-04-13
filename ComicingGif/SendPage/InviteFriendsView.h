//
//  InviteFriendsView.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 03/04/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "FindFriendsTableCell.h"

@protocol InviteFriendsViewDelegate <NSObject>

-(void)openMessageComposer:(NSArray*)sendNumbers messageText:(NSString*)messageTextValue;

@optional


@end


@interface InviteFriendsView : UIView

@property (nonatomic, assign) id<InviteFriendsViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tblvInviteFriends;

@property (strong, nonatomic) IBOutlet FindFriendsTableCell *tabCell;
@property (strong, nonatomic) IBOutlet UIView *view;

- (NSArray *)getSelectedContacts;
- (void)removeAllSelectedContacts;
- (NSArray *)getallInvitedContacts;

- (void)searchFriendByString:(NSString *)searchString;

@end
