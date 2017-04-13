//
//  GlideCell.h
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 09/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicPage.h"

@interface GlideCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgvComic;

@property (weak, nonatomic) ComicPage *comicPage;

@end
