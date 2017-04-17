//
//  Constants.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 24/12/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#pragma mark - URLs

//NSString * const BASE_URL = @"http://68.169.44.163/api/";
NSString * const POST_COMMENTS_URL = @"comics/";
NSString * const GET_COMICS_URL = @"comics/page/1/itemCount/8";
NSString * const GET_FRIENDS_URL = @"friends/id/";
NSString * const GET_GROUPS_URL = @"groups/userId/";
NSString * const GET_USER_PROFILE_URL = @"users/id/";
NSString * const DIRECTION_DOWN = @"down";
NSString * const DIRECTION_UP = @"up";
NSString * const SEARCH_USER_Id = @"users/loginId/";
NSString * const INBOXAPI = @"inbox/ownerId/";
NSString * const GET_GROUPS_MEMBER = @"groups/id/";
//NSString * const GET_GROUPS_COMICS = @"comics/groupId/";
NSString * const GET_GROUPS_COMICS = @"conversations/groupId/";

#pragma mark - Titles and Messages

NSString * const SORRY_TITLE = @"Sorry!";
NSString * const NO_TWITTER_ACCOUNTS_MESSAGE = @"No Twitter accounts are added on Settings.";
NSString * const SELECT_AN_ACCOUNT_MESSAGE = @"Select an account";
NSString * const ACCESS_NOT_GRANTED_MESSAGE = @"Acccess not granted.";
NSString * const TWITTER_STATUS_MESSAGE = @"Hurrayyy!!!  Find out more what your friends are doing on www.areyoucomicing.com";

#pragma mark - Button titles

NSString * const OK_TITLE = @"OK";
NSString * const CANCEL_TITLE = @"Cancel";

#pragma mark - Twitter API

NSString * const TWITTER_CONSUMER_KEY = @"RlyqaAkTyf7Ub7jX25pzeZ9Lf";
NSString * const TWITTER_CONSUMER_SECRET = @"3hD7m8MRAEMDUAGqBiR5e2hvvql0tWbXD05dMgMdgm4GliitoF";

#pragma mark - Storyboard Identifiers

NSString * const ME_VIEW_SEGUE = @"MePageViewSegue";
NSString * const TOP_BAR_VIEW = @"TopBarView";
NSString * const CAMERA_VIEW = @"CameraViewController";
NSString * const CONTACTS_VIEW = @"ContactsView";
NSString * const ME_VIEW = @"MePage";
NSString * const TOP_SEARCH_VIEW = @"TopSearchView";
NSString * const MAIN_PAGE_VIEW = @"MainPage";
NSString * const FRIEND_PAGE_VIEW = @"FriendPage";
NSString * const CBComicPreviewVCIdentifier = @"CBComicPreviewVC";
NSString * const ComicMakingViewControllerIdentifier = @"ComicMakingViewController";



#pragma mark - Others

NSString *const NOW = @"N";
NSString *const ONE_WEEK = @"1W";
NSString *const ONE_MONTH = @"1M";
NSString *const THREE_MONTHS = @"3M";

NSString *const CKeyName = @"v_comic_name";
NSString *const CKeyID = @"v_comic_id";
NSString *const CKeyImage = @"v_comic_image";
NSString *const CKeyDate = @"v_user_date";
NSString *const CKeyTime = @"v_user_time";

NSString *const UKeyName = @"v_user_name";
//NSString *const UKeyID = @"id";
//NSString *const UKeyImage = @"v_user_image";
//NSString *const UKeyDetail = @"user";

NSString *const FRIENDSFROMSERVER = @"serverFriends";

//Storyboard's Constants

NSString * const kMainStoryboard = @"Main";
NSString * const kComicMakingStoryboard = @"ComicMaking";

@end
