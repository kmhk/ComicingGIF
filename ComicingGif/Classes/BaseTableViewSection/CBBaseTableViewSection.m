//
//  CBBaseTableViewSection.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseTableViewSection.h"

@implementation CBBaseTableViewSection
- (NSInteger)numberOfRowsInSection{
    return self.dataArray.count;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    
}

- (CBBaseTableViewCell*)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    return [[CBBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 0.0f;
}

- (CGFloat)sectionFooterHeight{
    return 0.01f;
}

- (UIView*)sectionFooterView{
    return nil;
}

- (CGFloat)sectionHeaderHeight
{
    return 0.01f;
}

- (UIView*)sectionHeaderView
{
    return nil;
}

@end
