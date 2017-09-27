
//  Created by Subin Kurian on 10/8/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
#import "MainPageVC.h"
#import "ModelController.h"
#import "DataViewController.h"
#import "CommentsAPIManager.h"
#import "CommentModel.h"
#import "Utilities.h"
#import "STTwitter.h"
#import <Accounts/Accounts.h>
#import "ComicsAPIManager.h"
#import "ComicsModel.h"
#import "ComicBook.h"
#import "Slides.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "CameraViewController.h"
#import "ContactsViewController.h"
#import "FriendPageVC.h"
#import "TopSearchVC.h"
#import "ShareHelper.h"
#import "MBProgressHUD.h"
#import "ComicShareView.h"
#import "AppHelper.h"
#import "MePageVC.h"
#import "AppDelegate.h"
#import "MainPageCell.h"
#import "MainPage3SlideCell.h"
#import "Global.h"
#import "MainPage2SlideCell.h"
#import "InstructionView.h"
#import "ContactController.h"
#import "ComicCell.h"
#import "SlidesScrollView.h"

#import "ComicCellViewController.h"
#import "ComicPageViewController.h"

#import "CategoryCollectionViewCell.h"
#import "ComicProperties.h"
#import "UIButton+WebCache.h"

#define FB 10
#define IM 11
#define TW 12
#define IN 13

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage);
NSString * const BottomBarView = @"BottomBarView";

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface MainPageVC () <pagechangeDelegate,CustomTextViewDelegate, UIActionSheetDelegate, STTwitterAPIOSProtocol, UIGestureRecognizerDelegate,BookChangeDelegate, UITextViewDelegate, InstructionViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    // used by comment
    UIView *commentContainerView;
    CustomTextView *textView;
    int count;
    BOOL isFirstTime;
    int comicBookIndex;
    NSMutableArray *comicsArray;
    NSMutableArray *slideImages;
    UISwitch *onoff;
    ACAccount *twitterAccount;
    NSString *currentComicUserId;
    Friend *friendObject;
    TopSearchVC *topSearchView;
    BOOL changePage;
    int TagRecord;
    NSInteger currentComicIndex;
   
    NSUInteger pageIndex;
    NSUInteger oldPageIndex;

}
@property (weak, nonatomic) IBOutlet UIView *CurlContainer;
@property (weak, nonatomic) IBOutlet UIButton *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImage;
@property (weak, nonatomic) IBOutlet UIImageView *coverTemp;
@property (weak, nonatomic) IBOutlet UIButton *refreshComic;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Loader;
@property (readonly, strong, atomic) ModelController *modelController;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicOfComic;
@property (weak, nonatomic) IBOutlet UILabel *shareDotLabel;
@property (weak, nonatomic) IBOutlet MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet ComicShareView *comicShareView;
@property (weak, nonatomic) IBOutlet UITableView *tblvComics;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainLoader;

//used by comment
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,assign) float keyboardHeight;
@property(nonatomic,assign) float currentPoint;

// Twitter related
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;


@property (strong, nonatomic) NSMutableArray *allCellFrameHeight;

@property BOOL isAPICalling;

//Category
@property(strong, nonatomic) NSArray *categoriesNames;
@property(strong, nonatomic) NSArray *categoriesImageNames;
@property(weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *categoryCollectionViewHeightConstraint;
@property(assign, nonatomic) NSInteger selectedCategotyIndex;
@property(assign, nonatomic) NSInteger categoryCollectionViewHeightDefault;
@property(strong, nonatomic) NSString *selectedCategory;

//Detect Line
@property(weak, nonatomic) IBOutlet UIView *detectLine1;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *detectLineTopConstraint;

//Bottom buttons
@property(weak, nonatomic) IBOutlet UIButton *profilePicButton;
@property(weak, nonatomic) IBOutlet UIButton *likeButton;
@property(weak, nonatomic) IBOutlet UIButton *facebookButton;
@property(weak, nonatomic) IBOutlet UIButton *flagButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *gradientViewTopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonsContainerViewTrailingConstraint;
@property(weak, nonatomic) IBOutlet UIView *bottomButtonsContainerView;

@property(strong, nonatomic) ComicBook *currentlyShowingComicBook;

@end

@implementation MainPageVC
@synthesize modelController = _modelController;
@synthesize currentPoint,keyboardHeight, ComicBookDict, mainLoader, isAPICalling, allCellFrameHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    allCellFrameHeight = [[NSMutableArray alloc] init];
    
    [self.navigationController setNavigationBarHidden:YES];
//    [self addNotifications];
    
    
    
    UINib *cellNib = [UINib nibWithNibName:@"ComicCell" bundle:nil];
    [self.tblvComics registerNib:cellNib forCellReuseIdentifier:@"comicCell"];
    
    
    _categoriesNames = @[@"", @"food", @"failed", @"pets", @"funny", @"beauty", @"travel"];
    _categoriesImageNames = @[@"CategoryMyFeed", @"CategoryFood", @"CategoryFailed", @"CategoryPets", @"CategoryFunny", @"CategoryBeauty", @"CategoryTravel"];
    UINib *categoryNib = [UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil];
    [self.categoryCollectionView registerNib:categoryNib forCellWithReuseIdentifier:@"CategoryCollectionViewCell"];
    
    _categoryCollectionViewHeightDefault = self.view.frame.size.width / 7 + 10;
    _categoryCollectionViewHeightConstraint.constant = _categoryCollectionViewHeightDefault;
    
    comicsArray = [[NSMutableArray alloc] init];
    
    

    ComicBookDict=[NSMutableDictionary new];

    
    _containerView.hidden = YES;
    
    [self addTopBarView];
    [self addBottomBarView];
    [self chooseAccount];
    isFirstTime=TRUE;
    
    self.coverTemp.layer.borderColor=[UIColor whiteColor].CGColor;
    self.coverTemp.layer.borderWidth=5;
    self.coverTemp.layer.masksToBounds=TRUE;
    
    /**
     *  Profile picture rounded corner
     */
//    self.profilePic. layer.cornerRadius = self.profilePic.frame.size.width/2; // this value vary as per your desire
    self.profilePic .clipsToBounds = YES;
    /**
     *  setting parellex profile image
     */
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.profilePic addMotionEffect:group];
    // Configure the page view controller and add it as a child view controller.
    //    [ self loadBooks];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self setUpComment];
        [self handleScocialButtons];
    });
    
//    _selectedCategory = @"others";
    [self callAPIToGetTheComics];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeLeft:) name:@"ChangeNextPage" object:nil];
    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"MainPage" Attributes:nil];
    
    // open slide 2B Instruction
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Do some work");
        
       if ([InstructionView getBoolValueForSlide:kInstructionSlide2B] == NO)
       {
            InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
            instView.delegate = self;
            [instView showInstructionWithSlideNumber:SlideNumber2B withType:InstructionBubbleType];
            [instView setTrueForSlide:kInstructionSlide2B];
            
            [self.view addSubview:instView];
       }
    });
    

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    /**
     *  setup notification reciever to know table of index pressed or not
     */
    changePage = FALSE; // variable to fix the issue of flipping of pages automatically when coming from Me page etc.
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotifications];
    changePage =TRUE;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self addNotifications];
    [super viewWillAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.categoryCollectionView reloadData];
    
    _profilePicButton.layer.cornerRadius = _profilePicButton.frame.size.width / 2;
    _gradientViewTopConstraint.constant = _facebookButton.frame.size.height / 2;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChanged:) name:@"PageChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openInbox) name:@"OpenMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeInbox) name:@"CloseMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInboxButtonColor) name:@"changeInboxButtonColor" object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PageChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OpenMenu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CloseMenu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeInboxButtonColor" object:nil];
}

- (void)addBottomBarView {
    bottomBarView = [self.storyboard instantiateViewControllerWithIdentifier:BottomBarView];
    [bottomBarView.view setFrame:CGRectMake(0, self.view.frame.size.height - 30,self.view.frame.size.width, self.view.frame.size.height/2.2f)];
    [self addChildViewController:bottomBarView];
    [self.view addSubview:bottomBarView.view];
    
    __weak MainPageVC *weakSelf = self;    
    bottomBarView.connectAction = ^(void) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ContactController* cVc = (ContactController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Contact"];
        mainStoryboard = nil;
        [weakSelf.navigationController pushViewController:cVc animated:YES];
    };
    [bottomBarView didMoveToParentViewController:self];
}

