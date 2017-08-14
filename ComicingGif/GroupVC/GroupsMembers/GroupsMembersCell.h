//
//  GroupSectionCell.h
//  ComicApp
//
//  Created by Ramesh on 24/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupsMembersCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UIView *mHolderView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMember;

@end
