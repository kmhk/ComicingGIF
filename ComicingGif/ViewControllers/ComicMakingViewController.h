//
//  ComicMakingViewController.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicObjectView.h"


@interface ComicMakingViewController : UIViewController
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate,
ComicObjectViewDelegate
>

// initialize comic making view controller with background GIF/Image from url
- (void)initWithBaseImage:(NSURL *)url frame:(CGRect)rect index:(NSInteger)index objs:(NSArray *)array;

@property (nonatomic) NSInteger indexSaved;

@end
