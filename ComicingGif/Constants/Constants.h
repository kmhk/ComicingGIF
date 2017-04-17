//
//  Constants.h
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 24/12/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstants.h"

@interface Constants : NSObject

#pragma mark - URLs

//extern NSString * const BASE_URL;
extern NSString * const POST_COMMENTS_URL;
extern NSString * const GET_COMICS_URL;
extern NSString * const GET_FRIENDS_URL;
extern NSString * const GET_GROUPS_URL;
extern NSString * const GET_USER_PROFILE_URL;
extern NSString * const DIRECTION_DOWN;
extern NSString * const DIRECTION_UP;
extern NSString * const SEARCH_USER_Id;
extern NSString * const INBOXAPI;
extern NSString * const GET_GROUPS_MEMBER;
extern NSString * const GET_GROUPS_COMICS;

#pragma mark - Titles and Messages

extern NSString * const SORRY_TITLE;
extern NSString * const NO_TWITTER_ACCOUNTS_MESSAGE;
extern NSString * const SELECT_AN_ACCOUNT_MESSAGE;
extern NSString * const ACCESS_NOT_GRANTED_MESSAGE;
extern NSString * const TWITTER_STATUS_MESSAGE;

#pragma mark - Button titles

extern NSString * const OK_TITLE;
extern NSString * const CANCEL_TITLE;

#pragma mark - Twitter API

extern NSString * const TWITTER_CONSUMER_KEY;
extern NSString * const TWITTER_CONSUMER_SECRET;

#pragma mark - Storyboard Identifiers

extern NSString * const ME_VIEW_SEGUE;
extern NSString * const TOP_BAR_VIEW;
extern NSString * const CAMERA_VIEW;
extern NSString * const CONTACTS_VIEW;
extern NSString * const ME_VIEW;
extern NSString * const TOP_SEARCH_VIEW;
extern NSString * const MAIN_PAGE_VIEW;
extern NSString * const FRIEND_PAGE_VIEW;
extern NSString * const CBComicPreviewVCIdentifier;
extern NSString * const ComicMakingViewControllerIdentifier;


#pragma mark - Others

extern NSString *const NOW;
extern NSString *const ONE_WEEK;
extern NSString *const ONE_MONTH;
extern NSString *const THREE_MONTHS;

extern NSString *const CKeyName;
extern NSString *const CKeyID;
extern NSString *const CKeyImage;
extern NSString *const CKeyTime;
extern NSString *const CKeyDate;

extern NSString *const UKeyName;
//extern NSString *const UKeyID;
//extern NSString *const UKeyImage;
//extern NSString *const UKeyDetail;

extern NSString *const FRIENDSFROMSERVER;

//Storyboard's Constants

extern NSString *const kMainStoryboard;
extern NSString *const kComicMakingStoryboard;

@end
