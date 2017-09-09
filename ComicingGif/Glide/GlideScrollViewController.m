//
//  GlideScrollViewController.m
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 23/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "GlideScrollViewController.h"
#import "ComicItem.h"
#import "ComicNetworking.h"
#import "SendPageViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "InstructionView.h"
#import "UIImage+GIF.h"
@interface GlideScrollViewController () <SlidesScrollViewDelegate,ZoomTransitionProtocol,InstructionViewDelegate>
//
//@property (weak, nonatomic) IBOutlet SlidesScrollView *scrvComicSlide;
//
//@property (nonatomic, strong) ZoomInteractiveTransition * transition;
//@property (strong, nonatomic) NSMutableArray *comicSlides;
//@property (strong, nonatomic) UIView *transitionView;
//
//@property (nonatomic) NSInteger newSlideIndex;
//@property (nonatomic) NSInteger editSlideIndex;
//@property (assign, nonatomic) BOOL isSendPageReload;
//
//@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
//@property (nonatomic,strong) ComicPage *comicPageComicItems;
//@property (nonatomic, strong) ComicMakingViewController *parentViewController;
//
@property (strong, nonatomic) NSMutableArray *dirtySubviews;
@property (strong, nonatomic) NSMutableArray *dirtysubviewData;
@property (strong, nonatomic) NSString *fileNameToSave;

@property (nonatomic) BOOL isWideSlide;

@end

@implementation GlideScrollViewController

