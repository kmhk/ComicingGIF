//
//  MePageDetailsVC.h
//  CurlDemo
//
//  Created by Subin Kurian on 11/10/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicBook.h"

@interface MePageDetailsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (strong, nonatomic) ComicBook *comicBook;

@end
