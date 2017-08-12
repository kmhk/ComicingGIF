//
//  CBComicTitleFontDropdownViewController.m
//  ComicBook
//
//  Created by Amit on 13/01/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "CBComicTitleFontDropdownViewController.h"
#import "AppConstants.h"

@interface CBComicTitleFontDropdownViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSMutableArray *fontNames;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

@end

#define TitleFontTableViewCellLabelTag 11
#define TitleFontTableViewCellHeight 50

@implementation CBComicTitleFontDropdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fontNames = [NSMutableArray arrayWithObjects:@"BLACKHAWK Italic",
                  @"BLACKHAWK Swash",
                  @"BLACKHAWK",
                  @"Candyhouse Alt",
                  @"Candyhouse Caps",
                  @"Candyhouse Doodles",
                  @"Candyhouse",
                  @"Justlove-Italic",
                  @"Justlove-Regular",
                  @"Littlemorning",
                  @"Luckiest Softie Pro Extra Bold PS",nil];
    _viewTopConstraint.constant = IS_IPHONE_5?84: (IS_IPHONE_6?94: (IS_IPHONE_6P?104: 114));;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.fontNames.count <= 7) {
        self.tableViewHeightConstraint.constant = self.fontNames.count * TitleFontTableViewCellHeight;
    } else {
        self.tableViewHeightConstraint.constant = 6 * TitleFontTableViewCellHeight; //6 is max number of visible cells
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fontNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FontListTableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ((UILabel *)[cell viewWithTag:TitleFontTableViewCellLabelTag]).text = self.titleText;
    
    UIFont *font = [UIFont fontWithName:[self.fontNames objectAtIndex:indexPath.row] size:30.f];
    [((UILabel *)[cell viewWithTag:11]) setFont:font];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(getSelectedFontName:andTitle:)]) {
        [self.delegate getSelectedFontName:[self.fontNames objectAtIndex:indexPath.row] andTitle:_titleText];
    }
    [self closeDropDownAndDismissController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TitleFontTableViewCellHeight;
}

- (IBAction)emptyScreenTapped:(id)sender {
    [self closeDropDownAndDismissController];
}

- (void)closeDropDownAndDismissController {
    self.tableViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
