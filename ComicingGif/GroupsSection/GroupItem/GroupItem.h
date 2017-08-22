//
//  GroupItem.h
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupItem : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UIView *mHolderView;
@property (weak, nonatomic) IBOutlet UIView *addHolder;
@property (weak, nonatomic) IBOutlet UIButton *addGroupButton;

@end
