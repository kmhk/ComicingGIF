//
//  GroupsSection.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupItem.h"
#import "UIColor+colorWithHexString.h"
#import "GroupSectionCell.h"
#import "ComicNetworking.h"
#import "BaseModel.h"

#pragma mark - Delegate

@protocol GroupDelegate <NSObject>

@optional

-(void)addNewGroup;
-(void)showGroup:(NSInteger)groupId;
-(void)selectGroupItems:(id)object;

@end

@interface GroupsSection : UIView<UICollectionViewDelegate,UICollectionViewDataSource,ComicNetworkingDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UICollectionView *groupCollectionView;
@property (strong, nonatomic) IBOutlet GroupSectionCell *tabCell;
@property (nonatomic, assign) id<GroupDelegate> delegate;
@property (assign, nonatomic) BOOL enableAdd;
@property(strong,nonatomic)   NSMutableArray* groupsArray;
@property (assign, nonatomic) BOOL enableSelection;

@property (strong, nonatomic) NSMutableArray *selectedGroups;


-(void)getGroupsByUserId;
@end
