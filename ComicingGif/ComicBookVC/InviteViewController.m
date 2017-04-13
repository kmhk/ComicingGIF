//
//  InviteViewController.m
//  StickeyBoard
//
//  Created by Ramesh on 04/07/16.
//  Copyright © 2016 Comicing. All rights reserved.
//

#import "InviteViewController.h"
#import <objc/message.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ShareHelper.h"
#import <MessageUI/MessageUI.h>
#import "AppConstants.h"
#import "AppHelper.h"
#import "InviteScore.h"
#import "EmojiHelper.h"
#import "MyEmojiCategory.h"
#import "GlideScrollViewController.h"
#import "OpenCuteStickersGiftBoxViewController.h"
#import "FrinedsUsingComicingCell.h"
#import "UIImageView+WebCache.h"
#import "YLGIFImage.h"
#import <Contacts/Contacts.h>

@interface InviteViewController ()<MFMessageComposeViewControllerDelegate>
{
    NSMutableArray* contactList;
}
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipBack;
@property (weak, nonatomic) IBOutlet UILabel *lblEmoji;
@property (weak, nonatomic) IBOutlet UILabel *lblContactName;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblCurrentScore;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (nonatomic, assign) NSTimer *loadTimer;
@property (nonatomic, assign) NSUInteger contactIndex;
@property (strong, nonatomic) NSArray<MyEmojiCategory *> *emojiCategories;
@property (strong, nonatomic) NSArray<MyEmoji *> *emoji;
@property (weak, nonatomic) IBOutlet UIButton *btnGifBox50;
@property (weak, nonatomic) IBOutlet UIButton *btnGiftBox100;
@property (weak, nonatomic) IBOutlet UIButton *btnGiftBox200;
@property (weak, nonatomic) IBOutlet UIView *mHolderView;
@property (strong, nonatomic) NSArray <NSDictionary *> *friendsUsingComicing;
@property (strong, nonatomic) IBOutlet UICollectionView *mCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *gifBox50;
@property (weak, nonatomic) IBOutlet UIImageView *giftBox100;
@property (weak, nonatomic) IBOutlet UIImageView *giftBox200;

@end

@implementation InviteViewController


