//
//  CBPreviewHeaderSection.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBPreviewHeaderSection.h"
#import "CBPreviewHeaderCell.h"

#define kCellIdentifier @"PreviewHeaderCell"
#define kCellHeight 80.0f

@implementation CBPreviewHeaderSection
- (CBBaseTableViewCell*)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    self.tableView= tableView;
    CBPreviewHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"CBPreviewHeaderCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor= [UIColor blackColor];
    return cell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (NSInteger)numberOfRowsInSection{
    return 1;
}
@end