bool isClicked = NO;
//bool isStillSaving = NO;
NSTimer* timerObject;
@synthesize scrvComicSlide,comicSlides;
@synthesize transition, transitionView;
@synthesize newSlideIndex,editSlideIndex,parentViewController;

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
//    [super viewDidLoad];
    
    // set up the filename to save based on the friend/group id.
    if(self.comicType == ReplyComic && self.replyType == FriendReply) {
        self.fileNameToSave = [NSString stringWithFormat:@"ComicSlide_F%@", self.friendOrGroupId];
    } else if(self.comicType == ReplyComic && self.replyType == GroupReply) {
        self.fileNameToSave = [NSString stringWithFormat:@"ComicSlide_G%@", self.friendOrGroupId];
    } else {
        self.fileNameToSave = @"ComicSlide";
    }
    
    [self prepareView];
    
    if (comicSlides == nil || comicSlides.count == 0) {
        [scrvComicSlide pushAddSlideTap:scrvComicSlide.btnPlusSlide animation:NO];
    }
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    if(self.isSendPageReload) {
//        if(self.comicType == ReplyComic && self.replyType == FriendReply) {
//            self.fileNameToSave = [NSString stringWithFormat:@"ComicSlide_F%@", self.friendOrGroupId];
//        } else if(self.comicType == ReplyComic && self.replyType == GroupReply) {
//            self.fileNameToSave = [NSString stringWithFormat:@"ComicSlide_G%@", self.friendOrGroupId];
//        } else {
//            self.fileNameToSave = @"ComicSlide";
//        }
//        
//        for (UIView *subView in [scrvComicSlide subviews])
//        {
//            if (![subView isKindOfClass:[UIImageView class]]) {
//                [subView removeFromSuperview];
//            }
//        }
//        
//        [self prepareView];
//        
//        if (comicSlides == nil || comicSlides.count == 0) {
//            [scrvComicSlide pushAddSlideTap:scrvComicSlide.btnAddSlide animation:NO];
//        }
//        self.isSendPageReload = NO;
//    }
////    [self setComicSendButton];
//    [super viewWillAppear:animated];
//}
- (void)viewWillAppear:(BOOL)animated
{
    if(self.isSendPageReload) {
        [self prepareView];
    }
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - UIView Methods

-(void)setComicSendButton{
    if (comicSlides && [comicSlides count] > 0)
        [self.btnSend setEnabled:YES];
    else
        [self.btnSend setEnabled:NO];
}

- (void)prepareView
{
    
    scrvComicSlide.slidesScrollViewDelegate = self;
    
    transition = [[ZoomInteractiveTransition alloc] initWithNavigationController:self.navigationController];
    transition.handleEdgePanBackGesture = NO;
    
    transition.transitionDuration = 0.4;
    
    comicSlides = [self getDataFromFile];
    
    if (comicSlides.count == 0)
    {
        comicSlides = [[NSMutableArray alloc] init];
        [scrvComicSlide addPlusButton:0];
        [self refreshListPreview];
    }
    else
    {
        int count = 0;
        for (NSData *data in comicSlides)
        {
            ComicPage *comicPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [scrvComicSlide addViewAtIndex:count withComicSlide:comicPage];
            comicPage = nil;
            count++;
        }
        [scrvComicSlide addPlusButton:count];
        [self refreshListPreview];
        if (comicSlides.count == SLIDE_MAXCOUNT && scrvComicSlide.btnPlusSlide) {
            [scrvComicSlide.btnPlusSlide setHidden:YES];
            [scrvComicSlide.btnPlusSlide removeFromSuperview];
            [scrvComicSlide.btnWidePlusSlide removeFromSuperview];
            
            [scrvComicSlide setScrollViewContectSizeByLastIndex:count-1];
        }
        
    }
    [scrvComicSlide addTimeLineView];
}

-(void)refreshListPreview{
    int count = 0;
    for (NSData *data in comicSlides)
    {
        ComicPage *comicPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (comicPage.printScreenPath) {
            if (scrvComicSlide.listViewImages == nil) {
                scrvComicSlide.listViewImages = [[NSMutableArray alloc] init];
            }
            UIImage* imgPrintScreen = [scrvComicSlide getImageFile:comicPage.printScreenPath];
            if (imgPrintScreen != nil) {
                [scrvComicSlide.listViewImages addObject:imgPrintScreen];
            }
        }
        comicPage = nil;
        count++;
    }
    [scrvComicSlide refreshPreview:count withImages:scrvComicSlide.listViewImages];
}

#pragma mark - SlidesScrollViewDelegate Methods

-(void) tryToOpenComicMaking: (NSTimer *)theTimer {
    
    if (self.scrvComicSlide.isStillSaving == NO) {
        
        NSDictionary*  dicValue = [theTimer userInfo];
        
        editSlideIndex = [[dicValue objectForKey:@"SelectAtIndex"] intValue] ;
        newSlideIndex = (long)[[dicValue objectForKey:@"SelectAtIndex"] intValue];
        
        NSData *data = comicSlides[editSlideIndex];
        
        [timerObject invalidate];
        [self openComicMakingViewController:data];
    }
}

-(void)openComicMakingViewController:(NSData*)data{
    self.comicPageComicItems = nil;
    
    self.comicPageComicItems = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    ComicMakingViewController *cmv = [self.storyboard instantiateViewControllerWithIdentifier:@"ComicMakingViewController"];
    
//    cmv.comicPage = self.comicPageComicItems;
//    
//    [cmv setDelegate:self];
//    cmv.isNewSlide = NO;
    
    self.dirtysubviewData = self.comicPageComicItems.subviewData;
    self.dirtySubviews = self.comicPageComicItems.subviews;
    isClicked = NO;
//    self.comicPageComicItems.subviews = nil;
//    self.comicPageComicItems.subviewData = nil;
//    self.dirtysubviewData = nil;
//    self.dirtySubviews = nil;
    
    [self.navigationController pushViewController:cmv animated:YES];
}
- (void)slidesScrollView:(SlidesScrollView *)scrollview didSelectAtIndexPath:(NSInteger)index withView:(UIView *)view
{
    if (self.scrvComicSlide.isStillSaving)
        return;

    transitionView = view;
    comicSlides = [self getDataFromFile];
//    if (comicSlides == nil ||
//        [comicSlides count] == 0) {
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            NSData *data = comicSlides[index];
//            [self openComicMakingViewController:data];
//        });
//        
//    }else{
//        NSData *data = comicSlides[index];
//        [self openComicMakingViewController:data];
//    }
    
//    NSLog(@"****** Open Slide ******");
    
//    if (isStillSaving) {
//        timerObject = [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                                       target:self
//                                                     selector:@selector(tryToOpenComicMaking:)
//                                                     userInfo:@{@"SelectAtIndex":[NSString stringWithFormat: @"%ld", (long)index] }
//                                                      repeats:YES];
//    }else{
        editSlideIndex = index;
        newSlideIndex = (long)index;
        NSData *data = comicSlides[index];
        [self openComicMakingViewController:data];
//    }
}

- (void)slidesScrollView:(SlidesScrollView *)scrollview didSelectAddButtonAtIndex:(NSInteger)index withView:(UIView *)view
{
    [self slidesScrollView:scrollview didSelectAddButtonAtIndex:index withView:view pusWithAnimation:YES];
}


- (void)slidesScrollView:(SlidesScrollView *)scrollview didSelectAddButtonAtIndex:(NSInteger)index withView:(UIView *)view withType:(AddButtonType)type
{
    if (type == AddButtonTypeWide)
    {
        self.isWideSlide = YES;
    }
    else
    {
        self.isWideSlide = NO;

    }
     [self slidesScrollView:scrollview didSelectAddButtonAtIndex:index withView:view pusWithAnimation:YES];
    
}

- (void)slidesScrollView:(SlidesScrollView *)scrollview didSelectAddButtonAtIndex:(NSInteger)index withView:(UIView *)view pusWithAnimation:(BOOL)isPushAnimation
{
    if (self.scrvComicSlide.isStillSaving)
        return;
    
    self.comicPageComicItems = nil;
    self.dirtysubviewData = nil;
    self.dirtySubviews = nil;
    
    // add new slide
    transitionView = view;
    newSlideIndex = index;
    editSlideIndex = index;
    
    [scrvComicSlide addViewAtIndex:newSlideIndex withComicSlide:nil];
    
    ComicMakingViewController *cmv = [self.storyboard instantiateViewControllerWithIdentifier:@"ComicMakingViewController"];
    
//    if (self.isWideSlide == YES)
//    {
//        cmv.isWideSlide = YES;
//    }
//    else
//    {
//        cmv.isWideSlide = NO;
//        
//    }
//    
//    cmv.isNewSlide = YES;
//    
//    cmv.comicType = self.comicType;
//    cmv.replyType = self.replyType;
//    cmv.friendOrGroupId = self.friendOrGroupId;
//    cmv.shareId = self.shareId;
//    
//    [cmv setDelegate:self];
    if (self.navigationController == nil) {
        
        self.navigation = [[UINavigationController alloc]initWithRootViewController:self];
        [self.navigation.navigationBar setHidden:YES];
        
//        [AppDelegate application].window.rootViewController = self.navigation;
        
        [self.navigation pushViewController:cmv animated:isPushAnimation];
    }else{
    //[self.navigationController pushViewController:cmv animated:isPushAnimation];
        [self.navigationController pushViewController:cmv animated:YES];
    }
}

- (void)slidesScrollView:(SlidesScrollView *)scrollview didRemovedAtIndexPath:(NSInteger)index
{
    if (index >= 0 && [comicSlides count] > 0) {
        [comicSlides removeObjectAtIndex:index];
        [self saveDataToFile:comicSlides];
    }
    [self setComicSendButton];
}

- (void)returnAddedView:(UIView *)view
{
    transitionView = view;
}

- (void)saveSlideTitle:(NSString*)strValue slideIndex:(NSInteger)slideIndex
{
    if (comicSlides.count > slideIndex)
    {
        ComicPage *comicPage = [NSKeyedUnarchiver unarchiveObjectWithData:[comicSlides objectAtIndex:slideIndex]];
        comicPage.titleString = strValue;
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:comicPage];
        comicSlides[slideIndex] = data;
        
        [self saveDataToFile:comicSlides];
    }
}
- (void)updateListView:(NSArray*)listArray
{
    
}

//- (void)setPreviewForSlidesAtIndex:(CGRect)frameValue withImages:(NSArray *)slides completion:(void (^)(CGRect previewFrame))completion
//{
//    viewPreviewScrollSlide = [[SlidePreviewScrollView alloc] init];
//    viewPreviewScrollSlide.view.frame = frameValue;
//    viewPreviewScrollSlide.allSlideImages = slides;
//
//    [viewPreviewScrollSlide setupBook];
////    viewPreviewScrollSlide.delegate = self;
//
////    [viewPreviewScrollSlide setPreviewForSlidesAtIndex:index withImages:slides];
//
//    [self addChildViewController:viewPreviewScrollSlide];
//
//    completion
//    [self setScrollViewContectSize];
//}


#pragma mark - ZoomTransitionProtocol

- (UIView *)viewForZoomTransition:(BOOL)isSource
{
    return transitionView;
}

#pragma mark Button Events

- (IBAction)btnComicSendButtonClick:(id)sender {
    [self sendComic];
}

-(NSMutableDictionary*)createSendParams :(NSMutableArray*)slideArray{
    
    if (slideArray == nil && [slideArray count] > 0)
        return nil;

    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* comicMakeDic = [[NSMutableDictionary alloc] init];
    
    [comicMakeDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"]; // Hardcoded now
    [comicMakeDic setObject:@"" forKey:@"comic_title"];
    
    if(self.comicType == ReplyComic)
    {
        [comicMakeDic setObject:@"CS" forKey:@"comic_type"];
        [comicMakeDic setObject:self.shareId forKey:@"share_id"];
    }
    else
    {
        [comicMakeDic setObject:@"CM" forKey:@"comic_type"]; // COMIC MAKING yes it is hardcoded now
    }
    
    
    [comicMakeDic setObject:@"0" forKey:@"conversation_id"]; //it is hardcoded now
    [comicMakeDic setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[comicSlides count]]
                     forKey:@"slide_count"];
    
    [comicMakeDic setObject:@"1" forKey:@"status"];
//    [comicMakeDic setObject:@"1" forKey:@"is_public"];
    
    //Slide Array
    NSMutableArray* slides = [[NSMutableArray alloc] init];
    
    for (int i=0; i< [comicSlides count]; i++)
    {
//    for (NSData* data in comicSlides) {
        NSData* data = [comicSlides objectAtIndex:i];
        ComicPage* cmPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (i == 0 && cmPage.titleString && cmPage.titleString.length >0) {
            [comicMakeDic setObject:cmPage.titleString forKey:@"comic_title"];
        }
        
        //Comic Slide image url obj
        NSDictionary* urlSlides = [slideArray objectAtIndex:i];
        
        //ComicSlides Object
        NSMutableDictionary* cmSlide = [[NSMutableDictionary alloc] init];
        [cmSlide setObject:[urlSlides valueForKeyPath:@"url.slide_image"] forKey:@"slide_image"];
        [cmSlide setObject:[urlSlides valueForKeyPath:@"url.slide_thumb"] forKey:@"slide_thumb"];
        [cmSlide setObject:@"" forKey:@"slide_text"];
        [cmSlide setObject:kURLKey forKey:@"slide_image_type"];
        
        NSMutableArray* enhancements = [[NSMutableArray alloc] init];
        //Check is AUD is avalilabe
        
        for (int i = 0; i < cmPage.subviews.count; i ++)
        {
            id imageView = cmPage.subviews[i];
            CGRect myRect = [cmPage.subviewData[i] CGRectValue];
            //Check is ComicItemBubble
            if([imageView isKindOfClass:[ComicItemBubble class]])
            {
                if ([((ComicItemBubble*)imageView) isPlayVoice]) {
                    //Yes there is a Audio
                    //ComicSlides Object
                    NSMutableDictionary* cmEng = [[NSMutableDictionary alloc] init];
                    [cmEng setObject:@"AUD" forKey:@"enhancement_type"];
                    [cmEng setObject:@"1" forKey:@"enhancement_type_id"];
                    [cmEng setObject:@"1" forKey:@"is_custom"];
                    [cmEng setObject:@"" forKey:@"enhancement_text"];
                    NSData* audioData = [[NSData alloc] initWithContentsOfFile:((ComicItemBubble*)imageView).recorderFilePath];
                    [cmEng setObject:[audioData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
                              forKey:@"enhancement_file"];
                    [cmEng setObject:@"mp3" forKey:@"enhancement_file_type"];
                    
                    CGFloat midPointX = myRect.origin.x + (myRect.size.width/2);
                    CGFloat midPointY = myRect.origin.y + (myRect.size.height/2);
                    
                    [cmEng setObject:[NSString stringWithFormat:@"%f",midPointY] forKey:@"position_top"];
                    [cmEng setObject:[NSString stringWithFormat:@"%f",midPointX] forKey:@"position_left"];
                    [cmEng setObject:[NSString stringWithFormat:@"%f",myRect.size.width] forKey:@"width"];
                    [cmEng setObject:[NSString stringWithFormat:@"%f",myRect.size.height] forKey:@"height"];
                    [cmEng setObject:@"1" forKey:@"z_index"];
                    
                    [enhancements addObject:cmEng];
                }
            }
            if([imageView isKindOfClass:[ComicItemAnimatedSticker class]])
            {
                NSMutableDictionary* cmEng = [[NSMutableDictionary alloc] init];
                [cmEng setObject:@"GIF" forKey:@"enhancement_type"];
                [cmEng setObject:@"1" forKey:@"enhancement_type_id"];
                [cmEng setObject:@"1" forKey:@"is_custom"];
                [cmEng setObject:@"" forKey:@"enhancement_text"];
                
                if (((ComicItemAnimatedSticker*)imageView).combineAnimationFileName) {
                    //it had image,
                    NSString *animationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    animationPath = [[animationPath stringByAppendingPathComponent:((ComicItemAnimatedSticker*)imageView).combineAnimationFileName] stringByAppendingString:@".gif"];
                    
                    NSData *gifData = [NSData dataWithContentsOfFile:animationPath];
                    
                    [cmEng setObject:[gifData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
                              forKey:@"enhancement_file"];
                    [cmEng setObject:@"gif" forKey:@"enhancement_file_type"];
                    
                }
                
                CGFloat midPointX = myRect.origin.x;
                CGFloat midPointY = myRect.origin.y;
                
                [cmEng setObject:[NSString stringWithFormat:@"%f",midPointY] forKey:@"position_top"];
                [cmEng setObject:[NSString stringWithFormat:@"%f",midPointX] forKey:@"position_left"];
                [cmEng setObject:[NSString stringWithFormat:@"%.02f",myRect.size.width] forKey:@"width"];
                [cmEng setObject:[NSString stringWithFormat:@"%.02f",myRect.size.height] forKey:@"height"];
                [cmEng setObject:@"1" forKey:@"z_index"];
                
                [enhancements addObject:cmEng];
                //                }
            }
            if (enhancements && [enhancements count] > 0) {
                [cmSlide setObject:enhancements forKey:@"enhancements"];
            }
        }
        
        if ([cmPage.slideType isEqualToString:slideTypeWide])
        {
            [cmSlide setObject:@"1" forKey:@"slide_type"];
            
        }
        else
        {
            [cmSlide setObject:@"0" forKey:@"slide_type"];
            
        }
        
        [slides addObject:cmSlide];
        cmPage = nil;
        cmSlide = nil;
    }
    [comicMakeDic setObject:slides forKey:@"slides"];
    [dataDic setObject:comicMakeDic forKey:@"data"];
    
    
    return dataDic;
}

-(NSMutableDictionary*)setPutParamets :(NSString*)shareUserId ReplyTypeValue:(ReplyType)type ComicShareId:(NSString*)comic_id{
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* userDic = [[NSMutableDictionary alloc] init];
    [userDic setObject:comic_id forKey:@"comic_id"];
    [userDic setObject:[AppHelper getCurrentLoginId] forKey:@"user_id"];
    NSMutableArray* arrayObj = [[NSMutableArray alloc] init];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(type == FriendReply){
        [dict setValue:shareUserId forKey:@"friend_id"];
        [dict setValue:@"1" forKey:@"status"];
        
        [arrayObj addObject:dict];
        [userDic setObject:arrayObj forKey:@"friendShares"];
        
        arrayObj = nil;
        dict = nil;
    }
    else if(type == GroupReply){
        
        [dict setValue:shareUserId forKey:@"group_id"];
        [dict setValue:@"1" forKey:@"status"];
        
        [arrayObj addObject:dict];
        
        
        [userDic setObject:arrayObj forKey:@"groupShares"];
        
        arrayObj = nil;
        dict = nil;
    }
    
    [dataDic setObject:userDic forKey:@"data"];
    return dataDic;
}

-(void)sendComic {
    
    //Desable the image view intactin
    [self.view setUserInteractionEnabled:NO];
    
    NSMutableArray* paramArray = [[NSMutableArray alloc] init];
    
    for (NSData* data in comicSlides) {
        
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
        ComicPage* cmPage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSData *imageData = UIImagePNGRepresentation([AppHelper getImageFile:cmPage.printScreenPath]);//UIImageJPEGRepresentation([AppHelper getImageFile:cmPage.printScreenPath], 1);
        
        [dataDic setObject:imageData forKey:@"SlideImage"];
        
        NSData* slideTypeData = [@"slideImage" dataUsingEncoding:NSUTF8StringEncoding];
        
        [dataDic setObject:slideTypeData forKey:@"SlideImageType"];
        
        [paramArray addObject:dataDic];
    }
    
    NSLog(@"Start uploading");
    if(self.replyType == FriendReply) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartFriendReplyComicAnimation" object:nil];
    } else if(self.replyType == GroupReply) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartGroupReplyComicAnimation" object:nil];
    }
    
    ComicNetworking* cmNetWorking = [ComicNetworking sharedComicNetworking];
    [cmNetWorking UploadComicImage:paramArray completeBlock:^(id json, id jsonResponse) {
        
        NSLog(@"Finish Uploading");
        NSLog(@"Start Comic Creation");
        [cmNetWorking postComicCreation:[self createSendParams:[json objectForKey:@"slides"]]
                                     Id:nil
                             completion:^(id json,id jsonResposeHeader) {
                                 [AppHelper setCurrentcomicId:[json objectForKey:@"data"]];
                                 
                                 //Desable the image view intactin
                                 [self.view setUserInteractionEnabled:YES];
                                 
                                 if(self.comicType != ReplyComic) {
                                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                     SendPageViewController *controller = (SendPageViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"SendPage"];
                                     controller.comicSlideFileName = self.fileNameToSave;
                                     
                                     [self.navigationController pushViewController:controller animated:YES];
                                 } else {
                                     [cmNetWorking shareComicImage:[self setPutParamets:self.friendOrGroupId
                                                                         ReplyTypeValue:self.replyType
                                                                           ComicShareId:[json objectForKey:@"data"]]
                                                                Id:[json objectForKey:@"data"] completion:^(id json, id jsonResponse) {
                                                                    
                                                                    if (json) {
                                                                        if(self.replyType == FriendReply) {
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFriendComics" object:nil];
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopFriendReplyComicAnimation" object:nil];
                                                                            [self dismissViewControllerAnimated:YES completion:^{}];
                                                                        } else if(self.replyType == GroupReply) {
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupComics" object:nil];
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopGroupReplyComicAnimation" object:nil];
                                                                            [self dismissViewControllerAnimated:YES completion:^{}];
                                                                        }
                                                                        if (self.fileNameToSave) {
                                                                            [AppHelper deleteSlideFile:self.fileNameToSave];
                                                                        }
                                                                    }else{
                                                                        [AppHelper showErrorDropDownMessage:@"something went wrong !" mesage:@""];
                                                                    }
                                                                    
                                                                } ErrorBlock:^(JSONModelError *error) {
                                                                    
                                                                }];
                                 }
                             } ErrorBlock:^(JSONModelError *error) {
                                 NSLog(@"completion %@",error);
                                 //Desable the image view intactin
                                 [self.view setUserInteractionEnabled:YES];
                                 if(self.replyType == FriendReply) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopFriendReplyComicAnimation" object:nil];
                                     [self dismissViewControllerAnimated:YES completion:^{}];
                                 } else if(self.replyType == GroupReply) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"StopGroupReplyComicAnimation" object:nil];
                                     [self dismissViewControllerAnimated:YES completion:^{}];
                                 }
                             }];
        
    } ErrorBlock:^(JSONModelError *error) {
        [self.view setUserInteractionEnabled:YES];
        if(self.replyType == FriendReply) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopFriendReplyComicAnimation" object:nil];
            [self dismissViewControllerAnimated:YES completion:^{}];
        } else if(self.replyType == GroupReply) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopGroupReplyComicAnimation" object:nil];
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    }];
    
}

