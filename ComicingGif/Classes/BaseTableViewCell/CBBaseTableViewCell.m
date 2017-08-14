//
//  CBBaseTableViewCell.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseTableViewCell.h"

@implementation CBBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

// Add in subclass
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
//    [super setHighlighted:highlighted animated:animated];
//    if(highlighted){
//        [UIView animateWithDuration:0.3 animations:^{
//            self.backgroundColor= [UIColor colorWithHex:kGenericOffWhiteTextColor alpha:1.0f];
//        }];
//    }else{
//        [UIView animateWithDuration:0.3 animations:^{
//            self.backgroundColor= [UIColor colorWithHex:kWhiteColor alpha:1.0f];
//        }];
//    }
//}
@end