- (void)addTopBarView {
    topBarView = [self.storyboard instantiateViewControllerWithIdentifier:TOP_BAR_VIEW];
    CGFloat heightOfTopBar;
    CGFloat heightOfNavBar = 44;

    
    if (IS_IPHONE_5)
    {
        heightOfTopBar = heightOfNavBar+6;
    }
    else if(IS_IPHONE_6)
    {
        heightOfTopBar = heightOfNavBar+9;
    }
    else if (IS_IPHONE_6P)
    {
        heightOfTopBar = heightOfNavBar+10;
    }
    else
    {
        heightOfTopBar = heightOfNavBar+6;
    }
    [topBarView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, heightOfTopBar)];
    [self addChildViewController:topBarView];
    [self.view addSubview:topBarView.view];
    [topBarView didMoveToParentViewController:self];
    
//    __block typeof(self) weakSelf = self;
    __weak MainPageVC *weakSelf = self;
    
    topBarView.homeAction = ^(void) {
        [weakSelf callAPIToGetTheComics];
    };
    topBarView.contactAction = ^(void) {
//        ContactsViewController *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:CONTACTS_VIEW];
//        [weakSelf presentViewController:contactsView animated:YES completion:nil];
        [AppHelper closeMainPageviewController:weakSelf];
    };
    topBarView.meAction = ^(void) {
        MePageVC* meViewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:ME_VIEW_SEGUE];
//        [weakSelf performSegueWithIdentifier:ME_VIEW_SEGUE sender:nil];
        [weakSelf.navigationController pushViewController:meViewController animated:YES];
        
//        [[AppDelegate application].navigation pushViewController:meViewController animated:YES];
    };
    topBarView.searchAction = ^(void) {
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf name:UIKeyboardWillHideNotification object:nil];
        
        TopSearchVC *topSearchViewLocal = [weakSelf.storyboard instantiateViewControllerWithIdentifier:TOP_SEARCH_VIEW];
        [topSearchViewLocal displayContentController:weakSelf];
    };
    topBarView.isHomeHidden = YES;
}

- (void)openInbox {
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"Inbox" Action:@"Open" Label:@""];
    [commentContainerView setUserInteractionEnabled:FALSE];
    [self.pageViewController.view setUserInteractionEnabled:FALSE];
    [topBarView.view setUserInteractionEnabled:FALSE];
    [self.profilePic setUserInteractionEnabled:FALSE];
    commentContainerView.layer.zPosition = 0;
    bottomBarView.view.layer.zPosition = 1;
}

- (void)closeInbox {
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"Inbox" Action:@"Close" Label:@""];
    [commentContainerView setUserInteractionEnabled:TRUE];
    [self.pageViewController.view setUserInteractionEnabled:TRUE];
    [topBarView.view setUserInteractionEnabled:TRUE];
    [self.profilePic setUserInteractionEnabled:TRUE];
    commentContainerView.layer.zPosition = 1;
    bottomBarView.view.layer.zPosition = 0;
}

- (void)changeInboxButtonColor
{
    [bottomBarView setBottombuttonToYellow];
}

-(void)loadBooks {
    [ self SetupBook:comicBookIndex];
}
-(void)handleScocialButtons{
    [self.view bringSubviewToFront:[self.view viewWithTag:FB]];
    [self.view bringSubviewToFront:[self.view viewWithTag:TW]];
    [self.view bringSubviewToFront:[self.view viewWithTag:IM]];
    [self.view bringSubviewToFront:[self.view viewWithTag:IN]];
}
-(NSArray*)setupImages:(int)indexPath
{
    NSMutableArray *images=[NSMutableArray new];
    
    if(indexPath%2)
    {
        for(int i=1;i<9;i++)
        {
            [  images addObject:   [UIImage imageNamed:[NSString stringWithFormat:@"d%d",i]]];
        }
    }
    else
    {
        for(int i=8;i>0;i--)
        {
            [  images addObject:   [UIImage imageNamed:[NSString stringWithFormat:@"d%d",i]]];
        }
        
    }
    
    if(4>=images.count)
    {
        if(indexPath%2)
        {
            [images insertObject: [UIImage imageNamed:@"cover" ] atIndex:0];
        }
        else
        {
            [images insertObject: [UIImage imageNamed:@"cover1" ] atIndex:0];
        }
        
        [images insertObject: [UIImage imageNamed:@"plain" ] atIndex:1];
        
    }
    else
    {
        if(indexPath%2)
        {
            [images insertObject: [UIImage imageNamed:@"cover" ] atIndex:0];
        }
        else
        {
            [images insertObject: [UIImage imageNamed:@"cover1" ] atIndex:0];
        }
        
        
        [images insertObject: [UIImage imageNamed:@"plain" ] atIndex:1];
        
        [images insertObject: [UIImage imageNamed:@"plain" ] atIndex:2];
        
    }
    return images;
    
}

-(IBAction)swipeLeft:(id)sender
{
    comicBookIndex ++;
    if(comicBookIndex < [comicsArray count]) {
        [[self Loader] startAnimating];
        isFirstTime=TRUE;
        CGRect rect=self.containerView.frame;
        CGPoint finishPoint = CGPointMake(-600, self.containerView.center.y);
        [UIView animateWithDuration:1
                         animations:^{
                             self.containerView.center = finishPoint;
                             self.containerView.transform = CGAffineTransformMakeRotation(-1);
                         }completion:^(BOOL complete){
                             [self.containerView setAlpha:0];
                             self.shadowImage.alpha=0;
                             [self updateBoundary:0 :0 toView:self.containerView addView:self.shadowImage animated:NO];
                             [UIView animateWithDuration:.5
                                              animations:^{
                                                  
                                                  self.containerView.transform = CGAffineTransformMakeRotation(0);
                                              } completion:^(BOOL finished) {
                                                  
                                                  [self.pageViewController.view removeFromSuperview];
                                                  self.pageViewController=nil;
                                                  [self SetupBook:comicBookIndex];
                                                  self.containerView.frame =rect;
                                                  self.containerView.alpha=1;
                                                  [UIView animateWithDuration:.5
                                                                   animations:^{
                                                                       self.shadowImage.alpha=1;
                                                                       [[self Loader] stopAnimating];
                                                                       
                                                                   }];
                                              }];
                         }];
    }
}



/**
 *  book setting up
 */
