//
//  GlideViewController.m
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 09/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "GlideViewController.h"
#import "ZoomInteractiveTransition.h"
#import "ZoomTransitionProtocol.h"
#import "GlideCell.h"
#import "ComicMakingViewController.h"
#import "AppConstants.h"
#import "ComicPage.h"

@interface GlideViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
ZoomTransitionProtocol>

@property (weak, nonatomic) IBOutlet UICollectionView *clvGlide;

@property (nonatomic, strong) ZoomInteractiveTransition * transition;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;

@property (nonatomic, strong) NSMutableArray *allComicPages;
@property (nonatomic) NSInteger editSlideIndex;
@property (nonatomic) NSInteger newSlideIndex;

@property (nonatomic) NSInteger totalSlide;
@end

@implementation GlideViewController

@synthesize transition,clvGlide,selectedIndexPath, allComicPages,editSlideIndex,newSlideIndex,totalSlide,isComeFromGroupPage,isComeFromFriendPage,groupOrFriendID;


#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    clvGlide.autoresizesSubviews = NO;
    
    [self prepareView];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UIView Methods
- (void)prepareView
{
    transition = [[ZoomInteractiveTransition alloc] initWithNavigationController:self.navigationController];
    
    allComicPages = [[NSMutableArray alloc] init];
        //   Friends Reply Comic - > @"comicSlides_Friends_Reply_{FriendId}”
    //   Group Reply Comic - > @"comicSlides_Group_Reply_{GroupId}”
    if (isComeFromGroupPage)
    {
        NSString *groupKey = [NSString stringWithFormat:@"comicSlides_Group_Reply_{%@}",groupOrFriendID];
        
        allComicPages = [[[NSUserDefaults standardUserDefaults] objectForKey:groupKey] mutableCopy];
    }
    else if (isComeFromFriendPage)
    {
        NSString *friendKey = [NSString stringWithFormat:@"comicSlides_Group_Reply_{%@}",groupOrFriendID];
        
        allComicPages = [[[NSUserDefaults standardUserDefaults] objectForKey:friendKey] mutableCopy];
    }
    else
    {
         allComicPages = [[[NSUserDefaults standardUserDefaults] objectForKey:@"comicPages"] mutableCopy];
    }
    totalSlide = allComicPages.count + 1;
    
//    if (allComicPages.count == 0)
//    {
//        ComicPage *plusComic = [[ComicPage alloc] init];
//        
//        plusComic.printScreen = UIImageJPEGRepresentation([UIImage imageNamed:@"add-button.png"], 1);
//        
//        plusComic.isPlus = @"yes";
//        
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:plusComic];
//        
//        allComicPages = [[NSMutableArray alloc] init];
//        
//        [allComicPages addObject:data];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:allComicPages forKey:@"comicPages"];
//    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (allComicPages.count == 0)
    {
        return 1;
    }
    
    return allComicPages.count + 1;}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5)
    {
        return CGSizeMake(214, 378);
    }
    else if (IS_IPHONE_6)
    {
        return CGSizeMake(250, 444);
    }
    else if (IS_IPHONE_6P)
    {
        return CGSizeMake(276, 490);
    }
    else
    {
        return CGSizeMake(214, 378);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == allComicPages.count)
    {
        GlideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"glideCell" forIndexPath:indexPath];
        
        ComicPage *comicPagePlus = [[ComicPage alloc] init];
        
//        comicPagePlus.printScreen = UIImageJPEGRepresentation([UIImage imageNamed:@"ComicAdd"], 1);
        
        cell.comicPage = comicPagePlus;
        
//        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"plusCell" forIndexPath:indexPath];
//        
//        UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
//        
//        imageView.image = [UIImage imageNamed:@"add-button"];
        
        return cell;
    }
    else
    {
        GlideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"glideCell" forIndexPath:indexPath];

        if (indexPath.item > allComicPages.count - 1)
        {
            
        }
        else
        {
            NSData *data = allComicPages[indexPath.row];
            
            ComicPage *comicPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            cell.comicPage = comicPage;
        }
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    
    if (indexPath.item == allComicPages.count)
    {
        //new slide
        newSlideIndex = indexPath.item;
        
        ComicMakingViewController *cmv = [self.storyboard instantiateViewControllerWithIdentifier:@"ComicMakingViewController"];
        
//        cmv.isNewSlide = YES;
//
//        [cmv setDelegate:self];

        [self.navigationController pushViewController:cmv animated:YES];
    }
    else
    {
        //edit slide
        NSData *data = allComicPages[indexPath.row];
        
        ComicPage *comicPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        ComicMakingViewController *cmv = [self.storyboard instantiateViewControllerWithIdentifier:@"ComicMakingViewController"];
        
//        cmv.comicPage = comicPage;
//        
//        [cmv setDelegate:self];
//        cmv.isNewSlide = NO;
        
        [self.navigationController pushViewController:cmv animated:YES];
    }
}

#pragma mark - ZoomTransitionProtocol
- (UIView *)viewForZoomTransition:(BOOL)isSource
{
    GlideCell * cell = (GlideCell *)[clvGlide cellForItemAtIndexPath:selectedIndexPath];
    
    return cell.contentView;
}

