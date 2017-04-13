//
//  TopSearchVC.h
//  CurlDemo
//
//  Created by Ramesh on 18/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarViewController.h"
#import "UserSearch.h"

@interface TopSearchVC : UIViewController<UITableViewDelegate>
{
    TopBarViewController *topBarView;
//    UIViewController* _parentViewContent;
}

@property NSArray *searchResultArray;
@property (nonatomic, strong) UserSearch *friendSearchObject;

- (void) displayContentController: (UIViewController*) parentViewContent;
@end
