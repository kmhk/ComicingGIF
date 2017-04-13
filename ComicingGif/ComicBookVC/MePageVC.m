//
//  MePageVC.m
//  CurlDemo
//
//  Created by Subin Kurian on 10/28/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import "MePageVC.h"
#import "MeCell.h"
#import "FriendCell.h"
#import "ComicCommentPeopleVC.h"
#import "MeAPIManager.h"
#import "ComicsModel.h"
#import "ComicBook.h"
#import "Slides.h"
#import "MePageDetailsVC.h"
#import "DateLabel.h"
#import "Utilities.h"
#import "Constants.h"
#import "TopBarViewController.h"
#import "CameraViewController.h"
#import "ContactsViewController.h"
#import "MainPageVC.h"
#import "TopSearchVC.h"
#import "AppHelper.h"
#import "ContactController.h"
#import "UIImageView+WebCache.h"
#import "AppHelper.h"
#import "CommentModel.h"
#import "AppConstants.h"
#import "ComicPageViewController.h"
#import "FriendsAPIManager.h"

//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define arielBlackFont @"Arial-Black"

@interface MePageVC ()<commentersDelegate, UITextFieldDelegate, UITextViewDelegate> {
    int TagRecord;
    NSMutableArray *comicsArray;
    NSUInteger selectedRow;
    NSUInteger currentPageDownScroll;
    NSUInteger currentPageUpScroll;
    NSUInteger lastPageDownScroll;
    NSUInteger lastPageUpScroll;
    NSString *nowLabel;
    NSString *currentlyShowingTimelinePeriodDownScroll;
    NSString *currentlyShowingTimelinePeriodUpScroll;
    TopBarViewController *topBarView;
    ComicsModel *comicsModelObj;
    UIRefreshControl *refreshControl;
    NSMutableArray *bubbleLabels;
    IBOutlet NSLayoutConstraint *constHeaderTopY;
}
@property (weak, nonatomic) IBOutlet UIView *NameView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign, nonatomic) CATransform3D initialTransformation;

@property (weak, nonatomic) IBOutlet UIButton *NowButton;
@property (weak, nonatomic) IBOutlet UIButton *SecondButton;
@property (weak, nonatomic) IBOutlet UIButton *ThirdButton;
@property (weak, nonatomic) IBOutlet UIButton *FourthButton;
@property (weak, nonatomic) IBOutlet UIImageView *meUserPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lblComicCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFriendCount;

//dinesh
@property (weak, nonatomic) IBOutlet UILabel *mLineJoiningCentres;

@property (weak, nonatomic) IBOutlet UILabel *mNowDisplaylabel;
@property (weak, nonatomic) IBOutlet UILabel *mNowHollowlabel;

@property (weak, nonatomic) IBOutlet UILabel *mSecondDisplaylabel;
@property (weak, nonatomic) IBOutlet UILabel *mSecondHollowlabel;

@property (weak, nonatomic) IBOutlet UILabel *mThirdDisplaylabel;
@property (weak, nonatomic) IBOutlet UILabel *mThirdHollowlabel;

@property (weak, nonatomic) IBOutlet UILabel *mFourthDisplaylabel;
@property (weak, nonatomic) IBOutlet UILabel *mFourthHollowlabel;
@property (strong, nonatomic) NSMutableArray *allCellFrameHeight;

//New layout
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *comicCountVerticalBorderViewLeading;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *comicCountContainerViewLeading;
@property(weak, nonatomic) IBOutlet UIView *comicCountContainerView;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *friendCountVerticalBorderViewLeading;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *friendCountContainerViewLeading;
@property(weak, nonatomic) IBOutlet UIView *friendCountContainerView;

@property(weak, nonatomic) IBOutlet UITextField *fbTextField;
@property(weak, nonatomic) IBOutlet UITextField *igTextField;
@property(weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation MePageVC
@synthesize ComicBookDict, allCellFrameHeight;
- (void)viewDidLoad {
    
    
    UINib *meCellNib = [UINib nibWithNibName:@"MeCell" bundle:nil];
    [self.tableview registerNib:meCellNib forCellReuseIdentifier:@"Cell"];

    UINib *friendCellNib = [UINib nibWithNibName:@"FreindCellxib" bundle:nil];
    [self.tableview registerNib:friendCellNib forCellReuseIdentifier:@"Cell"];
    
    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"MePage" Attributes:nil];
    allCellFrameHeight = [[NSMutableArray alloc] init];

    [super viewDidLoad];
    [self addTopBarView];
    [self addUIRefreshControl];
    
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     self.currentButton=self.NowButton;
     [UIView beginAnimations:@"ScaleButton" context:NULL];
     [UIView setAnimationDuration: 0.5f];
     self.currentButton.transform = CGAffineTransformMakeScale(1.25,1.25);
     CGRect rect= self.currentButton.frame;
     rect.origin.x=0;
     self.currentButton.frame=rect;
     [UIView commitAnimations];
     
     
     });*/
    
    //dinesh
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.mNowHollowlabel.text = @"Now";
        self.mNowDisplaylabel.text = @"Now";

        
        //2
//        [self.mSecondHollowlabel setBackgroundColor:self.mSecondDisplaylabel.textColor];
//        [UIView beginAnimations:@"ScaleButton" context:NULL];
//        [UIView setAnimationDuration: 0];
        self.mSecondHollowlabel.transform = CGAffineTransformMakeScale(0.81,0.81);
//        [UIView commitAnimations];
//        self.mSecondHollowlabel.backgroundColor = self.mSecondHollowlabel.textColor;
        
        
        //3
//        [self.mThirdHollowlabel setBackgroundColor:self.mThirdDisplaylabel.textColor];
//        [UIView beginAnimations:@"ScaleButton" context:NULL];
//        [UIView setAnimationDuration: 0];
        self.mThirdHollowlabel.transform = CGAffineTransformMakeScale(0.81,0.81);
//        [UIView commitAnimations];
//        self.mThirdHollowlabel.backgroundColor = self.mThirdHollowlabel.textColor;
        
        
        //3
//        [self.mFourthHollowlabel setBackgroundColor:self.mFourthDisplaylabel.textColor];
//        [UIView beginAnimations:@"ScaleButton" context:NULL];
//        [UIView setAnimationDuration: 0];
        self.mFourthHollowlabel.transform = CGAffineTransformMakeScale(0.81,0.81);
