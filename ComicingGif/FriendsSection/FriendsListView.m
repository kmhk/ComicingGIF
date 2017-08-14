
//
//  FriendsListView.m
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "FriendsListView.h"
#import <objc/message.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "InviteFriendCell.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation FriendsListView

@synthesize isOnlyInviteFriends;
#define InviteTagValue 300

#define Selected_Action     @[@"AddToGroup",@"AddToFriends"]

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"FriendsListView" owner:self options:nil];
        [self addSubview:self.view];
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _friendsArray = [[NSMutableArray alloc] init];
        selectedFriends = [[NSMutableArray alloc] init];

      
        
        [self configView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setIsTitleLabelHide:(BOOL)isTitleLabelHide
{
    _headerName.hidden = YES;
    _tableHolderView.frame = self.view.bounds;
    _friendsListTableView.frame = _tableHolderView.bounds;

}


-(void)configView
{

    self.friendsListTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.friendsListTableView.sectionIndexColor = [UIColor blackColor];
    self.friendsListTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.friendsListTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.enableInvite = YES;
}



- (void)setNeedsLayout{
    
}

- (void)layoutIfNeeded{
    
}


#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 //   if(self.enableSectionTitles)
        return [alphabetsSectionTitles count];
 //   return 1;
}

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(self.enableSectionTitles){
        // Return the number of rows in the section.
        NSString *sectionTitle = [alphabetsSectionTitles objectAtIndex:section];
        NSArray *sectionAnimals = [friendsDictWithAlpabets objectForKey:sectionTitle];
        return [sectionAnimals count];
//    }
 //   return [self.friendsArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  //  if(self.enableSectionTitles)
    
    NSString *headerTitle = [alphabetsSectionTitles objectAtIndex:section];
    
    if ([headerTitle isEqualToString:@"!"])
    {
        return nil;
    }
    
    
    return headerTitle;
//    else
 //       return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.enableSectionTitles)
    {
        NSMutableArray *keys = [[friendsDictWithAlpabets allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)].mutableCopy;
        
        if ([keys containsObject:@"!"])
        {
            [keys removeObject:@"!"];
        }
        
        
        return keys;

        
        
      //  return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];

    }
    else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{

    return [alphabetsSectionTitles indexOfObject:title];
}



// This will tell your UITableView what data to put in which cells in your table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (isOnlyInviteFriends)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        InviteFriendCell *cell = [topLevelObjects objectAtIndex:0];
        
        User* us = nil;
        
        NSString* currentAlphaBets = [alphabetsSectionTitles objectAtIndex:indexPath.section];
        
        us =(User*)[[friendsDictWithAlpabets objectForKey:currentAlphaBets] objectAtIndex:indexPath.row];

        
        cell.lblUserName.text = us.first_name;
        cell.lblMobileNumber.text = us.mobile;
        
        
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:us.profile_pic] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
        
