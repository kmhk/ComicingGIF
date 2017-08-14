//
//  CBBaseTableViewController.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseViewController.h"

@interface CBBaseTableViewController : CBBaseViewController
- (NSInteger)ta_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)ta_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)ta_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView*)ta_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView*)ta_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)ta_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)ta_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (void)ta_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)ta_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
@end
