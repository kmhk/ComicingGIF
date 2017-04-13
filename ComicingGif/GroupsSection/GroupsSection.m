//
//  GroupsSection.m
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "GroupsSection.h"
#import "UIButton+Property.h"
#import "UIImage+resize.h"
#import "UIImageView+WebCache.h"

#define cell_button_tag 2020

@implementation GroupsSection

@synthesize selectedGroups;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {}
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"GroupsSection" owner:self options:nil];
        
        [self addSubview:self.view];
        [self configSection];
    }
    return self;
}

-(void)configSection{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.groupCollectionView registerClass:[GroupSectionCell class] forCellWithReuseIdentifier:@"tabCell"];
    self.groupCollectionView.delegate = self;
    selectedGroups = [[NSMutableArray alloc] init];

    
    [self getGroupsByUserId];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section { 
    return  self.enableAdd ?self.groupsArray.count + 1 : self.groupsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupSectionCell *cell = (GroupSectionCell*)[cv dequeueReusableCellWithReuseIdentifier:@"tabCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];

    [cell.mHolderView setHidden:NO];
    
    if (indexPath.row == 0 && self.enableAdd)
    {
        [cell.mHolderView setHidden:YES];
        [cell.addHolder setHidden:NO];
        [cell.addGroupButton addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        UserGroup* ug =  (UserGroup*)[self.groupsArray objectAtIndex:self.enableAdd?indexPath.row-1:indexPath.row];
        
        [cell.groupImage sd_setImageWithURL:[NSURL URLWithString:ug.group_icon]
                            placeholderImage:[UIImage imageNamed:@"Placeholder"] options:SDWebImageRetryFailed];
        
//        [cell.groupImage downloadImageWithURL:[NSURL URLWithString:ug.group_icon]
//                             placeHolderImage:[UIImage imageNamed:@"Placeholder"]
//                              completionBlock:^(BOOL succeeded, UIImage *image) {
//                                  cell.groupImage.image = [UIImage resizeImage:image newSize:CGSizeMake(40, 40)];
//                              }];
        
//        [cell.groupImage sd_setImageWithURL:[NSURL URLWithString:ug.group_icon]
//                             placeholderImage:[UIImage imageNamed:@"Placeholder"]
//                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////                                        cell.groupImage.image = [UIImage ScaletoFill:image toSize:CGSizeMake(40, 40)];
//                                        cell.groupImage.image = [UIImage resizeImage:image newSize:CGSizeMake(40, 40)];
//                                    }];
        cell.groupName.text = ug.group_title;
        [cell.groupName setFont:[UIFont  fontWithName:@"MYRIADPRO-REGULAR" size:12]];
        [cell.holderButton addTarget:self action:@selector(openGroup:) forControlEvents:UIControlEventTouchUpInside];
        cell.holderButton.tag = cell_button_tag + indexPath.row;
        cell.holderButton.property = ug.group_id;
        cell.groupImage.layer.cornerRadius = 5.0;
        cell.groupImage.layer.masksToBounds = YES;
        
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.enableSelection)
    {
        if (self.enableAdd && indexPath.row != 0)
        {
            
            //do call selection
            [self selectCellItems:[self.groupsArray objectAtIndex:indexPath.row]];
        }
    }
}
/*
// 4
- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


#pragma mark - Events

-(void)openGroup:(UIButton*)sender
{
    if(self.enableSelection)
    {
        NSInteger itemIndex = ((UIButton*)sender).tag - cell_button_tag;
        if(itemIndex >= 0 && [self.groupsArray count] > itemIndex)
        {
            NSIndexPath* tempIndexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];

            GroupSectionCell *cell = (GroupSectionCell*)[self.groupCollectionView cellForItemAtIndexPath:tempIndexPath];
            
            if(cell)
            {
               // [cell.bgSelectionView setBackgroundColor:[UIColor colorWithHexStr:@"26ace2"]];
               
                UserGroup* ug =  (UserGroup*)[self.groupsArray objectAtIndex:itemIndex];
 
                if ([selectedGroups containsObject:ug] == YES)
                {
                    // add obj
                    cell.groupImage.layer.borderColor = [UIColor clearColor].CGColor;
                    cell.groupImage.layer.borderWidth = 4;
                    
                    [selectedGroups removeObject:ug];
                }
                else
                {
                    // remove obj
                    cell.groupImage.layer.borderColor = [UIColor colorWithHexStr:@"26ace2"].CGColor;
                    cell.groupImage.layer.borderWidth = 4;
                    
                    [selectedGroups addObject:ug];
                }
            }
            
            [self selectCellItems:[self.groupsArray objectAtIndex:itemIndex]];
        }
    }
    else if (self.delegate && [self.delegate respondsToSelector:@selector(showGroup:)])
    {
        NSString* groupId = [NSString stringWithFormat:@"%@", ((UIButton*)sender).property];
        [self.delegate showGroup:[groupId intValue]];
    }
}
-(void)addGroup{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNewGroup)])
    {
        [self.delegate addNewGroup];
    }
}
-(void)selectCellItems:(id)object{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGroupItems:)])
    {
        [self.delegate selectGroupItems:object];
    }
}
-(void)getGroupsByUserId{
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking getUserGroupsByUserId:[AppHelper getCurrentLoginId] completion:^(id json,id jsonResponse) {
        [self groupResponse:json];
    } ErrorBlock:^(JSONModelError *error) {
        
    }];
}

#pragma mark Api Delegate

-(void)failResponse:(NSDictionary *)response{
    
}
-(void)groupResponse:(NSDictionary *)response{
    //initialize the models
    self.groupsArray  = [UserGroup arrayOfModelsFromDictionaries:response[@"data"]];
    [self.groupCollectionView reloadData];
    //    NSLog(@"USer %@",userArray);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
