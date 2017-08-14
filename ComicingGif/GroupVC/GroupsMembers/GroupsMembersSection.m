//
//  GroupsSection.m
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "GroupsMembersSection.h"
#import "UIImageView+WebCache.h"

@implementation GroupsMembersSection
//@synthesize groupsArray;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"GroupsMembersSection" owner:self options:nil];
    
        [self addSubview:self.view];
        [self configSection];
    }
    return self;
}

-(void)configSection{
    
    CGRect viewRect = self.view.frame;
    viewRect.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.view.frame = viewRect;
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.groupCollectionView registerClass:[GroupsMembersCell class] forCellWithReuseIdentifier:@"tabCell"];
    self.groupCollectionView.delegate = self;
}

-(void)refeshList:(NSMutableArray*)array{
    self.groupsTempArray = [array mutableCopy];
    self.groupsArray = array;
    [self.groupCollectionView reloadData];
}

-(void)refeshList{
    [self.groupCollectionView reloadData];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section { 
    return self.groupsTempArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupsMembersCell *cell = (GroupsMembersCell*)[cv dequeueReusableCellWithReuseIdentifier:@"tabCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];

    [cell.mHolderView setHidden:NO];
    
    [cell.btnAddMember setHidden:YES];
    [cell.groupImage setImage:nil];
    if ([self.groupsTempArray objectAtIndex:indexPath.row] &&
        [[self.groupsTempArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
            [cell.btnAddMember setHidden:YES];
    }else{
    
    GroupMember *us = (GroupMember*)[[GroupMember alloc] initWithDictionary:[self.groupsTempArray objectAtIndex:indexPath.row] error:nil];

    if (us == nil) {
        [cell.btnAddMember setHidden:YES];
    }else{
        [cell.groupImage sd_setImageWithURL:[NSURL URLWithString:us.profile_pic] placeholderImage:[UIImage imageNamed:@"Placeholder"] options:SDWebImageRetryFailed];
//        [cell.groupImage downloadImageWithURL:[NSURL URLWithString:us.profile_pic]
//                              placeHolderImage:[UIImage imageNamed:@"Placeholder"]
//                               completionBlock:^(BOOL succeeded, UIImage *image) {
//                                   cell.groupImage.image = image;
//                               }];

        
//        [cell.groupImage sd_setImageWithURL:[NSURL URLWithString:us.profile_pic]
//                             placeholderImage:[UIImage imageNamed:@"Placeholder"]
//                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                        
//                                    }];
        
    }
    }
    return cell;
}

// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


#pragma mark - Events

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