//        [UIView commitAnimations];
//        self.mFourthHollowlabel.backgroundColor = self.mFourthHollowlabel.textColor;

        
        //Now
        UILabel *display2 = self.mNowDisplaylabel;
        UILabel *hollow2 = self.mNowHollowlabel;
        
        self.currentDisplayLable = display2;
        self.currentHollowLable = hollow2;

        [display2 setHidden:NO];
        [hollow2 setBackgroundColor:[UIColor blackColor]];
        
        [UIView beginAnimations:@"ScaleButton" context:NULL];
        [UIView setAnimationDuration: 0];
        hollow2.transform = CGAffineTransformMakeScale(0.81,0.81);
        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.1 animations:^{
            [display2 setAlpha:0];
        } completion:^(BOOL finished) {
            
        }];
        //--------------------------
    });
    //-----------------------------------------------------------
    
    ComicBookDict=[NSMutableDictionary new];
    TagRecord=0;
    // Do any additional setup after loading the view.
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformation = transform;
    
    currentPageDownScroll = 0;
    currentPageUpScroll = 0;
    [self callAPIToGetTheComicsWithPageNumber:currentPageDownScroll + 1  andTimelinePeriod:@"" andDirection:@"" shouldClearAllData:YES];
    
    //Set Current User Pic
    CurrentUser *user = [[AppHelper initAppHelper] getCurrentUser];
    [self.meUserPicImageView sd_setImageWithURL:[NSURL URLWithString:user.profile_pic]];
    self.lblFirstName.text = user.first_name;
    
    UIColor *color = [UIColor colorWithRed:79/255.f green:193/255.f blue:242/255.f alpha:1.f];
    _fbTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"tap to add" attributes:@{NSForegroundColorAttributeName: color}];
    _igTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"tap to add" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self setUserFieldsInUIForUser:user];
    
    //dinesh-----------------------------------------------------------
    self.mNowHollowlabel.layer.cornerRadius = self.mNowHollowlabel.bounds.size.width/2;
    self.mNowHollowlabel.backgroundColor = [UIColor blackColor];
    self.mNowHollowlabel.layer.borderWidth = 2;
    self.mNowHollowlabel.layer.borderColor = [[UIColor colorWithRed:194.0/255.0 green:118.0/255.0 blue:170.0/255.0 alpha:1.0] CGColor];
    self.mNowHollowlabel.layer.masksToBounds = YES;
    
    self.mSecondHollowlabel.layer.cornerRadius = self.mSecondHollowlabel.bounds.size.width/2;
    self.mSecondHollowlabel.backgroundColor = [UIColor blackColor];
    self.mSecondHollowlabel.layer.borderWidth = 2;
    self.mSecondHollowlabel.layer.borderColor = [[UIColor colorWithRed:86.0/255.0 green:202.0/255.0 blue:245.0/255.0 alpha:1.0] CGColor];
    self.mSecondHollowlabel.layer.masksToBounds = YES;
    
    self.mThirdHollowlabel.layer.cornerRadius = self.mThirdHollowlabel.bounds.size.width/2;
    self.mThirdHollowlabel.backgroundColor = [UIColor blackColor];
    self.mThirdHollowlabel.layer.borderWidth = 2;
    self.mThirdHollowlabel.layer.borderColor = [[UIColor colorWithRed:86.0/255.0 green:202.0/255.0 blue:245.0/255.0 alpha:1.0] CGColor];
    self.mThirdHollowlabel.layer.masksToBounds = YES;
    
    self.mFourthHollowlabel.layer.cornerRadius = self.mFourthHollowlabel.bounds.size.width/2;
    self.mFourthHollowlabel.backgroundColor = [UIColor blackColor];
    self.mFourthHollowlabel.layer.borderWidth = 2;
    self.mFourthHollowlabel.layer.borderColor = [[UIColor colorWithRed:86.0/255.0 green:202.0/255.0 blue:245.0/255.0 alpha:1.0] CGColor];
    self.mFourthHollowlabel.layer.masksToBounds = YES;
    
    self.mNowHollowlabel.clipsToBounds = YES;
    self.mSecondHollowlabel.clipsToBounds = YES;
    self.mThirdHollowlabel.clipsToBounds = YES;
    self.mFourthHollowlabel.clipsToBounds = YES;
    
    [self.mNowHollowlabel  setHidden:YES];
    [self.mSecondHollowlabel  setHidden:YES];
    [self.mThirdHollowlabel  setHidden:YES];
    [self.mFourthHollowlabel  setHidden:YES];
    [self.mNowHollowlabel setHidden:YES];
    if (IS_IPHONE_5)
    {
        self.lblFirstName.font = [UIFont fontWithName:arielBlackFont size:13.f];
        self.lblComicCount.font = [self.lblComicCount.font fontWithSize:10.f];
        self.lblFriendCount.font = [self.lblFriendCount.font fontWithSize:10.f];
        _descriptionTextView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:11.f];
    }
    else if (IS_IPHONE_6)
    {
        
        self.lblFirstName.font = [UIFont fontWithName:arielBlackFont size:14.f];
        self.lblComicCount.font = [self.lblComicCount.font fontWithSize:11.f];
        self.lblFriendCount.font = [self.lblFriendCount.font fontWithSize:11.f];
        _descriptionTextView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12.f];
    }
    else if(IS_IPHONE_6P)
    {
        self.lblFirstName.font = [UIFont fontWithName:arielBlackFont size:15.f];
        self.lblComicCount.font = [self.lblComicCount.font fontWithSize:12.f];
        self.lblFriendCount.font = [self.lblFriendCount.font fontWithSize:12.f];
        _descriptionTextView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:13.f];
    }
    
    if (IS_IPHONE_5)
    {
        self.lblFriendCount.font = [UIFont fontWithName:arielBlackFont size:10.f];
//        self.lblComicCount.font = [self.lblComicCount.font fontWithSize:13.f];
    }
    else if (IS_IPHONE_6)
    {
        
        self.lblFriendCount.font = [UIFont fontWithName:arielBlackFont size:11.f];
//        self.lblComicCount.font = [self.lblComicCount.font fontWithSize:14.f];
        
    }
    else if(IS_IPHONE_6P)
    {
        self.lblFriendCount.font = [UIFont fontWithName:arielBlackFont size:12.f];
//        self.lblComicCount.font = [self.lblComicCount.font fontWithSize:15.f];
    }

    [self setBubbleLabels];
    
    
    
    [self getLoginUserAndSetValues];
}

- (void)setUserFieldsInUIForUser:(CurrentUser *)user {
    _fbTextField.text = user.fb_id;
    _igTextField.text = user.insta_id;
    _descriptionTextView.text = user.desc;
    
    [FriendsAPIManager getUserProfileByID:user.user_id
                         withSuccessBlock:^(id object) {
                             UserSearch *user = [MTLJSONAdapter modelOfClass:[UserSearch class] fromJSONDictionary:[object valueForKey:@"data"] error:nil];
                             
                             if (user.friendCount.length != 0) {
                                 if ([user.friendCount integerValue] <= 1) {
                                     self.lblFriendCount.text = [NSString stringWithFormat:@"%ld friend", (long)[user.friendCount integerValue]];
                                 } else {
                                     self.lblFriendCount.text = [NSString stringWithFormat:@"%ld friends", (long)[user.friendCount integerValue]];
                                 }
                                 self.friendCountContainerView.hidden = NO;
                             }
                             
                         } andFail:^(NSError *errorMessage) {
                             
                         }];
}