-(void)SetupBook:(int)tag {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    [slideImages removeAllObjects];
    ComicBook *comicBook = [comicsArray objectAtIndex:tag];
    [slideImages addObject:comicBook.coverImage];
    
    //    [comicBook.slides enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        Slides *slides = (Slides *)obj;
    //        [slideImages addObject:slides.slideImage];
    //        self.modelController.imageArray=slideImages;
    //        startingViewController.imageArray=slideImages;
    //    }];
    
    // vishnuvardhan
    NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
    [slidesArray addObjectsFromArray:comicBook.slides];
    
//    // To repeat the cover image again on index page as the first slide.
//    if(slidesArray.count > 1) {
//        [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
//        
//        // Adding a sample slide to array to maintain the logic
//        Slides *slides = [Slides new];
//        [slidesArray insertObject:slides atIndex:1];
//        
//        // vishnuvardhan logic for the second page
//        if(6<slidesArray.count) {
//            [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
//        }
//    }
    
    [AppDelegate application].dataManager.viewWidth = self.view.frame.size.width;
    [AppDelegate application].dataManager.viewHeight = self.view.frame.size.height;
    
    self.modelController.slidesArray=slidesArray;
    startingViewController.slidesArray = slidesArray;
    
    //    self.modelController.slidesArray=comicBook.slides;
    //    startingViewController.slidesArray = comicBook.slides;
    
    [self.profilePicOfComic sd_setImageWithURL:[NSURL URLWithString:comicBook.userDetail.profilePic]];
    //    self.profilePicOfComic.layer.cornerRadius = self.profilePicOfComic.frame.size.width / 2;
    self.profilePicOfComic.clipsToBounds = YES;
    
    textView.placeholder = [NSString stringWithFormat:@"Say something to %@", comicBook.userDetail.firstName];
    currentComicUserId = comicBook.userDetail.userId;
    
    friendObject = [[Friend alloc] init];
    friendObject.firstName = comicBook.userDetail.firstName;
    friendObject.lastName = comicBook.userDetail.lastName;
    friendObject.userId = comicBook.userDetail.userId;
    friendObject.profilePic = comicBook.userDetail.profilePic;
    
    /* set the dot color
     pink dot - comic sent to a person only
     orange dot - comic send to a group
     no dot - comic send to multiple people
     */
    self.shareDotLabel.layer.cornerRadius = self.shareDotLabel.frame.size.width / 2;
    self.shareDotLabel.clipsToBounds = YES;
    if([comicBook.friendShareCount integerValue] > 1) {
        [self.shareDotLabel setHidden:YES];
    } else if([comicBook.friendShareCount integerValue] == 1) {
        [self.shareDotLabel setHidden:NO];
        [self.shareDotLabel setBackgroundColor:[UIColor colorWithRed:207/255.0f green:112/255.0f blue:173/255.0f alpha:1.0f]]; // pink color
    } else if([comicBook.groupShareCount integerValue] > 0) {
        [self.shareDotLabel setHidden:NO];
        [self.shareDotLabel setBackgroundColor:[UIColor orangeColor]];
    }
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    self.pageViewController.dataSource = self.modelController;
    [ self.pageViewController.view  setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:self.pageViewController];
    self.pageViewController.view.backgroundColor = [UIColor clearColor];
    [self.CurlContainer insertSubview:self.pageViewController.view belowSubview:self.refreshComic];
    
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    // Find the tap gesture recognizer so we can remove it!
    UIGestureRecognizer* tapRecognizer = nil;
    for (UIGestureRecognizer* recognizer in self.pageViewController.gestureRecognizers) {
        if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] ) {
            tapRecognizer = recognizer;
            break;
        }
    }
    
    if ( tapRecognizer ) {
        [self.view removeGestureRecognizer:tapRecognizer];
        [self.pageViewController.view removeGestureRecognizer:tapRecognizer];
    }
    
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    [self setBoundary:0 :0 toView:self.CurlContainer addView:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

/**
 *  Go to the page from table of content
 *
 *  @param notification
 */
- (void)pageChanged:(NSNotification *)notification
{
    NSDictionary *dict=notification.userInfo;
    [self.modelController.dict setObject:[dict objectForKey:@"StartedPage"] forKey:@"StartedPage"];
    [self.modelController.dict setObject:[dict objectForKey:@"SelectedPageNumber"] forKey:@"SelectedPageNumber"];
    [self.modelController.dict setObject:[dict objectForKey:@"IndexSelected"] forKey:@"IndexSelected"];
    [self.modelController.dict setObject:[dict objectForKey:@"tag"] forKey:@"tag"];
    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    ComicBook *comicBook = [comicsArray objectAtIndex:comicBookIndex];
    
    // vishnuvardhan
    NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
    [slidesArray addObjectsFromArray:comicBook.slides];
    
    // To repeat the cover image again on index page as the first slide.
    if(slidesArray.count > 1) {
        [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
        
        // Adding a sample slide to array to maintain the logic
        Slides *slides = [Slides new];
        [slidesArray insertObject:slides atIndex:1];
        
        // vishnuvardhan logic for the second page
        if(6<slidesArray.count) {
            [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
        }
    }
    
    self.modelController.slidesArray=slidesArray;
    startingViewController.slidesArray=slidesArray;
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    self.pageViewController.dataSource = self.modelController;
    
}

- (IBAction)tappedProfilePicButton:(id)sender {
    //    [self performSegueWithIdentifier:ME_VIEW_SEGUE sender:nil];
    NSLog(@"%@", [Utilities getTheFriendObjForUserID:currentComicUserId]);
    //    if([Utilities getTheFriendObjForUserID:currentComicUserId] != nil) {
    FriendPageVC *friendView = [[FriendPageVC alloc] init];
    friendView = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendPage"];
    //        friendView.friendObj = [Utilities getTheFriendObjForUserID:currentComicUserId];
    //        friendView.friendObj = friendObject;
    [AppDelegate application].dataManager.friendObject = friendObject;
    [self presentViewController:friendView animated:YES completion:nil];
    //    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ModelController *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
        
    }
    _modelController.delegate=self;
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods
/**
 *  Checking for set the shadow of bookstack
 *
 *  @param currentpage present page index
 *  @param totalPage   total number of pages
 */
-(void)pageChange:(int)currentpage :(int)totalPage
{
    if(currentpage==totalPage )
    {
        self.shadowImage.hidden=true;
    }
    else
    {
        self.shadowImage.hidden=false;
    }
    [self updateBoundary:-(currentpage*2) :-(currentpage*2) toView:self.containerView addView:self.shadowImage animated:YES];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if(!changePage) {
        if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
            
            DataViewController *currentViewController = self.pageViewController.viewControllers[0];
            ComicBook *comicBook = [comicsArray objectAtIndex:comicBookIndex];
            
            // vishnuvardhan
            NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
            [slidesArray addObjectsFromArray:comicBook.slides];
            
            // To repeat the cover image again on index page as the first slide.
            if(slidesArray.count > 1) {
                [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
                
                // Adding a sample slide to array to maintain the logic
                Slides *slides = [Slides new];
                [slidesArray insertObject:slides atIndex:1];
                
                // vishnuvardhan logic for the second page
                if(6<slidesArray.count) {
                    [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
                }
            }
            
            currentViewController.slidesArray=slidesArray;
            NSArray *viewControllers = @[currentViewController];
            [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
            
            self.pageViewController.doubleSided = NO;
            return UIPageViewControllerSpineLocationMin;
        }
        
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        DataViewController *currentViewController = self.pageViewController.viewControllers[0];
        ComicBook *comicBook = [comicsArray objectAtIndex:comicBookIndex];
        
        // vishnuvardhan
        NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
        [slidesArray addObjectsFromArray:comicBook.slides];
        
        // To repeat the cover image again on index page as the first slide.
        if(slidesArray.count > 1) {
            [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
            
            // Adding a sample slide to array to maintain the logic
            Slides *slides = [Slides new];
            [slidesArray insertObject:slides atIndex:1];
            
            // vishnuvardhan logic for the second page
            if(6<slidesArray.count) {
                [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
            }
        }
        
        currentViewController.slidesArray=slidesArray;
        
        NSArray *viewControllers = nil;
        
        NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
        if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
            DataViewController *nextViewController =(DataViewController*) [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
            ComicBook *comicBook = [comicsArray objectAtIndex:comicBookIndex];
            
            // vishnuvardhan
            NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
            [slidesArray addObjectsFromArray:comicBook.slides];
            
            // To repeat the cover image again on index page as the first slide.
            if(slidesArray.count > 1) {
                [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
                
                // Adding a sample slide to array to maintain the logic
                Slides *slides = [Slides new];
                [slidesArray insertObject:slides atIndex:1];
                
                // vishnuvardhan logic for the second page
                if(6<slidesArray.count) {
                    [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
                }
            }
            
            nextViewController.slidesArray=slidesArray;
            viewControllers = @[currentViewController, nextViewController];
            
        } else {
            DataViewController *previousViewController =(DataViewController*) [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
            ComicBook *comicBook = [comicsArray objectAtIndex:comicBookIndex];
            
            // vishnuvardhan
            NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
            [slidesArray addObjectsFromArray:comicBook.slides];
            
            // To repeat the cover image again on index page as the first slide.
            if(slidesArray.count > 1) {
                [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
                
                // Adding a sample slide to array to maintain the logic
                Slides *slides = [Slides new];
                [slidesArray insertObject:slides atIndex:1];
                
                // vishnuvardhan logic for the second page
                if(6<slidesArray.count) {
                    [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
                }
            }
            
            previousViewController.slidesArray=slidesArray;
            viewControllers = @[previousViewController, currentViewController];
            
        }
        
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        return UIPageViewControllerSpineLocationMid;
    }
    
    return UIPageViewControllerSpineLocationMin;
}

-(void) setBoundary :(float) x :(float) y toView:(UIView*)toView addView:(UIView*)childView
{
    
    // Width constraint, half of parent view width
    [toView addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:toView
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:1
                                                        constant:x]];
    
    // Height constraint, half of parent view height
    [toView addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:toView
                                                       attribute:NSLayoutAttributeHeight
                                                      multiplier:1
                                                        constant:y]];
    
    // Center horizontally
    [toView addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:toView
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0]];
    
    // Center vertically
    [toView addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:toView
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0]];
    
}

-(void) updateBoundary :(float) x :(float) y toView:(UIView*)toView addView:(UIView*)childView animated:(BOOL)animated
{
    
    if(self.width)
        [toView removeConstraint:self.width];
    if(self.height)
        [toView removeConstraint:self.height];
    if(self.xConstraint)
        [toView removeConstraint:self.xConstraint];
    if(self.yConstraint)
        [toView removeConstraint:self.yConstraint];
    
    
    self.width=[NSLayoutConstraint constraintWithItem:childView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:toView
                                            attribute:NSLayoutAttributeWidth
                                           multiplier:1
                                             constant:x];
    
    self.height=[NSLayoutConstraint constraintWithItem:childView
                                             attribute:NSLayoutAttributeHeight
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:toView
                                             attribute:NSLayoutAttributeHeight
                                            multiplier:1
                                              constant:y];
    self.xConstraint=[NSLayoutConstraint constraintWithItem:childView
                                                  attribute:NSLayoutAttributeLeadingMargin
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:toView
                                                  attribute:NSLayoutAttributeLeadingMargin
                                                 multiplier:1.0
                                                   constant:0.0];
    self.yConstraint=[NSLayoutConstraint constraintWithItem:childView
                                                  attribute:NSLayoutAttributeTopMargin
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:toView
                                                  attribute:NSLayoutAttributeTopMargin
                                                 multiplier:1.0
                                                   constant:0.0];
    [toView addConstraint:self.width];
    
    
    [toView addConstraint:self.height];
    
    // Center horizontally
    [toView addConstraint:self.xConstraint];
    
    // Center vertically
    [toView addConstraint:self.yConstraint];
    
    if(!isFirstTime)
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             [toView layoutIfNeeded]; // Called on parent view
                         }];
    }
    else
    {
        [toView layoutIfNeeded];
        isFirstTime=FALSE;
    }
}

#pragma mark Scocial share events

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

- (IBAction)btnShareToSocialMedia:(id)sender
{
    ComicBook *comicBook = [comicsArray objectAtIndex:comicBookIndex];
    if (comicBook.slides && [comicBook.slides count] >0)
    {
        NSUInteger imageCount = [comicBook.slides count];// >= 4 ? 4 : [comicBook.slides count];
        NSMutableArray* imageArray = [[NSMutableArray alloc] init];
        for (int i=0; i < imageCount; i++) {
            
            Slides *slides = (Slides*)comicBook.slides[i];
            [imageArray addObject:[self getImageFromURL:slides.slideImage]];
            //I do have only this option need to check with Vishu
//            [imageArray addObject:[self getImageFromURL:[slideImages objectAtIndex:i]]];
        }
        switch (((UIButton*)sender).tag) {
            case FB:
            {
                [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"MainPage-ShareToSocialMedia" Action:@"FACEBOOK" Label:@""];
                [self doShareTo:FACEBOOK ShareImage:[self.comicShareView getComicShareImage:imageArray]];
                
            }
                break;
            case IM:
            {
                [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"MainPage-ShareToSocialMedia" Action:@"MESSAGE" Label:@""];
                [self doShareTo:MESSAGE ShareImage:[self.comicShareView getComicShareImage:imageArray]];
                
                break;
            }
            case TW:
            {
                [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"MainPage-ShareToSocialMedia" Action:@"TWITTER" Label:@""];
                [self doShareTo:TWITTER ShareImage:[self.comicShareView getComicShareImage:imageArray]];
            }
                break;
            case IN:
            {
                [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"MainPage-ShareToSocialMedia" Action:@"INSTAGRAM" Label:@""];
                [self doShareTo:INSTAGRAM ShareImage:[self.comicShareView getComicShareImage:imageArray]];
                break;
            }
            default:
                break;
        }
    }
}

-(void)doShareTo :(ShapeType)type ShareImage:(UIImage*)imgShareto{

    
    NSData *imageData = UIImagePNGRepresentation(imgShareto);
    UIImage *image=[UIImage imageWithData:imageData];
    
    
    /* Commented for testing*/
//    ShareHelper* sHelper = [ShareHelper shareHelperInit];
//    sHelper.parentviewcontroller = self;
//    [sHelper shareAction:type ShareText:@""
//              ShareImage:image
//              completion:^(BOOL status) {
//              
//
//              }];
//    
}


#pragma mark Comment Module


/**
 *  Setup comment typing textfield
 */

-(void)setUpComment
{
    self.keyboardHeight = 5;
    currentPoint=[[self scrollView] bounds].size.height;
    self.scrollView.layer.zPosition = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    CGFloat textViewX;
    CGFloat twitterLabelX;
    CGFloat onOffX;
    
    CGFloat width;
    
    if(IS_IPHONE_5)
    {
        textViewX= 140;
        twitterLabelX= 160;
        onOffX= 125;
        width = 170;
    }
    else if(IS_IPHONE_6)
    {
        textViewX= 145;
        twitterLabelX= 165;
        onOffX= 130;
        width = 180;
    }
    else if(IS_IPHONE_6P)
    {
        textViewX= 150;
        twitterLabelX= 170;
        onOffX= 135;
        width = 190;
    }
    
    commentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 93, self.view.frame.size.width, 60)]; // 95
    onoff = [[UISwitch alloc] initWithFrame: CGRectMake(0, 0, 30, 30)];
    onoff.onTintColor= [UIColor colorWithRed:(.61) green:(.93) blue:(.93) alpha:1];
    onoff.transform = CGAffineTransformMakeScale(0.30, 0.30);
    [commentContainerView addSubview:onoff];
    [onoff setOn:YES animated:YES];
    [onoff addTarget:self action:@selector(toggledTweetSwitch:) forControlEvents:UIControlEventValueChanged];
    UILabel*twitterLabel=[[UILabel alloc]initWithFrame: CGRectMake(40, 10, 160, 10)];
    twitterLabel.text=@"Tweet this comment";
    twitterLabel.textColor=[UIColor whiteColor];
    twitterLabel.font = [UIFont fontWithName:@"AmericanTypewriter"  size:10];
    [commentContainerView addSubview:twitterLabel];
//    [commentContainerView setBackgroundColor:[UIColor redColor]];
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(20, 22, self.view.frame.size.width - 40, 25)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 2;
    textView.maxHeight = 60.0f;
    textView.font = [UIFont fontWithName:@"AmericanTypewriter" size:IS_IPHONE_5?10:14];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    //    textView.backgroundColor = [UIColor colorWithRed:(.61) green:(.93) blue:(.93) alpha:1];
    textView.backgroundColor = [UIColor colorWithRed:(0.611) green:(0.854) blue:(0.925) alpha:1];
    textView.layer.cornerRadius=4;
    textView.layer.masksToBounds=YES;
    [textView setTextColor:[UIColor whiteColor]];
    
    
    // Flag Button
//    UIButton *btnFlag = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40 , CGRectGetMinY(textView.frame), 50, CGRectGetHeight(textView.frame))];
//    [btnFlag addTarget:self action:@selector(openFlahSheet) forControlEvents:UIControlEventTouchUpInside];
//    
//    [btnFlag setImage:[UIImage imageNamed:@"flag-button"] forState:UIControlStateNormal];
//    
//    [commentContainerView addSubview:btnFlag];
//    
    [self.view addSubview:commentContainerView];
    
    commentContainerView.alpha = 0;
    
    commentContainerView.layer.zPosition = 0;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [commentContainerView addSubview:textView];
    commentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    commentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
  //  [commentContainerView bringSubviewToFront:self.view];
}

- (void)showCommentContainerView
{
    [textView becomeFirstResponder];
    
    
   [UIView animateWithDuration:0.6 animations:^{
       
       commentContainerView.alpha = 1;
       
   }];
}

-(void)hideCommentContainerView
{
    [textView resignFirstResponder];
    
    [UIView animateWithDuration:0.6 animations:^{
        commentContainerView.alpha = 0;

    }];
}

#pragma mark - Flag Event
- (void)openFlahSheet
{
    // open actionsheet
    
    UIActionSheet *flagActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Violence",@"Sexual content",@"Copyrighted content",@"Other", nil];
    
    [flagActionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([btnTitle isEqualToString:@"Violence"])
    {
        [self callAPIForFlaggingWithText:btnTitle withFlagID:@"1"];
    }
    else if ([btnTitle isEqualToString:@"Sexual content"])
    {
        [self callAPIForFlaggingWithText:btnTitle withFlagID:@"2"];
    }
    else if ([btnTitle isEqualToString:@"Copyrighted content"])
    {
        [self callAPIForFlaggingWithText:btnTitle withFlagID:@"3"];

    }
    else if ([btnTitle isEqualToString:@"Other"])
    {
        [self callAPIForFlaggingWithText:btnTitle withFlagID:@"4"];
    }
    
}

#pragma mark - API for Flagging
- (void)callAPIForFlaggingWithText:(NSString *)text withFlagID:(NSString *)flagID
{
    ComicBook *comicBook = _currentlyShowingComicBook;//[comicsArray objectAtIndex:comicBookIndex];
    
    NSDictionary *flagRequest = @{@"flag_type_id":flagID,
                                  @"user_id":comicBook.userDetail.userId,
                                  @"user_remarks":text};
    
    NSDictionary *flagDataDict = @{@"comic_id" : comicBook.comicId,
                           @"flag_request":flagRequest};
    
    NSDictionary *flagDict = @{@"data" :flagDataDict};
    
    [ComicsAPIManager setFlagForComic:flagDict withSuccessBlock:^(id object) {
        
        [AppHelper showSuccessDropDownMessage:@"Flag has been successfully sent." mesage:@""];
        
    } andFail:^(NSError *errorMessage) {
        [AppHelper showErrorDropDownMessage:ERROR_MESSAGE mesage:@""];
    }];
}


#pragma mark - Add new comment to the view
/**
 *  Add new comment to the view
 *
 *  @param comment Comment Text
 */
- (void)addComment:(NSString*)comment :(NSString*)imageUrl {
    
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"AddComment" Action:comment Label:@""];
    
    count++;
    UIView *cell=[self Cell:comment:imageUrl];
    CGRect Rect=cell.frame;
    Rect.origin.y =currentPoint-keyboardHeight;
    cell.frame=Rect;
    [self.scrollView addSubview:cell];
    [UIView animateWithDuration:1 animations:^{
        
        currentPoint=currentPoint+Rect.size.height+5;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, currentPoint);
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - (self.scrollView.bounds.size.height));
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    
    }];
    
    CGFloat duration = 14 ;
    
    [UIView animateWithDuration:duration animations:^{
        cell.alpha = 0;
    }];
    
    CAKeyframeAnimation *animation = [self createAnimation:Rect];
    animation.duration = duration;
    [cell.layer addAnimation:animation forKey:@"position"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration + 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cell removeFromSuperview];
        count--;
        [self resetSize];
    });
}

