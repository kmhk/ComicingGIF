//
//  searchFriendView.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 06/04/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchFriendView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tblvSearch;
- (void)searchFriendByString:(NSString *)searchString;
@property (strong, nonatomic) IBOutlet UIView *view;

@end
