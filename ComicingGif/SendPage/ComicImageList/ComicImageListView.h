//
//  ComicImageListViewController.h
//  ComicApp
//
//  Created by Ramesh on 02/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicImageListView.h"
#import "ComicImageCollectionCell.h"

@interface ComicImageListView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UICollectionView *comicImageCollectionView;
@property (strong, nonatomic) NSMutableArray*  comicImageCollection;
@property (strong, nonatomic) IBOutlet ComicImageCollectionCell *tabCell;

-(void)refeshList:(NSMutableArray*)array;

@end
