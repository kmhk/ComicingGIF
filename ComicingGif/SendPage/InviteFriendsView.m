//
//  InviteFriendsView.m
//  ComicBook
//
//  Created by ADNAN THATHIYA on 03/04/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "InviteFriendsView.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "ComicNetworking.h"
#import <MessageUI/MessageUI.h>
#import "FindFriendsTableCell.h"
#import "InviteFriendCell.h"


#define InviteTagValue 300

@interface InviteFriendsView()<UITableViewDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate>
{
    NSMutableArray* contactList;
    NSMutableArray* contactNumber;
    NSArray* temContactList;
    NSMutableArray *selectedContacts;
    NSMutableArray *searchArray;
    NSMutableArray *saveContactList;
}

@end

@implementation InviteFriendsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
        [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsView" owner:self options:nil];
        [self addSubview:self.view];
        
        selectedContacts = [[NSMutableArray alloc] init];
        
        [self bindData];
    }
    
    return self;
}


-(void)bindData
{
    if (contactNumber)
    {
        [contactNumber removeAllObjects];
        contactNumber = nil;
    }
    contactNumber = [[NSMutableArray alloc] init];
    saveContactList = [[NSMutableArray alloc] init];
    
    [self getPhoneContact];
    [self getContactListFromServer];
}

-(void)getPhoneContact{
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
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
}

- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook
{
    if (contactList)
    {
        [contactList removeAllObjects];
        contactList = nil;
    }
    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        if (lastName == NULL)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"name"];
        }
        else
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        }
        
        
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, j);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [contactNumber addObject:[self removeSpecialChara:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j)]];
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j) forKey:@"Phone"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [contactNumber addObject:[self removeSpecialChara:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j)]];
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j) forKey:@"Phone"];
                break ;
            }
            
        }
        
        [contactList addObject:dOfPerson];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [contactList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    contactList = sortedArray.mutableCopy;
    
    temContactList = contactList;
    
    saveContactList = contactList;
    
    [self.tblvInviteFriends reloadData];
}

-(NSString*)removeSpecialChara :(NSString*)phoneNumberString{
    return [[phoneNumberString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];
    
}

-(void)getContactListFromServer{
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    
    [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"];
    [userDic setObject:contactList forKey:@"contacts"];
    [dataDic setObject:userDic forKey:@"data"];
    
    userDic = nil;
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    
    [cmNetWorking postPhoneContactList:dataDic Id:[AppHelper getCurrentLoginId]
                            completion:^(id json,id jsonResposeHeader) {
                                
                            } ErrorBlock:^(JSONModelError *error) {
                                
                            }];
    dataDic = nil;
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactList.count;
}

// This will tell your UITableView what data to put in which cells in your table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // FindFriendsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    InviteFriendCell *cell = [topLevelObjects objectAtIndex:0];
    
    cell.lblMobileNumber.text = [[contactList objectAtIndex:indexPath.row] objectForKey:@"Phone"];
    cell.lblUserName.text = [[contactList objectAtIndex:indexPath.row] objectForKey:@"name"];
   
    [cell.btnInvite addTarget:self
                       action:@selector(inviteButtonClick:)
             forControlEvents:UIControlEventTouchUpInside];
    cell.btnInvite.tag = InviteTagValue + indexPath.row;
    cell.btnInvite.selected = NO;

    NSDictionary *dict =  [contactList objectAtIndex:indexPath.row];
    
    if ([selectedContacts containsObject:dict])
    {
        cell.imgvSelectCell.hidden = NO;
    }
    else
    {
        cell.imgvSelectCell.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteFriendCell *cell = (InviteFriendCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell)
    {
     
        NSDictionary *dict =  [contactList objectAtIndex:indexPath.row];
        
        if ([selectedContacts containsObject:dict])
        {
            [selectedContacts removeObject:dict];

        }
        else
        {
            [selectedContacts addObject:dict];

        }
        
        [_tblvInviteFriends reloadData];
    }
}

-(void)inviteButtonClick:(id)sender
{
    UIButton* btn =(UIButton*)sender;
    NSInteger indexValue = btn.tag - InviteTagValue ;
 
    if (contactList && [contactList objectAtIndex:indexValue])
    {
        NSMutableDictionary* dict = [contactList objectAtIndex:indexValue];
        NSString* phoneNumber = @"";
        if ([dict objectForKey:@"Phone"]) {
            phoneNumber = [dict objectForKey:@"Phone"];
        }
        
        btn.layer.backgroundColor=[[UIColor clearColor] CGColor];
        btn.layer.borderColor = [[UIColor clearColor] CGColor];
        
        btn.layer.cornerRadius= 0;
        
        btn.selected = YES;
        [btn setImage:[UIImage imageNamed:@"selected-invite"] forState:UIControlStateSelected];
        
        NSString *loginID = [NSString stringWithFormat:@"%@",[[AppHelper initAppHelper] getCurrentUser].login_id];
        
        NSString *inviteString = INVITE_TEXT(loginID);
        
        
        [self.delegate openMessageComposer:[NSArray arrayWithObjects:phoneNumber, nil] messageText:inviteString];
    }
    
}

- (void)searchFriendByString:(NSString *)searchString
{
    searchArray = [[NSMutableArray alloc] init];
  
    if ([searchString isEqualToString:@""])
    {
        contactList = [[NSMutableArray alloc] init];

        contactList = saveContactList;
    }
    else
    {
        NSString* filter = @"%K CONTAINS[cd] %@";
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"name", searchString];
        
        NSArray* filteredData = [contactList filteredArrayUsingPredicate:predicate];
        
        
        [searchArray addObjectsFromArray:filteredData];
        contactList = [[NSMutableArray alloc] init];
        contactList = searchArray;
    }
    
    [_tblvInviteFriends reloadData];

}



//-(void)openMessageComposer:(NSArray*)sendNumbers messageText:(NSString*)messageTextValue
//{
//    
//    }

- (NSArray *)getallInvitedContacts
{
    return contactList.copy;
}

- (void)removeAllSelectedContacts
{
    selectedContacts = [[NSMutableArray alloc] init];
}

- (NSArray *)getSelectedContacts
{
    return selectedContacts.copy;
}

#pragma MessageDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultSent:
            
            break;
        default:
            break;
    }
    
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
}


@end