- (void)getLoginUserAndSetValues {
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    NSString *loginID = [[AppHelper initAppHelper] getCurrentUser].login_id;
    [cmNetWorking searchById:loginID completion:^(id json,id jsonResposeHeader) {
        if (json) {
            
            //Search for current user in search results
            NSDictionary *currentuserDict;
            for (NSDictionary *userDict in [json objectForKey:@"data"]) {
                if ([[userDict valueForKey:@"login_id"] isEqualToString:loginID]) {
                    currentuserDict = userDict;
                    break;
                }
            }
            if (currentuserDict) {
                [AppHelper setCurrentUser:currentuserDict];
                [self setUserFieldsInUIForUser:[AppHelper initAppHelper].getCurrentUser];
            }
        }
    } ErrorBlock:^(JSONModelError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    
    
    
}
-(void)viewDidLayoutSubviews
{
    UIView *headerblank = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 5)];
    headerblank.backgroundColor = [UIColor clearColor];
    self.tableview.tableHeaderView = headerblank;
    self.meUserPicImageView.layer.cornerRadius = self.meUserPicImageView.bounds.size.height/2;
    self.meUserPicImageView.layer.masksToBounds = YES;
    
    
    _comicCountContainerView.layer.cornerRadius = _comicCountVerticalBorderViewLeading.constant =_comicCountContainerView.frame.size.height / 2;
    _comicCountContainerViewLeading.constant = -_comicCountContainerView.frame.size.height / 2;
    
    _friendCountContainerView.layer.cornerRadius = _friendCountVerticalBorderViewLeading.constant =_friendCountContainerView.frame.size.height / 2;
    _friendCountContainerViewLeading.constant = -_friendCountContainerView.frame.size.height / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];

  //  int height=0;

    if (comicBook.comments.count > 0)
    {
        // MeCell
        
        if (allCellFrameHeight.count == 0 || allCellFrameHeight == nil)
        {
            return [self getHeightForMeCell:indexPath];
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
                return [self getHeightForMeCell:indexPath];
            }
        }
        else
        {
            return [self getHeightForMeCell:indexPath];
        }
    }
    else
    {
        if (allCellFrameHeight.count == 0 || allCellFrameHeight == nil)
        {
            return [self getHeightForFriendCell:indexPath];
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
                return [self getHeightForFriendCell:indexPath];
            }
        }
        else
        {
            return [self getHeightForFriendCell:indexPath];
        }


