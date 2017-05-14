//
//  CBComicPageCollectionVC.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBComicPageCollectionVC.h"
#import "CBComicImageSection.h"
#import "CBComicImageCell.h"
#import "ZoomInteractiveTransition.h"
#import "AppConstants.h"

#define kMaxCellCount 100000

@interface CBComicPageCollectionVC () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *verticalShadowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalShadowImageView;
//@property (nonatomic, strong) ZoomInteractiveTransition * transition;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@property (nonatomic, strong) UILongPressGestureRecognizer* longPressRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer* tapGestureRecognizer;
@end

@implementation CBComicPageCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.longPressRecognizer= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.longPressRecognizer.delegate= self;
    self.longPressRecognizer.delaysTouchesBegan= YES;
    [self.collectionView addGestureRecognizer:self.longPressRecognizer];
    
    self.tapGestureRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    self.tapGestureRecognizer.delegate= self;
    self.tapGestureRecognizer.delaysTouchesBegan= YES;
    [self.collectionView addGestureRecognizer:self.tapGestureRecognizer];
    
//    self.dataArray= [NSMutableArray new];
    
//    [self.dataArray addObject:[[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] image:[UIImage imageNamed:@"hor_image.jpg"] orientation:COMIC_ITEM_ORIENTATION_LANDSCAPE]];
//    [self.dataArray addObject:[[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] image:[UIImage imageNamed:@"ver_image.jpg"] orientation:COMIC_ITEM_ORIENTATION_PORTRAIT]];
//    [self.dataArray addObject:[[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] image:[UIImage imageNamed:@"ver_image.jpg"] orientation:COMIC_ITEM_ORIENTATION_PORTRAIT]];
//    [self.dataArray addObject:[[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] image:[UIImage imageNamed:@"hor_image.jpg"] orientation:COMIC_ITEM_ORIENTATION_LANDSCAPE]];
//    [self.dataArray addObject:[[CBComicItemModel alloc] initWithTimestamp:[self currentTimestmap] image:[UIImage imageNamed:@"hor_image.jpg"] orientation:COMIC_ITEM_ORIENTATION_LANDSCAPE]];
//    [self refreshImageOrientation];
    
//    self.collectionView.scrollEnabled= NO;
    
    if(!self.dataArray){
        self.dataArray= [NSMutableArray new];
    }
    if(self.sectionArray.count == 0){
        [self setupSections];
    }
}

- (void)setupSections{
    self.sectionArray= [NSMutableArray new];
    CBComicImageSection* section= [CBComicImageSection new];
    section.dataArray= self.dataArray;
    [self.sectionArray addObject:section];
    [self.collectionView reloadData];
}

- (void)refreshDataArray:(NSMutableArray*)dataArray{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.collectionView reloadData];
}

- (CGFloat)contentHeight{
    return self.collectionView.collectionViewLayout.collectionViewContentSize.height+22.0f+78.0f;
}

- (NSNumber*)currentTimestmap{
    return @([[NSDate date] timeIntervalSince1970]);
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            CBBaseCollectionViewSection* section= [self.sectionArray objectAtIndex:indexPath.section];
            if([section isKindOfClass:[CBComicImageSection class]]){
                self.selectedIndexPath= indexPath;
                // Show alert view
                [self showDeleteAlertForIndexPath:indexPath];
            }
        }
    }
}

- (void)tapRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (indexPath == nil){
        NSLog(@"couldn't find index path on tap");
    } else {
        if(self.delegate && [self.delegate conformsToProtocol:@protocol(CBComicPageCollectionDelegate)]){
            if([self.delegate respondsToSelector:@selector(didTapOnComicItemWithIndex:)]){
                [self.delegate didTapOnComicItemWithIndex:indexPath.item];
            }
        }
    }
}

- (void)showDeleteAlertForIndexPath:(NSIndexPath*)indexPath{
    UIAlertController* alertController= [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete this image?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* deleteAction= [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CBComicItemModel* deletedItem= [self.dataArray objectAtIndex:indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self refreshImageOrientation];
//        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [self.collectionView reloadData];
        if(self.delegate && [self.delegate conformsToProtocol:@protocol(CBComicPageCollectionDelegate)]){
            if([self.delegate respondsToSelector:@selector(didDeleteComicItem:inComicPage:)]){
                [self.delegate didDeleteComicItem:deletedItem inComicPage:self];
            }
        }
    }];
    UIAlertAction* cancelAction= [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)refreshImageOrientation{
    for(NSInteger i=0; i < self.dataArray.count; i++){
        CBComicItemModel* currentItem= self.dataArray[i];
        if(currentItem.itemOrientation == COMIC_ITEM_ORIENTATION_LANDSCAPE){
            currentItem.imageOrientation= COMIC_IMAGE_ORIENTATION_LANDSCAPE;
        }else {
            if(i-1 >= 0){
                CBComicItemModel* previousItem= self.dataArray[i-1];
                if(previousItem.itemOrientation == COMIC_ITEM_ORIENTATION_PORTRAIT){
                    if(previousItem.imageOrientation == COMIC_IMAGE_ORIENTATION_PORTRAIT_FULL){
                        previousItem.imageOrientation= COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF;
                        currentItem.imageOrientation= COMIC_IMAGE_ORIENTATION_PORTRAIT_HALF;
                        continue;
                    }
                }
            }
            currentItem.imageOrientation= COMIC_IMAGE_ORIENTATION_PORTRAIT_FULL;
        }
    }
}

- (void)addComicItem:(CBComicItemModel*)comicItem completion:(void (^)(BOOL))completion {
    if (self.dataArray.count == kMaxItemsInComic) {
        return;
    }
    if(!self.dataArray){
        self.dataArray= [NSMutableArray new];
    }
    [self.dataArray addObject:comicItem];
    if(self.sectionArray.count == 0){
        [self setupSections];
    }
//    [[[self.sectionArray objectAtIndex:0] dataArray] addObject:comicItem];
    [self refreshImageOrientation];
//    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.dataArray indexOfObject:comicItem] inSection:0]]];
    
    
    if (self.collectionView != nil) {
        [self.collectionView reloadData];
    }
    
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.dataArray indexOfObject:comicItem] inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    
    completion(YES);
}

#pragma mark- UICollectionViewDataSource helper methods

- (UICollectionViewCell*)ta_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CBBaseCollectionViewSection* section= [self.sectionArray objectAtIndex:indexPath.section];
    UICollectionViewCell* cell= [super ta_collectionView:collectionView cellForItemAtIndexPath:indexPath];
    if([section isKindOfClass:[CBComicImageSection class]]){
        // Do something
        ((CBComicImageSection *)section).comicItemModel = [self.dataArray objectAtIndex:indexPath.item];
        [(CBComicImageSection *)section createUIForCell:(CBComicImageCell *)cell withIndex:indexPath.item andFrame:self.collectionView.frame];
    }
    return cell;
}

#pragma mark- ZoomTransitionProtocol method
- (UIView*)getZoomTransitionViewForIndexPath:(NSIndexPath *)indexPath {
    if(indexPath){
        CBComicImageCell * cell = (CBComicImageCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

#pragma mark-

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
