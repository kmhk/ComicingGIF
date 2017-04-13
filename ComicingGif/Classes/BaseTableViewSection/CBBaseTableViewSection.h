//
//  CBBaseTableViewSection.h
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBBaseTableViewCell.h"

@interface CBBaseTableViewSection : NSObject
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSString* headerTitle;

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (CBBaseTableViewCell*)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfRowsInSection;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)sectionFooterHeight;
- (UIView*)sectionFooterView;
- (CGFloat)sectionHeaderHeight;
- (UIView*)sectionHeaderView;
@end