//        NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
//        [slidesArray addObjectsFromArray:comicBook.slides];
//        
//        ComicPageViewController *viewPreviewScrollSlide = [[ComicPageViewController alloc] init];
//        viewPreviewScrollSlide.view.frame = CGRectMake(0, 0, 0, 0);
//        
//        viewPreviewScrollSlide.allSlideImages = slidesArray;
//        [viewPreviewScrollSlide setupBook];
//        
//        viewPreviewScrollSlide.view.backgroundColor = [UIColor blueColor];
//        
//        if ([comicBook.comicTitle isEqualToString:@""] || comicBook.comicTitle == nil)
//        {
//            return viewPreviewScrollSlide.view.bounds.size.height + 20;
//        }
//        else
//        {
//            return viewPreviewScrollSlide.view.bounds.size.height + 60 + 20;
//        }

        
    }
    
 
    //return tableView.bounds.size.height-height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if(currentPage < lastPage) {
    //        return comicsArray.count + 1;
    //    }
    return comicsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];
  
    if(comicBook.comments.count > 0)
    {
        static NSString *simpleTableIdentifier = @"Cell";
        __block MeCell* cell= (MeCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
       
        CGFloat height = [allCellFrameHeight[indexPath.row] floatValue];
        
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, height);
        
        cell=nil;
        if (cell == nil)
        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
            
            cell = (MeCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

            
            if(nil != [ComicBookDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
                [ComicBookDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            UIView *container=[cell viewWithTag:1];
           
            container.clipsToBounds = YES;

            
//            ComicBookVC*comic=[self.storyboard instantiateViewControllerWithIdentifier:@"ComicBookVC"];
//            
//            comic.delegate=self;
//            comic.Tag=(int)indexPath.row;
            
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
            
            
            ComicBookVC *comic = [self.storyboard instantiateViewControllerWithIdentifier:@"ComicBookVC"];
            
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
            
             [container layoutIfNeeded];
            
            comic.view.frame = CGRectMake(0, 0, width, CGRectGetHeight(container.frame));
            
            //  comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(container.frame), CGRectGetHeight(container.frame));
            
            //            [comic setImages: [self setupImages:indexPath]];
            
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
            [ comic.view setTranslatesAutoresizingMaskIntoConstraints:YES];
            //[self setBoundary:0 :0 toView:container addView:comic.view];
            
            [ComicBookDict setObject:comic forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            
            CGRect frame = comic.view.frame;
            frame.origin.y = 0;
            frame.size.width = width;
            
            comic.view.frame = frame;

            [container addSubview:comic.view];

            
            
//            comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(container.frame), CGRectGetHeight(container.frame));
//            
//            [container addSubview:comic.view];
//            //            [comic setImages: [self setupImages:indexPath]];
//            
//            ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];
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
//            [comic setSlidesArray:slidesArray];
//            [comic setupBook];
//            [self addChildViewController:comic];
//            [ comic.view setTranslatesAutoresizingMaskIntoConstraints:NO];
//            [self setBoundary:0 :0 toView:container addView:comic.view];
//            [ComicBookDict setObject:comic forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
//            NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
//            
//            [slidesArray addObjectsFromArray:comicBook.slides];
//            
//            [container layoutIfNeeded];
//            
//            ComicPageViewController *viewPreviewScrollSlide = [[ComicPageViewController alloc] init];
//            
//            CGFloat width = ComicWidthIPhone5;
//            
//            if (IS_IPHONE_5)
//            {
//                width = ComicWidthIPhone5;
//            }
//            else if (IS_IPHONE_6)
//            {
//                width = ComicWidthIPhone6;
//                
//            }
//            else if (IS_IPHONE_6P)
//            {
//                width = ComicWidthIPhone6plus;
//            }
//            
//            
//            viewPreviewScrollSlide.view.frame = CGRectMake(0, 0, width, CGRectGetHeight(container.frame));
//            
//            viewPreviewScrollSlide.allSlideImages = slidesArray;
//            [viewPreviewScrollSlide setupBook];
//            
//            [container addSubview:viewPreviewScrollSlide.view];
//            
//            CGRect frame = viewPreviewScrollSlide.view.frame;
//            frame.origin.y = 0;
//            //        frame.size.width = CGRectGetWidth(cell.viewComicBook.frame);
//            viewPreviewScrollSlide.view.frame = frame;

            
            
            UIView *peopleContainer=[cell viewWithTag:2];
            peopleContainer.tag = indexPath.row;
            [self performSelectorInBackground:@selector(addCommentPeople:) withObject:peopleContainer];
        }
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"Cell";
        __block FriendCell * cell= (FriendCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell = nil;
        if (cell == nil)
        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FreindCellxib" owner:self options:nil];
//            cell = [nib objectAtIndex:0];

            cell = (FriendCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            CGFloat height = [allCellFrameHeight[indexPath.row] floatValue];
            
            
              cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, height);
            
            if(nil != [ComicBookDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [ComicBookDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }
            
//            ComicBookVC *comic=[self.storyboard instantiateViewControllerWithIdentifier:@"ComicBookVC"];
//            comic.delegate=self;
//            comic.Tag=(int)indexPath.row;
            
            
            // Adnan
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
//            comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(cell.viewComicBook.frame), CGRectGetHeight(cell.viewComicBook.frame));
//            
//            [cell.viewComicBook addSubview:comic.view];
//            [self addChildViewController:comic];
//            //
            
           
            
            // To repeat the cover image again on index page as the first slide.
//      //      if(slidesArray.count > 1) {
//      //          [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
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
//            [comic setSlidesArray:slidesArray];
//            
//            [comic setupBook];
           
            [cell.viewComicBook layoutIfNeeded];
            
            cell.viewComicBook.clipsToBounds = YES;
            
            ComicBookVC *comic = [self.storyboard instantiateViewControllerWithIdentifier:@"ComicBookVC"];
            
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
            
            [cell.viewComicBook layoutIfNeeded];
            
            comic.view.frame = CGRectMake(0, 0, width, CGRectGetHeight(cell.viewComicBook.frame));
            
            //  comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(container.frame), CGRectGetHeight(container.frame));
            
            //            [comic setImages: [self setupImages:indexPath]];
            
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
           // [comic setImages: [self setupImages:indexPath]];

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
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == comicsArray.count - 1 && currentPageDownScroll < lastPageDownScroll)
    {
        // downscroll with same period
        [self callAPIToGetTheComicsWithPageNumber:currentPageDownScroll + 1  andTimelinePeriod:currentlyShowingTimelinePeriodDownScroll andDirection:DIRECTION_DOWN shouldClearAllData:NO];
    }
    else if(indexPath.row == comicsArray.count - 1 && currentPageDownScroll == lastPageDownScroll)
    {
        // downscroll with next period
        if([self getTheNextPeriod:currentlyShowingTimelinePeriodDownScroll] != nil)
        {
            currentPageDownScroll = 0;
            [self callAPIToGetTheComicsWithPageNumber:currentPageDownScroll + 1  andTimelinePeriod:[self getTheNextPeriod:currentlyShowingTimelinePeriodDownScroll] andDirection:DIRECTION_DOWN shouldClearAllData:NO];
        }
    }
    
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



- (CGFloat)getHeightForFriendCell:(NSIndexPath *)indexPath
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
        double cellHeight = comic.view.bounds.size.height  + 60 + 20 ;
        
        [allCellFrameHeight addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        
        return cellHeight;
    }
    
}


- (CGFloat)getHeightForMeCell:(NSIndexPath *)indexPath
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
        double cellHeight = comic.view.bounds.size.height + 20 + 60;
        
        [allCellFrameHeight addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        
        return cellHeight;
    }
    else
    {
        double cellHeight = comic.view.bounds.size.height  + 60 + 20 + 60;
        
        [allCellFrameHeight addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        
        return cellHeight;
    }
    
}



-(void)bookChanged:(int)Tag
{
    if(TagRecord!=Tag)
    {
        ComicBookVC*comic=(ComicBookVC*)[ComicBookDict objectForKey:[NSString stringWithFormat:@"%d",TagRecord]];
        [comic ResetBook];
    }
    TagRecord=Tag;
    
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
    constHeaderTopY.constant = heightOfNavBar;
    [topBarView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, heightOfTopBar)];
    [self addChildViewController:topBarView];
    [self.view addSubview:topBarView.view];
    [topBarView didMoveToParentViewController:self];
    topBarView.view.backgroundColor = [UIColor blackColor];
    __block typeof(self) weakSelf = self;
    topBarView.homeAction = ^(void) {
        //        currentPageDownScroll = 0;
        //        currentPageUpScroll = 0;
        //        [weakSelf callAPIToGetTheComicsWithPageNumber:currentPageDownScroll + 1  andTimelinePeriod:@"" andDirection:@"" shouldClearAllData:YES];
        
        //        MainPageVC *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:MAIN_PAGE_VIEW];
        //        [weakSelf presentViewController:contactsView animated:YES completion:nil];
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    topBarView.contactAction = ^(void) {
        //        ContactsViewController *contactsView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:CONTACTS_VIEW];
        //        [weakSelf presentViewController:contactsView animated:YES completion:nil];
        [AppHelper closeMainPageviewController:weakSelf];
    };
    topBarView.meAction = ^(void) {
        
    };
    topBarView.searchAction = ^(void) {
        TopSearchVC *topSearchView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:TOP_SEARCH_VIEW];
        [topSearchView displayContentController:weakSelf];
        //        [weakSelf presentViewController:topSearchView animated:YES completion:nil];
    };
}

- (void)addUIRefreshControl {
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [self.tableview addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(refreshTable)
             forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
    [refreshControl endRefreshing];
    if(currentPageUpScroll == 0 || currentPageUpScroll == lastPageUpScroll) {
        currentPageUpScroll = 0;
        // upscroll with previous period
        if([self getThePreviousPeriod:currentlyShowingTimelinePeriodUpScroll] != nil) {
            [self callAPIToGetTheComicsWithPageNumber:currentPageUpScroll + 1 andTimelinePeriod:[self getThePreviousPeriod:currentlyShowingTimelinePeriodUpScroll] andDirection:DIRECTION_UP shouldClearAllData:NO];
        }
    } else if(currentPageUpScroll < lastPageUpScroll) {
        // upscroll with same period
        [self callAPIToGetTheComicsWithPageNumber:currentPageUpScroll + 1 andTimelinePeriod:currentlyShowingTimelinePeriodUpScroll andDirection:DIRECTION_UP shouldClearAllData:NO];
    }
}

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
    ComicBook *comicBook = [comicsArray objectAtIndex:indexPath.row];
    [slideImagesArray addObject:comicBook.coverImage];
    
    for(Slides *slides in comicBook.slides) {
        [slideImagesArray addObject:slides.slideImage];
    }
    return slideImagesArray;
}

-(void)addCommentPeople:(UIView*)peopleContainer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ComicCommentPeopleVC*people=[self.storyboard instantiateViewControllerWithIdentifier:@"ComicCommentPeopleVC"];
        people.delegate=self;
        people.row = peopleContainer.tag;
        ComicBook *comicBook = [comicsArray objectAtIndex:peopleContainer.tag];
        people.CommentPeopleArray = comicBook.comments;
        [peopleContainer addSubview:people.view];
        [self addChildViewController:people];
        [people.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBoundary:0 :0 toView:peopleContainer addView:people.view];
    });
    
    
}

-(void)commentersPressedAtRow:(NSUInteger)row {
    selectedRow = row;
    [self performSegueWithIdentifier:@"MePageDetailsVC" sender:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y; // here you will get the offset value
    CGFloat value = offset / self.tableview.frame.size.height;
    
    if(value>0&&value<2.8)
    {
        
        self.NameView.alpha=1-value/4;
    }
}

-(void) setBoundary :(float) x :(float) y toView:(UIView*)parent addView:(UIView*)child
{
    
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:parent
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:1.0
                                                        constant:0]];
    
    // Height constraint, half of parent view height
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:parent
                                                       attribute:NSLayoutAttributeHeight
                                                      multiplier:1
                                                        constant:0]];
    
    
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                       attribute:NSLayoutAttributeLeading                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:parent
                                                       attribute:NSLayoutAttributeLeading
                                                      multiplier:1.0
                                                        constant:0]];
    
    
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:parent
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1.0
                                                        constant:0]];
    [parent layoutIfNeeded];
    
}

