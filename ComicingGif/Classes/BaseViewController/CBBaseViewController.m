//
//  CBBaseViewController.m
//  ComicBook
//
//  Created by Atul Khatri on 02/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseViewController.h"

@interface CBBaseViewController ()

@end

@implementation CBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"........................%@", [NSString stringWithFormat:@"%@",self]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self loadContent];
}

- (void)loadContent{
    // Override to make API call here
}

- (void)dealloc{
    self.tableView.delegate= nil;
    self.collectionView.delegate= nil;
}
@end
