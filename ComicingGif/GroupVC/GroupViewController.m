//
//  GroupViewController.m
//  ComicApp
//
//  Created by Ramesh on 24/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "GroupViewController.h"
#import "SearchViewController.h"
#import "TopBarViewController.h"
#import "TopSearchVC.h"
#import "Constants.h"
#import "MainPageVC.h"
#import "UIImageView+WebCache.h"

@interface GroupViewController ()
{
    TopBarViewController *topBarView;
}
@end

#define SEARCHTEXTFILES_TAG 10

@implementation GroupViewController

- (void)viewDidLoad {
    
    [self addTopBarView];
    [self configViews];
    [self getGroupDetails];
    self.friendsList.delegate = self;
    self.friendsList.enableSelection = ![self isGroupEditing];
    self.friendsList.enableSectionTitles=YES;
    self.friendsList.enableInvite = NO;
    self.friendsList.selectedActionName = @"AddToGroup";
    self.friendsList.isTitleLabelHide = YES;
    self.friendsList.hideTickByDefault = ![self isGroupEditing];
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma Static Methods

-(BOOL)isGroupEditing{
    if(self.group_id > 0)
        return YES;
    return NO;
}

#pragma Methods

- (void)addTopBarView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle: [NSBundle mainBundle]];
    
    topBarView = [mainStoryboard instantiateViewControllerWithIdentifier:TOP_BAR_VIEW];
    [topBarView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self addChildViewController:topBarView];
    [self.view addSubview:topBarView.view];
    [topBarView didMoveToParentViewController:self];
    
    __block typeof(self) weakSelf = self;
    topBarView.homeAction = ^(void) {
        //        currentPageDownScroll = 0;
        //        currentPageUpScroll = 0;
        //        [weakSelf callAPIToGetTheComicsWithPageNumber:currentPageDownScroll + 1  andTimelinePeriod:@"" andDirection:@"" shouldClearAllData:YES];
        
        //        MainPageVC *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:MAIN_PAGE_VIEW];
        //        [weakSelf presentViewController:contactsView animated:YES completion:nil];
        
        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
        
        for (UIViewController *viewController in viewControllers)
        {
            if ([viewController isKindOfClass:[MainPageVC class]])
            {
                [weakSelf.navigationController popToViewController:viewController animated:YES];
            }
        }
        
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    topBarView.contactAction = ^(void) {
        //        ContactsViewController *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:CONTACTS_VIEW];
        //        [weakSelf presentViewController:contactsView animated:YES completion:nil];
        [AppHelper closeMainPageviewController:weakSelf];
    };
    topBarView.meAction = ^(void) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    topBarView.searchAction = ^(void) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle: [NSBundle mainBundle]];
        
        TopSearchVC *topSearchView = [mainStoryboard instantiateViewControllerWithIdentifier:TOP_SEARCH_VIEW];
        [topSearchView displayContentController:weakSelf];
        //        [weakSelf presentViewController:topSearchView animated:YES completion:nil];
    };
}


-(void)configViews{
    
    self.groupImage.layer.cornerRadius = 5.0;
    self.groupImage.layer.masksToBounds = YES;
    self.sectionDividerViewHolder.lblHeadText.text = @"Add Friends";
    self.sectionDividerViewHolder.lblHeadText.textAlignment = NSTextAlignmentLeft;
    
    CGRect lblRect = self.sectionDividerViewHolder.lblHeadText.frame;
    lblRect.origin.x = 38;
    self.sectionDividerViewHolder.lblHeadText.frame = lblRect;
    
    CGRect friendListRect = self.friendsList.view.frame;
    friendListRect.size.height = self.friendsList.frame.size.height;
    self.friendsList.view.frame = friendListRect;
    [self.friendsList.headerName setHidden:YES];
}

-(void)getGroupDetails{
    if (self.group_id < 0) {
        [self bindEmptyGroupDetails];
        return;
    }
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking getGroupDetailsByUserId:[NSString stringWithFormat: @"%ld", (long)self.group_id]
                               completion:^(id json,id jsonResposeHeader) {
                                   [self groupResponse:json];
    } ErrorBlock:^(JSONModelError *error) {
    }];
}

