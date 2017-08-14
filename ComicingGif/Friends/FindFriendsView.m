//
//  FindFriendsView.m
//  ComicApp
//
//  Created by Ramesh on 10/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "FindFriendsView.h"

@implementation FindFriendsView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"FindFriendsView" owner:self options:nil];
        self.view.frame = self.frame;
        [self addSubview:self.view];
        
        [self configView];
        
        //Just for test
        [self bindData];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"FindFriendsView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self configView];
        
        //Just for test
        [self bindData];
    }
    return self;
}


#pragma Methods

-(void)configView{
    
    self.searchTextHolderView.layer.borderColor = [[UIColor colorWithHexStr:@"005bae"] CGColor];
    self.searchTextHolderView.layer.cornerRadius = 15;
    self.searchTextHolderView.layer.masksToBounds = YES;
    self.searchTextHolderView.layer.borderWidth = 1.0f;
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"dig up friends by name" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    self.txtSearch.attributedPlaceholder = str;
    
    [self setTextFont];
    
}

-(void)setTextFont{

    [self.lblHeadText setFont:[UIFont  fontWithName:@"Myriad Roman" size:28]];
    self.lblHeadText.text = @"Find \n Friends";
}

-(void)bindData{
    if (contactNumber) {
        [contactNumber removeAllObjects];
        contactNumber = nil;
    }
    contactNumber = [[NSMutableArray alloc] init];
    
    [self getPhoneContact];
    [self getContactListFromServer];
}
-(NSString*)removeSpecialChara :(NSString*)phoneNumberString{
    return [[phoneNumberString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];

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

// Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
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
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
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
    
    [self.contactListTableView reloadData];
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
    static NSString *CellIdentifer = @"FriendsList";
    FindFriendsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"FindFriendsTableCell" owner:self options:nil];
        cell = self.tabCell;
        self.tabCell = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.lblMobileNumber.text = [[contactList objectAtIndex:indexPath.row] objectForKey:@"Phone"];
    cell.lblUserName.text = [[contactList objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma Webservice

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

@end
