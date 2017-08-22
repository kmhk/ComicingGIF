//
//  MePageVC.h
//  CurlDemo
//
//  Created by Subin Kurian on 10/28/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicBookVC.h"
@interface MePageVC : UIViewController<UITableViewDelegate, UITableViewDataSource,BookChangeDelegate>
@property(nonatomic,strong)NSMutableDictionary*ComicBookDict;
@property(nonatomic,strong)UIButton* currentButton;

@property(nonatomic,strong)UILabel* currentHollowLable;
@property(nonatomic,strong)UILabel* currentDisplayLable;


@end