-(void)groupResponse:(NSDictionary *)response{
    UserGroup *objGroup = [[UserGroup alloc] init];
    [objGroup setValuesForKeysWithDictionary:response[@"data"]];
    
//    groupsDetails = [UserGroup arrayOfModelsFromDictionaries:response[@"data"]];
//    [self getGroupDetails];
    [self BindGroupDetails:objGroup];
    for (NSDictionary* gpMembers in objGroup.members) {
        if ([[gpMembers objectForKey:@"user_id"] isEqualToString:[AppHelper getCurrentLoginId]]) {
            self.friendsList.enableSelection = YES;
            break;
        }
    }
}

-(void)bindEmptyGroupDetails{
    
    [self.btnGroupIcon setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    self.btnGroupIcon.layer.cornerRadius = 4;
    self.btnGroupIcon.layer.borderWidth = 1.5;
    self.btnGroupIcon.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnGroupIcon.clipsToBounds = YES;
    [self.groupName setHidden:YES];
    
    [self.txtGroupName setHidden:NO];
    
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 10; ++i)
    {
        [temp addObject:@""];
    }
    
    [self.groupMembers refeshList:temp];
    temp = nil;
//    temp = nil;
    [self.friendsList getFriendsByUserId];
}

-(void)BindGroupDetails:(UserGroup*)ug{

    if (ug == nil)
        return;
    
    if (ug.group_icon != nil) {
        
        [self.groupImage sd_setImageWithURL:[NSURL URLWithString:ug.group_icon]
                            placeholderImage:[UIImage imageNamed:@"Placeholder"] options:SDWebImageRetryFailed];
        
//        [self.groupImage downloadImageWithURL:[NSURL URLWithString:ug.group_icon]
//                             placeHolderImage:[UIImage imageNamed:@"Placeholder"]
//                              completionBlock:^(BOOL succeeded, UIImage *image) {
//                                  self.groupImage.image = image;
//                              }];
        
//        [self.groupImage sd_setImageWithURL:[NSURL URLWithString:ug.group_icon]
//                           placeholderImage:[UIImage imageNamed:@"Placeholder"]
//                                  completed:^(UIImage *image, NSError *error,
//                                              SDImageCacheType cacheType, NSURL *imageURL) {
//                                  }];
    }

    self.groupName.text = ug.group_title;
    self.group_id = [ug.group_id integerValue];
    [self.txtGroupName setHidden:NO];
    self.txtGroupName.text = ug.group_title;
    [self.groupName setHidden:YES];
    
    //if it less than 10 it will bind with + icon
    if (ug.members && [ug.members count] < 10) {
        NSMutableArray* temp = [ug.members mutableCopy];
        for (NSInteger i = ug.members.count; i < 10; ++i)
        {
            [temp insertObject:@"" atIndex:i];
        }
        [self.groupMembers refeshList:temp];
        temp = nil;
    }else {
        [self.groupMembers refeshList:ug.members];
    }
    
    [self.friendsList getFriendsByUserId:ug.members];
    ug = nil;
}

//-(void)addFriendsToGroup:(UserFriends*)friendObj{
//    if (friendObj == nil) {
//        return;
//    }
//    
//    NSString* currentUserId = @"";
//    NSMutableDictionary* gmp = [[NSMutableDictionary alloc] init];
//    if ([friendObj isKindOfClass:[FriendSearchResult class]]) {
//        FriendSearchResult* fsr = (FriendSearchResult*)friendObj;
//        [gmp setObject:fsr.first_name forKey:@"first_name"];
//        [gmp setObject:fsr.last_name forKey:@"last_name"];
//        [gmp setObject:fsr.user_id forKey:@"user_id"];
//        currentUserId = fsr.user_id;
//        [gmp setObject:fsr.profile_pic forKey:@"profile_pic"];
//        [gmp setObject:@"" forKey:@"role"];
//        fsr = nil;
//    }else{
//        [gmp setObject:friendObj.first_name forKey:@"first_name"];
//        [gmp setObject:friendObj.last_name forKey:@"last_name"];
//        [gmp setObject:friendObj.friend_id forKey:@"user_id"];
//        currentUserId = friendObj.friend_id;
//        [gmp setObject:friendObj.profile_pic forKey:@"profile_pic"];
//        [gmp setObject:@"" forKey:@"role"];
//    }
//    
//    //To handle selection and deselection
//    if (self.groupMembers.groupsArray) {
//        BOOL isAdd = NO;
//        for (id dict in self.groupMembers.groupsArray) {
//            if (dict && ![dict isKindOfClass:[NSString class]]) {
//                if (![currentUserId isEqualToString:@""] &&
//                    [[dict objectForKey:@"user_id"] isEqualToString:currentUserId]) {
//                    [self.groupMembers.groupsArray removeObject:dict];
//                    isAdd = YES;
//                    break;
//                }
//            }
//        }
//        if (!isAdd) {
//            [self.groupMembers.groupsArray insertObject:gmp atIndex:0];
//        }
//        if ([[self.groupMembers.groupsArray
//              objectAtIndex:self.groupMembers.groupsArray.count - 1] isKindOfClass:[NSString class]]) {
//            [self.groupMembers.groupsArray removeLastObject];
//        }
//    }
//    [self.groupMembers refeshList];
//    gmp = nil;
//}

