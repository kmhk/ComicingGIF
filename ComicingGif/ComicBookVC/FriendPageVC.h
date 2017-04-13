//
//  FriendPageVC.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 03/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicBookVC.h"
#import "ComicCommentPeopleVC.h"
#import "TopBarViewController.h"
#import "Friend.h"
#import "ComicsModel.h"
#import "DateLabel.h"

@interface FriendPageVC : UIViewController <UITableViewDelegate, UITableViewDataSource,BookChangeDelegate, commentersDelegate> {
    int TagRecord;
    NSUInteger selectedRow;
    TopBarViewController *topBarView;
    NSUInteger currentPageDownScroll;
    NSUInteger currentPageUpScroll;
    NSUInteger lastPageDownScroll;
    NSUInteger lastPageUpScroll;
    NSString *nowLabel;
    NSString *currentlyShowingTimelinePeriodDownScroll;
    NSString *currentlyShowingTimelinePeriodUpScroll;
    ComicsModel *comicsModelObj;
    UIRefreshControl *refreshControl;
    NSMutableArray *comicsArray;
    NSMutableArray *bubbleLabels;
    
    IBOutlet NSLayoutConstraint *const_headerTopY;
}
@property (strong, nonatomic) IBOutlet UIButton *btn_follow;

@property(nonatomic,strong)NSMutableDictionary*ComicBookDict;
@property (weak, nonatomic) IBOutlet UIView *NameView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign, nonatomic) CATransform3D initialTransformation;
@property (assign, nonatomic) Friend *friendObj;

@property (weak, nonatomic) IBOutlet UIButton *NowButton;
@property (weak, nonatomic) IBOutlet UIButton *SecondButton;
@property (weak, nonatomic) IBOutlet UIButton *ThirdButton;
@property (weak, nonatomic) IBOutlet UIButton *FourthButton;
@property (weak, nonatomic) IBOutlet UIImageView *friendBubble;
@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalComicCountLabel;

@property(nonatomic,strong)UILabel* currentHollowLable;
@property(nonatomic,strong)UILabel* currentDisplayLable;

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

@property (weak, nonatomic) IBOutlet UILabel *lblFriendCount;
//New layout
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *comicCountVerticalBorderViewLeading;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *comicCountContainerViewLeading;
@property(weak, nonatomic) IBOutlet UIView *comicCountContainerView;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *friendCountVerticalBorderViewLeading;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *friendCountContainerViewLeading;
@property(weak, nonatomic) IBOutlet UIView *friendCountContainerView;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *followCountVerticalBorderViewTrailing;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *followCountContainerViewTrailing;
@property(weak, nonatomic) IBOutlet UIView *followCountContainerView;

@end