-(IBAction)TimeLineAction:(UIButton*)sender {
    
    if(self.currentDisplayLable == [self getDisplayabel:sender])
    {
        return;
    }
    
    if(sender.tag < bubbleLabels.count) {
        [self addTimelineButtonAnimation:sender];
        DateLabel *dateLabel = [bubbleLabels objectAtIndex:sender.tag];
        NSString *period = dateLabel.code;
        if(period.length != 0) {
            [self makeTimelinePopulateWithPeriod:period];
        }
    }
    //    if(sender.tag == 0) {
    //        [self makeTimelinePopulateWithPeriod:NOW];
    //    } else if(sender.tag == 1) {
    //        [self makeTimelinePopulateWithPeriod:ONE_WEEK];
    //    } else if(sender.tag == 2) {
    //        [self makeTimelinePopulateWithPeriod:ONE_MONTH];
    //    } else if(sender.tag == 3) {
    //        [self makeTimelinePopulateWithPeriod:THREE_MONTHS];
    //    }
}

- (void)makeTimelinePopulateWithPeriod:(NSString *)period {
    //    if([nowLabel isEqualToString:period]) {
    //        [self makeTableViewScrollToIndexPath:0];
    //    } else {
    //        if([self haveComicForThePeriod:period]) {
    //            [self makeTableViewScrollToIndexPath:[self getFirstIndexOfComicForThePeriod:period]];
    //        } else {
    currentPageUpScroll = 0;
    // call api to get comics
    [self callAPIToGetTheComicsWithPageNumber:1 andTimelinePeriod:period andDirection:DIRECTION_DOWN shouldClearAllData:YES];
    //        }
    //    }
}

- (void)makeTableViewScrollToIndexPath:(NSUInteger)index {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)addTimelineButtonAnimation:(UIButton *)sender {
    
    /*
     [UIView beginAnimations:@"ScaleButton" context:NULL];
     [UIView setAnimationDuration: 0.5f];
     self.currentButton.transform = CGAffineTransformMakeScale(1,1);
     
     CGRect rect= self.currentButton.frame;
     rect.origin.x=0;
     self.currentButton.frame=rect;
     
     [UIView commitAnimations];
     self.currentButton=sender;
     [UIView beginAnimations:@"ScaleButton" context:NULL];
     [UIView setAnimationDuration: 0.5f];
     self.currentButton.transform = CGAffineTransformMakeScale(1.25,1.25);
     
     CGRect rect1= self.currentButton.frame;
     rect1.origin.x=0;
     self.currentButton.frame=rect1;
     
     [UIView commitAnimations];s
     */
    
    //dinesh
//    UILabel *display1 = self.currentDisplayLable;
//    UILabel *hollow1 = self.currentHollowLable;
    
    
//    [UIView beginAnimations:@"ScaleButton" context:NULL];
//    [UIView setAnimationDuration: 1];
//    hollow1.transform = CGAffineTransformMakeScale(0.2,0.2);
//    [UIView commitAnimations];
//    
//    
//    [display1 setHidden:NO];
//    [display1 setAlpha:0];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            [display1 setAlpha:0.3];
//            
//        } completion:^(BOOL finished) {
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                [hollow1 setBackgroundColor:display1.textColor];
//
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.5 animations:^{
//                    [display1 setAlpha:1.0];
//                }];
//            }];
//        }];
//    }];
    
    UILabel *display2 = [self getDisplayabel:sender];
    UILabel *hollow2 = [self getHallowLabel:sender];
    
    self.currentDisplayLable=display2;
    self.currentHollowLable=hollow2;
    [display2 setHidden:NO];
    [hollow2 setBackgroundColor:[UIColor blackColor]];

//    [UIView beginAnimations:@"ScaleButton" context:NULL];
//    [UIView setAnimationDuration: 1];
    hollow2.transform = CGAffineTransformMakeScale(0.81,0.81);
//    [UIView commitAnimations];
    
//    [UIView animateWithDuration:0.1 animations:^{
        [display2 setAlpha:0];
//    } completion:^(BOOL finished) {
//        
//    }];
    //--------------------------
    
    
    // Delay execution of my block for 0.3 seconds.
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
     
     [UIView animateWithDuration:0.25 animations:^{
     //self.currentHollowLable.text = @"";
     [self.currentHollowLable setAlpha:1.0];
     } completion:^(BOOL finished) {
     
     [UIView beginAnimations:@"ScaleButton" context:NULL];
     [UIView setAnimationDuration: 0.5f];
     self.currentHollowLable.transform = CGAffineTransformMakeScale(0.2,0.2);
     [UIView commitAnimations];
     
     self.currentHollowLable=[self getHallowLabel:sender];
     self.currentDisplayLable=[self getDisplayabel:sender];
     
     self.currentHollowLable.text = [self.currentDisplayLable text];
     [self.currentDisplayLable setHidden:YES];
     
     [UIView beginAnimations:@"ScaleButton" context:NULL];
     [UIView setAnimationDuration: 0.5f];
     self.currentHollowLable.transform = CGAffineTransformMakeScale(0.81,0.81);
     [UIView commitAnimations];
     }];
     });*/
    
}

- (UILabel *)getHallowLabel: (UIButton *)sender
{
    
    if(sender.tag == 0) {
        return self.mNowHollowlabel;
    } else if(sender.tag == 1) {
        return self.mSecondHollowlabel;
    } else if(sender.tag == 2) {
        return self.mThirdHollowlabel;
    } else if(sender.tag == 3) {
        return self.mFourthHollowlabel;
    }
    
    return nil;
}

- (UILabel *)getDisplayabel: (UIButton *)sender
{
    
    if(sender.tag == 0) {
        return self.mNowDisplaylabel;
    } else if(sender.tag == 1) {
        return self.mSecondDisplaylabel;
    } else if(sender.tag == 2) {
        return self.mThirdDisplaylabel;
    } else if(sender.tag == 3) {
        return self.mFourthDisplaylabel;
    }
    
    return nil;
}