#pragma mark - ComicMakingViewControllerDelegate

- (void)comicMakingItemRemoveAll:(ComicPage *)comicPage removeAll:(BOOL)isRemoveAll{
   
    if (self.comicPageComicItems != nil) {
        //Remove subviews
        [self.comicPageComicItems.subviews removeAllObjects];
        [self.comicPageComicItems.subviewData removeAllObjects];
    }
    
}
- (void)comicMakingItemSave:(ComicPage *)comicPage
              withImageView:(id)comicItemData
            withPrintScreen:(UIImage *)printScreen
                 withRemove:(BOOL)remove
              withImageView:(UIImageView *)imageView
{
    
    if (self.comicPageComicItems == nil) {
        self.comicPageComicItems = [[ComicPage alloc] init];
    }
    if (imageView == nil)
        return;
    
    dispatch_queue_t autoSaveCurrentDrawQueue  = dispatch_queue_create("comicItem_AutoSave", NULL);
    dispatch_async( autoSaveCurrentDrawQueue ,
                   ^ {
                       @try {
                           self.dirtysubviewData = nil;
                           self.dirtySubviews = nil;
                           
                           //Removing existign data
                           if (self.comicPageComicItems.subviews == nil) {
                               self.comicPageComicItems.subviews = [[NSMutableArray alloc] init];
                           }
                           if (self.comicPageComicItems.subviewData == nil) {
                               self.comicPageComicItems.subviewData = [[NSMutableArray alloc] init];
                           }
                           if (self.comicPageComicItems.subviewTranformData == nil) {
                               self.comicPageComicItems.subviewTranformData = [[NSMutableArray alloc] init];
                           }
                           
                           if (remove) {
                               if ([self.comicPageComicItems.subviews containsObject:comicItemData]) {
                                   
                                   NSInteger anIndex = [self.comicPageComicItems.subviews indexOfObject:comicItemData];
                                   if (anIndex >= 0 && [self.comicPageComicItems.subviewData count] > anIndex) {
                                       [self.comicPageComicItems.subviewData removeObjectAtIndex:anIndex];
                                   }
                                   if (anIndex >= 0 && [self.comicPageComicItems.subviewTranformData count] > anIndex) {
                                       [self.comicPageComicItems.subviewTranformData removeObjectAtIndex:anIndex];
                                   }
                                   [self.comicPageComicItems.subviews removeObject:comicItemData];
                               }
                           }else{
                               
                               if ([self.comicPageComicItems.subviews containsObject:comicItemData]) {
                                   
                                   NSInteger anIndex = [self.comicPageComicItems.subviews indexOfObject:comicItemData];
                                   if (anIndex >= 0 && [self.comicPageComicItems.subviewData count] > anIndex) {
                                       [self.comicPageComicItems.subviewData removeObjectAtIndex:anIndex];
                                   }
                                   if (anIndex >= 0 && [self.comicPageComicItems.subviewTranformData count] > anIndex) {
                                       [self.comicPageComicItems.subviewTranformData removeObjectAtIndex:anIndex];
                                   }
                                   
                                   [self.comicPageComicItems.subviews removeObject:comicItemData];
                               }
                               
                               [self.comicPageComicItems.subviews addObject:comicItemData];
                               [self.comicPageComicItems.subviewData addObject:[NSValue valueWithCGRect:((UIView*)comicItemData).frame]];
                               [self.comicPageComicItems.subviewTranformData addObject:[NSValue valueWithCGAffineTransform:((UIView*)comicItemData).transform]];
                               
                               self.dirtysubviewData  =  self.comicPageComicItems.subviewData;
                               self.dirtySubviews = self.comicPageComicItems.subviews;
                               
                               [self setComicSendButton];
                           }
                           
                           self.comicPageComicItems.containerImagePath =  [self SaveImageFile:UIImagePNGRepresentation(imageView.image)/*UIImageJPEGRepresentation(imageView.image,1)*/ type:@"png"];
                           self.comicPageComicItems.printScreenPath = [self SaveImageFile:UIImagePNGRepresentation(printScreen)/*UIImageJPEGRepresentation(printScreen, 1) */type:@"png"];
                           
                           NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.comicPageComicItems];
                           
                           
                           if ([comicSlides count ] > editSlideIndex) {
                               [comicSlides replaceObjectAtIndex:editSlideIndex withObject:data];
                               [self saveDataToFile:comicSlides];
                           }else{
                               [comicSlides addObject:data];
                               [self saveDataToFile:comicSlides];
                           }
                       }
                       @catch (NSException *exception) {
                       }
                       @finally {
                       }
                   });
    
}