- (void)viewDidLoad {
    
    [self prepareView];
    [super viewDidLoad];
    
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"FrinedsUsingComicingCell" bundle:nil] forCellWithReuseIdentifier:@"fs"];
    
    [self.mHolderView setClipsToBounds:YES];
    [self.mHolderView.layer setMasksToBounds:YES];
    [self.mHolderView.layer setCornerRadius:10];
    
    [self getPhoneContact];
     // // // [self getContactListFromServer]; commented by sandeep
    
    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"InviteView" Attributes:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    if ([AppHelper isNiceGiftBoxOpened])
    {
        [self.btnGifBox50 setUserInteractionEnabled:NO];
        self.gifBox50.image = [YLGIFImage imageNamed:@"open_gift_box_flat.png"];
    }
    
    if ([AppHelper isAwesomeGiftBoxOpened])
    {
        [self.btnGiftBox100 setUserInteractionEnabled:NO];
        self.giftBox100.image = [YLGIFImage imageNamed:@"open_gift_box_flat.png"];
    }
    
    if ([AppHelper isExoticGiftBoxOpened])
    {
        [self.btnGiftBox200 setUserInteractionEnabled:NO];
        self.giftBox200.image = [YLGIFImage imageNamed:@"open_gift_box_flat.png"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Events

- (IBAction)btnClose:(id)sender {
    
    [self.delegate hideInviteView];
}
- (IBAction)btnInviteClick:(id)sender {
    
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"InviteClick" Action:@"InviteClick" Label:@""];
    [self stopTitleAutoLoad];
    //    [self updateInviteScore:INVITE_POINT_PERINVITE];
    if ([contactList count] > self.contactIndex) {
        NSDictionary* dct = [contactList objectAtIndex:self.contactIndex];
        
        id mobile = [dct objectForKey:@"MobileNumber"];
        NSString *loginID = [NSString stringWithFormat:@"%@",[[AppHelper initAppHelper] getCurrentUser].login_id];
        
        if ([mobile isKindOfClass:[NSString class]])
        {
            [self openMessageComposer:[NSArray arrayWithObjects:[dct objectForKey:@"MobileNumber"], nil]
                          messageText:INVITE_TEXT(loginID)];
        }
        else if ([mobile isKindOfClass:[NSArray class]])
        {
            [self openMessageComposer:[NSArray arrayWithArray:[dct objectForKey:@"MobileNumber"]]
                          messageText:INVITE_TEXT(loginID)];
        }
        
    }
}
- (IBAction)btnSkipClick:(id)sender {
    [self stopTitleAutoLoad];
    [self loadContact];
    //[self startTitleAutoLoad];
}
- (IBAction)btnSkipBack:(id)sender {
    [self stopTitleAutoLoad];
    self.contactIndex = self.contactIndex - 1;
    if (self.contactIndex == -1) {
        self.contactIndex = 0;
    }
    [self setContactName];
    //[self startTitleAutoLoad];
}
- (IBAction)btnGiftBoxClick50:(id)sender {
    [self btnClose:nil];
    //[self.delegate getStickerListByCategory:ALL CategoryName:@"ALL"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    OpenCuteStickersGiftBoxViewController *controller = (OpenCuteStickersGiftBoxViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"OpenCuteStickersGiftBoxViewController"];
    [self presentViewController:controller animated:YES completion:nil];
    
}
- (IBAction)btnGiftBox100Click:(id)sender {
    [self btnClose:nil];
    //[self.delegate getStickerListByCategory:ALL CategoryName:@"ALL"];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    OpenCuteStickersGiftBoxViewController *controller = (OpenCuteStickersGiftBoxViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"OpenCuteStickersGiftBoxViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)btnGiftBox200Click:(id)sender {
    [self btnClose:nil];
    //[self.delegate getStickerListByCategory:ALL CategoryName:@"ALL"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    OpenCuteStickersGiftBoxViewController *controller = (OpenCuteStickersGiftBoxViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"OpenCuteStickersGiftBoxViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)doneClicked:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    GlideScrollViewController *controller = (GlideScrollViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"glidenavigation"];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark Methods

-(void)setContactName{
    if ([contactList count] > self.contactIndex) {
        
        NSDictionary* dct = [contactList objectAtIndex:self.contactIndex];
        self.lblContactName.text = [NSString stringWithFormat:@"Invite %@",[dct objectForKey:@"FullName"]];
        
        self.lblEmoji.text = [NSString stringWithFormat:@"%@",[self getRandomEmojiString]];
    }
}

-(void)loadContact{
    self.contactIndex = self.contactIndex + 1;
    if ([contactList count] == self.contactIndex) {
        self.contactIndex = 0;
    }
    [self setContactName];
}
- (void)startTitleAutoLoad{
    [self.loadTimer invalidate];
    self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                      target:self
                                                    selector:@selector(loadContact)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)stopTitleAutoLoad{
    [self.loadTimer invalidate];
    self.loadTimer = nil;
}

-(void)openMessageComposer:(NSArray*)sendNumbers messageText:(NSString*)messageTextValue{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.messageComposeDelegate = self;
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = messageTextValue;
        controller.recipients = sendNumbers;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }}

-(void)prepareView{
    
    self.contactIndex = 0;
    
    /*self.view.layer.borderColor = [UIColor blackColor].CGColor;
     self.view.layer.borderWidth = 1.0f;
     self.view.layer.cornerRadius = 10;
     self.view.layer.masksToBounds = true;*/
    
    self.btnInvite.layer.cornerRadius = 5;
    self.btnInvite.layer.masksToBounds = true;
    
    self.btnSkip.layer.cornerRadius = 5;
    self.btnSkip.layer.masksToBounds = true;
    
    self.lblEmoji.text = [NSString stringWithFormat:@"%@",[self getRandomEmojiString]];
    
    self.emojiCategories = [EmojiHelper getEmoji];
    for (MyEmojiCategory* emj in self.emojiCategories) {
        if ([emj.name isEqualToString:DEFAULT_EMOJI]) {
            self.emoji = emj.emoji;
            break;
        }
    }
}

-(NSString*)getRandomEmojiString{
    if (self.emoji && [self.emoji count] > 0) {
        int lowerBound = 0;
        int upperBound = [self.emoji count];
        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        return self.emoji[rndValue].emojiString;
    }else{
        return @"\U0001F602";
    }
    
}
-(void)enableScoreRow
{
    [self.btnGifBox50 setUserInteractionEnabled:NO];
    [self.btnGiftBox100 setUserInteractionEnabled:NO];
    [self.btnGiftBox200 setUserInteractionEnabled:NO];
    
    self.lblCurrentScore.text = [NSString stringWithFormat:@"%.f", [self getCurrentScoreFromDB]];
    float scoreValue = [self getCurrentScoreFromDB];
    if (scoreValue >= INVITE_POINT_200) {
        if (![AppHelper isExoticGiftBoxOpened])
        {
            self.giftBox200.image = [YLGIFImage imageNamed:@"box03.gif"];
            [self.btnGifBox50 setUserInteractionEnabled:YES];
            [self.btnGiftBox100 setUserInteractionEnabled:YES];
            [self.btnGiftBox200 setUserInteractionEnabled:YES];
        }
        
    }else if(scoreValue >= INVITE_POINT_100 &&
             scoreValue <= INVITE_POINT_200) {
        
        if (![AppHelper isAwesomeGiftBoxOpened])
        {
            self.giftBox100.image = [YLGIFImage imageNamed:@"box02.gif"];
            [self.btnGifBox50 setUserInteractionEnabled:YES];
            [self.btnGiftBox100 setUserInteractionEnabled:YES];
        }
        
    }else if(scoreValue >= INVITE_POINT_50 &&
             scoreValue <= INVITE_POINT_100) {
        
        if (![AppHelper isNiceGiftBoxOpened])
        {
            self.gifBox50.image   = [YLGIFImage imageNamed:@"box01.gif"];
            [self.btnGifBox50 setUserInteractionEnabled:YES];
        }
    }
}



#pragma mark Adddressbook

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
    
    [self getPhoneContact];
    
}

