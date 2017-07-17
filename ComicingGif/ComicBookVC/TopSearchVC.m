//
//  TopSearchVC.m
//  CurlDemo
//
//  Created by Ramesh on 18/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "TopSearchVC.h"
#import "ContactsViewController.h"
#import "CameraViewController.h"
#import "MePageVC.h"
#import "Constants.h"
#import "FriendsAPIManager.h"
#import "DateLabel.h"
#import "UserSearch.h"
#import "UIImageView+WebCache.h"
#import "MainPageVC.h"
#import "AppHelper.h"
#import "FriendPageVC.h"
#import "AppDelegate.h"
#import "MainPageGroupViewController.h"
#import "PrivateConversationViewController.h"

const int blurViewTag = 1010;

@interface TopSearchVC () <UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation TopSearchVC

- (void)viewDidLoad {
    
    [self addTopBarView];
    [self addBlurEffectOverImageView];
    self.tableview.delegate = self;
    
        //dinesh
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewSingleTap:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.delegate = self;
        tapGesture.accessibilityValue = @"temp";
        [self.tableview addGestureRecognizer:tapGesture];
        //------
    
    [super viewDidLoad];
    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"SearchView" Attributes:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// write this method in MainViewController
- (void) displayContentController: (UIViewController*) parentViewContent
{
    [parentViewContent addChildViewController:self];                 // 1
    self.view.bounds = parentViewContent.view.bounds;                 //2
    [parentViewContent.view addSubview:self.view];
    [parentViewContent didMoveToParentViewController:parentViewContent];          // 3
    [parentViewContent.view bringSubviewToFront:self.view];
    
    [self.view setAlpha:0.0f];
    //fade in
    [UIView animateWithDuration:2.0f animations:^{
        [self.view setAlpha:1.0f];
    } completion:^(BOOL finished) {
    }];
    if ([parentViewContent isKindOfClass:[MainPageVC class]])
    {
        _topBarView.isHomeHidden = YES;
    }
    else
    {
        _topBarView.isHomeHidden = NO;
    }
}

//you can also write this method in MainViewController to remove the child VC you added before.
- (void) hideContentController
{
    //fade out
    [UIView animateWithDuration:2.0f animations:^{
        [self.view setAlpha:0.0f];
        [[self.parentViewController.view viewWithTag:blurViewTag] setAlpha:0.0];
    } completion:^(BOOL finished) {
        [[self.parentViewController.view viewWithTag:blurViewTag] removeFromSuperview];
        [self willMoveToParentViewController:nil];  // 1
        [self.view removeFromSuperview];            // 2
        [self removeFromParentViewController];      // 3
    }];
    
    
}

- (IBAction)tappedBackButton:(id)sender {
    [self hideContentController];
}

#pragma mrak - user events

- (void)tableViewSingleTap: (UITapGestureRecognizer *)gesture
{
    [self.parentViewController.view endEditing:YES];
    [self hideContentController];
    
    //    for (id view in topBarView.mSearchBarHolderView.subviews)
    //    {
    //        if ([view isKindOfClass:[UITextField class]] && [(UITextField *)view isEditing])
    //        {
    //            [self.parentViewController.view endEditing:YES];
    //            [self hideContentController];
    //
    //            return;
    //        }
    //    }
    
    //    if (topBarView.isEditing)
    //    {
    //        [self.parentViewController.view endEditing:YES];
    //        [self hideContentController];
    //    }
}

#pragma mark Methods

- (void)addTopBarView {
    _topBarView = [self.storyboard instantiateViewControllerWithIdentifier:TOP_BAR_VIEW];
    CGFloat heightOfTopBar;
    CGFloat heightOfNavBar = 44;

    if (IS_IPHONE_5)
    {
        heightOfTopBar = heightOfNavBar+6;
    }
    else if(IS_IPHONE_6)
    {
        heightOfTopBar = heightOfNavBar+9;
    }
    else if (IS_IPHONE_6P)
    {
        heightOfTopBar = heightOfNavBar+10;
    }
    else
    {
        heightOfTopBar = heightOfNavBar+6;
    }
    [_topBarView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, heightOfTopBar)];
    [self addChildViewController:_topBarView];
    [self.view addSubview:_topBarView.view];
    [_topBarView didMoveToParentViewController:self];
    
    //__block typeof(self) weakSelf = self;
    __weak TopSearchVC *weakSelf = self;
    
    _topBarView.homeAction = ^(void) {
        if ([weakSelf.parentViewController isKindOfClass:[MainPageGroupViewController class]]||[weakSelf.parentViewController isKindOfClass:[PrivateConversationViewController class]])
        {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
        MainPageVC *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:MAIN_PAGE_VIEW];
        //        [weakSelf presentViewController:contactsView animated:YES completion:nil];
        [weakSelf.navigationController pushViewController:contactsView animated:YES];
        }
    };
    
    _topBarView.contactAction = ^(void) {
        //        ContactsViewController *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:CONTACTS_VIEW];
        //        [weakSelf presentViewController:contactsView animated:YES completion:nil];
        [AppHelper closeMainPageviewController:weakSelf];
    };
    _topBarView.meAction = ^(void) {
        MePageVC *meView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:ME_VIEW_SEGUE];
        //        [weakSelf presentViewController:meView animated:YES completion:nil];
        [weakSelf.navigationController pushViewController:meView animated:YES];
    };
    _topBarView.searchAction = ^(void) {
        [weakSelf.topBarView handleSearchControl:YES];
    };
    _topBarView.searchUser = ^(NSString* searchText){
        //        [topBarView handleSearchControl:YES];
        [weakSelf doSearchUser:searchText];
    };
    
    //By default handle textSearch
    [_topBarView handleSearchControl:YES];
}
-(void) addBlurEffectOverImageView{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.view.bounds;
    visualEffectView.tag = blurViewTag;
    
    [self.parentViewController.view addSubview:visualEffectView];
    [visualEffectView setAlpha:0.0f];
    
    [UIView animateWithDuration:1.0f animations:^{
        [visualEffectView setAlpha:1.0f];
    } completion:^(BOOL finished) {
    }];
}


