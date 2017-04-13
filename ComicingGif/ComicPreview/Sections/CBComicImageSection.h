//
//  CBComicImageSection.h
//  ComicBook
//
//  Created by Atul Khatri on 02/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBBaseCollectionViewSection.h"

@class CBComicItemModel;
@class CBComicImageCell;

@interface CBComicImageSection : CBBaseCollectionViewSection

@property (strong, nonatomic) CBComicItemModel *comicItemModel;

- (void)createUIForCell:(CBComicImageCell *)cell withIndex:(NSInteger)index;

@end