- (void)comicMakingViewControllerWithEditingDone:(ComicMakingViewController *)controll
                                   withImageView:(UIImageView *)imageView
                                 withPrintScreen:(UIImage *)printScreen
                                    withNewSlide:(BOOL)newslide withPopView:(BOOL)isPopView withIsWideSlide:(BOOL)isWideSlide
{
    if (isPopView)
    {
        [self.navigationController popViewControllerAnimated:YES];
      
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Do background work
            @try {
                
                self.scrvComicSlide.isStillSaving = YES;
                @autoreleasepool {
//                    self.comicPageComicItems = nil;
                    if (self.comicPageComicItems == nil)
                    {
                        self.comicPageComicItems = [[ComicPage alloc] init];
                        
                        self.comicPageComicItems.subviewData = self.dirtysubviewData;
                        self.comicPageComicItems.subviews = self.dirtySubviews;
                    }
                    
                    self.comicPageComicItems.containerImagePath =  [self SaveImageFile:UIImagePNGRepresentation(imageView.image) type:@"png"];
                    self.comicPageComicItems.printScreenPath = [self SaveImageFile:UIImagePNGRepresentation(printScreen) type:@"png"];
                    
                    //Add time line
                    NSDate *now = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"h.mm a";
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    self.comicPageComicItems.timelineString = [dateFormatter stringFromDate:now];
                    dateFormatter = nil;
                    
                    if (isWideSlide)
                    {
                        self.comicPageComicItems.slideType = slideTypeWide;
                    }
                    else
                    {
                        self.comicPageComicItems.slideType = slideTypeTall;
                    }

                    
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.comicPageComicItems];
                    if (newslide)
                    {
                        [comicSlides addObject:data];
                        [self saveDataToFile:comicSlides];
                    }
                    else
                    {
                        [comicSlides replaceObjectAtIndex:editSlideIndex withObject:data];
                        [self saveDataToFile:comicSlides];
                    }
                    self.scrvComicSlide.isStillSaving = NO;
                    data = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setComicSendButton];
                        
                        [scrvComicSlide reloadComicImageAtIndex:newSlideIndex withComicSlide:printScreen withComicSlide:comicSlides];
                        
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserEnterSecondTimeGlideViewController] == YES)
                        {
                            
                            
                            // below code for slide 16
                            if ([InstructionView getBoolValueForSlide:kInstructionSlide16] == YES)
                            {
                                // open "delete a comic" Instruction
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    NSLog(@"Do some work");
                                    
                                    if ([InstructionView getBoolValueForSlide:kInstructionSlideE] == NO)
                                    {
                                        InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                                        instView.delegate = self;
                                        [instView showInstructionWithSlideNumber:SlideNumberE withType:InstructionGIFType];
                                        [instView setTrueForSlide:kInstructionSlideE];
                                        
                                        [self.view addSubview:instView];
                                    }
                                });
                            }
                        }
                        // second time gif animation
                        
                        
                        if ([InstructionView getBoolValueForSlide:kInstructionSlide14] == YES)
                        {
                            // "send it to friends" slide16
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                NSLog(@"Do some work");
                                
                                if ([InstructionView getBoolValueForSlide:kInstructionSlide16] == NO)
                                {
                                    InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                                    instView.delegate = self;
                                    [instView showInstructionWithSlideNumber:SlideNumber16 withType:InstructionBubbleType];
                                    [instView setTrueForSlide:kInstructionSlide16];
                                    
                                    [self.view addSubview:instView];
                                }
                            });
                        }
                        
                        
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserEnterFirstTimeGlideViewController] == YES)
                        {
                            // second time
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserEnterSecondTimeGlideViewController];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        
                        // first time 
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserEnterFirstTimeGlideViewController];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        // open Instruction
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            NSLog(@"Do some work");
                            
                            if ([InstructionView getBoolValueForSlide:kInstructionSlide13] == NO)
                            {
                            InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
                            instView.delegate = self;
                            [instView showInstructionWithSlideNumber:SlideNumber13 withType:InstructionGIFType];
                            [instView setTrueForSlide:kInstructionSlide13];
                            
                            [self.view addSubview:instView];
                             }
                        });

                        
                    });
                }
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
        });
    }
    else
    {
        //Doing main thread
        [scrvComicSlide reloadComicImageAtIndex:newSlideIndex withComicSlide:printScreen withComicSlide:comicSlides];
        @try {
            self.scrvComicSlide.isStillSaving = YES;
            @autoreleasepool {
                if (self.comicPageComicItems == nil) {
                    self.comicPageComicItems = [[ComicPage alloc] init];
                    
                    self.comicPageComicItems.subviewData = self.dirtysubviewData;
                    self.comicPageComicItems.subviews = self.dirtySubviews;
                }
                
                self.comicPageComicItems.containerImagePath =  [self SaveImageFile:UIImagePNGRepresentation(imageView.image)/*UIImageJPEGRepresentation(imageView.image,1)*/ type:@"png"];
                self.comicPageComicItems.printScreenPath = [self SaveImageFile:UIImagePNGRepresentation(printScreen)/*UIImageJPEGRepresentation(printScreen, 1)*/ type:@"png"];
                
                //Add time line
                NSDate *now = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"h.mm a";
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                self.comicPageComicItems.timelineString = [dateFormatter stringFromDate:now];
                dateFormatter = nil;
                
                if (isWideSlide)
                {
                    self.comicPageComicItems.slideType = slideTypeWide;
                }
                else
                {
                    self.comicPageComicItems.slideType = slideTypeTall;
                }
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.comicPageComicItems];
                
                if (newslide)
                {
                    [comicSlides addObject:data];
                    [self saveDataToFile:comicSlides];
                }
                else
                {
                    [comicSlides replaceObjectAtIndex:editSlideIndex withObject:data];
                    [self saveDataToFile:comicSlides];
                }
                
//                NSLog(@"************* editSlideIndex ***************");
//                ComicPage * sample = [NSKeyedUnarchiver unarchiveObjectWithData:comicSlides[editSlideIndex]];
//                NSLog(@"%@",sample.subviews);
//                NSLog(@"************* editSlideIndex ***************");
                
                self.scrvComicSlide.isStillSaving = NO;
                self.comicPageComicItems = nil;
                data = nil;
//                self.isSendPageReload = YES;
                [self setComicSendButton];
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

#pragma mark DB Methods

-(void)saveDataToFile:(NSMutableArray*)slideObj
{
    [AppHelper saveDataToFile:slideObj fileName:self.fileNameToSave];
//    NSLog(@"****** saveDataToFile ******");
}

-(NSMutableArray*)getDataFromFile{    
    return [AppHelper getDataFromFile:self.fileNameToSave];
}


//-(void)saveComicSlides:(NSMutableArray*)slidesObj{
//    
//    NSManagedObjectContext *context = [[AppHelper initAppHelper] managedObjectContext];
//    
//    NSManagedObject *stickersList = [NSEntityDescription insertNewObjectForEntityForName:@"ComicSlidesData" inManagedObjectContext:context];
//    [stickersList setValue:slidesObj forKey:@"comicSlide"];
//    
//    NSError *error = nil;
//    if (![context save:&error]) {
//        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//    }
//}
//
//-(NSMutableArray*)getComicSlides{
//    
//    // Fetch the devices from persistent data store
//    NSManagedObjectContext *context = [[AppHelper initAppHelper] managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ComicSlidesData"];
//    NSMutableArray* stickersArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    
//    return [stickersArray valueForKey:@"comicSlide"];
//}

#pragma mark - Methods

-(NSString*)SaveImageFile:(NSData*)imageDataObj type:(NSString*)fileType{
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",UUID,fileType] ]; //Add the file name
    [imageDataObj writeToFile:filePath atomically:YES]; //Write the file
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    NSLog(@"File Path :%@",filePath);
    imageDataObj = nil;
    return [NSString stringWithFormat:@"%@.%@",UUID,fileType];
}

#pragma mark mainpageAction

- (IBAction)btnComicBoyClick:(id)sender {
    
    [AppHelper openMainPageviewController:self];
    
}

#pragma mark - InstructionViewDelegate
- (void)didCloseInstructionViewWith:(InstructionView *)view withClosedSlideNumber:(SlideNumber)number
{
    [view removeFromSuperview];
    
    if (number == SlideNumber13)
    {
    
        // open Instruction
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"Do some work");
            
              if ([InstructionView getBoolValueForSlide:kInstructionSlide14] == NO)
              {
            InstructionView *instView = [[InstructionView alloc] initWithFrame:self.view.bounds];
            instView.delegate = self;
            [instView showInstructionWithSlideNumber:SlideNumber14 withType:InstructionBubbleType];
            [instView setTrueForSlide:kInstructionSlide14];
            
            [self.view addSubview:instView];
              }
        });
    }
    else if (number == SlideNumber16B)
    {
        
     
    }
    
    
}

@end