//        [cell.userImage downloadImageWithURL:[NSURL URLWithString:us.profile_pic]
//                            placeHolderImage:[UIImage imageNamed:@"Placeholder"]
//                             completionBlock:^(BOOL succeeded, UIImage *image) {
//                                 cell.userImage.image = image;
//                             }];
        
        
        [[cell.userImage layer] setBorderWidth:4.0f];
        [[cell.userImage layer] setBorderColor:[UIColor clearColor].CGColor];
        
        //Config tickMark in Group
        if(groupMembersList && [us isKindOfClass:[UserFriends class]] &&
           us.friend_id &&
           [self findUserInsideTheGroup:us.friend_id] && ![us.friend_id isEqualToString:@"-1"])
        {
            if (!self.hideTickByDefault) {
                [cell.selectedTickImage setHidden:NO];
            }
//            [[cell.userImage layer] setBorderColor:[UIColor colorWithHexStr:@"26ace2"].CGColor];
        }
        else if([us isKindOfClass:[UserFriends class]] && us.friend_id && us.status == FRIEND)
        {
            if (!self.hideTickByDefault) {
                [cell.selectedTickImage setHidden:NO];
            }
//            [[cell.userImage layer] setBorderColor:[UIColor colorWithHexStr:@"26ace2"].CGColor];
        }
        
        
        
        
        if ([selectedFriends containsObject:us])
        {
            [cell.selectedTickImage setHidden:NO];
            
        }
        else
        {
            [cell.selectedTickImage setHidden:YES];
            
        }
        
        
        //Config Invite Button
        if ([us isKindOfClass:[UserFriends class]] &&
            us.friend_id)
        {
            if (us.status == UNFRIEND &&
                [us.friend_id isEqualToString:@"-1"])
            {
                [cell.btnInvite setHidden:NO];
                [cell.btnInvite addTarget:self
                                   action:@selector(inviteButtonClick:)
                         forControlEvents:UIControlEventTouchUpInside];
                
                [cell.userImage setHidden:YES];
            }
        }
        else
        {
            if (self.enableInvite && us.status == UNFRIEND)
            {
                [cell.btnInvite setHidden:NO];
                [cell.btnInvite addTarget:self
                                   action:@selector(inviteButtonClick:)
                         forControlEvents:UIControlEventTouchUpInside];
                
                [cell.userImage setHidden:YES];
            }
        }
        
        cell.btnInvite.tag = InviteTagValue + indexPath.row;
        cell.btnInvite.selected = NO;

        return cell;

    }
    else
    {
        static NSString *CellIdentifer = @"FriendsList";
        FriendsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"FriendsListTableViewCell" owner:self options:nil];
            cell = self.tabCell;
            self.tabCell = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        User* us = nil;
        
        NSString* currentAlphaBets = [alphabetsSectionTitles objectAtIndex:indexPath.section];
        
        us =(User*)[[friendsDictWithAlpabets objectForKey:currentAlphaBets] objectAtIndex:indexPath.row];
        
        cell.lblUerName.text = us.first_name;
        
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:us.profile_pic] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
        
        //Config image border
        [[cell.userImage layer] setBorderWidth:4.0f];
        [[cell.userImage layer] setBorderColor:[UIColor clearColor].CGColor];
        
        if ([selectedFriends containsObject:us])
        {
            [cell.selectedTickImage setHidden:NO];
        }
        else
        {
            [cell.selectedTickImage setHidden:YES];
        }

        
        //Config tickMark in Group
        if(groupMembersList && [us isKindOfClass:[UserFriends class]] &&
           us.friend_id &&
           [self findUserInsideTheGroup:us.friend_id])
        {
            if (!self.hideTickByDefault) {
             [cell.selectedTickImage setHidden:NO];
            }
//            [[cell.userImage layer] setBorderColor:[UIColor colorWithHexStr:@"26ace2"].CGColor];
        }
        else if((groupMembersList == nil || [groupMembersList count] == 0 ) &&
                [us isKindOfClass:[UserFriends class]] && us.friend_id && ![us.friend_id isEqualToString:@"-1"])
//        else if([us isKindOfClass:[UserFriends class]] && us.friend_id && us.status == FRIEND)
        {
            if (!self.hideTickByDefault) {
                [cell.selectedTickImage setHidden:NO];
            }
            
//            [[cell.userImage layer] setBorderColor:[UIColor colorWithHexStr:@"26ace2"].CGColor];
        }
        
        //Config Invite Button
        if ([us isKindOfClass:[UserFriends class]] &&
            us.friend_id)
        {
            if (us.status == UNFRIEND &&
                [us.friend_id isEqualToString:@"-1"])
            {
                [cell.btnInvite setHidden:NO];
                [cell.btnInvite addTarget:self
                                   action:@selector(inviteButtonClick:)
                         forControlEvents:UIControlEventTouchUpInside];
                
                [cell.userImage setHidden:YES];
            }
        }
        else
        {
            if (self.enableInvite && us.status == UNFRIEND)
            {
                [cell.btnInvite setHidden:NO];
                [cell.btnInvite addTarget:self
                                   action:@selector(inviteButtonClick:)
                         forControlEvents:UIControlEventTouchUpInside];
                
                [cell.userImage setHidden:YES];
            }
        }
        
        cell.btnInvite.tag = InviteTagValue + indexPath.row;
        cell.btnInvite.selected = NO;
        
        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.enableSelection)
    {
        
        NSString* currentAlphaBets = [alphabetsSectionTitles objectAtIndex:indexPath.section];
        
        User* usSelection =(User*)[[friendsDictWithAlpabets objectForKey:currentAlphaBets] objectAtIndex:indexPath.row];
        FriendsListTableViewCell *cell = (FriendsListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        if(cell)
        {
            [cell.selectedTickImage setHidden:!cell.selectedTickImage.hidden];
            
            if (cell.selectedTickImage.hidden)
            {
                [[cell.userImage layer] setBorderColor:[UIColor clearColor].CGColor];
            }
            else
            {
//                [[cell.userImage layer] setBorderColor:[UIColor colorWithHexStr:@"26ace2"].CGColor];
            }
        }
        
        
        if ([selectedFriends containsObject:usSelection])
        {
            //remove if already exist
            [selectedFriends removeObject:usSelection];
        }
        else
        {
            // add if friend selected
            [selectedFriends addObject:usSelection];
        }
        [self doSelectedAction:usSelection];
    }
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    [headerView setBackgroundColor:[UIColor colorWithHexStr:@"c2c2c2"]];
//    return headerView;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor clearColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pointNow = scrollView.contentOffset;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < pointNow.y)
    {
        NSLog(@"down");
    }
    else if (scrollView.contentOffset.y > pointNow.y)
    {
        NSLog(@"up");
    }
    
    [self.delegate scrollViewDidScroll:scrollView withTableView:self.friendsListTableView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset withTableView:self.friendsListTableView];
}