- (void)callAPIToPostComment:(NSString *)comment
{
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"PostComment" Action:comment Label:@""];
    CommentModel *commentModel = [[CommentModel alloc] init];
    commentModel.commentType = @"T";
    commentModel.commentText = comment;
    commentModel.referenceId = @"0";
    commentModel.userId = [AppHelper getCurrentLoginId];
    commentModel.status = @"1";
    ComicBook *comicBook = [comicsArray objectAtIndex:currentComicIndex];
    NSError *error;
    [CommentsAPIManager postCommentForComicId:comicBook.comicId
                              WithCommentDict:[MTLJSONAdapter JSONDictionaryFromModel:commentModel error:&error]
                             withSuccessBlock:^(id object) {
                                 NSLog(@"%@", object);
//                                 [self addComment:comment:self.profilePicOfComic.image];
                                 [self addComment:comment :[[AppHelper initAppHelper] getCurrentUser].profile_pic];
                             } andFail:^(NSError *errorMessage) {
                                 NSLog(@"%@", errorMessage);
                             }];
}
/**
 *  Animation to move up
 *
 *  @param frame current frame position
 *
 *  @return animation
 */
- (CAKeyframeAnimation *)createAnimation:(CGRect)frame {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();int height = -frame.size.height;
    int xOffset = frame.origin.x+ frame.size.width/2;
    int yOffset = frame.origin.y;
    CGPoint p1 = CGPointMake(xOffset, height * 0 + yOffset);
    CGPoint p2 = CGPointMake(xOffset, height * 3 + yOffset);
    CGPathMoveToPoint(path, NULL, p1.x,p1.y);
    CGPathAddQuadCurveToPoint(path, NULL, p1.x , p1.y + height / 2.0, p2.x, p2.y);
    animation.path = path;
    animation.calculationMode = kCAAnimationCubicPaced;
    CGPathRelease(path);
    return animation;
}
/**
 *  Resize the Content size of scroll when it is having no comment. else it will increase anonimously
 */
