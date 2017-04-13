//
//  CMCGroupCell.h
//  ComicApp
//
//  Created by ADNAN THATHIYA on 01/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCComic.h"

@interface CMCComicCell : UITableViewCell

@property (weak, nonatomic) CMCComic *comic;
@property (weak, nonatomic) IBOutlet UIView *viewComicBook;
@end