- (void)searchFriendByString:(NSString *)searchString
{
    searchArray = [[NSMutableArray alloc] init];
    
    if ([searchString isEqualToString:@""])
    {
        friendsDictWithAlpabets = [[NSMutableDictionary alloc] init];
        
        friendsDictWithAlpabets = saveFriendsDictWithAlpabets;
        alphabetsSectionTitles = saveAlphabetsSectionTitles;
    }
    else
    {
        searchUsers = [[NSMutableDictionary alloc]init];
        
        for (NSString *key in saveFriendsDictWithAlpabets)
        {
            NSArray *arr = saveFriendsDictWithAlpabets[key];
            
            for (User *user in arr)
            {
                if ([[user.first_name lowercaseString] containsString:[searchString lowercaseString]])
                {
                    NSMutableArray *arr1 = searchUsers[key];
                    
                    if (arr1 == nil || arr1.count == 0)
                    {
                        arr1 = [[NSMutableArray alloc] init];
                    }
                    
                    [arr1 addObject:user];
                    
                    if (arr1.count > 0)
                    {
                        [searchUsers setValue:arr1 forKey:key];

                    }
                }
            }
        }
        
        
        
        friendsDictWithAlpabets = searchUsers;
        alphabetsSectionTitles = [[friendsDictWithAlpabets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//        NSString* filter = @"%K CONTAINS[cd] %@";
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"first_name", searchString];
//        
//        NSArray* filteredData = [_friendsArray filteredArrayUsingPredicate:predicate];
//        
//        
//        [searchArray addObjectsFromArray:filteredData];
//        _friendsArray = [[NSMutableArray alloc] init];
//        _friendsArray = searchArray;
    }
    
    [self.friendsListTableView reloadData];
    
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.delegate friendlistDidScrollwithScrollView:scrollView];
//}



#pragma mark Methods

-(void)inviteButtonClick:(UIButton *)sender
{
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"FriendsInvite" Action:@"Invite" Label:@""];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(openMessageComposer:messageText:)])
    {
        
        CGPoint center= sender.center;
        CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.friendsListTableView];
        NSIndexPath *indexPath = [self.friendsListTableView indexPathForRowAtPoint:rootViewPoint];
        
        NSString* currentAlphaBets = [alphabetsSectionTitles objectAtIndex:indexPath.section];
        
        User* usSelection =(User*)[[friendsDictWithAlpabets objectForKey:currentAlphaBets] objectAtIndex:indexPath.row];
        sender.selected = YES;
        
        sender.layer.backgroundColor=[[UIColor clearColor] CGColor];
        sender.layer.borderColor = [[UIColor clearColor] CGColor];
        
        sender.layer.cornerRadius= 0;

        [sender setImage:[UIImage imageNamed:@"selected-invite"] forState:UIControlStateNormal];
        
        NSString *loginID = [NSString stringWithFormat:@"%@",[[AppHelper initAppHelper] getCurrentUser].login_id];
        
        NSString *inviteString = INVITE_TEXT(loginID);
        
        
        if (usSelection.mobile != nil)
        {
            [self.delegate openMessageComposer:@[usSelection.mobile] messageText:inviteString];

        }
        else
        {
            [self.delegate openMessageComposer:nil messageText:inviteString];

        }
        
        
        
        
        
