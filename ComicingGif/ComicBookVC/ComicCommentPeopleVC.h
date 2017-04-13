//
//  ComicCommentPeopleVC.h
//  CurlDemo
//
//  Created by Subin Kurian on 11/2/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol commentersDelegate <NSObject>

@optional

-(void)commentersPressedAtRow:(NSUInteger)row;

@end

@interface ComicCommentPeopleVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *commentCountButton;
@property(nonatomic,strong) NSArray *CommentPeopleArray;
@property(nonatomic,assign) NSUInteger row;
@property(nonatomic,strong) id<commentersDelegate>delegate;

@end