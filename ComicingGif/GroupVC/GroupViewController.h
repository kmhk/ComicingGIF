//
//  GroupViewController.h
//  ComicApp
//
//  Created by Ramesh on 24/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionDividerView.h"
#import "FriendsListView.h"
#import "GroupsMembersSection.h"
#import "ComicNetworking.h"
#import "BaseModel.h"

@interface GroupViewController : UIViewController<ComicNetworkingDelegate,FriendListDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray* groupsDetails;
//    NSMutableDictionary* usersList;
    NSMutableArray* groupAddArray;
    NSMutableArray* groupCreateArray;
}
/* properties */
@property (weak, nonatomic) IBOutlet SectionDividerView *sectionDividerViewHolder;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UIView *groupMemberImages;
@property (weak, nonatomic) IBOutlet FriendsListView *friendsList;
@property (weak, nonatomic) IBOutlet GroupsMembersSection *groupMembers;
@property (weak, nonatomic) IBOutlet UIButton *btnGroupIcon;
@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchFriends;
//@property(nonatomic,assign) BOOL isAddNew;

@property (assign,nonatomic) NSInteger group_id;

/* END */

/* Events */
- (IBAction)backButtonClick:(id)sender;
- (IBAction)btnAddClick:(id)sender;
- (IBAction)btnGroupIconClick:(id)sender;
- (IBAction)btnSearchFriendClick:(id)sender;


/* END */
@end