//        if (self.enableSectionTitles)
//        {
//            
//
//        }
//        else
//        {
//            UIButton* btn =(UIButton*)sender;
//            NSInteger indexValue = btn.tag - InviteTagValue ;
//            
//            User  *us = (User*)[self.friendsArray objectAtIndex:indexValue];
//            
//            if (us.mobile == nil)
//            {
//                [self.delegate openMessageComposer:nil messageText:INVITE_TEXT];
//
//            }
//            else
//            {
//                [self.delegate openMessageComposer:@[us.mobile] messageText:INVITE_TEXT];
//
//            }
//            
//            
//        }
        
        
        
    }
}

- (BOOL)findUserInsideTheGroup:(NSString *)userId {
    // ivar: NSArray *myArray;
    __block BOOL found = NO;
    __block GroupMember *dict = nil;
    
    [groupMembersList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        dict = (GroupMember*)[[GroupMember alloc] initWithDictionary:obj error:nil];
        NSString *uId = dict.user_id;
        if ([uId isEqualToString:userId]) {
            found = YES;
            *stop = YES;
        }
        dict = nil;
    }];
    
    return found;
}

-(void)doSelectedAction:(id)obj
{
    if ([self.selectedActionName isEqualToString:[Selected_Action objectAtIndex:0]])
    {
        //Do Add to Group
        [self addToGroup:obj];
    }
    else if([self.selectedActionName isEqualToString:[Selected_Action objectAtIndex:1]])
    {
        //Do Add to Friends
        [self addToFriends:obj];
    }
    else
    {
        [self addToItems:obj];
    }
}

-(void)addToItems:(id)object{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:)])
    {
        [self.delegate selectedRow:object];
    }
}

-(void)addToGroup:(id)usObject
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:param:)])
    {
        if ([usObject isKindOfClass:[FriendSearchResult class]])
        {
            FriendSearchResult* uf = (FriendSearchResult*)usObject;
            GroupUserItems* gui = [[GroupUserItems alloc]init];
            gui.user_id = uf.user_id;
            gui.role = (uf.user_id == [AppHelper getCurrentLoginId] ? @"2":@"1");
            gui.status = ([self findUserInsideTheGroup:uf.user_id] ? @"0" : @"1");
            [self.delegate selectedRow:gui param:uf];
            uf = nil;
            gui = nil;
        }
        else
        {
            UserFriends* uf = (UserFriends*)usObject;
            GroupUserItems* gui = [[GroupUserItems alloc]init];
            gui.user_id = uf.friend_id;
            gui.role = (uf.friend_id == [AppHelper getCurrentLoginId] ? @"2":@"1");
            gui.status = ([self findUserInsideTheGroup:uf.friend_id] ? @"0" : @"1");
            [self.delegate selectedRow:gui param:uf];
            uf = nil;
            gui = nil;
        }
    }
}

-(void)addToFriends:(id)usObject{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:)])
    {
        User* uf = (User*)usObject;
        NSMutableDictionary * selectedUser = [[NSMutableDictionary alloc] init];
        if([uf isKindOfClass:[UserFriends class]])
        {
            [selectedUser setObject:uf.friend_id forKey:@"friend_id"];
            [selectedUser setObject:@"0"  forKey:@"status"];
        }else{
            [selectedUser setObject:uf.user_id forKey:@"friend_id"];
            [selectedUser setObject:@"1"  forKey:@"status"];
        }
        [self.delegate selectedRow:selectedUser];
        selectedUser = nil;
    }
}

-(void)getFriendsByUserId:(NSArray*)groupMembers{
    
    groupMembersList = groupMembers;
    [self getFriendsByUserId];
}

-(void)getFriendsByUserId{
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
//    cmNetWorking.delegate= self;
    [cmNetWorking userFriendsByUserId:[AppHelper getCurrentLoginId] completion:^(id json,id jsonResposeHeader) {
        [self friendslistResponse:json];
    } ErrorBlock:^(JSONModelError *error) {
        
    }];
}

-(void)friendslistResponse:(NSDictionary *)response
{
    
    //initialize the models
    
    NSArray *friendsFromServer;
    
    if (response[@"data"] != nil)
    {   
        friendsFromServer = [UserFriends arrayOfModelsFromDictionaries:response[@"data"]];
    }
    NSMutableArray* phoneContact = [self getPhoneContact];
    
    if (phoneContact != nil)
    {
        [self.friendsArray removeAllObjects];
        [self.friendsArray addObjectsFromArray:phoneContact];
    }
        
    [self setSectionAlphbets:self.friendsArray withFriendsFromServer:friendsFromServer];
    saveContactList = [[NSMutableArray alloc] init];
    saveContactList = _friendsArray;
    
    [self.friendsListTableView reloadData];
}

