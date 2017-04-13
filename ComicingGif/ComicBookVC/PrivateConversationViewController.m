//
//  PrivateConversationViewController.m
//  ComicApp
//
//  Created by ADNAN THATHIYA on 12/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#import "PrivateConversationViewController.h"
#import "CMCComicCell.h"
#import "BFPaperButton.h"
#import "ComicBookVC.h"
#import "MeCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "Constants.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "TopBarViewController.h"
#import "CameraViewController.h"
#import "ContactsViewController.h"
#import "MePageVC.h"
#import "MeAPIManager.h"
#import "ComicsModel.h"
#import "ComicBook.h"
#import "Slides.h"
#import "PrivateConversationCell.h"
#import "UIImageView+WebCache.h"
#import "PrivateConversationAPIManager.h"
#import "AppHelper.h"
#import "UIButton+WebCache.h"
#import "GlideScrollViewController.h"
#import "AppConstants.h"
#import "ComicConversationModel.h"
#import "ComicConversationBook.h"
#import "PrivateConversationTextCell.h"
#import "TopSearchVC.h"
#import "ComicPageViewController.h"

@interface PrivateConversationViewController () {
    int TagRecord;
    TopBarViewController *topBarView;
    NSArray *comicsArray;
    
    IBOutlet UIView *main_TransparentView;
    IBOutlet NSLayoutConstraint *constHeaderTopY;
    IBOutlet NSLayoutConstraint *constHeaderMholderTopY;
}

@property (weak, nonatomic) IBOutlet UITableView *tblvComics;
@property (weak, nonatomic) IBOutlet UIView *viewTransperant;
@property (weak, nonatomic) IBOutlet UIButton *btnMe;
@property (weak, nonatomic) IBOutlet UIButton *btnFriend;
@property (weak, nonatomic) IBOutlet UIView *viewPen;
@property (weak, nonatomic) IBOutlet UIImageView *imgvPinkDots;
@property (strong, nonatomic) NSMutableArray *comics;
@property (strong, nonatomic) NSString *shareId;
@property (nonatomic,weak) IBOutlet UILabel *mFriendName;
@property (nonatomic,weak) IBOutlet UIView *mHolderView;
@property (nonatomic,weak) IBOutlet UITextField *mCommentInputTF;
@property (nonatomic,weak) IBOutlet UIButton *mSendCommentButton;
@property (nonatomic, assign) BOOL keyboardShown;
@property (nonatomic, assign) BOOL allowToAnimate;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *HolderViewBottomConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *HolderViewHeightConstraint;
@property (nonatomic, assign) int initialHeight;
@property (strong, nonatomic) NSMutableArray *allCellFrameHeight;


@property CGRect saveTableViewFrame;

@end

@implementation PrivateConversationViewController

@synthesize saveTableViewFrame, viewTransperant, tblvComics, comics;
@synthesize btnMe,btnFriend, viewPen, imgvPinkDots,ComicBookDict, allCellFrameHeight;



#pragma mark - UIViewController
- (void)viewDidLoad
{
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    self.initialHeight = mainScreen.bounds.size.height - 25;
    
    allCellFrameHeight = [[NSMutableArray alloc] init];
    
    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"PrivateConversation" Attributes:nil];
    [super viewDidLoad];
    [self animation];
    [self prepareView];
    [self addTopBarView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callAPIToGetTheComics) name:@"UpdateFriendComics" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startReplyComicAnimation) name:@"StartFriendReplyComicAnimation" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopReplyComicAnimation) name:@"StopFriendReplyComicAnimation" object:nil];
    [self callAPIToGetTheComics];
    [main_TransparentView sendSubviewToBack:viewTransperant];
}

//dinesh
#pragma mark - keyboard handling methods & Textfield delgates

- (void)resetAnimationVariables
{
    self.allowToAnimate = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self resetAnimationVariables];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Say Something to @%@", self.friendObj.firstName]
                                                              attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.mCommentInputTF.attributedPlaceholder = str;
    
    [self.mCommentInputTF setClipsToBounds:YES];
    [self.mCommentInputTF.layer setMasksToBounds:YES];
    [self.mCommentInputTF.layer setCornerRadius:3];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidLayoutSubviews
{
    btnMe.layer.cornerRadius = btnMe.bounds.size.height/2;
    btnMe.layer.masksToBounds = YES;
    btnFriend.layer.cornerRadius = btnFriend.bounds.size.height/2;
    btnFriend.layer.masksToBounds = YES;
}
// Setup keyboard handlers to slide the view containing the table view and
// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
    //[self moveView:[notification userInfo] up:YES];
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (!self.keyboardShown)
    {
        self.keyboardShown = YES;
        self.allowToAnimate = !self.keyboardShown;
        
        self.HolderViewBottomConstraint.constant = keyboardSize.height;

        [UIView animateWithDuration:0.5 animations:^{
            
            self.mHolderView.frame = CGRectMake(self.mHolderView.frame.origin.x,
                                                        25,
                                                        self.mHolderView.frame.size.width,
                                                        self.initialHeight - keyboardSize.height);
            
        } completion:^(BOOL finished) {
            if (!self.tblvComics.isDragging && (self.tblvComics.frame.size.height < self.tblvComics.contentSize.height)) {
                CGPoint offset = CGPointMake(0, self.tblvComics.contentSize.height - self.tblvComics.frame.size.height);
                [self.tblvComics setContentOffset:offset animated:NO];
            }
        }];
    }
    else
    {
        self.mHolderView.frame = CGRectMake(self.mHolderView.frame.origin.x,
                                                    25,
                                                    self.mHolderView.frame.size.width,
                                                    self.initialHeight - keyboardSize.height);
        
        self.HolderViewBottomConstraint.constant = keyboardSize.height;
        
        if (!self.tblvComics.isDragging && (self.tblvComics.frame.size.height < self.tblvComics.contentSize.height)) {
            CGPoint offset = CGPointMake(0, self.tblvComics.contentSize.height - self.tblvComics.frame.size.height);
            [self.tblvComics setContentOffset:offset animated:NO];
        }
    }
    
    
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    //[self moveView:[notification userInfo] up:NO];
    
    //CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.mHolderView.frame = CGRectMake(self.mHolderView.frame.origin.x,
                                                    25,
                                                    self.mHolderView.frame.size.width,
                                                    self.initialHeight);
        self.HolderViewBottomConstraint.constant = 0;
        
    }completion:^(BOOL finished) {
        self.keyboardShown = NO;
        self.allowToAnimate = !self.keyboardShown;
    }];
}

