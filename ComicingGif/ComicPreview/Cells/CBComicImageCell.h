//
//  CBComicImageCell.h
//  ComicBook
//
//  Created by Atul Khatri on 04/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseCollectionViewCell.h"
#import "ComicItem.h"

@interface CBComicImageCell : CBBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *baseLayerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *staticImageView;
@property (weak, nonatomic) IBOutlet UIView *topLayerView;

@end
