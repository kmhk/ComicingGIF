//
//  SendPageViewController.m
//  ComicApp
//
//  Created by Ramesh on 27/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "SendPageViewController.h"
#import "ComicPage.h"
#import "searchFriendView.h"
#import "ComicMakingViewController.h"
#import "GlideScrollViewController.h"
@interface
SendPageViewController ()<UITextFieldDelegate>
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIView *viewPrivate;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteFrnd;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet searchFriendView *viewSearchList;

@property CGRect frameFriendListView;
@property CGRect frameSearchView;
@property CGRect frameViewPublic;
@property CGRect frameViewShare;
@property CGRect frameViewPrivate;
@property CGRect frameLblFriend;
@property CGRect frameViewSearchFriendList;

@property CGFloat heightOfFriendlist;
@property CGFloat heightOfViewPrivate;
@property CGFloat positionYoflblFriends;

@property BOOL isSearchEnable;
@property BOOL isInvitefriendListOpen;
@end

@implementation SendPageViewController

@synthesize viewPrivate,viewInviteSuper,lastContentOffset,frameFriendListView,frameViewShare,frameSearchView,frameViewPublic,frameLblFriend,heightOfViewPrivate,heightOfFriendlist,positionYoflblFriends,txtSearch,frameViewSearchFriendList,isInvitefriendListOpen;

#define FB 10
#define IM 11
#define TW 12
#define IN 13

- (void)viewDidLoad
{
    
   // [self configViews];
    [self configText];
    [super viewDidLoad];
    
    frameViewShare = _viewShare.frame;
    frameViewPublic = _viewPublic.frame;
    frameSearchView = _viewSearch.frame;
    frameFriendListView = _friendsListView.frame;
    _frameViewPrivate = viewPrivate.frame;
    frameLblFriend = _lblFriends.frame;
    frameViewSearchFriendList = _viewSearchList.frame;
    
    txtSearch.delegate = self;
    
    heightOfViewPrivate = viewPrivate.frame.size.height + _viewShare.frame.size.height+_viewPublic.frame.size.height;
    
    heightOfFriendlist = heightOfViewPrivate - 50;
    
    positionYoflblFriends = _viewPrivateTop.frame.size.height + 20;
    
    // Do any additional setup after loading the view from its nib.
    [self hideInviteView];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
    self.friendsListView.enableSectionTitles = NO;
    self.friendsListView.enableSelection = YES;
    self.friendsListView.delegate = self;
    self.friendsListView.hideTickByDefault = YES;
    self.groupsView.delegate = self;
    self.viewInvite.delegate = self;
    self.groupsView.enableSelection= YES;
    
    [self.friendsListView getFriendsByUserId];
    [self bindComicImages];

    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"SendPage" Attributes:nil];
}


//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)hideInviteView
{
    CGRect frame = viewInviteSuper.frame;
    
    frame.origin.y = viewPrivate.frame.origin.y + viewPrivate.frame.size.height;
    
    viewInviteSuper.frame = frame;
    
}

- (void)viewDidAppear:(BOOL)animated
{

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Methods

-(void)configViews{

    [self.headerView.btn1 setImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
    [self.headerView.btn3 setImage:[UIImage imageNamed:@"smile.png"] forState:UIControlStateNormal];
    CGRect frame = self.headerView.btn3.frame;
//    frame.size = CGSizeMake(34, 34);
    frame = CGRectMake(frame.origin.x + 8, frame.origin.y + 5, 34, 34);
    self.headerView.btn3.frame = frame;
    
    frame = self.headerView.btn1.frame;
    frame.size = CGSizeMake(24, 34);
    self.headerView.btn1.frame = frame;
    
    frame =  self.friendsListView.headerName.frame;
    frame.origin.x = 20;
    self.friendsListView.headerName.frame = frame;
    
    frame = self.friendsListView.tableHolderView.frame;
    frame.origin.y = frame.origin.y - 5;
    self.friendsListView.tableHolderView.frame = frame;
    
    CGRect friendListRect = self.friendsListView.view.frame;
    friendListRect.size.height = self.friendsListView.frame.size.height;
    self.friendsListView.view.frame = friendListRect;
    
    frame = self.groupsView.frame;
    frame.size.height = 87;
    self.groupsView.frame = frame;
    
    frame = self.groupsView.groupCollectionView.frame;
    frame.origin.x = 0;
    frame.size.height = 87;
    self.groupsView.groupCollectionView.frame = frame;
}
-(void)configText
{
    if (IS_IPHONE_5)
    {
        [self.lblGroup setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:15]];
        [self.lblFriends setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:15]];
    }
    else if (IS_IPHONE_6)
    {
        [self.lblGroup setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:17]];
        [self.lblFriends setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:17]];
    }
    else if (IS_IPHONE_6P)
    {
        [self.lblGroup setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:20]];
        [self.lblFriends setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:20]];
    }
    else
    {
        [self.lblGroup setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:15]];
        [self.lblFriends setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:15]];
    }
    
   
    
    
    
    
    
    
    [self.friendsListView.headerName setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:12]];
    self.friendsListView.headerName.text = @"Best friends";
    [self.friendsListView.headerName setTextColor:[UIColor colorWithHexStr:@"231f20"]];
    
}