#pragma mark TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (self.mCommentInputTF.text.length > 0)
    {
        [PrivateConversationAPIManager postPrivateConversationV2CommentWithFriendId:self.friendObj.friendId
                                                                          shareText:self.mCommentInputTF.text
                                                                      currentUserId:[AppHelper getCurrentLoginId]
                                                                       SuccessBlock:^(id object) {
                                                                           NSLog(@"Post object response : %@", object);
                                                                           self.mCommentInputTF.text = @"";
                                                                           self.allowToAnimate = NO;
                                                                           [self callAPIToGetTheComics];
                                                                       } andFail:^(NSError *errorMessage) {
                                                                           
                                                                       }];
    }
    
    return YES;
}

#define MAX_LENGTH 50

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= MAX_LENGTH && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {
        return YES;
    }
}

#pragma mark - UIView Methods
- (void)prepareView
{
   /* if(IS_IPHONE_5)
    {
        btnMe.frame = CGRectMake(CGRectGetMinX(btnMe.frame),
                                 CGRectGetMinY(btnMe.frame),
                                 CGRectGetWidth(btnMe.frame),
                                 CGRectGetHeight(btnMe.frame));
        
        btnFriend.frame = CGRectMake(CGRectGetMinX(btnFriend.frame),
                                     CGRectGetMinY(btnFriend.frame),
                                     CGRectGetWidth(btnFriend.frame),
                                     CGRectGetHeight(btnFriend.frame));
    }
    else if(IS_IPHONE_6)
    {
        btnMe.frame = CGRectMake(CGRectGetMinX(btnMe.frame),
                                 CGRectGetMinY(btnMe.frame),
                                 58,
                                 58);
        
        btnFriend.frame = CGRectMake(CGRectGetMinX(btnFriend.frame),
                                     CGRectGetMinY(btnFriend.frame),
                                     49,
                                     49);
    }
    else if(IS_IPHONE_6P)
    {
        btnMe.frame = CGRectMake(CGRectGetMinX(btnMe.frame),
                                 CGRectGetMinY(btnMe.frame),
                                 61,
                                 61);
        
        btnFriend.frame = CGRectMake(CGRectGetMinX(btnFriend.frame),
                                     CGRectGetMinY(btnFriend.frame),
                                     52,
                                     52);
    }*/
    
    
    TagRecord=0;
    ComicBookDict=[NSMutableDictionary new];
    comics = [[NSMutableArray alloc] init];
    
    saveTableViewFrame = tblvComics.frame;
    
    tblvComics.pullToRefreshView.arrowColor = [UIColor whiteColor];
    tblvComics.pullToRefreshView.textColor = [UIColor whiteColor];
    tblvComics.pullToRefreshView.activityIndicatorViewColor = [UIColor whiteColor];
    
    [self.btnMe sd_setImageWithURL:[NSURL URLWithString:[[AppHelper initAppHelper] getCurrentUser].profile_pic] forState:UIControlStateNormal];
    [self.btnFriend sd_setImageWithURL:[NSURL URLWithString:self.friendObj.profilePic] forState:UIControlStateNormal];
    //[self.imgvPinkDots setImage:[UIImage imageNamed:@"dots11"]];
    
    // [self setupPenAnimation];
    
    //    [self loadMoreData];
}

- (void)startReplyComicAnimation {
    self.imgvPinkDots.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"dots1"],
                                         [UIImage imageNamed:@"dots2"],
                                         [UIImage imageNamed:@"dots3"],
                                         [UIImage imageNamed:@"dots4"],
                                         [UIImage imageNamed:@"dots5"],
                                         [UIImage imageNamed:@"dots6"],
                                         [UIImage imageNamed:@"dots7"],
                                         [UIImage imageNamed:@"dots8"],
                                         [UIImage imageNamed:@"dots9"],
                                         [UIImage imageNamed:@"dots10"],
                                         [UIImage imageNamed:@"dots11"],nil];
    self.imgvPinkDots.animationDuration = 2.0f;
    self.imgvPinkDots.animationRepeatCount = 0;
    [self.imgvPinkDots startAnimating];
}