#pragma Webservice

-(void)getContactListFromServer{
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    
    [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"];
    if (contactList != nil) {
        [userDic setObject:contactList forKey:@"contacts"];
    }
    [dataDic setObject:userDic forKey:@"data"];
    
    userDic = nil;
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    
    
    
    /*temp
     [cmNetWorking postPhoneContactList:dataDic Id:@"659"
     completion:^(id json,id jsonResposeHeader) {
     
     NSLog(@"jsonResposeHeader");
     
     } ErrorBlock:^(JSONModelError *error) {
     
     }];*/
    
    if(self.friendsUsingComicing)
        self.friendsUsingComicing = nil;
    self.friendsUsingComicing=[[NSArray alloc] init];
    
    [cmNetWorking postPhoneContactList:dataDic Id:[AppHelper getCurrentLoginId]
                            completion:^(id json,id jsonResposeHeader) {
                                
                                NSLog(@"jsonResposeHeader");
                                
                                //@"845"
                                [cmNetWorking getComicingFriendsList:nil Id:[AppHelper getCurrentLoginId] completion:^(id json, id jsonResponse) {
                                    //NSLog(@"json : %@", json);
                                    
                                    if([json objectForKey:@"json"])
                                        self.friendsUsingComicing = json[@"data"];
                                    
                                    [self.mCollectionView reloadData];
                                    
                                } ErrorBlock:^(JSONModelError *error) {
                                    NSLog(@"error : %@", error.localizedDescription);
                                }];
                                
                            } ErrorBlock:^(JSONModelError *error) {
                                
                            }];
    
    /*[cmNetWorking getComicingFriendsList:dataDic Id:[AppHelper getCurrentLoginId] completion:^(id json, id jsonResponse) {
     NSLog(@"json : %@", json);
     
     } ErrorBlock:^(JSONModelError *error) {
     NSLog(@"error : %@", error.localizedDescription);
     }];*/
    
    
    dataDic = nil;
}

-(void)getPhoneContact{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        // OS version >= 9.0
        // Call contact address book function
        
        if ([CNContactStore class]) {
            //ios9 or later
            CNEntityType entityType = CNEntityTypeContacts;
            if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
            {
                CNContactStore * contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if(granted){
                        [self getAllContact];
                    }
                }];
            }
            else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
            {
                [self getAllContact];
            }
        }
    } else {
        // OS version < 9.0
        // Call address book function
        
        //ABAddressBookRef addressBook = ABAddressBookCreate();
        
        CFErrorRef error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        
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
}

