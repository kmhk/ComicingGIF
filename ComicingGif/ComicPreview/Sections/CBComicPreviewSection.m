//
//  CBComicPreviewSection.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBComicPreviewSection.h"
#import "CBComicPreviewCell.h"

#define kCellIdentifier @"ComicPreviewCell"

@implementation CBComicPreviewSection
- (CBBaseTableViewCell*)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    self.tableView= tableView;
    CBComicPreviewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"CBComicPreviewCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor= [UIColor blackColor];
    return cell;
}

- (NSInteger)numberOfRowsInSection{
    return 1;
}
@end