- (void)stopReplyComicAnimation {
    [self.imgvPinkDots stopAnimating];
    [self.imgvPinkDots setImage:[UIImage imageNamed:@"dots11"]];
}

- (void)animation
{
    btnMe.transform = CGAffineTransformMakeScale(0, 0);
    btnFriend.transform = CGAffineTransformMakeScale(0, 0);
    viewPen.transform = CGAffineTransformMakeScale(0, 0);
    imgvPinkDots.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^
     {
         btnMe.transform = CGAffineTransformMakeScale(1, 1);
         btnFriend.transform = CGAffineTransformMakeScale(1, 1);
         viewPen.transform = CGAffineTransformMakeScale(1, 1);
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.5 animations:^
          {
              imgvPinkDots.alpha = 1;
          }];
     }];
    
}

- (void)addTopBarView {
    topBarView = [self.storyboard instantiateViewControllerWithIdentifier:TOP_BAR_VIEW];
    CGFloat heightOfNavBar = 44;

    CGFloat heightOfTopBar;
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
    constHeaderTopY.constant = heightOfTopBar-20;
    constHeaderMholderTopY.constant = heightOfTopBar-20;
    [topBarView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, heightOfTopBar)];
    [self addChildViewController:topBarView];
    [self.view addSubview:topBarView.view];
    [topBarView didMoveToParentViewController:self];
    
    __block typeof(self) weakSelf = self;
    topBarView.homeAction = ^(void) {
        //        CameraViewController *cameraView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:CAMERA_VIEW];
        //        [weakSelf presentViewController:cameraView animated:YES completion:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];

    };
    topBarView.contactAction = ^(void) {
        //        ContactsViewController *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:CONTACTS_VIEW];
        //        [weakSelf presentViewController:contactsView animated:YES completion:nil];
        [AppHelper closeMainPageviewController:self];
    };
    topBarView.meAction = ^(void) {
        //        [weakSelf performSegueWithIdentifier:ME_VIEW_SEGUE sender:nil];
        MePageVC *meView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:ME_VIEW_SEGUE];
        //        [weakSelf presentViewController:meView animated:YES completion:nil];
        [weakSelf.navigationController pushViewController:meView animated:YES];
    };
    topBarView.searchAction = ^(void)
    {
        TopSearchVC *topSearchView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:TOP_SEARCH_VIEW];
        [topSearchView displayContentController:weakSelf];
    };
}