-(void)friendsSearchResponse:(NSDictionary *)response
{
    
    //initialize the models
    
    NSArray *friendsFromServer;
    
    if (response[@"data"] != nil)
    {
        friendsFromServer = [FriendSearchResult arrayOfModelsFromDictionaries:response[@"data"]];
    }
    NSMutableArray* phoneContact = [self getPhoneContact];
    
    if (phoneContact != nil)
    {
        [self.friendsArray removeAllObjects];
        [self.friendsArray addObjectsFromArray:phoneContact];
    }
    
    [self setSectionAlphbets:self.friendsArray withFriendsFromServer:friendsFromServer];
    saveContactList = [[NSMutableArray alloc] init];
    saveContactList = _friendsArray;
    
    [self.friendsListTableView reloadData];
}

-(void)searchFriendsById:(NSMutableArray*)list
{
    if ([list count] == 0)
    {
        [AppHelper showWarningDropDownMessage:@"" mesage:@"No search result found"];
        return;
    }
    
    self.friendsArray  = list;
  //  if (self.enableSectionTitles) {
     //   [self setSectionAlphbets:self.friendsArray];
  //  }
    [self.friendsListTableView reloadData];
}

-(void)setSectionAlphbets:(NSMutableArray*)resultArray withFriendsFromServer:(NSArray *)friendsServer
{
    NSMutableSet *set = [NSMutableSet set];
    
    if(friendsDictWithAlpabets == nil)
    {
        friendsDictWithAlpabets = [[NSMutableDictionary alloc] init];
    }
    
    if (friendsServer != nil)
    {
        [friendsDictWithAlpabets setObject:friendsServer forKey:@"!"];
    }
    
    
    for (UserFriends * ufs in self.friendsArray)
    {
        NSString* str = ufs.first_name;
        
        if (str.length > 0)
        {
            if (![set containsObject:[str substringToIndex:1]])
            {
                NSString* alph = [[str substringToIndex:1] uppercaseString];
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"first_name beginswith[c] %@", alph];
                NSArray *filteredArr = [self.friendsArray filteredArrayUsingPredicate:pred];
            
                [friendsDictWithAlpabets setObject:filteredArr forKey:alph];
            }
            
            [set addObject:[str substringToIndex:1]];
        }
    }
    
    saveFriendsDictWithAlpabets = friendsDictWithAlpabets;
    
    if (alphabetsSectionTitles == nil)
    {
        alphabetsSectionTitles = [[NSMutableArray alloc] init];
    }
    
    alphabetsSectionTitles = [[friendsDictWithAlpabets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    saveAlphabetsSectionTitles = alphabetsSectionTitles;
    
    [self.friendsListTableView reloadData];

}

#pragma mark Adddressbook

-(NSMutableArray*)getPhoneContact{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        return [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        return [self getContactsWithAddressBook:addressBook];
    }
    return nil;
}

// Get the contacts.
- (NSMutableArray*)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    if (contactList) {
        [contactList removeAllObjects];
        contactList = nil;
    }
    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
//        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        UserFriends* userObj = [[UserFriends alloc] init];
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        userObj.first_name = (__bridge NSString*)firstName;
        userObj.last_name = (__bridge NSString*)lastName;
        
//        [dOfPerson setObject:(__bridge NSString*)firstName forKey:@"first_name"];
//        [dOfPerson setObject:(__bridge NSString*)lastName forKey:@"last_name"];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            userObj.email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0);
//            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, j);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [contactNumber addObject:[self removeSpecialChara:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j)]];
                userObj.mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j);
         //       [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j) forKey:@"mobile"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [contactNumber addObject:[self removeSpecialChara:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j)]];
                userObj.mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j);
//                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j) forKey:@"mobile"];
                break ;
            }
            
        }
        userObj.friend_id = @"-1";
        userObj.status = UNFRIEND;
//        [dOfPerson setObject:[NSString stringWithFormat:@"-1"] forKey:@"friend_id"];
        [contactList addObject:userObj];
        userObj = nil;
    }
    return contactList;
}
-(NSString*)removeSpecialChara :(NSString*)phoneNumberString{
    return [[phoneNumberString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];
    
}

@end
