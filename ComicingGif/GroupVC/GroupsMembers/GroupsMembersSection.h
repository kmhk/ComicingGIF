//
//  GroupsSection.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+colorWithHexString.h"
#import "GroupsMembersCell.h"
#import "BaseModel.h"
#import "AppHelper.h"

#pragma mark - Delegate

@interface GroupsMembersSection : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UICollectionView *groupCollectionView;
@property (strong, nonatomic) IBOutlet GroupsMembersCell *tabCell;
@property (strong, nonatomic) NSMutableArray *groupsArray;
@property (strong, nonatomic) NSMutableArray *groupsTempArray;

-(void)refeshList:(NSMutableArray*)array;
-(void)refeshList;
@end