#pragma mark - dummy Data
- (NSMutableArray *)makeDummyComics
{
    NSMutableArray *dummyComics = [[NSMutableArray alloc] init];
    
    //    NSDictionary *comicUser1 = @{UKeyID : @13,
    //                                 UKeyImage: @"u1.jpg",
    //                                 UKeyName : @"John"};
    //    NSDictionary *comicUser2 = @{UKeyID : @13,
    //                                 UKeyImage: @"u2.png",
    //                                 UKeyName : @"Merry"};
    //    NSDictionary *comicUser3 = @{UKeyID : @13,
    //                                 UKeyImage: @"u3.jpg",
    //                                 UKeyName : @"Adam"};
    //    NSDictionary *comicUser4 = @{UKeyID : @13,
    //                                 UKeyImage: @"u4.jpg",
    //                                 UKeyName : @"Mark"};
    //    NSDictionary *comicUser5 = @{UKeyID : @13,
    //                                 UKeyImage: @"u5.jpg",
    //                                 UKeyName : @"Jessica"};
    //    NSDictionary *comicUser6 = @{UKeyID : @13,
    //                                 UKeyImage: @"u6.jpg",
    //                                 UKeyName : @"Johnsan"};
    //    NSDictionary *comicUser7 = @{UKeyID : @13,
    //                                 UKeyImage: @"u7.jpg",
    //                                 UKeyName : @"Justin"};
    //    NSDictionary *comicUser8 = @{UKeyID : @13,
    //                                 UKeyImage: @"u8.jpg",
    //                                 UKeyName : @"Peterson"};
    //    NSDictionary *comicUser9 = @{UKeyID : @13,
    //                                 UKeyImage: @"u9.jpg",
    //                                 UKeyName : @"Fedrick"};
    //    NSDictionary *comicUser10 = @{UKeyID : @13,
    //                                  UKeyImage: @"u10.jpg",
    //                                  UKeyName : @"Rebbeca"};
    //
    //    NSDictionary *comicUser11 = @{UKeyID : @13,
    //                                  UKeyImage: @"u3.jpg",
    //                                  UKeyName : @"Adam"};
    //    NSDictionary *comicUser12 = @{UKeyID : @13,
    //                                  UKeyImage: @"u4.jpg",
    //                                  UKeyName : @"Mark"};
    //    NSDictionary *comicUser13 = @{UKeyID : @13,
    //                                  UKeyImage: @"u5.jpg",
    //                                  UKeyName : @"Jessica"};
    //    NSDictionary *comicUser14 = @{UKeyID : @13,
    //                                  UKeyImage: @"u6.jpg",
    //                                  UKeyName : @"Johnsan"};
    //    NSDictionary *comicUser15 = @{UKeyID : @13,
    //                                  UKeyImage: @"u7.jpg",
    //                                  UKeyName : @"Justin"};
    //    NSDictionary *comicUser16 = @{UKeyID : @13,
    //                                  UKeyImage: @"u8.jpg",
    //                                  UKeyName : @"Peterson"};
    //    NSDictionary *comicUser17 = @{UKeyID : @13,
    //                                  UKeyImage: @"u9.jpg",
    //                                  UKeyName : @"Fedrick"};
    //
    //    NSDictionary *comicUser18 = @{UKeyID : @13,
    //                                  UKeyImage: @"u4.jpg",
    //                                  UKeyName : @"Mark"};
    //    NSDictionary *comicUser19 = @{UKeyID : @13,
    //                                  UKeyImage: @"u5.jpg",
    //                                  UKeyName : @"Jessica"};
    //    NSDictionary *comicUser20 = @{UKeyID : @13,
    //                                  UKeyImage: @"u6.jpg",
    //                                  UKeyName : @"Johnsan"};
    //
    //
    //    CMCComic *comic1 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"the book.png",
    //                                                              CKeyTime : @"2.15 pm",
    //                                                              CKeyDate : @"OCT 10, 2015",
    //                                                              UKeyDetail : comicUser1}];
    //
    //    CMCComic *comic2 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"comic2.jpg",
    //                                                              CKeyTime : @"1.45 am",
    //                                                              CKeyDate : @"JAN 15, 2015",
    //                                                              UKeyDetail : comicUser2}];
    //
    //    CMCComic *comic3 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"comic3.jpg",
    //                                                              CKeyTime : @"3.30 pm",
    //                                                              CKeyDate : @"FEB 21, 2015",
    //                                                              UKeyDetail : comicUser3}];
    //
    //    CMCComic *comic4 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"comic4.jpg",
    //                                                              CKeyTime : @"1.30 pm",
    //                                                              CKeyDate : @"MAY 28, 2015",
    //                                                              UKeyDetail : comicUser4}];
    //
    //    CMCComic *comic5 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"comic5.jpg",
    //                                                              CKeyTime : @"10 am",
    //                                                              CKeyDate : @"MAR 25, 2015",
    //                                                              UKeyDetail : comicUser5}];
    //
    //    CMCComic *comic6 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"comic6.jpg",
    //                                                              CKeyTime : @"2.20 pm",
    //                                                              CKeyDate : @"JUN 21, 2015",
    //                                                              UKeyDetail : comicUser6}];
    //
    //    CMCComic *comic7 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"comic7.jpg",
    //                                                              CKeyTime : @"10 am",
    //                                                              CKeyDate : @"MAR 25, 2015",
    //                                                              UKeyDetail : comicUser7}];
    //
    //    CMCComic *comic8 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"comic8.jpg",
    //                                                              CKeyTime : @"1.30 pm",
    //                                                              CKeyDate : @"MAY 28, 2015",
    //                                                              UKeyDetail : comicUser8}];
    //
    //    CMCComic *comic9 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                              CKeyName : @"",
    //                                                              CKeyImage : @"comic9.jpg",
    //                                                              CKeyTime : @"3.30 pm",
    //                                                              CKeyDate : @"FEB 21, 2015",
    //                                                              UKeyDetail : comicUser9}];
    //
    //    CMCComic *comic10 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic10.jpg",
    //                                                               CKeyTime : @"1.30 pm",
    //                                                               CKeyDate : @"MAY 28, 2015",
    //                                                               UKeyDetail : comicUser10}];
    //
    //    CMCComic *comic11 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic11.jpg",
    //                                                               CKeyTime : @"2.20 pm",
    //                                                               CKeyDate : @"JUN 21, 2015",
    //                                                               UKeyDetail : comicUser11}];
    //
    //    CMCComic *comic12 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic12.jpg",
    //                                                               CKeyTime : @"1.45 am",
    //                                                               CKeyDate : @"JAN 15, 2015",
    //                                                               UKeyDetail : comicUser12}];
    //
    //    CMCComic *comic13 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic13.jpg",
    //                                                               CKeyTime : @"3.30 pm",
    //                                                               CKeyDate : @"FEB 21, 2015",
    //                                                               UKeyDetail : comicUser13}];
    //
    //    CMCComic *comic14 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic14.jpg",
    //                                                               CKeyTime : @"1.30 pm",
    //                                                               CKeyDate : @"MAY 28, 2015",
    //                                                               UKeyDetail : comicUser14}];
    //
    //    CMCComic *comic15 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic15.jpg",
    //                                                               CKeyTime : @"3.30 pm",
    //                                                               CKeyDate : @"FEB 21, 2015",
    //                                                               UKeyDetail : comicUser15}];
    //
    //    CMCComic *comic16 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic16.jpg",
    //                                                               CKeyTime : @"1.30 pm",
    //                                                               CKeyDate : @"MAY 28, 2015",
    //                                                               UKeyDetail : comicUser16}];
    //
    //    CMCComic *comic17 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic17.jpg",
    //                                                               CKeyTime : @"2.20 pm",
    //                                                               CKeyDate : @"JUN 21, 2015",
    //                                                               UKeyDetail : comicUser17}];
    //
    //    CMCComic *comic18 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic18.jpg",
    //                                                               CKeyTime : @"1.45 am",
    //                                                               CKeyDate : @"JAN 15, 2015",
    //                                                               UKeyDetail : comicUser18}];
    //
    //    CMCComic *comic19 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic19.jpg",
    //                                                               CKeyTime : @"1.30 pm",
    //                                                               CKeyDate : @"MAY 28, 2015",
    //                                                               UKeyDetail : comicUser19}];
    //
    //    CMCComic *comic20 = [[CMCComic alloc] initWithDictionary:@{CKeyID : @1,
    //                                                               CKeyName : @"",
    //                                                               CKeyImage : @"comic9.jpg",
    //                                                               CKeyTime : @"1.45 am",
    //                                                               CKeyDate : @"JAN 15, 2015",
    //                                                               UKeyDetail : comicUser20}];
    //
    //
    //    [dummyComics addObject:comic1];
    //    [dummyComics addObject:comic2];
    //    [dummyComics addObject:comic3];
    //    [dummyComics addObject:comic4];
    //    [dummyComics addObject:comic5];
    //    [dummyComics addObject:comic6];
    //    [dummyComics addObject:comic7];
    //    [dummyComics addObject:comic8];
    //    [dummyComics addObject:comic9];
    //    [dummyComics addObject:comic10];
    //    [dummyComics addObject:comic11];
    //    [dummyComics addObject:comic12];
    //    [dummyComics addObject:comic13];
    //    [dummyComics addObject:comic14];
    //    [dummyComics addObject:comic15];
    //    [dummyComics addObject:comic16];
    //    [dummyComics addObject:comic17];
    //    [dummyComics addObject:comic18];
    //    [dummyComics addObject:comic19];
    //    [dummyComics addObject:comic20];
    
    return dummyComics;
}


