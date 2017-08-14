//
//  FriendCell.h
//  ComicApp
//
//  Created by ADNAN THATHIYA on 22/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblComicTitle;

@property (weak, nonatomic) IBOutlet UIView *viewComicBook;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintComicTitle;

@end
