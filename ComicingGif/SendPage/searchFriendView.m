//
//  searchFriendView.m
//  ComicBook
//
//  Created by ADNAN THATHIYA on 06/04/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "searchFriendView.h"
#import "InviteFriendCell.h"
#define InviteTagValue 300

@interface searchFriendView()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* contactList;
    NSMutableArray* contactNumber;
    NSArray* temContactList;
    NSMutableArray *selectedContacts;
    NSMutableArray *searchArray;
    NSMutableArray *saveContactList;
}

@end

@implementation searchFriendView

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
        [[NSBundle mainBundle] loadNibNamed:@"searchFriendView" owner:self options:nil];
        [self addSubview:self.view];
        
        selectedContacts = [[NSMutableArray alloc] init];
        
    }
    
    return self;
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    InviteFriendCell *cell = (InviteFriendCell*)[tableView cellForRowAtIndexPath:indexPath];
//    
//    if(cell)
//    {
//        
//        NSDictionary *dict =  [contactList objectAtIndex:indexPath.row];
//        
//        if ([selectedContacts containsObject:dict])
//        {
//            [selectedContacts removeObject:dict];
//            
//        }
//        else
//        {
//            [selectedContacts addObject:dict];
//            
//        }
//        
//        [_tblvSearch reloadData];
//    }
//}

//-(void)inviteButtonClick:(id)sender
//{
//    UIButton* btn =(UIButton*)sender;
//    NSInteger indexValue = btn.tag - InviteTagValue ;
//    
//    if (contactList && [contactList objectAtIndex:indexValue])
//    {
//        NSMutableDictionary* dict = [contactList objectAtIndex:indexValue];
//        NSString* phoneNumber = @"";
//        if ([dict objectForKey:@"Phone"]) {
//            phoneNumber = [dict objectForKey:@"Phone"];
//        }
//        [self.delegate openMessageComposer:[NSArray arrayWithObjects:phoneNumber, nil] messageText:INVITE_TEXT];
//    }
//    
//}


- (void)searchFriendByString:(NSString *)searchString
{
    
}


@end
