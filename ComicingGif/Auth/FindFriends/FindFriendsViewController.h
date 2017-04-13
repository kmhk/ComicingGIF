//
//  FindFriendsView.h
//  ComicApp
//
//  Created by Ramesh on 10/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindFriendsTableCell.h"
#import "UIColor+colorWithHexString.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppHelper.h"
#import "ComicNetworking.h"
#import "ContactController.h"
#import "FriendsListView.h"

@interface FindFriendsViewController : UIViewController<UITableViewDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate>
{
    NSMutableArray* contactList;
    NSMutableArray* contactNumber;
    NSArray* temContactList;
}
@property (weak, nonatomic) IBOutlet UIView *searchTextHolderView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIImageView *imgSearch;
@property (weak, nonatomic) IBOutlet UITableView *contactListTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptionText;
@property (weak, nonatomic) IBOutlet UIImageView *imgvUser;

@property (weak, nonatomic) IBOutlet UILabel *lblCaptionText2;
@property (weak, nonatomic) IBOutlet UILabel *lblHeadText;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet FriendsListView *viewFriendList;

@property (strong, nonatomic) IBOutlet FindFriendsTableCell *tabCell;

@property (strong, nonatomic) UIImage *imgUser;

@property CGRect frameSearchTextHolderView;
@property CGRect frameContactListTableView;
@property CGRect frameViewHeader;
@property CGRect frameViewFriendList;
- (IBAction)btnSkipAction:(id)sender;
@end