- (void)callAPIToGetTheComicsWithPageNumber:(NSUInteger)page andTimelinePeriod:(NSString *)period andDirection:(NSString *)direction shouldClearAllData:(BOOL)clearData
{
    [MeAPIManager getTimelineWithPageNumber:page
                             timelinePeriod:period
                                  direction:direction
                              currentUserId:[AppHelper getCurrentLoginId]
                               SuccessBlock:^(id object) {
                                   NSLog(@"%@", object);
                                   NSError *error;
                                   comicsModelObj = [MTLJSONAdapter modelOfClass:ComicsModel.class fromJSONDictionary:[object valueForKey:@"data"] error:&error];
                                   NSLog(@"%@", comicsModelObj);
                                   if(currentPageDownScroll == 0 && period.length == 0) {
                                       nowLabel = [self getTheDefaultPeriod:comicsModelObj];
                                       [self configureBubbleLabelsArray:comicsModelObj];
                                       comicsArray = [[NSMutableArray alloc] init];
                                       currentlyShowingTimelinePeriodDownScroll = nil;
                                       
                                       NSString *period = [self getTheDefaultPeriod:comicsModelObj];
                                       currentlyShowingTimelinePeriodUpScroll = period;
                                   }
                                   
                                   
                                   //                                   NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                                   //                                   [tempArray addObjectsFromArray:comicsModel.books];
                                   
                                   // adding the active code to each Book object so that it is possible to find the comics according to specific dates.
                                   
                                   //                                   for (ComicBook *book in tempArray) {
                                   //                                       book.periodCode = period;
                                   //                                   }
                                   
                                   // check if we have the same periodCode data, then add this response to it. If we dont have, then check the position to be added and add it.
                                   //                                   if([self haveComicForThePeriod:period]) {
                                   //                                       NSRange range;
                                   //                                       range.length = tempArray.count;
                                   //                                       range.location = [self getLastIndexOfComicForThePeriod:period] + 1;
                                   //                                       NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                                   //                                       [comicsArray insertObjects:tempArray atIndexes:indexSet];
                                   //                                   } else {
                                   //                                       if([period isEqualToString:ONE_MONTH]) {
                                   //                                           NSRange range;
                                   //                                           range.length = tempArray.count;
                                   //                                           range.location = [self getLastIndexOfComicForThePeriod:ONE_WEEK] + 1;
                                   //                                           NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                                   //                                           [comicsArray insertObjects:tempArray atIndexes:indexSet];
                                   //                                       } else {
                                   //                                           // all comics for ONE_WEEK and THREE_MONTHS
                                   //                                           [comicsArray addObjectsFromArray:tempArray];
                                   //                                       }
                                   //                                   }
                                   
                                   
                                   
                                   self.lblComicCount.text =  @"0 Comic";
                                   self.comicCountContainerView.hidden = NO;
                                   self.friendCountContainerView.hidden = NO;
                                   if(clearData)
                                   {
                                       [comicsArray removeAllObjects];
                                       lastPageDownScroll = [comicsModelObj.pagination.last integerValue];
                                       currentPageDownScroll = [comicsModelObj.pagination.current integerValue];
                                       [comicsArray addObjectsFromArray:comicsModelObj.books];
                                       
                                       NSString *period = [self getTheDefaultPeriod:comicsModelObj];
                                       currentlyShowingTimelinePeriodUpScroll = period;
                                       currentlyShowingTimelinePeriodDownScroll = period;
                                       
                                       NSInteger comicCount = [comicsArray count];
                                       if (comicCount <= 1) {
                                           self.lblComicCount.text = [NSString stringWithFormat:@"%lu Comic",(unsigned long)comicCount];
                                       } else {
                                           self.lblComicCount.text = [NSString stringWithFormat:@"%lu Comics",(unsigned long)comicCount];
                                       }
                                   } else if([direction isEqualToString:DIRECTION_UP]) {
                                       NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                                       [tempArray addObjectsFromArray:comicsModelObj.books];
                                       
                                       NSRange range;
                                       range.length = tempArray.count;
                                       range.location = 0;
                                       NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                                       [comicsArray insertObjects:tempArray atIndexes:indexSet];
                                       
                                       lastPageUpScroll = [comicsModelObj.pagination.last integerValue];
                                       currentPageUpScroll = [comicsModelObj.pagination.current integerValue];
                                       
                                       NSString *period = [self getTheDefaultPeriod:comicsModelObj];
                                       currentlyShowingTimelinePeriodUpScroll = period;
                                   } else {
                                       lastPageDownScroll = [comicsModelObj.pagination.last integerValue];
                                       currentPageDownScroll = [comicsModelObj.pagination.current integerValue];
                                       
                                       NSString *period = [self getTheDefaultPeriod:comicsModelObj];
                                       currentlyShowingTimelinePeriodDownScroll = period;
                                       
                                       [comicsArray addObjectsFromArray:comicsModelObj.books];
                                   }
                                   NSInteger comicCount = [comicsModelObj.totalCount integerValue];
                                   if (comicCount <= 1) {
                                       self.lblComicCount.text = [NSString stringWithFormat:@"%ld Comic", (long)comicCount];
                                   } else {
                                       self.lblComicCount.text = [NSString stringWithFormat:@"%ld Comics", (long)comicCount];
                                   }
                                   [self.tableview reloadData];
                                   
                                   //Dinesh
                                   /*CGSize size = [[[AppHelper initAppHelper] getCurrentUser].first_name sizeWithAttributes:
                                                  @{NSFontAttributeName:
                                                        [UIFont systemFontOfSize:17]}];
                                   
                                   NSLog(@"Size %@", NSStringFromCGSize(size));
                                   NSLog(@"labelFrame %@", NSStringFromCGRect(self.lblFirstName.frame));
                                   
                                   CGFloat lblTrialingValue = self.lblFirstName.frame.origin.x + size.width;
                                   CGFloat comicWidth = 100;
                                   CGFloat viewWidth = self.view.bounds.size.width;
                                   
                                   
                                   if(lblTrialingValue + comicWidth + 100 < viewWidth)
                                   {
                                       self.lblComicCount.frame = CGRectMake(lblTrialingValue + 25,
                                                                             self.lblFirstName.frame.origin.y,
                                                                             100,
                                                                             self.lblComicCount.frame.size.height);
                                       
                                   }
                                   else
                                   {
                                       self.lblComicCount.frame = CGRectMake(self.lblFirstName.frame.origin.x,
                                                                             self.lblFirstName.frame.origin.y + self.lblFirstName.frame.size.height + 5,
                                                                             100,
                                                                             self.lblComicCount.frame.size.height);
                                   }*/
                                   [self.lblFirstName setText:[NSString stringWithFormat:@"%@",[[AppHelper initAppHelper] getCurrentUser].first_name]];
                                   
                                   
//                                   NSMutableAttributedString *strName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", [[AppHelper initAppHelper] getCurrentUser].first_name] attributes:@{NSFontAttributeName:self.lblFirstName.font}];
//                                   
//                                   //[self.nameLabel.attributedText mutableCopy];
//                                   [strName appendAttributedString:[[NSAttributedString alloc] initWithString:@"       "]];
//                                   
//                                   NSMutableAttributedString *strName2 = [[NSMutableAttributedString alloc]initWithString:self.lblComicCount.text attributes:@{NSFontAttributeName:self.lblComicCount.font}];
//                                   
//                                   [strName appendAttributedString:strName2];
//                                   self.lblFirstName.attributedText = strName;
                                   //--------------
                                   
                               } andFail:^(NSError *errorMessage) {
                                   NSLog(@"%@", errorMessage);
                               }];
}

- (NSString *)getTheDefaultPeriod:(ComicsModel *)comicsModel {
    NSString *predStr = @"active == 1";
    NSPredicate *pred = [NSPredicate predicateWithFormat:predStr];
    NSArray *result = [comicsModel.dateLabels filteredArrayUsingPredicate:pred];
    if(result.count > 0) {
        DateLabel *dateLabel = result[0];
        return dateLabel.code;
    }
    return nil;
}

- (NSString *)getTheNextPeriod:(NSString *)currentPeriod {
    NSString *predStr = [NSString stringWithFormat:@"code == \"%@\"", currentPeriod];
    NSPredicate *pred = [NSPredicate predicateWithFormat:predStr];
    NSArray *result = [comicsModelObj.dateLabels filteredArrayUsingPredicate:pred];
    if(result.count > 0) {
        DateLabel *dateLabel = result[0];
        NSUInteger indexOfObj = [comicsModelObj.dateLabels indexOfObject:dateLabel];
        if(indexOfObj+1 < comicsModelObj.dateLabels.count) {
            DateLabel *dateLabelObj = comicsModelObj.dateLabels[indexOfObj+1];
            return dateLabelObj.code;
        }
    }
    return nil;
}