-(NSDictionary*)getGroupShares:(UserGroup*) ug{
    @autoreleasepool {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        if(ug)
        {
            [dict setValue:ug.group_id forKey:@"group_id"];
            [dict setValue:@"1" forKey:@"status"];
        }
        return dict;
    }

}

-(NSDictionary*)getFriendsShares:(UserFriends*) uf{
    @autoreleasepool {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        if(uf)
        {
            [dict setValue:uf.friend_id forKey:@"friend_id"];
            [dict setValue:@"1" forKey:@"status"];
        }
        return dict;
    }
}

-(void)generateGroupShareArray:(UserGroup*)ug
{
    if(shareGroupsArray == nil)
        shareGroupsArray = [[NSMutableArray alloc] init];
    if(ug)
    {
        if ([shareGroupsArray containsObject:[self getGroupShares:ug]])
        {
            [shareGroupsArray removeObject:[self getGroupShares:ug]];
        }
        else
        {
            [shareGroupsArray addObject:[self getGroupShares:ug]];

        }
    }
}

-(void)generateFriendShareArray:(UserFriends*)uf
{
    if(shareFriendsArray == nil)
        shareFriendsArray = [[NSMutableArray alloc] init];
    if(uf)
    {
        [shareFriendsArray addObject:[self getFriendsShares:uf]];
    }
}
-(NSMutableDictionary*)setPutParamets{
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
        [userDic setObject:[AppHelper getCurrentcomicId] forKey:@"comic_id"];
        [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"];
        if(shareGroupsArray){
            [userDic setObject:shareGroupsArray forKey:@"groupShares"];
        }
        if (shareFriendsArray) {
            [userDic setObject:shareFriendsArray forKey:@"friendShares"];
        }
        [dataDic setObject:userDic forKey:@"data"];
        return dataDic;
}

-(void)doSendData
{
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    //i d't know what is 3 .. need to confirm with Shy
    [cmNetWorking shareComicImage:[self setPutParamets] Id:[AppHelper getCurrentcomicId] completion:^(id json,id jsonResposeHeader)
    {
        [self clearNavStack];
        
    } ErrorBlock:^(JSONModelError *error)
    {
        NSLog(@"Share Error %@",error);
    }];
    
}

-(void)doShareTo :(ShapeType)type ShareImage:(UIImage*)imgShareto{
    
    NSData *imageData = UIImagePNGRepresentation(imgShareto);
    UIImage *image=[UIImage imageWithData:imageData];
    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    //Just to test
    
//     UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//     NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//     NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
//     [imageData writeToFile:filePath atomically:YES]; //Write the file
//    NSLog(@"Log %@",filePath);
    
    
    /* Commented for testing*/
    ShareHelper* sHelper = [ShareHelper shareHelperInit];
    sHelper.parentviewcontroller = self;
    [sHelper shareAction:type ShareText:@""
              ShareImage:image
              completion:^(BOOL status) {
              }];
    
}

#pragma mark : Events
- (IBAction)btnInviteFriendsTap:(id)sender
{
    CGRect frame =   viewInviteSuper.frame;
    
    frame.origin.y = viewPrivate.frame.origin.y;
     viewInviteSuper.frame = frame;
    
    frame = viewPrivate.frame;
    frame.origin.y = self.view.frame.size.height;
    
    [UIView animateWithDuration:0.6 animations:^
    {
        viewPrivate.frame = frame;
    }
    completion:^(BOOL finished)
    {
        _btnInviteFrnd.userInteractionEnabled = NO;
    }];
}

- (IBAction)btnPostTap:(UIButton *)sender
{
    if(sender.isSelected == NO)
    {
        sender.selected = YES;
        
        sender.backgroundColor = [UIColor colorWithHexStr:@"#31ADE1"];
        sender.layer.cornerRadius = CGRectGetHeight(sender.frame) / 2 - CGRectGetHeight(sender.frame) / 4;
        sender.layer.masksToBounds = YES;
    
    }
    else
    {
        sender.selected = NO;
        
        sender.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)btnCloseInviteView:(id)sender
{
    [UIView animateWithDuration:0.6 animations:^
     {
        // [self hideInviteView];
         viewPrivate.frame = _frameViewPrivate;
     }
                     completion:^(BOOL finished)
     {
         _btnInviteFrnd.userInteractionEnabled = YES;
     }];
}

- (IBAction)backButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEveryOnceClick:(id)sender {
    
    //do loop for the group
    if (self.groupsView.groupsArray) {
        for (UserGroup* ug in self.groupsView.groupsArray) {
            [self generateGroupShareArray:ug];
        }
    }
    //do loop for the Friends
    if (self.friendsListView.friendsArray) {
        for (UserFriends* uf in self.friendsListView.friendsArray) {
            [self generateFriendShareArray:uf];
        }
    }
    [self doSendData];
}

- (IBAction)btnShareComic:(id)sender
{
    [self doSendData];
}

- (IBAction)btnShareToSocialMedia:(id)sender {
    switch (((UIButton*)sender).tag) {
        case FB:
        {
            
//            [self doShareTo:FACEBOOK ShareImage:[self.comicShareViewView getComicShareImage:@[[UIImage imageNamed:@"Glide-1"],
//                                                                                             [UIImage imageNamed:@"Glide-2"],
//                                                                                             [UIImage imageNamed:@"Glide-3"]]]];
            
            [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"SendPage-ShareToSocialMedia" Action:@"FACEBOOK" Label:@""];
            [self doShareTo:FACEBOOK ShareImage:[self.comicShareViewView getComicShareImage:imageArray]];
        }
            break;
        case IM:
        {
            [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"SendPage-ShareToSocialMedia" Action:@"MESSAGE" Label:@""];
            [self doShareTo:MESSAGE ShareImage:[self.comicShareViewView getComicShareImage:imageArray]];
        
            break;
        }
        case TW:
        {
            [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"SendPage-ShareToSocialMedia" Action:@"TWITTER" Label:@""];
            [self doShareTo:TWITTER ShareImage:[self.comicShareViewView getComicShareImage:imageArray]];
        }
            break;
        case IN:
        {
//            [self doShareTo:INSTAGRAM ShareImage:[self.comicShareViewView getComicShareImage:@[[UIImage imageNamed:@"Image_Slide1"]]]];
            
            [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"SendPage-ShareToSocialMedia" Action:@"INSTAGRAM" Label:@""];
            [self doShareTo:INSTAGRAM ShareImage:[self.comicShareViewView getComicShareImage:imageArray]];
                        break;
        }
        default:
            break;
    }
}

-(void)bindComicImages{
    imageArray = [[NSMutableArray alloc] init];
    
    NSMutableArray* comicSlides = [AppHelper getDataFromFile:@"ComicSlide"];
    //[[[NSUserDefaults standardUserDefaults] objectForKey:@"comicSlides"] mutableCopy];
    for (NSData* data in comicSlides) {
        ComicPage* cmPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //ComicSlides Object
        [imageArray  addObject:[AppHelper getImageFile:cmPage.printScreenPath]];
    }
    //    [imageArray addObject:@"01.png"];
    //    [imageArray addObject:@"02.png"];
    //    [imageArray addObject:@"03.png"];
    //    [imageArray addObject:@"04.png"];
    
//    [self.comicImageList refeshList:imageArray];
    comicSlides = nil;
    //    imageArray = nil;
}

- (IBAction)btnShareToPublic:(id)sender {

    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    [userDic setObject:[AppHelper getCurrentcomicId] forKey:@"comic_id"];
    [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"];
    [userDic setObject:@"1" forKey:@"is_public"];
    [dataDic setObject:userDic forKey:@"data"];
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    //i d't know what is 3 .. need to confirm with Shy
    [cmNetWorking shareComicImage:dataDic Id:[AppHelper getCurrentcomicId]
                       completion:^(id json,id jsonResposeHeader) {
                           
                           [self clearNavStack];
                           
                           
    } ErrorBlock:^(JSONModelError *error) {
        
    }];
}

-(void)clearNavStack
{
    if (self.comicSlideFileName) {
        [AppHelper deleteSlideFile:self.comicSlideFileName];
    }
    
    NSArray* navArray = [self.navigationController viewControllers];
    for (UIViewController* viewControll in navArray) {
        if ([viewControll isKindOfClass:[ComicMakingViewController class]]) {
            [viewControll removeFromParentViewController];
            break;
        }
        if ([viewControll isKindOfClass:[GlideScrollViewController class]]) {
            [viewControll removeFromParentViewController];
            break;
        }
        if ([viewControll isKindOfClass:[SendPageViewController class]]) {
            [viewControll removeFromParentViewController];
            break;
        }
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    GlideScrollViewController *controller = (GlideScrollViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"glidenavigation"];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark GroupList Delegate
-(void)selectGroupItems:(id)object
{
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"SendPage" Action:@"GroupShare" Label:@""];
    UserGroup* ug = (UserGroup*)object;
    if(ug)
        [self generateGroupShareArray:ug];
}

#pragma mark FriendsList Delegate
-(void)selectedRow:(id)object
{
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"SendPage" Action:@"FriendsShare" Label:@""];
    UserFriends* uf = (UserFriends*)object;
    if(uf)
        [self generateFriendShareArray:uf];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView withTableView:(UITableView *)tableView
{
    NSLog(@"%f",scrollView.contentOffset.y);

    CGFloat yVelocity = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
    if (yVelocity < 0)
    {
        NSLog(@"Up");
        
        if (!_isSearchEnable)
        {
            if (isInvitefriendListOpen == NO)
            {
                tableView.scrollEnabled = NO;
                scrollView.scrollsToTop = YES;
                // _viewShare
                // _viewSearch
                
                isInvitefriendListOpen = YES;
                [UIView animateWithDuration:0.6 animations:^{
                     CGRect frame = _friendsListView.frame;
                     
//                     frame = _viewSearch.frame;
//                     frame.origin.y = _comicImageList.frame.size.height;
//                     _viewSearch.frame = frame;
                    
                     frame = _viewShare.frame;
                     frame.origin.y = frame.origin.y - _viewShare.frame.size.height;
                     _viewShare.frame = frame;
                     
//                     frame = viewPrivate.frame;
//                     frame.origin.y = _comicImageList.frame.size.height + _viewSearch.frame.size.height;
//                     frame.size.height = heightOfViewPrivate;
//                     viewPrivate.frame = frame;
                    
                     frame = _lblFriends.frame;
                     frame.origin.y = positionYoflblFriends;
                     _lblFriends.frame = frame;
                     
                     frame =  _friendsListView.frame;
                     frame.origin.y = _lblFriends.frame.origin.y + _lblFriends.frame.size.height;
                     frame.size.height = heightOfFriendlist;
                     _friendsListView.frame = frame;
                     
                     _lblGroup.hidden = YES;
                     
                     _friendsListView.enableSectionTitles = YES;
                 }completion:^(BOOL finished) {
                     [_friendsListView.friendsListTableView reloadData];
                     
                     tableView.scrollEnabled = YES;
                 }];

            }
            else
            {
                tableView.scrollEnabled = YES;

            }
            
            
        }
    }
    else if (yVelocity > 0)
    {
        NSLog(@"Down");
        
        if (_isSearchEnable == NO)
        {
            if (isInvitefriendListOpen)
            {
                if (scrollView.contentOffset.y < 40)
                {
                    [UIView animateWithDuration:0.3 animations:^
                    {
                        _viewSearch.frame = frameSearchView;
                        _viewShare.frame = frameViewShare;
                        viewPrivate.frame = _frameViewPrivate;
                        _lblFriends.frame = frameLblFriend;
                        _friendsListView.frame = frameFriendListView;

                    }completion:^(BOOL finished)
                    {
                        _lblGroup.hidden = NO;
                        isInvitefriendListOpen = NO;
                        _friendsListView.enableSectionTitles = NO;
                        [_friendsListView.friendsListTableView reloadData];
                        tableView.scrollEnabled = YES;
                        
                    }];
                }
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset withTableView:(UITableView *)tableView
{

}

#pragma mark : InviteFriendsViewDelegate Methods

-(void)openMessageComposer:(NSArray*)sendNumbers messageText:(NSString*)messageTextValue
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = messageTextValue;
        
        if (sendNumbers != nil)
        {
            controller.recipients = sendNumbers;
        }
        
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            _btnInviteFrnd.userInteractionEnabled = YES;

            
            [self searchButtonAnimationStop];

            break;
        case MessageComposeResultSent:
            _btnInviteFrnd.userInteractionEnabled = YES;

            [self searchButtonAnimationStop];
            break;
        default:
            break;
    }
    
        [self dismissViewControllerAnimated:YES completion:^{
        }];
}


#pragma mark Api Delegate

-(void)comicNetworking:(id)sender postFailResponse:(NSDictionary *)response{
    
}
-(void)comicNetworking:(id)sender postShareComicResponse:(NSDictionary *)response
{
    NSLog(@"Share Sucess");
}

#pragma mark : UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
        //animation
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    
    _friendsListView.enableSectionTitles = NO;
    _isSearchEnable = YES;
    
    [UIView animateWithDuration:0.6 animations:^
     {
         CGRect frame = _friendsListView.frame;
         
//         frame = _viewSearch.frame;
//         frame.origin.y = _comicImageList.frame.size.height + 5;
//         _viewSearch.frame = frame;
         
         frame = _viewShare.frame;
         frame.origin.y = frame.origin.y - _viewShare.frame.size.height;
         _viewShare.frame = frame;
         
//         frame = viewPrivate.frame;
//         frame.origin.y = _comicImageList.frame.size.height + _viewSearch.frame.size.height;
//         frame.size.height = heightOfViewPrivate;
//         viewPrivate.frame = frame;
         
         frame = _lblFriends.frame;
         frame.origin.y = positionYoflblFriends;
         _lblFriends.frame = frame;
         
         frame =  _friendsListView.frame;
         frame.origin.y = 0;
         frame.size.height = heightOfFriendlist - CGRectGetHeight(keyboardFrame) + 70;
         _friendsListView.frame = frame;
         
         _lblGroup.hidden = YES;
         _lblFriends.hidden = YES;
         
     }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self searchButtonAnimationStop];
    
    [_friendsListView searchFriendByString:@""];
    [_friendsListView.friendsListTableView reloadData];
    
    return YES;
}

- (void)searchButtonAnimationStop
{
    _friendsListView.enableSectionTitles = YES;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _viewSearch.frame = frameSearchView;
        _viewShare.frame = frameViewShare;
        viewPrivate.frame = _frameViewPrivate;
        _lblFriends.frame = frameLblFriend;
        _friendsListView.frame = frameFriendListView;
        
        
        
    }completion:^(BOOL finished) {
        _lblGroup.hidden = NO;
        _lblFriends.hidden = NO;
        txtSearch.text = @"";
        [_friendsListView.friendsListTableView reloadData];
        [_viewInvite.tblvInviteFriends reloadData];
    }];
    
    
    
    _isSearchEnable = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSUInteger newLength = (textField.text.length - range.length) + string.length;
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    [_friendsListView searchFriendByString:newString];
    [_friendsListView.friendsListTableView reloadData];
    return YES;
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
