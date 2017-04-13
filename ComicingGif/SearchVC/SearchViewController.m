//
//  SearchViewController.m
//  ComicApp
//
//  Created by Ramesh on 27/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [self configViews];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.avView.btnSearchById setHidden:YES];
    [self.avView.txtSearchById setHidden:NO];
    [self.avView.txtSearchById becomeFirstResponder];
    self.avView.delegate = self;
    [self.friendListView getFriendsByUserId];
    self.friendListView.delegate = self;
    self.friendListView.selectedActionName = @"AddToFriends";
    [super viewWillAppear:animated];
}

-(void)configViews{
    
    CGRect frameRect = self.friendListView.view.frame;
    frameRect.size.height = self.friendListView.frame.size.height;
    self.friendListView.view.frame = frameRect;
    
}

- (IBAction)backButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnAddFriendClick:(id)sender {
    
    if(selectedDict)
    {
        NSMutableArray* friendsArry = [[NSMutableArray alloc] init];
        for (NSString* key in selectedDict) {
            id value = [selectedDict objectForKey:key];
            [friendsArry addObject:value];
        }
        
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
        [userDic setObject:friendsArry forKey:@"friends"];
        [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"];
        [dataDic setObject:userDic forKey:@"data"];
        
        ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
//        cmNetWorking.delegate= self;
        [cmNetWorking addRemoveFriends:dataDic completion:^(id json,id jsonResposeHeader) {
            [self addFriendsResponse:json];
        } ErrorBlock:^(JSONModelError *error) {
        }];
        dataDic = nil;
        userDic = nil;
        friendsArry = nil;
    }
}

-(void)addFriendsResponse:(NSDictionary *)response{
    [selectedDict removeAllObjects];
    selectedDict = nil;
    [self.btnAddFriends setHidden:YES];
    [self.friendListView getFriendsByUserId];
}

-(void)postFriendsSearchResponse:(NSDictionary *)response{
    [self.friendListView searchFriendsById:[FriendSearchResult arrayOfModelsFromDictionaries:response]];
}

#pragma mark FriendsList Delegate

-(void)selectedRow:(id)object{
    if(selectedDict == nil)
    {
        selectedDict = [[NSMutableDictionary alloc] init];
    }
    if ([selectedDict objectForKey:[object objectForKey:@"friend_id"]]) {
        [selectedDict removeObjectForKey:[object objectForKey:@"friend_id"]];
    }
    [selectedDict setObject:object forKey:[object objectForKey:@"friend_id"]];
    
    if ([selectedDict count] > 0) {
        [self.btnAddFriends setHidden:NO];
    }
}

- (void)selectedRow:(id)object param:(id)objectList
{
}
- (void)openMessageComposer:(NSArray*)sendNumbers messageText:(NSString*)messageTextValue
{
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset withTableView:(UITableView *)tableView
{
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView withTableView:(UITableView *)tableView
{}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