- (NSString *)getThePreviousPeriod:(NSString *)currentPeriod {
    NSString *predStr = [NSString stringWithFormat:@"code == \"%@\"", currentPeriod];
    NSPredicate *pred = [NSPredicate predicateWithFormat:predStr];
    NSArray *result = [comicsModelObj.dateLabels filteredArrayUsingPredicate:pred];
    if(result.count > 0) {
        DateLabel *dateLabel = result[0];
        NSUInteger indexOfObj = [comicsModelObj.dateLabels indexOfObject:dateLabel];
        if(indexOfObj != 0) {
            DateLabel *dateLabelObj = comicsModelObj.dateLabels[indexOfObj-1];
            return dateLabelObj.code;
        }
    }
    return nil;
}

- (NSUInteger)getFirstIndexOfComicForThePeriod:(NSString *)period {
    NSString *predStr = [NSString stringWithFormat:@"periodCode == \"%@\"", period];
    NSPredicate *pred = [NSPredicate predicateWithFormat:predStr];
    NSArray *result = [comicsArray filteredArrayUsingPredicate:pred];
    if(result.count > 0) {
        ComicBook *comicBook = result[0];
        NSLog(@"%lu", (unsigned long)[comicsArray indexOfObject:comicBook]);
        return (unsigned long)[comicsArray indexOfObject:comicBook];
    }
    return 0;
}

- (NSUInteger)getLastIndexOfComicForThePeriod:(NSString *)period {
    NSString *predStr = [NSString stringWithFormat:@"periodCode == \"%@\"", period];
    NSPredicate *pred = [NSPredicate predicateWithFormat:predStr];
    NSArray *result = [comicsArray filteredArrayUsingPredicate:pred];
    if(result.count > 0) {
        ComicBook *comicBook = [result lastObject];
        NSLog(@"%lu", (unsigned long)[comicsArray indexOfObject:comicBook]);
        return (unsigned long)[comicsArray indexOfObject:comicBook];
    }
    return 0;
}

- (BOOL)haveComicForThePeriod:(NSString *)period {
    NSString *predStr = [NSString stringWithFormat:@"periodCode == \"%@\"", period];
    NSPredicate *pred = [NSPredicate predicateWithFormat:predStr];
    NSArray *result = [comicsArray filteredArrayUsingPredicate:pred];
    if(result.count > 0) {
        return YES;
    }
    return NO;
}

- (void)setBubbleLabels {
    /*[self.FourthButton setHidden:TRUE];
     [self.ThirdButton setHidden:TRUE];
     [self.SecondButton setHidden:TRUE];
     [self.NowButton setHidden:TRUE];
     
     if(bubbleLabels.count > 3) {
     DateLabel *dateLabel = bubbleLabels[3];
     [self.FourthButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
     [self.FourthButton setTitle:[Utilities getDateStringForParam:dateLabel.code] forState:UIControlStateNormal];
     [self.FourthButton setHidden:FALSE];
     }
     if(bubbleLabels.count > 2) {
     DateLabel *dateLabel = bubbleLabels[2];
     [self.ThirdButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
     [self.ThirdButton setTitle:[Utilities getDateStringForParam:dateLabel.code] forState:UIControlStateNormal];
     [self.ThirdButton setHidden:FALSE];
     }
     if(bubbleLabels.count > 1) {
     DateLabel *dateLabel = bubbleLabels[1];
     [self.SecondButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
     [self.SecondButton setTitle:[Utilities getDateStringForParam:dateLabel.code] forState:UIControlStateNormal];
     [self.SecondButton setHidden:FALSE];
     }
     if(bubbleLabels.count > 0) {
     DateLabel *dateLabel = bubbleLabels[0];
     [self.NowButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
     [self.NowButton setTitle:[Utilities getDateStringForParam:dateLabel.code] forState:UIControlStateNormal];
     [self.NowButton setHidden:FALSE];
     }*/
    
    [self.FourthButton setHidden:TRUE];
    [self.mFourthDisplaylabel setHidden:TRUE];
    [self.mFourthHollowlabel setHidden:TRUE];
    
    [self.ThirdButton setHidden:TRUE];
    [self.mThirdDisplaylabel setHidden:TRUE];
    [self.mThirdHollowlabel setHidden:TRUE];
    
    [self.SecondButton setHidden:TRUE];
    [self.mSecondDisplaylabel setHidden:TRUE];
    [self.mSecondHollowlabel setHidden:TRUE];
    
    [self.NowButton setHidden:TRUE];
    [self.mNowDisplaylabel setHidden:TRUE];
    [self.mNowHollowlabel setHidden:TRUE];
    
    self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                self.mLineJoiningCentres.frame.origin.y,
                                                self.mLineJoiningCentres.frame.size.width,
                                                0);
    
    
    if(bubbleLabels.count > 3) {
        DateLabel *dateLabel = bubbleLabels[3];
        self.mFourthHollowlabel.text = [Utilities getDateStringForParam:dateLabel.code];
        self.mFourthDisplaylabel.text = [Utilities getDateStringForParam:dateLabel.code];
        
        [self.FourthButton setHidden:FALSE];
        [self.mFourthDisplaylabel setHidden:FALSE];
        [self.mFourthHollowlabel setHidden:FALSE];
        
        [self.ThirdButton setHidden:FALSE];
        [self.mThirdHollowlabel setHidden:FALSE];
        [self.mThirdDisplaylabel setHidden:FALSE];
        
        [self.SecondButton setHidden:FALSE];
        [self.mSecondHollowlabel setHidden:FALSE];
        [self.mSecondDisplaylabel setHidden:FALSE];
        
        [self.NowButton setHidden:FALSE];
        [self.mNowHollowlabel setHidden:FALSE];
        [self.mNowDisplaylabel setHidden:FALSE];
        
        self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                    self.mLineJoiningCentres.frame.origin.y,
                                                    self.mLineJoiningCentres.frame.size.width,
                                                    self.mFourthHollowlabel.center.y + self.mFourthHollowlabel.superview.frame.origin.y - self.mLineJoiningCentres.frame.origin.y);
    }
    if(bubbleLabels.count > 2) {
        DateLabel *dateLabel = bubbleLabels[2];
        self.mThirdHollowlabel.text = [Utilities getDateStringForParam:dateLabel.code];
        self.mThirdDisplaylabel.text = [Utilities getDateStringForParam:dateLabel.code];
        
        [self.ThirdButton setHidden:FALSE];
        [self.mThirdHollowlabel setHidden:FALSE];
        [self.mThirdDisplaylabel setHidden:FALSE];
        
        [self.SecondButton setHidden:FALSE];
        [self.mSecondHollowlabel setHidden:FALSE];
        [self.mSecondDisplaylabel setHidden:FALSE];
        
        [self.NowButton setHidden:FALSE];
        [self.mNowHollowlabel setHidden:FALSE];
        [self.mNowDisplaylabel setHidden:FALSE];
        
        self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                    self.mLineJoiningCentres.frame.origin.y,
                                                    self.mLineJoiningCentres.frame.size.width,
                                                    self.mThirdHollowlabel.center.y + self.mThirdHollowlabel.superview.frame.origin.y - self.mLineJoiningCentres.frame.origin.y);
    }
    if(bubbleLabels.count > 1) {
        DateLabel *dateLabel = bubbleLabels[1];
        self.mSecondHollowlabel.text = [Utilities getDateStringForParam:dateLabel.code];
        self.mSecondDisplaylabel.text = [Utilities getDateStringForParam:dateLabel.code];
        
        [self.SecondButton setHidden:FALSE];
        [self.mSecondHollowlabel setHidden:FALSE];
        [self.mSecondDisplaylabel setHidden:FALSE];
        
        [self.NowButton setHidden:FALSE];
        [self.mNowHollowlabel setHidden:FALSE];
        [self.mNowDisplaylabel setHidden:FALSE];
        
        self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                    self.mLineJoiningCentres.frame.origin.y,
                                                    self.mLineJoiningCentres.frame.size.width,
                                                    self.mSecondHollowlabel.center.y + self.mSecondHollowlabel.superview.frame.origin.y  - self.mLineJoiningCentres.frame.origin.y);
    }
    if(bubbleLabels.count > 0) {
        DateLabel *dateLabel = bubbleLabels[0];
        self.mNowHollowlabel.text = [Utilities getDateStringForParam:dateLabel.code];
        self.mNowDisplaylabel.text = [Utilities getDateStringForParam:dateLabel.code];
        
        [self.NowButton setHidden:FALSE];
        [self.mNowHollowlabel setHidden:FALSE];
        [self.mNowDisplaylabel setHidden:FALSE];
        
        self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                    self.mLineJoiningCentres.frame.origin.y,
                                                    self.mLineJoiningCentres.frame.size.width,
                                                    self.mNowHollowlabel.center.y + self.mNowHollowlabel.superview.frame.origin.y - self.mLineJoiningCentres.frame.origin.y);
    }
    

    if(bubbleLabels.count > 3) {
        self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                    self.mLineJoiningCentres.frame.origin.y,
                                                    self.mLineJoiningCentres.frame.size.width,
                                                    self.mFourthHollowlabel.center.y + self.mFourthHollowlabel.superview.frame.origin.y - self.mLineJoiningCentres.frame.origin.y);
    }
    else if(bubbleLabels.count > 2) {
        self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                    self.mLineJoiningCentres.frame.origin.y,
                                                    self.mLineJoiningCentres.frame.size.width,
                                                    self.mThirdHollowlabel.center.y + self.mThirdHollowlabel.superview.frame.origin.y - self.mLineJoiningCentres.frame.origin.y);
    }
    else if(bubbleLabels.count > 1) {
        self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                    self.mLineJoiningCentres.frame.origin.y,
                                                    self.mLineJoiningCentres.frame.size.width,
                                                    self.mSecondHollowlabel.center.y + self.mSecondHollowlabel.superview.frame.origin.y  - self.mLineJoiningCentres.frame.origin.y);
    }
    else if(bubbleLabels.count > 0) {
        self.mLineJoiningCentres.frame = CGRectMake(self.mLineJoiningCentres.frame.origin.x,
                                                    self.mLineJoiningCentres.frame.origin.y,
                                                    self.mLineJoiningCentres.frame.size.width,
                                                    self.mNowHollowlabel.center.y + self.mNowHollowlabel.superview.frame.origin.y - self.mLineJoiningCentres.frame.origin.y);
    }
    
    
    
    NSLog(@"line frame : %@", NSStringFromCGRect(self.mLineJoiningCentres.frame));
    
}

