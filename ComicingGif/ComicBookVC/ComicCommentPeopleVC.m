//
//  ComicCommentPeopleVC.m
//  CurlDemo
//
//  Created by Subin Kurian on 11/2/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import "ComicCommentPeopleVC.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"

@interface ComicCommentPeopleVC ()

@end

@implementation ComicCommentPeopleVC
@synthesize CommentPeopleArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.commentCountButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.CommentPeopleArray.count] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
      return [CommentPeopleArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CommentPeopleCell" forIndexPath:indexPath];
   if(cell!=nil) {
       UIImageView *img=[cell viewWithTag:1];
       img.layer.cornerRadius=15;
       img.clipsToBounds = YES;
       img.layer.masksToBounds=YES;
   }
  
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *img=[cell viewWithTag:1];
    CommentModel *commentModel = [CommentPeopleArray objectAtIndex:indexPath.row];
    [img sd_setImageWithURL:[NSURL URLWithString:commentModel.profilePic] placeholderImage:nil options:SDWebImageRetryFailed];
}
- (IBAction)commenters:(id)sender {
    [[self delegate]commentersPressedAtRow:self.row];
}
@end