#pragma mark Address book methods

// Get the contacts.
- (NSMutableArray*)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    if (contactList) {
        [contactList removeAllObjects];
        contactList = nil;
    }
    contactList = [[NSMutableArray alloc] init];
    //    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople =ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
    
    CFIndex number = CFArrayGetCount(allPeople);
    
    NSString *firstName;
    NSString *lastName;
    NSString *phoneNumber ;
    
    for( int i=0;i<number;i++)
    {
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        phoneNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phones, 0);
        
        if (firstName == nil) {
            firstName = @"";
        }
        if (lastName == nil) {
            lastName = @"";
        }
        
        NSString* FullName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        
        if(phoneNumber != NULL &&
           FullName != NULL)
        {
            NSMutableDictionary* dictObj = [[NSMutableDictionary alloc] init];
            [dictObj setObject:FullName forKey:@"FullName"];
            [dictObj setObject:phoneNumber forKey:@"MobileNumber"];
            [contactList addObject:dictObj];
            dictObj = nil;
        }
    }
    [self setContactName];
    //[self startTitleAutoLoad];
    [self enableScoreRow];
    return contactList;
}

#pragma mark Contacts methods

-(void)getAllContact
{
    if([CNContactStore class])
    {
        if (contactList) {
            [contactList removeAllObjects];
            contactList = nil;
        }
        contactList = [[NSMutableArray alloc] init];
        
        //iOS 9 or later
        NSError* contactError;
        CNContactStore* addressBook = [[CNContactStore alloc]init];
        [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]] error:&contactError];
        NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey];
        CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        BOOL success = [addressBook enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
            [self parseContactWithContact:contact];
        }];
        
        if (success)
        {
            NSLog(@"got contacts");
            
            [self setContactName];
            //[self startTitleAutoLoad];
            [self enableScoreRow];
            
            [self getContactListFromServer];
        }
    }
}

- (void)parseContactWithContact :(CNContact* )contact
{
    
    
    NSString * firstName =  contact.givenName;
    NSString * lastName =  contact.familyName;
    NSArray * phoneNumber = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    NSString * email = [contact.emailAddresses valueForKey:@"value"];
    NSArray * addrArr = [self parseAddressWithContac:contact];
    
    if (firstName == nil) {
        firstName = @"";
    }
    if (lastName == nil) {
        lastName = @"";
    }
    
    NSString* FullName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    
    //NSLog(@"full name : %@, phoneNumber : %@", FullName, phoneNumber);
    
    if((phoneNumber != NULL &&
        [phoneNumber isKindOfClass:[NSArray class]]) &&
       FullName != NULL)
    {
        NSMutableDictionary* dictObj = [[NSMutableDictionary alloc] init];
        [dictObj setObject:FullName forKey:@"FullName"];
        [dictObj setObject:phoneNumber forKey:@"MobileNumber"];
        [contactList addObject:dictObj];
        dictObj = nil;
    }
    
}