-(void)updateGroupIcon:(UIImage*)image{
    [self.btnGroupIcon setImage:nil forState:UIControlStateNormal];
    [self.btnGroupIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [self.groupImage setImage:nil];
    [self.groupImage setImage:image];
}


-(void)doCreateNewGroup
{
    if(self.groupImage.image == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please upload group pic"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }
    if([self.txtGroupName.text isEqualToString:@""] ||
       [[self.txtGroupName.text lowercaseString] isEqualToString:@"group name"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please enter group name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"];
    [userDic setObject:self.txtGroupName.text forKey:@"group_title"];
    [userDic setObject:[AppHelper encodeToBase64String:self.groupImage.image] forKey:@"group_icon"];
    [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"group_owner"];
    [userDic setObject:@"1" forKey:@"status"];
    [dataDic setObject:userDic forKey:@"data"];
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking createGroup:dataDic completion:^(id json,id jsonResposeHeader) {
        [self createGroupResponse:json];
    } ErrorBlock:^(JSONModelError *error) {
        
    }];
    dataDic = nil;
    userDic = nil;
}
-(void)doUpdateGroup{
    if(self.groupImage.image == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please upload group pic"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }
    if([self.txtGroupName.text isEqualToString:@""] ||
       [[self.txtGroupName.text lowercaseString] isEqualToString:@"group name"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please enter group name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    [userDic setObject:self.txtGroupName.text forKey:@"group_title"];
    [userDic setObject:[AppHelper encodeToBase64String:self.groupImage.image] forKey:@"group_icon"];
    [dataDic setObject:userDic forKey:@"data"];
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking updateGroup:dataDic Id:[NSString stringWithFormat:@"%li",(long)self.group_id]
                   completion:^(id json,id jsonResposeHeader) {
        [self createGroupResponse:json];
    } ErrorBlock:^(JSONModelError *error) {
        
    }];
    dataDic = nil;
    userDic = nil;
}
-(void)doAddMemmers{
    if(self.groupMembers.groupsArray)
    {
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
        NSMutableArray * temAttay = [[NSMutableArray alloc] init];
        for (NSDictionary* dict in self.groupMembers.groupsArray) {
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                NSDictionary *normalDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                            [dict objectForKey:@"user_id"],@"user_id",[dict objectForKey:@"role"],@"role",[dict objectForKey:@"status"],@"status",nil];
                [temAttay addObject:normalDict];
            }
        }
        //Add Current user as Admin/Owner
        NSDictionary *normalDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    [[AppHelper initAppHelper] getCurrentUser].user_id,@"user_id",GROUP_OWNER,@"role",@"1",@"status",nil];
        
        [temAttay addObject:normalDict];
        
        [userDic setObject:temAttay forKey:@"users"];
        [dataDic setObject:userDic forKey:@"data"];
        
        ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
        [cmNetWorking addRemoveUserFromGroup:dataDic
                                     GroupId:[NSString stringWithFormat: @"%ld", (long)self.group_id] completion:^(id json,id jsonResposeHeader) {
                                         [self addRemoveUserGroupResponse:json];
                                         [AppHelper showSuccessDropDownMessage:@"Added" mesage:@""];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     } ErrorBlock:^(JSONModelError *error) {
                                         NSLog(@"Error %@",error);
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }];
        dataDic = nil;
        userDic = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)isFriendsSearch:(UITextField*)txtField{
    if (txtField.tag == SEARCHTEXTFILES_TAG)
        return YES;
    
    return NO;
}

-(void)DoFriendsSearch :(NSString*)textValue{
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking searchById:textValue completion:^(id json,id jsonResposeHeader) {
        if (json) {
                 [self.friendsList searchFriendsById:[FriendSearchResult
                                                      arrayOfModelsFromDictionaries:json[@"data"]]];
        }
    } ErrorBlock:^(JSONModelError *error) {
    }];
}

#pragma Events

- (IBAction)backButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)btnAddClick:(id)sender
{
    if(self.group_id < 0)
    {
        //do Create Group
        [self doCreateNewGroup];
        return;
    }
    else
    {
        [self doUpdateGroup];
    }
}

- (IBAction)btnGroupIconClick:(id)sender {
    @autoreleasepool {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                                 delegate: self
                                                        cancelButtonTitle: @"Cancel"
                                                   destructiveButtonTitle: nil
                                                        otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
        [actionSheet showInView:self.view];
    }
}

- (IBAction)btnSearchFriendClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SearchViewController *controller = (SearchViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Search"];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark actionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    UIImage* selectedImage = [info valueForKey: UIImagePickerControllerOriginalImage];
    selectedImage = [AppHelper imageWithImage:selectedImage scaledToSize:self.groupImage.frame.size];
    [self updateGroupIcon:selectedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self isFriendsSearch:textField] &&
        [[textField.text lowercaseString] isEqualToString:@"search to add friends"]){
        textField.text = @"";
    }else if([[textField.text lowercaseString] isEqualToString:@"group name"])
    {
        textField.text = @"";
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self isFriendsSearch:textField] &&
        [[textField.text lowercaseString] isEqualToString:@""]){
        textField.text = @"search to add friends";
    }else if([[textField.text lowercaseString] isEqualToString:@""])
    {
        textField.text = @"group name";
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self isFriendsSearch:textField]) {
        [self DoFriendsSearch:textField.text];
    }else if([[textField.text lowercaseString] isEqualToString:@""])
    {
        textField.text = @"Group Name";
    }
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark FriendsList Delegate

