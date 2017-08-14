
//
//  CBComicPageViewController.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Comic Book. All rights reserved.
//

#import "CBComicPageViewController.h"
#import "AppConstants.h"

#define kMaxCellCount 100000

@interface CBComicPageViewController () <CBComicPageCollectionDelegate>
@end

@implementation CBComicPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray= [NSMutableArray new];
    
//    [self setupPageViewController];
    self.viewControllers= [NSMutableArray new];
}

- (void)addComicItem:(CBComicItemModel*)comicItem completion:(void (^)(BOOL finished))completion{
    
    if (self.dataArray.count == kMaxItemsInComic) {
        completion(NO);
        return;
    }
    
    [self.dataArray addObject:comicItem];
    
    if(self.dataArray.count%kMaxItemsInComic == 1){
        // Add a new page
        CBComicPageCollectionVC* vc;
        if (self.viewControllers.count == 0) {
            vc = [[CBComicPageCollectionVC alloc] initWithNibName:@"CBComicPageCollectionVC" bundle:nil];
            vc.delegate= self;
            [self addViewControllers:@[vc]];
        } else {
            vc = [self.viewControllers lastObject];
        }
        [self changePageToIndex:self.viewControllers.count-1 completed:^(BOOL success) {
            if(success){
                [vc addComicItem:comicItem completion:^(BOOL finished, CBComicItemModel *itemModel) {
                    
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    completion(YES);
                });
            }
        }];
    }else{
        // Add item in last page
        CBComicPageCollectionVC* vc= [self.viewControllers lastObject];
        if(self.currentIndex != self.viewControllers.count-1){
            [self changePageToIndex:self.viewControllers.count-1 completed:^(BOOL success) {
                if(success){
                    [vc addComicItem:comicItem completion:^(BOOL finished, CBComicItemModel *itemModel) {
                        
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        completion(YES);
                    });
                }
            }];
        }else{
            [vc addComicItem:comicItem completion:^(BOOL finished, CBComicItemModel *itemModel) {
                
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completion(YES);
            });
        }
    }
    if(!self.pageController){
        [self reloadPageViewController];
    }
}

- (void)refreshPageContentAfterIndex:(NSInteger)index{
    BOOL shouldRemoveLastPage= NO;
    for(NSInteger i=index+1; i < self.viewControllers.count; i++){
        CBComicPageCollectionVC* collectionVC= [self.viewControllers objectAtIndex:i];
        NSMutableArray* comicItems= [NSMutableArray new];
        NSInteger offset= collectionVC.index*kMaxItemsInComic;
        for(NSInteger j=offset; j < offset+kMaxItemsInComic; j++){
            if(j < self.dataArray.count){
                [comicItems addObject:[self.dataArray objectAtIndex:j]];
            }
        }
        [collectionVC refreshDataArray:comicItems];
        if(comicItems.count == 0){
            shouldRemoveLastPage= YES;
        }
    }
    if(shouldRemoveLastPage && self.currentIndex != self.viewControllers.count-1){
        // Add next view controller's first comic item into current page
        NSInteger itemToAdd= self.index+1*kMaxItemsInComic;
        if(itemToAdd-1 < self.dataArray.count){
            CBComicPageCollectionVC* currentVC= [self.viewControllers objectAtIndex:index];
            [currentVC addComicItem:[self.dataArray objectAtIndex:itemToAdd-1] completion:^(BOOL finished, CBComicItemModel *itemModel) {
                
            }];
        }
    }
    if(shouldRemoveLastPage && self.viewControllers.count>1){
        if(self.viewControllers.count>1){
            if(self.currentIndex == [(CBComicPageCollectionVC*)[self.viewControllers lastObject] index]){
                // Scroll to left and delete last index
                [self scrollPageViewToLeft:^(BOOL sucess) {
                    if(sucess){
                        [self.viewControllers removeLastObject];
                    }
                }];
            }else{
                // Remove last index
                [self.viewControllers removeLastObject];
            }
        }else if(self.viewControllers.count>0){
            // Do nothing
        }
    }
}

#pragma mark- CBComicPageCollectionDelegate method
- (void)didDeleteComicItem:(CBComicItemModel *)comicItem inComicPage:(CBComicPageCollectionVC *)comicPage{
    [self.dataArray removeObject:comicItem];
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(CBComicPageViewControllerDelegate)]){
        if([self.delegate respondsToSelector:@selector(didDeleteComicItem:inPage:)]){
            [self.delegate didDeleteComicItem:comicItem inPage:comicPage];
        }
    }
    [self refreshPageContentAfterIndex:comicPage.index];
}

- (void)didTapOnComicItemWithIndex:(NSInteger)index {
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(CBComicPageViewControllerDelegate)]){
        if([self.delegate respondsToSelector:@selector(didTapOnComicItemWithIndex:)]){
            [self.delegate didTapOnComicItemWithIndex:index];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