-(void)resetSize
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(count==0)
        {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, [[self scrollView] bounds].size.height);
            CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
            [self.scrollView setContentOffset:bottomOffset animated:YES];
            currentPoint=[[self scrollView] bounds].size.height+self.keyboardHeight;
        }
    });
}


/**
 *  Handle kyboard Shown state
 *
 *  @param note Keyboard informations
 */

- (void)keyboardWasShown:(NSNotification*)note
{
    commentContainerView.layer.zPosition = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        // Need to translate the bounds to account for rotation.
        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        // get a rect for the textView frame
        CGRect containerFrame = commentContainerView.frame;
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        commentContainerView.frame = containerFrame;
        self.keyboardHeight=keyboardBounds.size.height-10;
        currentPoint=currentPoint+self.keyboardHeight ;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, currentPoint);
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height );
        [self.scrollView setContentOffset:bottomOffset animated:NO];
        [UIView commitAnimations];
    });
    
}
/**
 *  Handle keyboard hiding state
 *
 *  @param note Keyboard informations
 */
- (void)keyboardWillBeHidden:(NSNotification*)note
{
    commentContainerView.layer.zPosition = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        // get a rect for the textView frame
        CGRect containerFrame = commentContainerView.frame;
        containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height-35; // 35
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        // set views with new info
        commentContainerView.frame = containerFrame;
        currentPoint=currentPoint-self.keyboardHeight ;
        self.keyboardHeight=0;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, currentPoint);
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height );
        [self.scrollView setContentOffset:bottomOffset animated:YES];
        // commit animations
        [UIView commitAnimations];
    });
}
/**
 *  Send the comment clicking send button in the keyboard
 *
 *  @param growingTextView textview which contains the comment
 *
 *  @return return the status true or false according charecter
 */
-(BOOL)growingTextViewShouldReturn:(CustomTextView *)growingTextView
{
    if([textView.text length]!=0)
    {
        [self postTwitterStatus:textView.text forAccount:twitterAccount];
        [self callAPIToPostComment:textView.text];
        textView.text = @"";
    }
    
    [textView resignFirstResponder];
    
    [self hideCommentContainerView];
    
    return NO;
}
/**
 *  The textview will grow according to the text move to new line
 *
 *  @param growingTextView Thext viewcontains the comment
 *  @param height          the hight regurd for contain new line
 */
- (void)growingTextView:(CustomTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = commentContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    commentContainerView.frame = r;
}
/**
 *  Making Comment showing Cell
 *
 *  @param Text Comment
 *
 *
 *  @param image profile image
 *
 *  @return view which having comment and profile picture
 */
-(UIView*)Cell:(NSString*)Text :(NSString*)imageUrl
{
    UIView *view= [[UIView alloc]init];
    UIFont *font = [UIFont fontWithName:@"AmericanTypewriter"  size:15];
    CGSize size =[self frameForText:Text sizeWithFont:font constrainedToSize:CGSizeMake(220,9999)lineBreakMode:NSLineBreakByWordWrapping ];
    float height=(size.height<25)? 25 :size.height;
    view.frame=CGRectMake(15, 0, size.width+60, height+30);
    UIView *commentBackground= [[UIView alloc]initWithFrame:CGRectMake(0, 3, size.width+55, height+15)];
    UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, size.width, height+10)];
    commentLabel.text=Text;
    commentLabel.textColor=[UIColor whiteColor];
    commentLabel.numberOfLines = 0;
    commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    commentLabel.text = (Text ? Text : @"");
    commentLabel.font = font;
    commentLabel.backgroundColor=[UIColor clearColor];
    [commentBackground addSubview:commentLabel];
    commentBackground.backgroundColor=[UIColor colorWithRed:(.55) green:(.83) blue:(.91) alpha:.8];
    commentBackground.layer.cornerRadius=12;
    commentBackground.layer.masksToBounds=YES;
    UIImageView *profilePic=[[UIImageView alloc] init];
    [profilePic sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    profilePic.frame=CGRectMake(5, 3, 40, 40);
    profilePic.contentMode=UIViewContentModeScaleAspectFit;
    profilePic.layer.cornerRadius=20;
    profilePic.layer.masksToBounds=YES;
    profilePic.backgroundColor=[UIColor colorWithRed:(.55) green:(.83) blue:(.91) alpha:.8];
    [view addSubview:commentBackground];
    [view addSubview:profilePic];
    return view;
}
/**
 *  Adjust the size of comment view height
 *
 *  @param text          Comment
 *  @param font          font used for comment
 *  @param size          a maximum size passing
 *  @param lineBreakMode linebreakmodeword wrapping
 *
 *  @return Size of the frame needed to display comment
 */
-(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary * attributes = @{NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
    CGRect textRect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    return textRect.size;
}

#pragma mark - TWITTER related methods

- (IBAction)toggledTweetSwitch:(id)sender {
    UISwitch *tweetSwitch = (id)sender;
    if ([tweetSwitch isOn]) {
        [self chooseAccount];
    }
}

- (void)postTwitterStatus:(NSString *)status forAccount:(ACAccount *)account {
    
    self.twitter = nil;
    self.twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
    
    [_twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        NSString *statusUpdate = [NSString stringWithFormat:@"%@\n%@", status, TWITTER_STATUS_MESSAGE];
        [_twitter postStatusUpdate:statusUpdate
                 inReplyToStatusID:nil
                          latitude:nil
                         longitude:nil
                           placeID:nil
                displayCoordinates:nil
                          trimUser:nil
                      successBlock:^(NSDictionary *status) {
                          NSLog(@"success status ----%@", status);
                      } errorBlock:^(NSError *error) {
                          NSLog(@"error status ----%@", error);
                      }];
        
    } errorBlock:^(NSError *error) {
    }];
}