#pragma mark .

-(void)doSearchUser:(NSString*)txtSearch{
    
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"UserSearch" Action:txtSearch Label:@""];
    
    [FriendsAPIManager getTheListOfFriendsByID:txtSearch withSuccessBlock:^(id object) {
        self.searchResultArray = [MTLJSONAdapter modelsOfClass:[UserSearch class] fromJSONArray:[object valueForKey:@"data"] error:nil];
        [self.tableview reloadData];
    } andFail:^(NSError *errorMessage) {
        NSLog(@"%@", errorMessage);
    }];
    
    //    __block typeof(self) weakSelf = self;
    //    FriendPageVC *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:FRIEND_PAGE_VIEW];
    //    [weakSelf.navigationController pushViewController:contactsView animated:YES];
}

#pragma mark TableViewDelegate

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    if (self.searchResultArray.count > 0)
    //    {
    //        UITapGestureRecognizer *_tapGesture = nil;
    //        for (UIGestureRecognizer *gesture in self.tableview.gestureRecognizers)
    //        {
    //            if ([gesture isKindOfClass:[UITapGestureRecognizer class]] && [gesture.accessibilityValue isEqualToString:@"temp"])
    //            {
    //                _tapGesture = (UITapGestureRecognizer *)gesture;
    //            }
    //        }
    //
    //        [tableView removeGestureRecognizer:_tapGesture];
    //    }
    //    else
    //    {
    //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewSingleTap:)];
    //        tapGesture.numberOfTapsRequired = 1;
    //        tapGesture.delegate = self;
    //        tapGesture.accessibilityValue = @"temp";
    //        [self.tableview addGestureRecognizer:tapGesture];
    //    }
    
    return [self.searchResultArray count];
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    for (id view in _topBarView.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]] && [(UITextField *)view isEditing] && self.searchResultArray.count == 0)
        {
            return YES;
        }
    }
    
    
    CGPoint location = [touch locationInView:touch.view];
    NSIndexPath *tappedIndexPath = [self.tableview indexPathForRowAtPoint:location];

    if(!tappedIndexPath)
    {
        return YES;
    }
    
    return NO;
    
    
    //    if ([touch.view isDescendantOfView:self.tableview]) {
    //
    //        // Don't let selections of auto-complete entries fire the
    //        // gesture recognizer
    //        return NO;
    //    }
    
    //return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.friendSearchObject = self.searchResultArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Profile Pic
    UIImageView*imageView=(UIImageView*)[cell viewWithTag:1];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.friendSearchObject.profilePic]];
    imageView.layer.cornerRadius =  imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
    imageView.layer.masksToBounds=YES;
    
    //Profile Name
    UILabel*labl=(UILabel*)[cell viewWithTag:2];
    labl.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    labl.text = [NSString stringWithFormat:@"%@ %@",self.friendSearchObject.firstName,self.friendSearchObject.lastName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"SearchResult" Action:@"ResultFaceClick" Label:@""];
    
   self.friendSearchObject = self.searchResultArray[indexPath.row];
    
    Friend *friend = [[Friend alloc] init];
    friend.country = self.friendSearchObject.country;
    friend.dob = self.friendSearchObject.dob;
    friend.email = self.friendSearchObject.email;
    friend.firstName = self.friendSearchObject.firstName;
    friend.lastName = self.friendSearchObject.lastName;
    friend.mobile = self.friendSearchObject.mobile;
    friend.profilePic = self.friendSearchObject.profilePic;
    friend.status = self.friendSearchObject.status;
    friend.userId = self.friendSearchObject.userId;
    friend.userType = self.friendSearchObject.userTypeId;
    friend.loginId = self.friendSearchObject.loginId;
    friend.fb_id = self.friendSearchObject.fb_id;
    friend.insta_id = self.friendSearchObject.insta_id;
    friend.desc = self.friendSearchObject.desc;
    
    [AppDelegate application].dataManager.friendObject = friend;
    
    //[self performSegueWithIdentifier:@"FriendPageSegue" sender:indexPath];
    
        __block typeof(self) weakSelf = self;
        FriendPageVC *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:FRIEND_PAGE_VIEW];
    NSLog(@"%@",NSStringFromClass([weakSelf.parentViewController class]));
        [weakSelf.parentViewController.navigationController pushViewController:contactsView animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - statusbar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
