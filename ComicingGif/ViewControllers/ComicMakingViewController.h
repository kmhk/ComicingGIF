//
//  ComicMakingViewController.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicObjectView.h"
#import "CMCBubbleView.h"
#import "CMCCaptionView.h"


@interface ComicMakingViewController : UIViewController
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate,
ComicObjectViewDelegate,
CMCBubbleViewDelegate,
CMCCaptionViewDelegate
>

// initialize comic making view controller with background GIF/Image from url

@property (nonatomic) NSInteger indexSaved;
@property (nonatomic, assign) BOOL shouldShowScrollBar;
@property (nonatomic) BOOL isFromCamera;

- (void)initWithBaseImage:(NSURL *)url frame:(CGRect)rect andSubviewArray:(NSMutableArray *)arrSubviews isTall:(BOOL)isTall index:(NSInteger)index;

@end
