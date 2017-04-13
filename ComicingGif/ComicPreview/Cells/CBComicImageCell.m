//
//  CBComicImageCell.m
//  ComicBook
//
//  Created by Atul Khatri on 04/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBComicImageCell.h"

@implementation CBComicImageCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 3.0f;
}

@end