-(void)selectedRow:(id)object param:(UserFriends*)friendObj{
    if (friendObj == nil) {
        return;
    }
    
    NSString* currentUserId = @"";
    NSMutableDictionary* gmp = [[NSMutableDictionary alloc] init];
    if ([friendObj isKindOfClass:[FriendSearchResult class]]) {
        FriendSearchResult* fsr = (FriendSearchResult*)friendObj;
        [gmp setObject:fsr.first_name forKey:@"first_name"];
        [gmp setObject:fsr.last_name forKey:@"last_name"];
        [gmp setObject:fsr.user_id forKey:@"user_id"];
        currentUserId = fsr.user_id;
        [gmp setObject:@"1" forKey:@"status"];
        [gmp setObject:fsr.profile_pic forKey:@"profile_pic"];
        if ([fsr.user_id isEqualToString:[[AppHelper initAppHelper] getCurrentUser].user_id]) {
            [gmp setObject:GROUP_OWNER forKey:@"role"];
        }else{
            [gmp setObject:GROUP_MEMBER forKey:@"role"];
        }
        
        fsr = nil;
    }else{
        [gmp setObject:friendObj.first_name forKey:@"first_name"];
        [gmp setObject:friendObj.last_name forKey:@"last_name"];
        [gmp setObject:friendObj.friend_id forKey:@"user_id"];
        currentUserId = friendObj.friend_id;
        [gmp setObject:friendObj.profile_pic forKey:@"profile_pic"];
        [gmp setObject:@"1" forKey:@"status"];
        if ([friendObj.friend_id isEqualToString:[[AppHelper initAppHelper] getCurrentUser].user_id]) {
            [gmp setObject:GROUP_OWNER forKey:@"role"];
        }else{
            [gmp setObject:GROUP_MEMBER forKey:@"role"];
        }
    }
    
    //To handle selection and deselection
    if (self.groupMembers.groupsArray) {
//        [self.groupMembers.groupsTempArray removeAllObjects];
        self.groupMembers.groupsTempArray = [self.groupMembers.groupsArray mutableCopy];
        BOOL isAdd = NO;
        int i =0;
        for (id dict in self.groupMembers.groupsArray) {
            if (dict && ![dict isKindOfClass:[NSString class]]) {
                if ([[dict objectForKey:@"user_id"] isEqualToString:[gmp objectForKey:@"user_id"]]) {
                    NSMutableDictionary* mDict = [dict mutableCopy];
                    if ([[dict objectForKey:@"status"] isEqualToString:@"1"]) {
                        [mDict setObject:@"0" forKey:@"status"];
                    }else{
                        [mDict setObject:@"1" forKey:@"status"];
                    }
                    [self.groupMembers.groupsArray replaceObjectAtIndex:[self.groupMembers.groupsArray indexOfObject:dict] withObject:mDict];
//                    [self.groupMembers.groupsTempArray removeObjectAtIndex:[self.groupMembers.groupsArray indexOfObject:mDict]];
                    isAdd = YES;
                    break;
                }
            }
            i = i + 1;
        }
        if (!isAdd) {
            [self.groupMembers.groupsArray insertObject:gmp atIndex:0];
//            [self.groupMembers.groupsTempArray insertObject:gmp atIndex:0];
        }
        if ([[self.groupMembers.groupsArray
              objectAtIndex:self.groupMembers.groupsArray.count - 1] isKindOfClass:[NSString class]]) {
            [self.groupMembers.groupsArray removeLastObject];
//            [self.groupMembers.groupsTempArray removeLastObject];
        }
    }
//    NSMutableArray* tempArray = [self.groupMembers.groupsTempArray copy];
    [self.groupMembers.groupsTempArray removeAllObjects];
    for (int i =0; i < [self.groupMembers.groupsArray count] ; i++) {
        if ([self.groupMembers.groupsArray objectAtIndex:i] &&
            ![[self.groupMembers.groupsArray objectAtIndex:i] isKindOfClass:[NSString class]])
        {
            if ([[[self.groupMembers.groupsArray objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"1"]) {
                [self.groupMembers.groupsTempArray addObject:[self.groupMembers.groupsArray objectAtIndex:i]];
            }
        }
    }
    [self.groupMembers refeshList];
    gmp = nil;
}
//-(void)selectedRow:(id)object param:(id)objectList{
//    
//    GroupUserItems* uf = (GroupUserItems*)object;
//    
//    NSMutableDictionary*  usersList = [[NSMutableDictionary alloc] init];
//    
//    [usersList setObject:uf.user_id forKey:@"user_id"];
//    [usersList setObject:uf.status forKey:@"status"];
//    [usersList setObject:uf.role forKey:@"role"];
//    
//    if(groupAddArray == nil)
//    {
//        groupAddArray = [[NSMutableArray alloc] init];
//    }
//    [groupAddArray addObject:usersList];
//    uf = nil;
//    
//    [self addFriendsToGroup:objectList];
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset withTableView:(UITableView *)tableView
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView withTableView:(UITableView *)tableView
{
    
}

#pragma mark Api Delegate

-(void)comicNetworking:(id)sender postFailResponse:(NSDictionary *)response{
    [self.friendsList getFriendsByUserId];
}

-(void)createGroupResponse:(NSDictionary *)response
{
    if(response && [[response objectForKey:@"result"] isEqualToString:@"success"])
    {
        GroupCreate *gc = (GroupCreate*)[[GroupCreate alloc] initWithDictionary:response[@"data"] error:nil];
        if(gc)
        {
            self.groupName.text = gc.group_title;
            self.group_id = [gc.group_id integerValue];
            if ( self.group_id > 0) {
                [self doAddMemmers];
            }
        }
    }
    
}
-(void)addRemoveUserGroupResponse:(NSDictionary *)response
{
    if(response && [[response objectForKey:@"result"] isEqualToString:@"success"])
    {
        [self getGroupDetails];
    }
}

#pragma mark - statusbar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