#pragma mark - ComicMakingViewControllerDelegate Method
- (void)comicMakingViewControllerWithEditingDone:(ComicMakingViewController *)controll withComicPage:(NSData *)comicPage withNewSlide:(BOOL)newSlide
{
    if (allComicPages.count == 0)
    {
        allComicPages = [[NSMutableArray alloc] init];
    }
    
    if (newSlide)
    {
        [allComicPages insertObject:comicPage atIndex:newSlideIndex];
        
        selectedIndexPath = [NSIndexPath indexPathForItem:newSlideIndex inSection:0];
        
        NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:newSlideIndex + 1  inSection:0];
        
        [clvGlide insertItemsAtIndexPaths:@[indexPaths]];
        
        [clvGlide performBatchUpdates:^
        {
            
            
        } completion:^(BOOL finished)
        {
            
        }];
        
//        [clvGlide insertItemsAtIndexPaths:@[indexPaths]];
//        
//        //   NSLog(@"array = %@",[userDefaults valueForKey:@"comicPages"]);
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newSlideIndex inSection:0];
//        
//        [clvGlide reloadItemsAtIndexPaths:@[indexPath]];
    }
    else
    {
        [allComicPages replaceObjectAtIndex:editSlideIndex withObject:comicPage];
        
        selectedIndexPath = [NSIndexPath indexPathForItem:editSlideIndex inSection:0];
        
//        [[NSUserDefaults standardUserDefaults] setObject:allComicPages forKey:@"comicPages"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:editSlideIndex inSection:0];
        
        [clvGlide reloadItemsAtIndexPaths:@[indexPath]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)comicMakingViewControllerWithEditingDone:(ComicMakingViewController *)controll withImageView:(UIImageView *)imageView andImage:(UIImage *)printScreen withNewSlide:(BOOL)newSlide
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    ComicPage *comicPage = [[ComicPage alloc] init];
//    
//    comicPage.containerImageView = imageView;
//    comicPage.containerImage = imageView.image;
//    comicPage.printScreen = UIImageJPEGRepresentation(printScreen, 1);
//    
//    comicPage.imageData = UIImageJPEGRepresentation(printScreen, 1);
//    
//    NSMutableArray *allSubveiews = [[NSMutableArray alloc] init];
//    NSMutableArray *allSubveiewsData = [[NSMutableArray alloc] init];
//    
//    NSArray *subviews = imageView.subviews;
//    
//    for (id subview in subviews)
//    {
//        if ([subview isKindOfClass:[UIImageView class]])
//        {
//            UIImageView *imageView = (UIImageView *)subview;
//            
//            UIImage *image = imageView.image;
//            
//            NSData *imageData = UIImagePNGRepresentation(image);
//            
//            [allSubveiewsData addObject:imageData];
//            
//            [allSubveiews addObject:subview];
//        }
//        else if ([subview isKindOfClass:[UIView class]])
//        {
//            UIView *view = (UIView *)subview;
//            
//            NSArray *allsubviews = view.subviews;
//            
//            UIImageView *imageView = (UIImageView *)allsubviews[0];
//            
//            UIImage *image = imageView.image;
//            
//            NSData *imageData = UIImagePNGRepresentation(image);
//            
//            [allSubveiewsData addObject:imageData];
//            
//            [allSubveiews addObject:subview];
//            
//            NSLog(@"subview = %@",allsubviews);
//        }
//        
//    }
//    
//    comicPage.subviews = [allSubveiews copy];
//    comicPage.subviewData = [allSubveiewsData copy];
//    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:comicPage];
//    
//    allComicPages = [[[NSUserDefaults standardUserDefaults] objectForKey:@"comicPages"] mutableCopy];
//    
//    if (allComicPages == nil)
//    {
//        allComicPages = [[NSMutableArray alloc] init];
//    }
//    
//    if (newSlide)
//    {
//        [allComicPages insertObject:data atIndex:newSlideIndex];
//        
//        [clvGlide performBatchUpdates:^
//        {
//            NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:newSlideIndex + 1 inSection:0];
//            
//            [clvGlide insertItemsAtIndexPaths:@[indexPaths]];
//            
//        }completion:^(BOOL finished)
//        {
//            
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            
//            [userDefaults setObject:allComicPages forKey:@"comicPages"];
//            [userDefaults synchronize];
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newSlideIndex inSection:0];
//            
//            NSIndexPath *plusIndexPath = [NSIndexPath indexPathForRow:newSlideIndex + 1 inSection:0];
//            
//            [clvGlide reloadItemsAtIndexPaths:@[indexPath,plusIndexPath]];
//        }];
//    }
//    else
//    {
//        [allComicPages replaceObjectAtIndex:editSlideIndex withObject:data];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:allComicPages forKey:@"comicPages"];
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:editSlideIndex inSection:0];
//        
//      //  NSIndexPath *plusIndexPath = [NSIndexPath indexPathForRow:allComicPages.count - 1 inSection:0];
//        
//        [clvGlide reloadItemsAtIndexPaths:@[indexPath]];
//        
//    }
//}

@end
