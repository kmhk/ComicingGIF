//
//  CBBaseTableViewController.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseTableViewController.h"
#import "CBBaseTableViewSection.h"
#import "CBBaseTableViewCell.h"

@interface CBBaseTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView* tableHeaderView;
@property (nonatomic, strong) UIView* statusBarOverlayView;
@property (nonatomic, assign) CGFloat tableHeaderViewHeight;
@end

@implementation CBBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate= self;
    self.tableView.dataSource= self;
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self ta_tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self ta_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self ta_tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self ta_tableView:tableView heightForHeaderInSection:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [self ta_tableView:tableView viewForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [self ta_tableView:tableView heightForFooterInSection:section];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ta_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self ta_tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self ta_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark- 
- (NSInteger)ta_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] numberOfRowsInSection];
}

- (UITableViewCell *)ta_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBBaseTableViewSection* section= [self.sectionArray objectAtIndex:indexPath.section];
    CBBaseTableViewCell* cell= [section cellWithTableView:tableView forIndexPath:indexPath];
    return cell;
}

- (CGFloat)ta_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBBaseTableViewSection* section= [self.sectionArray objectAtIndex:indexPath.section];
    return [section heightForRowAtIndexPath:indexPath];
}

- (UIView*)ta_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] sectionHeaderView];
}

- (UIView*)ta_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] sectionFooterView];
}

- (CGFloat)ta_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] sectionHeaderHeight];
}

- (CGFloat)ta_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [[self.sectionArray objectAtIndex:section] sectionFooterHeight];
}

- (void)ta_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[self.sectionArray objectAtIndex:indexPath.section] tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)ta_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
