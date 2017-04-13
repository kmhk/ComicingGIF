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

@interface FindFriendsView : UIView<UITableViewDelegate>
{
    NSMutableArray* contactList;
    NSMutableArray* contactNumber;
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *searchTextHolderView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIImageView *imgSearch;
@property (weak, nonatomic) IBOutlet UITableView *contactListTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptionText;

@property (weak, nonatomic) IBOutlet UILabel *lblCaptionText2;
@property (weak, nonatomic) IBOutlet UILabel *lblHeadText;

@property (strong, nonatomic) IBOutlet FindFriendsTableCell *tabCell;

@end
