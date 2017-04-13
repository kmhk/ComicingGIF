//
//  IndexPageVC.h
//  CurlDemo
//
//  Created by Subin Kurian on 10/19/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"
#import "Enhancement.h"

@interface IndexPageVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *slidesArray;

@property(nonatomic,strong)IBOutlet UICollectionView*collectionView;
@property(nonatomic,assign)int pageNumber;
@property(nonatomic,assign) int Tag;

@property BOOL isSlidesContainImages;

@end