- (void)configureBubbleLabelsArray:(ComicsModel *)comicsModel {
    if(comicsModel.dateLabels.count > 0) {
        bubbleLabels = [[NSMutableArray alloc] init];
        if(comicsModel.dateLabels.count < 2) {
            [bubbleLabels addObject:comicsModel.dateLabels[0]];
        } else if(comicsModel.dateLabels.count < 3) {
            [bubbleLabels addObject:comicsModel.dateLabels[0]];
            
            DateLabel *dateLabel1 = comicsModel.dateLabels[0];
            DateLabel *dateLabel2 = comicsModel.dateLabels[1];
            if(![[Utilities getDateStringForParam:dateLabel1.code] isEqualToString:[Utilities getDateStringForParam:dateLabel2.code]]) {
                [bubbleLabels addObject:comicsModel.dateLabels[1]];
            }
            
            
        } else if(comicsModel.dateLabels.count <= 4) {
            [bubbleLabels addObject:comicsModel.dateLabels[0]];
            
            DateLabel *dateLabel1 = comicsModel.dateLabels[0];
            DateLabel *dateLabel2 = comicsModel.dateLabels[1];
            if(![[Utilities getDateStringForParam:dateLabel1.code] isEqualToString:[Utilities getDateStringForParam:dateLabel2.code]]) {
                [bubbleLabels addObject:comicsModel.dateLabels[1]];
            }
            
            DateLabel *dateLabel3 = comicsModel.dateLabels[1];
            DateLabel *dateLabel4 = comicsModel.dateLabels[2];
            if(![[Utilities getDateStringForParam:dateLabel3.code] isEqualToString:[Utilities getDateStringForParam:dateLabel4.code]]) {
                [bubbleLabels addObject:comicsModel.dateLabels[2]];
            }
            if(comicsModel.dateLabels.count == 4) {
                [bubbleLabels addObject:comicsModel.dateLabels[3]];
            }
        }
        [self setBubbleLabels];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"MePageDetailsVC"]) {
        MePageDetailsVC *mePageDetails = [segue destinationViewController];
        mePageDetails.comicBook = [comicsArray objectAtIndex:selectedRow];
    }
}

- (IBAction)btnContactClick:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ContactController* cVc = (ContactController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Contact"];
    mainStoryboard = nil;
    [self.navigationController pushViewController:cVc animated:YES];
    //    [self presentViewController:cVc animated:YES
    //                   completion:^{
    //                   }];
}

#pragma mark - TextField and TextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _fbTextField || textField == _igTextField) {
        [self postUserData];
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _descriptionTextView) {
        
        if ([text isEqualToString:@"\n"]) {
            [self postUserData];
            [textView resignFirstResponder];
        }
        
        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length > 50) {
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField sizeToFit];
}

-(void)postUserData {
    
    //    [self keyboardWillHide];
    //    if (isProcessing) {
    //        return;
    //    }
    //Do Validate
    //    if([self validateFileds:YES])
    //    {
    //        isProcessing = YES;
    
    [AppHelper showWarningDropDownMessage:@"Please wait !" mesage:@""];
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];

    [userDic setObject:_fbTextField.text forKey:@"fb_id"];
    [userDic setObject:_igTextField.text forKey:@"insta_id"];
    [userDic setObject:_descriptionTextView.text forKey:@"description"];
    
    [dataDic setObject:userDic forKey:@"data"];
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking updateUserInfo:dataDic Id:[AppHelper getCurrentLoginId] completion:^(id json,id jsonResposeHeader) {
        
            if ([json objectForKey:@"data"]) {
                [AppHelper setCurrentUser:[json objectForKey:@"data"]];
                [self setUserFieldsInUIForUser:[AppHelper initAppHelper].getCurrentUser];
            }
    } ErrorBlock:^(JSONModelError *error) {
        NSLog(@"Error %@",error);
        [AppHelper showSuccessDropDownMessage:ERROR_MESSAGE mesage:@""];
//        isProcessing = NO;
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