- (void)chooseAccount {
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if(granted == NO) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:SORRY_TITLE message:ACCESS_NOT_GRANTED_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okButton = [UIAlertAction actionWithTitle:OK_TITLE style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    [onoff setOn:NO animated:YES];
                }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            self.iOSAccounts = [account accountsWithAccountType:accountType];
            
            if([_iOSAccounts count] == 0) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:SORRY_TITLE message:NO_TWITTER_ACCOUNTS_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okButton = [UIAlertAction actionWithTitle:OK_TITLE style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    [onoff setOn:NO animated:YES];
                }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
            } else if([_iOSAccounts count] == 1) {
                twitterAccount = [_iOSAccounts lastObject];
                [onoff setOn:YES animated:YES];
            } else {
                UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:SELECT_AN_ACCOUNT_MESSAGE message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CANCEL_TITLE style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [onoff setOn:NO animated:YES];
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                }];
                [actionSheet addAction:cancelAction];
                
                for(ACAccount *account in _iOSAccounts) {
                    UIAlertAction *accountAction = [UIAlertAction actionWithTitle:account.username style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [onoff setOn:YES animated:YES];
                        twitterAccount = account;
                    }];
                    [actionSheet addAction:accountAction];
                }
                
                // Present action sheet.
                [self presentViewController:actionSheet animated:YES completion:nil];
            }
        }];
    };
    
#if TARGET_OS_IPHONE &&  (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
        [account requestAccessToAccountsWithType:accountType
                           withCompletionHandler:accountStoreRequestCompletionHandler];
    } else {
        [account requestAccessToAccountsWithType:accountType
                                         options:NULL
                                      completion:accountStoreRequestCompletionHandler];
    }
#else
    [account requestAccessToAccountsWithType:accountType
                                     options:NULL
                                  completion:accountStoreRequestCompletionHandler];
#endif
    
}

#pragma mark STTwitterAPIOSProtocol

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
    if(twitterAPI != _twitter) return;
    NSLog(@"-- account was invalidated: %@ | %@", invalidatedAccount, invalidatedAccount.username);
}

#pragma mark - API

- (void)callAPIToGetTheComics
{
    pageIndex = 0;
    
    [mainLoader startAnimating];
    
    [ComicsAPIManager getTheComicsWithPage:1 andCategory:_selectedCategory SuccessBlock:^(id object)
    {
        [mainLoader stopAnimating];

        
        _containerView.hidden = NO;
        NSError *error;
        ComicsModel *comicsModel = [MTLJSONAdapter modelOfClass:ComicsModel.class fromJSONDictionary:[object valueForKey:@"data"] error:&error];
        comicBookIndex = 0;
        slideImages = [[NSMutableArray alloc] init];
        
        if (comicsModel.books.count > 0)
        {
            pageIndex = pageIndex + 1;

        }
        
        
        [comicsArray addObjectsFromArray:comicsModel.books];
        // [self SetupBook:comicBookIndex];
        
        
        
        [_tblvComics reloadData];
        if (comicsModel.books.count != 0) {
            [self updateButtonInfoWithComicBook:comicsModel.books[0] withIndexPath:[NSIndexPath indexPathWithIndex:0]];
        }
        
    } andFail:^(NSError *errorMessage)
    {
        NSLog(@"%@", errorMessage);
        _containerView.hidden = YES;
        [[self Loader] stopAnimating];
        [mainLoader stopAnimating];
    }];
}

- (void)callAPIToGetTheComicsWithPage:(NSUInteger)page
{
    [ComicsAPIManager getTheComicsWithPage:page andCategory:_selectedCategory SuccessBlock:^(id object)
     {
         _containerView.hidden = NO;
         NSError *error;
         ComicsModel *comicsModel = [MTLJSONAdapter modelOfClass:ComicsModel.class fromJSONDictionary:[object valueForKey:@"data"] error:&error];
         slideImages = [[NSMutableArray alloc] init];
         
         [comicsArray addObjectsFromArray:comicsModel.books];
         
         if (comicsModel.books.count > 0)
         {
             pageIndex = pageIndex + 1;
         }
         [_tblvComics reloadData];

         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
             isAPICalling = NO;
         });
         
     } andFail:^(NSError *errorMessage)
    {
         NSLog(@"%@", errorMessage);
         _containerView.hidden = YES;
         [[self Loader] stopAnimating];
     }];
}


