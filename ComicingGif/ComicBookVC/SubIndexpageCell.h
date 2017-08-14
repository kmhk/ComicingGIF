//
//  SubIndexpageCell.h
//  ComicBook
//
//  Created by Sanjay Thakkar on 17/09/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubIndexpageCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img_MainImage;
@property (strong,nonatomic) NSMutableArray *arrOfEnhancements;
@property (strong,nonatomic) NSMutableArray *arrOfAnimationStickers;

@end