- (NSMutableArray *)parseAddressWithContac: (CNContact *)contact
{
    NSMutableArray * addrArr = [[NSMutableArray alloc]init];
    CNPostalAddressFormatter * formatter = [[CNPostalAddressFormatter alloc]init];
    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    if (addresses.count > 0) {
        for (CNPostalAddress* address in addresses) {
            [addrArr addObject:[formatter stringFromPostalAddress:address]];
        }
    }
    return addrArr;
}


#pragma mark -
-(NSString*)removeSpecialChara :(NSString*)phoneNumberString{
    return [[phoneNumberString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //[self updateInviteScore:INVITE_POINT_PERINVITE];
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"unknown error sending m");
            break;
        case MessageComposeResultSent:
            [self updateInviteScore:INVITE_POINT_PERINVITE];
            break;
        default:
            break;
    }
    [self loadContact];
    //[self startTitleAutoLoad];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark collection view data source

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.friendsUsingComicing.count;
    
}

#define SAFESTRING(str) ISVALIDSTRING(str) ? str : @""
#define ISVALIDSTRING(str) (str != nil && [str isKindOfClass:[NSNull class]] == NO)

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FrinedsUsingComicingCell *cell = (FrinedsUsingComicingCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"fs" forIndexPath:indexPath];
    
    NSString *profilePic = self.friendsUsingComicing[indexPath.item][@"profile_pic"];
    
    if (ISVALIDSTRING(profilePic))
    {
        [cell.mDPImageView sd_setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:[UIImage imageNamed:@"Placeholder"] options:SDWebImageRetryFailed];
    }
    
    NSString *displayName = self.friendsUsingComicing[indexPath.item][@"first_name"];
    cell.mFirstName.text = SAFESTRING(displayName);
    
    return cell;
}

#pragma mark DBMethods

-(void)updateInviteScore:(CGFloat)scoreValue{
    
    NSManagedObjectContext *context = [[AppHelper initAppHelper] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"InviteScore"];
    NSError *error      = nil;
    NSArray *results    = [context executeFetchRequest:fetchRequest error:&error];
    if ([results count] == 0) {
        
        NSManagedObjectContext *context_save = [[AppHelper initAppHelper] managedObjectContext];
        
        NSManagedObject *stickersList = [NSEntityDescription insertNewObjectForEntityForName:@"InviteScore" inManagedObjectContext:context_save];
        [stickersList setValue:[NSString stringWithFormat:@"%.f", scoreValue] forKey:@"scoreValue"];
        
        NSError *error = nil;
        if (![context_save save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }else{
        for (NSManagedObject *managedObject in results) {
            
            NSString* scoreValue = ((InviteScore*)results[0]).scoreValue;
            int fScoreValue = [scoreValue floatValue];
            int oldScoreValue = fScoreValue;
            fScoreValue = fScoreValue + INVITE_POINT_PERINVITE;
            
            [managedObject setValue:[NSString stringWithFormat:@"%.i", fScoreValue] forKey:@"scoreValue"];
            
            //            self.lblCurrentScore.text = [NSString stringWithFormat:@"%.f", [self getCurrentScoreFromDB]];
            self.lblCurrentScore.format = @"%d";
            [self.lblCurrentScore countFrom:oldScoreValue to:fScoreValue withDuration:3.0];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    [self enableScoreRow];
}

-(float)getCurrentScoreFromDB{
    NSManagedObjectContext *context = [[AppHelper initAppHelper] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"InviteScore"];
    NSError *error      = nil;
    NSArray *results    = [context executeFetchRequest:fetchRequest error:&error];
    if ([results count] == 0) {
        return 0;
    }else{
        NSString* scoreValue = ((InviteScore*)results[0]).scoreValue;
        CGFloat fScoreValue = [scoreValue floatValue];
        return fScoreValue;
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

#pragma mark - statusbar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