#pragma mark - statusbar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideCommentContainerView];
    
    return YES;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return comicsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];
    
    static NSString *simpleTableIdentifier = @"mainPageCell";
    
    __block MainPageCell* cell= (MainPageCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell = nil;
    if (cell == nil)
    {
        cell = (MainPageCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (nil!=[ComicBookDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
        {
            [ComicBookDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        
//        [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:comicBook.userDetail.profilePic]];
        
        [cell layoutIfNeeded];

        if ([comicBook.comicTitle isEqualToString:@""] || comicBook.comicTitle == nil)
        {
            cell.lblComicTitle.hidden = YES;
            cell.heightConstraintComicTitle.constant = 0;

        }
        else
        {
            cell.lblComicTitle.hidden = NO;
            cell.lblComicTitle.text = comicBook.comicTitle;
            
            cell.heightConstraintComicTitle.constant = 60;
        }
        ComicBookColorCode colorCode = (ComicBookColorCode)[((ComicProperties *)comicBook.comicProperties).fontColor integerValue];
        cell.topImageView.image = [Global getImageForColorCode:colorCode andDirection:Top];
        cell.leftImageView.image = [Global getImageForColorCode:colorCode andDirection:Left];
        cell.bottomImageView.image = [Global getImageForColorCode:colorCode andDirection:Bottom];
        cell.rightImageView.image = [Global getImageForColorCode:colorCode andDirection:Right];
                
        cell.fontName = ((ComicProperties *)comicBook.comicProperties).fontName;
        
        if (cell.fontName.length == 0) {
            cell.fontName = @"Comic Sans MS";
        }
        
        float fontSize;
        if (IS_IPHONE_5) {
            fontSize = cell.lblComicTitle.text.length <= 8? 43: 20;
        } else if (IS_IPHONE_6) {
            fontSize = cell.lblComicTitle.text.length <= 8? 44: 25;
        } else if (IS_IPHONE_6P) {
            fontSize = cell.lblComicTitle.text.length <= 8? 48: 28;
        } else {
            fontSize = cell.lblComicTitle.text.length <= 8? 50: 30;
        }
        UIFont *font = [UIFont fontWithName:cell.fontName size:fontSize];
        [cell.lblComicTitle setFont:font];
   
        //dinesh
        cell.mUserName.text = comicBook.userDetail.firstName;
        cell.lblDate.text = [self dateFromString:comicBook.createdDate];
        cell.lblTime.text = [self timeFromString:comicBook.createdDate];
        
        // New Code - Adnan
        [cell layoutIfNeeded];
        
//        NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
//        [slidesArray addObjectsFromArray:comicBook.slides];
        
        [cell.viewComicBook layoutIfNeeded];
        [cell.viewComicCointainer layoutIfNeeded];
        
        
        ComicBookVC *comic = [self.storyboard instantiateViewControllerWithIdentifier:@"ComicBookVC"];
        
        comic.parentController = self;
        comic.bookWidth = cell.viewComicBook.frame.size.width;
        comic.delegate=self;
        comic.Tag=(int)indexPath.row;
        
        NSLog(@"............................... %@ ............ \n%f",cell, comic.bookWidth);
        
//        CGFloat width = ComicWidthIPhone5;
//        
//        if (IS_IPHONE_5)
//        {
//            width = ComicWidthIPhone5;
//        }
//        else if (IS_IPHONE_6)
//        {
//            width = ComicWidthIPhone6;
//            
//        }
//        else if (IS_IPHONE_6P)
//        {
//            width = ComicWidthIPhone6plus;
//        }
        CGFloat width = cell.viewComicBook.frame.size.width;
        
         comic.view.frame = CGRectMake(0, 0, width, CGRectGetHeight(cell.viewComicBook.frame));
        
      //  comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(container.frame), CGRectGetHeight(container.frame));
        
        //            [comic setImages: [self setupImages:indexPath]];
        
        ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];
        // vishnu
        NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
        [slidesArray addObjectsFromArray:comicBook.slides];
        
        // To repeat the cover image again on index page as the first slide.
//        if(slidesArray.count > 1) {
//            [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
//            
//            // Adding a sample slide to array to maintain the logic
//            Slides *slides = [Slides new];
//            [slidesArray insertObject:slides atIndex:1];
//            
//            // vishnuvardhan logic for the second page
//            if(6<slidesArray.count) {
//                [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
//            }
//        }
        
        //HARDCODED DATA FOR TESTING COMIC BOOK LAYERING====================================================
        
//        for (NSInteger slideCount = 0; slideCount < slidesArray.count; slideCount++) {
//            Slides *slide = (Slides *)slidesArray[slideCount];
//            
//            if (slideCount%2 == 0) {
//                slide.slideType = @"1";
//                slide.slideImage = @"http://assets.barcroftmedia.com.s3-website-eu-west-1.amazonaws.com/assets/images/recent-images-11.jpg";
//                
//                Enhancement *enh = [Enhancement new];
//                enh.enhancementType = @"GIF";
//                enh.enhancementFile = @"https://media.giphy.com/media/3o6Yg9tdaoA4klW0Fi/source.gif";
//                enh.xPos = @"0";
//                enh.yPos = @"0";
//                enh.zIndex = 1;
//                enh.height = @"150";
//                enh.width = @"170";
//                
//                Enhancement *enh1 = [Enhancement new];
//                enh1.enhancementType = @"IMAGE";
//                enh1.enhancementFile = @"http://www.scri8e.com/stars/PNG_Clouds/zc06.png?filename=./zc06.png&w0=800&h0=289&imgType=3&h1=50&w1=140";
//                enh1.xPos = @"35";
//                enh1.yPos = @"30";
//                enh1.zIndex = 3;
//                enh1.height = @"80";
//                enh1.width = @"80";
//                
//                Enhancement *enh2 = [Enhancement new];
//                enh2.enhancementType = @"GIF";
//                enh2.enhancementFile = @"https://giant.gfycat.com/ClutteredSevereCur.gif";
//                enh2.xPos = @"220";
//                enh2.yPos = @"140";
//                enh2.zIndex = 2;
//                enh2.height = @"250";
//                enh2.width = @"270";
//                
//                slide.enhancements = [NSArray arrayWithObjects:enh, enh1, enh2, nil];
//            } else {
//                slide.slideType = @"0";
//                slide.slideImage = @"https://giant.gfycat.com/ClutteredSevereCur.gif";
//                
//                Enhancement *enh = [Enhancement new];
//                enh.enhancementType = @"STATICIMAGE";
//                enh.enhancementFile = @"http://staging.comicing.cc/images/comics/slides/579a66714877a";
//                enh.xPos = @"0";
//                enh.yPos = @"0";
//                enh.zIndex = 2;
//                enh.height = @"50";
//                enh.width = @"50";
//                
//                slide.enhancements = [NSArray arrayWithObjects:enh, nil];
//            }
//            
//        }
        
        [comic setSlidesArray:slidesArray];
        [comic setAllSlideImages:slidesArray];
        [comic setupBook];
        [self addChildViewController:comic];
        [ comic.view setTranslatesAutoresizingMaskIntoConstraints:YES];
        //[self setBoundary:0 :0 toView:container addView:comic.view];
        
        [ComicBookDict setObject:comic forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        
        CGRect frame = comic.view.frame;
        frame.origin.y = 0;
        frame.size.width = width;
        
        comic.view.frame = frame;

       // comic.pageViewController.view.frame = CGRectMake(0, 0, 0, 0);
//        comic.view.clipsToBounds = YES;
        [cell.viewComicBook addSubview:comic.view];
        
        //buttons events
        cell.btnBubble.tag = indexPath.row;
        cell.btnTwitter.tag = indexPath.row;
        cell.btnFacebook.tag = indexPath.row;
        
        [cell.btnFacebook addTarget:self action:@selector(btnFacebookTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnTwitter addTarget:self action:@selector(btnTwitterTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnBubble addTarget:self action:@selector(btnBubbleTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];
    
    NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
    
//    for (NSInteger slideCount = 0; slideCount <= comicBook.slides.count; slideCount++) {
//        Slides *slide = (Slides *)comicBook.slides[slideCount];
//        if (slideCount%2 == 0) {
//            slide.slideType = @"0";
//            Enhancement *enh = [Enhancement new];
//            enh.enhancementType = @"GIF";
//            enh.enhancementFile = @"https://giant.gfycat.com/ClutteredSevereCur.gif";
//            enh.xPos = @"0";
//            enh.yPos = @"0";
//            enh.zIndex = 1;
//            enh.height = @"50";
//            enh.width = @"50";
//            
//            slide.enhancements = [NSArray arrayWithObjects:enh, nil];
//        } else {
//            slide.slideType = @"1";
//            Enhancement *enh = [Enhancement new];
//            enh.enhancementType = @"STATICIMAGE";
//            enh.enhancementFile = @"http://staging.comicing.cc/images/comics/slides/579a66714877a";
//            enh.xPos = @"0";
//            enh.yPos = @"0";
//            enh.zIndex = 1;
//            enh.height = @"50";
//            enh.width = @"50";
//            
//            slide.enhancements = [NSArray arrayWithObjects:enh, nil];
//        }
//        
//    }
    
    [slidesArray addObjectsFromArray:comicBook.slides];
    ComicPageViewController *viewPreviewScrollSlide = [[ComicPageViewController alloc] init];
    viewPreviewScrollSlide.view.frame = CGRectMake(0, 0, 0, 0);
    
    viewPreviewScrollSlide.allSlideImages = slidesArray;
    [viewPreviewScrollSlide setupBook];
    
    viewPreviewScrollSlide.view.backgroundColor = [UIColor blueColor];

    if ([comicBook.comicTitle isEqualToString:@""] || comicBook.comicTitle == nil)
    {
        return viewPreviewScrollSlide.view.bounds.size.height + 20 + 45;
    }
    else
    {
        return viewPreviewScrollSlide.view.bounds.size.height + 60 + 20 + 45;
    }
    
    
    
    
    
    // ****************************
    
//    if (allCellFrameHeight.count == 0 || allCellFrameHeight == nil)
//    {
//        return [self getHeightForCell:indexPath];
//    }
//    else if (allCellFrameHeight.count > 0)
//    {
//       // id height =  allCellFrameHeight[indexPath.row];
//        
//        if (allCellFrameHeight.count > indexPath.row + 1)
//        {
//            id height =  allCellFrameHeight[indexPath.row];
//            
//            return [height floatValue];
//        }
//        else
//        {
//            return [self getHeightForCell:indexPath];
//        }
//    }
//    else
//    {
//        return [self getHeightForCell:indexPath];
//    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell layoutSubviews];
    
    
    
    if (indexPath.row == comicsArray.count - 1)
    {
        NSLog(@"call API");
        
        if (oldPageIndex != pageIndex)
        {
            isAPICalling = YES;
            oldPageIndex = pageIndex;
//            [self callAPIToGetTheComicsWithPage:pageIndex];
        }
    }
    
    if (isAPICalling == NO)
    {
        cell.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.contentView.layer.shadowOffset = CGSizeMake(10, 10);
        cell.contentView.alpha = 0;
        cell.contentView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
        cell.contentView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        [UIView animateWithDuration:1 animations:^{
            cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
            cell.contentView.alpha = 1;
            cell.contentView.layer.transform = CATransform3DIdentity;
        }];

    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offset = scrollView.contentOffset.y; // here you will get the offset value
//    CGFloat value = offset / _tblvComics.frame.size.height;
//    
//    NSLog(@"value = %f",value);
//    
//    if(value > 0 && value < 1)
//    {
//        self.viewTransperant.alpha = 1-value/4;
//    }
//}

#pragma mark - UICollectionView methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _categoriesNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCollectionViewCell *categoryCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCell" forIndexPath:indexPath];
    
    categoryCollectionViewCell.categoryName.text = _categoriesNames[indexPath.item];
    categoryCollectionViewCell.imageNamePrefix = _categoriesImageNames[indexPath.item];
    
    [categoryCollectionViewCell shouldSelectCell:_selectedCategotyIndex == indexPath.item];
    if (indexPath.item == 0) {
        categoryCollectionViewCell.categoryNameLabelHeightConstraint.constant = 0;
    } else {
        categoryCollectionViewCell.categoryNameLabelHeightConstraint.constant = categoryCollectionViewCell.contentView.frame.size.height *0.25;
    }
    
    return categoryCollectionViewCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedCategotyIndex = indexPath.item;
    [collectionView reloadData];
    
    _selectedCategory = _categoriesNames[indexPath.item];
    [self callAPIToGetTheComics];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat widthHeight = collectionView.frame.size.width / 7;
    return CGSizeMake(widthHeight, widthHeight);
}

#pragma mark - HELPER Methods

- (CGFloat)getHeightForCell:(NSIndexPath *)indexPath
{
    ComicBookVC*comic=[self.storyboard instantiateViewControllerWithIdentifier:@"ComicBookVC"];
    
    comic.delegate=self;
    comic.Tag=(int)indexPath.row;
    
    CGFloat width = ComicWidthIPhone5;
    
    if (IS_IPHONE_5)
    {
        width = ComicWidthIPhone5;
    }
    else if (IS_IPHONE_6)
    {
        width = ComicWidthIPhone6;
        
    }
    else if (IS_IPHONE_6P)
    {
        width = ComicWidthIPhone6plus;
    }
    
    comic.view.frame = CGRectMake(0, 0, width, 0);
    ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];
    // vishnu
    NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
    [slidesArray addObjectsFromArray:comicBook.slides];
    
    // To repeat the cover image again on index page as the first slide.
    if(slidesArray.count > 1) {
        [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
        
        // Adding a sample slide to array to maintain the logic
        Slides *slides = [Slides new];
        [slidesArray insertObject:slides atIndex:1];
        
        // vishnuvardhan logic for the second page
        if(6<slidesArray.count) {
            [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
        }
    }
    [comic setSlidesArray:slidesArray];
    [comic setAllSlideImages:slidesArray];
    [comic setupBook];
    [self addChildViewController:comic];
    [ comic.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[self setBoundary:0 :0 toView:container addView:comic.view];
    
    
    
    
    CGRect frame = comic.view.frame;
    frame.origin.y = 0;
    //        frame.size.width = CGRectGetWidth(cell.viewComicBook.frame);
    comic.view.frame = frame;
    
    
    if ([comicBook.comicTitle isEqualToString:@""] || comicBook.comicTitle == nil)
    {
        double cellHeight = comic.view.bounds.size.height + 20;
        
        [allCellFrameHeight addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        
        return cellHeight;
    }
    else
    {
        double cellHeight = comic.view.bounds.size.height + 60 + 20;
        
        [allCellFrameHeight addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        
        return cellHeight;
    }

}


#pragma mark - share button events
- (void)btnFacebookTap:(UIButton *)sender
{
    ComicBook *comicBook = _currentlyShowingComicBook;//[comicsArray objectAtIndex:sender.tag];
    
    if (comicBook.slides && [comicBook.slides count] >0)
    {
        NSUInteger imageCount = [comicBook.slides count];// >= 4 ? 4 : [comicBook.slides count];
        NSMutableArray* imageArray = [[NSMutableArray alloc] init];
        for (int i=0; i < imageCount; i++) {
            
            Slides *slides = (Slides*)comicBook.slides[i];
            [imageArray addObject:[self getImageFromURL:slides.slideImage]];
            //I do have only this option need to check with Vishu
            //            [imageArray addObject:[self getImageFromURL:[slideImages objectAtIndex:i]]];
        }
        
        
        [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"MainPage-ShareToSocialMedia" Action:@"FACEBOOK" Label:@""];
        UIImage *image = [self.comicShareView getComicShareImage:imageArray];
        [self doShareTo:FACEBOOK ShareImage:image];
    }
}

- (void)btnTwitterTap:(UIButton *)sender
{
    ComicBook *comicBook = [comicsArray objectAtIndex:sender.tag];
    

    
    if (comicBook.slides && [comicBook.slides count] >0)
    {
        NSUInteger imageCount = [comicBook.slides count];// >= 4 ? 4 : [comicBook.slides count];
        NSMutableArray* imageArray = [[NSMutableArray alloc] init];
        for (int i=0; i < imageCount; i++)
        {
            Slides *slides = (Slides*)comicBook.slides[i];
            [imageArray addObject:[self getImageFromURL:slides.slideImage]];
            //I do have only this option need to check with Vishu
            //            [imageArray addObject:[self getImageFromURL:[slideImages objectAtIndex:i]]];
        }
        
        [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"MainPage-ShareToSocialMedia" Action:@"TWITTER" Label:@""];
        UIImage *image = [self.comicShareView getComicShareImage:imageArray];
        [self doShareTo:TWITTER ShareImage:image];
    }
}

- (void)btnBubbleTap:(UIButton *)sender
{
    [self showCommentContainerView];
    
    currentComicIndex = sender.tag;
    
    ComicBook *comicBook = [comicsArray objectAtIndex:currentComicIndex];
    
    textView.placeholder = [NSString stringWithFormat:@"Say something to %@", comicBook.userDetail.firstName];
}

#pragma  mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tblvComics) {
        
        if ([_tblvComics numberOfRowsInSection:0] <= 1) {
            return;
        }
        if (_categoryCollectionViewHeightConstraint.constant != 0) {
            [self changeCategoryCollectionViewHeightTo:0];
        }
        //0.5 was added just to make the condition satisfy... It can be removed once the issue is found
        if (_bottomButtonsContainerViewTrailingConstraint.constant != - (_bottomButtonsContainerView.frame.size.width - 0.5)) {
            [self changeButtomButtonViewTrailingTo:-_bottomButtonsContainerView.frame.size.width];
        }
        
        CGRect newDetectLine1Frame;
        CGFloat variableHeight;
        
        CGFloat percentOfAreaDetectLineShouldCoverOutOf1 = 0.65;
        CGFloat startingPercentOfDetectLineOutOf1 = 0.15;
        
        variableHeight = (_tblvComics.frame.size.height * percentOfAreaDetectLineShouldCoverOutOf1) * (_tblvComics.contentOffset.y / (_tblvComics.contentSize.height - _tblvComics.frame.size.height));
        newDetectLine1Frame.origin.y = _tblvComics.frame.size.height * startingPercentOfDetectLineOutOf1 + _tblvComics.contentOffset.y + variableHeight;
 
        NSIndexPath *indexPath = [_tblvComics indexPathForRowAtPoint:newDetectLine1Frame.origin];
        
        ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];
        [self updateButtonInfoWithComicBook:comicBook withIndexPath:indexPath];
        
        //For testing purpose
        _detectLineTopConstraint.constant = _tblvComics.frame.size.height * startingPercentOfDetectLineOutOf1 + variableHeight;
        _detectLine1.hidden = YES;
        
        if (bottomBarView.menuState == Open) {
            [bottomBarView closeMenu];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _tblvComics) {
        [self changeCategoryCollectionViewHeightTo:_categoryCollectionViewHeightDefault];
        [self changeButtomButtonViewTrailingTo:-5];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tblvComics && !decelerate) {
        [self changeCategoryCollectionViewHeightTo:_categoryCollectionViewHeightDefault];
        [self changeButtomButtonViewTrailingTo:-5];
    }
}

- (void)changeCategoryCollectionViewHeightTo:(NSInteger)height {
    _categoryCollectionViewHeightConstraint.constant = height;
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)changeButtomButtonViewTrailingTo:(NSInteger)trailing {
    _bottomButtonsContainerViewTrailingConstraint.constant = trailing;
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Bottom buttons method

- (IBAction)facebookButtonTapped:(id)sender {
    [self btnFacebookTap:sender];
}

- (IBAction)likeButtonTapped:(id)sender {
    
}

- (IBAction)flagButtonTapped:(id)sender {
    [self openFlahSheet];
}

- (void)updateButtonInfoWithComicBook:(ComicBook *)comicBook withIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return;
    }
    _currentlyShowingComicBook = comicBook;
    [_profilePicButton sd_setImageWithURL:[NSURL URLWithString:comicBook.userDetail.profilePic] forState:UIControlStateNormal];
}

#pragma mark - BookChangeDelegate Methods
-(void)bookChanged:(int)Tag
{
    if(TagRecord!=Tag)
    {
        ComicBookVC*comic=(ComicBookVC*)[ComicBookDict objectForKey:[NSString stringWithFormat:@"%d",TagRecord]];
        [comic ResetBook];
    }
    
    TagRecord=Tag;
}


#pragma mark - Helper Methods
- (NSString *)dateFromString:(NSString *)dateString
{
    // createdDate = "2015-07-06 10:15:36";
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    return [dateFormat stringFromDate:date];
    
    //Oct 5,2015
}

- (NSString *)timeFromString:(NSString *)timeString
{
    // createdDate = "2015-07-06 10:15:36";
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormat dateFromString:timeString];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"hh.mm a"];
    return [dateFormat stringFromDate:date];
    
    //Oct 5,2015
}

- (void)didCloseInstructionViewWith:(InstructionView *)view withClosedSlideNumber:(SlideNumber)number
{
    [view removeFromSuperview];
}

@end