#pragma mark - Helper Methods
- (void)refreshData
{
    [tblvComics.pullToRefreshView stopAnimating];
}

- (void)loadMoreData
{
    [comics addObjectsFromArray:[self makeDummyComics]];
    
    [tblvComics.infiniteScrollingView stopAnimating];
    
    [tblvComics reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        CGFloat height = CGRectGetHeight(viewTransperant.frame);
        return height;
    }
    
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CGRectGetHeight(viewTransperant.frame))];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (comicsArray != nil &&
        comicsArray.count > 0 &&
        (comicsArray.count - 1) == section)
    {
        CGFloat height = 45;
        return height;
    }
    
    
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 45)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return comicsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comicsArray[section] count];
}

#define CONVERSTION_TYPE_COMIC @"comic"
#define CONVERSTION_TYPE_TEXT  @"text"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"PrivateConversationCell";
    
    ComicConversationBook *mComicConversatinBook = (ComicConversationBook *)[comicsArray[indexPath.section] objectAtIndex:indexPath.row];

    if ([mComicConversatinBook.conversationType isEqualToString:CONVERSTION_TYPE_COMIC])
    {
        
        
        
        __block PrivateConversationCell* cell= (PrivateConversationCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell = nil;

        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrivateConversationCell" owner:self options:nil];
            
            cell = [nib objectAtIndex:0];
            
            if(nil!=[ComicBookDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [ComicBookDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }
            
            ComicBookVC *comic=[self.storyboard instantiateViewControllerWithIdentifier:@"ComicBookVC"];
            comic.delegate=self;
            comic.Tag=(int)indexPath.row;
            
            ComicBook *comicBook = (ComicBook *)mComicConversatinBook.coversation[0];

            [cell.userProfilePic sd_setImageWithURL:[NSURL URLWithString:comicBook.userDetail.profilePic]];
            
            //dinesh
            cell.mUserName.text = comicBook.userDetail.firstName;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *dateFromStr = [dateFormat dateFromString:comicBook.createdDate];
            [dateFormat setDateFormat:@"MMM dd, hh.mm a"];
            NSString *dateStr = [dateFormat stringFromDate:dateFromStr];
            
            cell.lblDate.text = dateStr;
            
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
            
            //dinesh
            cell.mUserName.text = comicBook.userDetail.firstName;
  
            
            // New Code - Adnan
            [cell layoutIfNeeded];
           
            
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
            
            comic.view.frame = CGRectMake(0, 0, width, CGRectGetHeight(cell.viewComicBook.frame));
            
            //  comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(container.frame), CGRectGetHeight(container.frame));
            
            //            [comic setImages: [self setupImages:indexPath]];
            
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
            [ comic.view setTranslatesAutoresizingMaskIntoConstraints:YES];
            //[self setBoundary:0 :0 toView:container addView:comic.view];
            
            [ComicBookDict setObject:comic forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            
            CGRect frame = comic.view.frame;
            frame.origin.y = 0;
            frame.size.width = width;
            
            comic.view.frame = frame;
            
            // comic.pageViewController.view.frame = CGRectMake(0, 0, 0, 0);
            
            [cell.viewComicBook addSubview:comic.view];

            [ComicBookDict setObject:comic forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            if ([comicBook.userDetail.userId isEqualToString:[AppHelper getCurrentLoginId]])
            {
                if ([mComicConversatinBook.chatStatus isEqualToString:@"seen"])
                {
                    cell.mChatStatus.text = @"Read";
                }
                else
                {
                    cell.mChatStatus.text = @"Unread";
                }
            }
        }
        
//        __block PrivateConversationCell* cell= (PrivateConversationCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//        
//        cell = nil;
//        
//        if (cell == nil)
//        {
//            
//            
//            if ([comicBook.comicTitle isEqualToString:@""] || comicBook.comicTitle == nil)
//            {
//                cell.lblComicTitle.hidden = YES;
//                cell.heightConstraintComicTitle.constant = 0;
//                
//            }
//            else
//            {
//                cell.lblComicTitle.hidden = NO;
//                cell.lblComicTitle.text = comicBook.comicTitle;
//                
//                cell.heightConstraintComicTitle.constant = 60;
//            }
//            
//            
//            comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(cell.viewComicBook.frame), CGRectGetHeight(cell.viewComicBook.frame));
//            
//            [cell.viewComicBook addSubview:comic.view];
//            
//            // vishnu
//            NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
//            [slidesArray addObjectsFromArray:comicBook.slides];
//            
//            // To repeat the cover image again on index page as the first slide.
//            if(slidesArray.count > 1) {
//                [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
//                
//                // Adding a sample slide to array to maintain the logic
//                Slides *slides = [Slides new];
//                [slidesArray insertObject:slides atIndex:1];
//                
//                // vishnuvardhan logic for the second page
//                if(6<slidesArray.count) {
//                    [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
//                }
//            }
//            
//            //        [comic setImages: [self setupImages:indexPath]];
//            [comic setSlidesArray:slidesArray];
//            [comic setupBook];
//            [self addChildViewController:comic];
//            
//            
//        }
        
             
        return cell;
    }
    else
    {
        PrivateConversationTextCell *cell = (PrivateConversationTextCell *)[tableView dequeueReusableCellWithIdentifier:@"fs"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrivateConversationTextCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        ComicBook *comicBook = (ComicBook *)mComicConversatinBook.coversation[0];
        
        if ([comicBook.userDetail.userId isEqualToString:[AppHelper getCurrentLoginId]])
        {
            [cell.leftIndicator setHidden:YES];
            [cell.rightIndicator setHidden:NO];
            
            [cell.userProfilePic setHidden:YES];
            [cell.mUserName setHidden:YES];
            
            [cell.mMessageHolderView setBackgroundColor:[UIColor colorWithHexStr:@"97999C"]];
            
            cell.lblDate.textColor = [UIColor colorWithHexStr:@"58595B"];
        }
        else
        {
            [cell.leftIndicator setHidden:NO];
            [cell.rightIndicator setHidden:YES];
            
            [cell.userProfilePic setHidden:NO];
            [cell.mUserName setHidden:NO];
            
            [cell.mMessageHolderView setBackgroundColor:[UIColor colorWithHexStr:@"5BCAF4"]];
            cell.lblDate.textColor = [UIColor colorWithHexStr:@"1B75BC"];

            [cell.userProfilePic sd_setImageWithURL:[NSURL URLWithString:comicBook.userDetail.profilePic]];
            cell.mUserName.text = comicBook.userDetail.firstName;
        }
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateFromStr = [dateFormat dateFromString:comicBook.createdDate];
        [dateFormat setDateFormat:@"MMM dd, hh.mm a"];
        NSString *dateStr = [dateFormat stringFromDate:dateFromStr];
        
        cell.lblDate.text = dateStr;
    
        cell.mMessage.text = comicBook.message;
        
        if ([comicBook.userDetail.userId isEqualToString:[AppHelper getCurrentLoginId]])
        {
            if ([mComicConversatinBook.chatStatus isEqualToString:@"seen"])
            {
                cell.mChatStatus.text = @"Read";
            }
            else
            {
                cell.mChatStatus.text = @"Unread";
            }
            
            if (![(ComicConversationBook *)[comicsArray[indexPath.section] lastObject] isEqual:mComicConversatinBook])
            {
                cell.mChatStatus.hidden = YES;
                cell.const_bottom_bubble.constant = 1;
            }
        }
        else
        {
            
            if (![(ComicConversationBook *)[comicsArray[indexPath.section] firstObject] isEqual:mComicConversatinBook])
            {
                cell.mUserName.hidden = YES;
                cell.userProfilePic.hidden = YES;
            }
            
            cell.mChatStatus.hidden = YES;
            cell.const_bottom_bubble.constant = 1;
        }
        
        CGSize labelExtectedSize = [cell.mMessage.text sizeWithAttributes:
                           @{NSFontAttributeName:cell.mMessage.font}];
        
        NSLog(@"labelExtectedSize : %@", NSStringFromCGSize(labelExtectedSize));
        
        if (labelExtectedSize.width > cell.mMessage.bounds.size.width)
        {
            cell.mMessageHolderView.frame = CGRectMake(cell.mMessageHolderView.frame.origin.x,
                                                       cell.mMessageHolderView.frame.origin.y,
                                                       cell.mMessageHolderView.frame.size.width,
                                                       74);
            cell.mChatStatus.frame = CGRectMake(cell.mChatStatus.frame.origin.x,
                                                       cell.mMessageHolderView.frame.origin.y + cell.mMessageHolderView.frame.size.height + 8,
                                                       cell.mChatStatus.frame.size.width,
                                                       cell.mChatStatus.frame.size.height);
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComicConversationBook *mComicConversatinBook = (ComicConversationBook *)[comicsArray[indexPath.section] objectAtIndex:indexPath.row];

    ComicBook *comicBook = (ComicBook *)mComicConversatinBook.coversation[0];
    
    if ([mComicConversatinBook.conversationType isEqualToString:CONVERSTION_TYPE_COMIC])
    {
        if (allCellFrameHeight.count == 0 || allCellFrameHeight == nil)
        {
            return [self getHeightForCell:indexPath withComic:comicBook];
        }
        else if (allCellFrameHeight.count > 0)
        {
            // id height =  allCellFrameHeight[indexPath.row];
            
            if (allCellFrameHeight.count > indexPath.row + 1)
            {
                id height =  allCellFrameHeight[indexPath.row];
                
                return [height floatValue];
            }
            else
            {
                return [self getHeightForCell:indexPath withComic:comicBook];
            }
        }
        else
        {
            return [self getHeightForCell:indexPath withComic:comicBook];
        }
    }
    else if ([mComicConversatinBook.conversationType isEqualToString:CONVERSTION_TYPE_TEXT])
    {
        CGFloat fontSize = 8;
        
        if (IS_IPHONE_5)
        {
            fontSize = 8.;
            
        }
        else if (IS_IPHONE_6)
        {
            fontSize = 9.;
        }
        else if (IS_IPHONE_6P)
        {
            fontSize = 10.;
        }
        
        int incr  = 0;
        
        if ([(ComicConversationBook *)[comicsArray[indexPath.section] lastObject] isEqual:mComicConversatinBook] &&
            ([comicBook.userDetail.userId isEqualToString:[AppHelper getCurrentLoginId]]))
        {
            incr = 20;
        }
        
        CGSize labelExtectedSize = [comicBook.message sizeWithAttributes:
                           @{NSFontAttributeName:[UIFont fontWithName:@"ArialMT" size:fontSize]}];
        if (labelExtectedSize.width > tableView.frame.size.width - 180)
        {
            return 69 + incr;
        }
        
        return 50 + incr;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.allowToAnimate)
    {
        cell.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.contentView.layer.shadowOffset = CGSizeMake(10, 10);
        cell.contentView.alpha = 0;
        cell.contentView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
        cell.contentView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        [UIView animateWithDuration:1 animations:^
         {
             cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
             cell.contentView.alpha = 1;
             cell.contentView.layer.transform = CATransform3DIdentity;
         }];
    }
    
    
}

- (CGFloat)getHeightForCell:(NSIndexPath *)indexPath withComic:(ComicBook *)comicBook
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
   // ComicBook *comicBook = [comicArray objectAtIndex:indexPath.row];
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
        double cellHeight = comic.view.bounds.size.height + 20 + 15;
        
        [allCellFrameHeight addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        
        return cellHeight;
    }
    else
    {
        double cellHeight = comic.view.bounds.size.height + 60 + 20 + 15;
        
        [allCellFrameHeight addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        
        return cellHeight;
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.allowToAnimate)
    {
        CGFloat offset = scrollView.contentOffset.y; // here you will get the offset value
        CGFloat value = offset / tblvComics.frame.size.height;
        
        NSLog(@"value = %f",value);
        
        if(value > 0 && value < 1)
        {
            self.viewTransperant.alpha = 1-value/4;
        }
    }
    
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

#pragma mark - Events Methods
- (IBAction)btnMeTouchDown:(id)sender
{
    [UIView animateWithDuration:0.1 animations:^
     {
         btnMe.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
     }];
}

- (IBAction)btnMeTouchUpInside:(id)sender
{
    [self restoreTransformWithBounceForView:btnMe];
}

- (IBAction)btnMeTouchUpOutside:(id)sender
{
    [self restoreTransformWithBounceForView:btnMe];
}

- (IBAction)btnFriendTouchDown:(id)sender
{
    [UIView animateWithDuration:0.1 animations:^
     {
         btnFriend.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
     }];
}

- (IBAction)btnFriendTouchUpInside:(id)sender
{
    [self restoreTransformWithBounceForView:btnFriend];
}

- (IBAction)btnFriendTouchUpOutside:(id)sender
{
    [self restoreTransformWithBounceForView:btnFriend];
}

- (void)restoreTransformWithBounceForView:(UIView*)view
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^
     {
         view.layer.transform = CATransform3DIdentity;
     }
                     completion:nil];
}

- (IBAction)btnPenTouchDown:(id)sender
{
    [UIView animateWithDuration:0.1 animations:^
     {
         viewPen.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
     }];
}

- (IBAction)btnPenTouchUpInside:(id)sender
{
    [self restoreTransformWithBounceForView:viewPen];
    [self navigateToGlideScrollView];
}

- (IBAction)btnPenTouchUpOutside:(id)sender
{
    [self navigateToGlideScrollView];
    [self restoreTransformWithBounceForView:viewPen];
}

- (void)navigateToGlideScrollView {
    [[GoogleAnalytics sharedGoogleAnalytics] logUserEvent:@"Private-Reply" Action:@"FriendReply" Label:@""];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"glidenavigation"];
    GlideScrollViewController *controller = (GlideScrollViewController *)[navigationController.childViewControllers firstObject];
    controller.comicType = ReplyComic;
    controller.replyType = FriendReply;
    controller.friendOrGroupId = self.friendObj.friendId;
    controller.shareId = self.shareId;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)sendCommentClicked:(id)sender
{
    if (self.mCommentInputTF.text.length > 0)
    {
        [PrivateConversationAPIManager postPrivateConversationV2CommentWithFriendId:self.friendObj.friendId
                                                                          shareText:self.mCommentInputTF.text
                                                                      currentUserId:[AppHelper getCurrentLoginId]
                                                                       SuccessBlock:^(id object) {
                                                                           NSLog(@"Post object response : %@", object);
                                                                       } andFail:^(NSError *errorMessage) {
                                                                           
                                                                       }];
    }
}

- (IBAction)tappedBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - helper methods

-(NSArray*)setupImages:(NSIndexPath*)indexPath
{
    /*
     NSMutableArray *images=[NSMutableArray new];
     
     if(indexPath.row%2)
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
     if(indexPath.row%2)
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
     if(indexPath.row%2)
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
     */
    
    NSMutableArray *slideImagesArray = [[NSMutableArray alloc] init];
    ComicBook *comicBook = [comicsArray[indexPath.section] objectAtIndex:indexPath.row];
    [slideImagesArray addObject:comicBook.coverImage];
    
    for(Slides *slides in comicBook.slides) {
        [slideImagesArray addObject:slides.slideImage];
    }
    return slideImagesArray;
}

- (NSArray *)getGroupedComics: (NSArray *)cmcs
{
    //ComicConversationBook *mComicConversatinBook = (ComicConversationBook *)[comicsArray objectAtIndex:indexPath.row];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSString *lastUserId = nil;
    
    for (ComicConversationBook *conversationBook in cmcs)
    {
        ComicBook *comicBook = (ComicBook *)conversationBook.coversation[0];
        
        if (lastUserId &&
            [lastUserId isEqualToString:comicBook.userDetail.userId])
        {
            [[tempArray lastObject] addObject:conversationBook];
        }
        else
        {
            NSMutableArray *tempArray1 = [[NSMutableArray alloc] init];
            [tempArray1 addObject:conversationBook];
            [tempArray addObject:tempArray1];
        }
        
        lastUserId = comicBook.userDetail.userId;
    }
    
    return tempArray;
}

- (void)callAPIToGetTheComics {
    
    self.mFriendName.text = self.friendObj.firstName;
    [PrivateConversationAPIManager getPrivateConversationWithFriendId:self.friendObj.friendId
                                                        currentUserId:[AppHelper getCurrentLoginId]
                                                         SuccessBlock:^(id object) {
                                                             
                                                             
                                                             
                                                             
                                                             
                                                             
                                                             NSLog(@"%@", object);
                                                             NSError *error;
                                                             /*ComicsModel *comicsModel = [MTLJSONAdapter modelOfClass:ComicsModel.class fromJSONDictionary:[object valueForKey:@"data"] error:&error];*/
                                                             
                                                             ComicConversationModel *comicsModel = [MTLJSONAdapter modelOfClass:ComicConversationModel.class fromJSONDictionary:[object valueForKey:@"data"] error:&error];
                                                             
                                                             NSLog(@"%@", comicsModel);
                                                             self.shareId = comicsModel.shareId;
                                                             NSArray *temp = comicsModel.books;
                                                             temp = [[temp reverseObjectEnumerator] allObjects];
                                                             
                                                             comicsArray = [self getGroupedComics:temp];
                                                             
                                                             [self.tblvComics reloadData];
                                                             
                                                             
                                                             //Scroll down to the last cell of table View
                                                             CGPoint offset = CGPointMake(0, self.tblvComics.contentSize.height - self.tblvComics.frame.size.height);
                                                             [self.tblvComics setContentOffset:offset animated:NO];
                                                             //---------------

                                                             //PUT request to update SEEN comic/ text object
                                                             [PrivateConversationAPIManager putSeenStatusWithOwnerId:self.friendObj.friendId
                                                                                                              userId:[AppHelper getCurrentLoginId]
                                                                                                        SuccessBlock:^(id object) {
                                                                 NSLog(@"Updated lastSeen comic/ text object");
                                                             } andFail:^(NSError *errorMessage) {
                                                                 NSLog(@"fails to update lastSeen comic/ text object");
                                                             }];
                                                             //---------------
                                                             
                                                             [self performSelector:@selector(resetAnimationVariables) withObject:nil afterDelay:1];
                                                             
                                                         } andFail:^(NSError *errorMessage) {
                                                             NSLog(@"%@", errorMessage);
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
@end
