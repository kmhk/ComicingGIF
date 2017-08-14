//
//  ComicCellViewController.m
//  ComicBook
//
//  Created by ADNAN THATHIYA on 06/10/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "ComicCellViewController.h"
#import "ComicBookVC.h"
#import "AppConstants.h"
#import "ComicImage.h"
#import "Slides.h"
#import "UIImageView+WebCache.h"
#import "Global.h"
#import "YLImageView.h"

@interface ComicCellViewController ()<BookChangeDelegate>
{
    int TagRecord;
    ComicBookVC *comic;
    CGSize wideSlideSize;
    CGSize normalSlideSize_big;
    CGSize normalSlideSize_small;
    int currentIndex;
}


@property (weak, nonatomic) IBOutlet UIView *viewComic;
@property (weak, nonatomic) IBOutlet UIView *viewComicBook;



@property (strong, nonatomic) NSArray *slides;

// New ComicImage Layout
@property (strong, nonatomic) NSMutableArray *comicImages;
@property(nonatomic,assign) CGRect currentSlideFrame;
@property (nonatomic, strong) UIView * viewSlides;

@property (nonatomic) CGFloat totalHeight;
@property (nonatomic) CGFloat paddingX;
@property (nonatomic) CGFloat paddingY;


@end

@implementation ComicCellViewController
@synthesize slides, viewComicBook, viewComic, viewWhiteBorder;
@synthesize comicImages, currentSlideFrame, viewSlides, totalHeight, paddingX, paddingY;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:@"ComicCellViewController" bundle:nil];
    if (self)
    {
        self.view.frame = frame;
        
        paddingX = 8;
        paddingY = 6;
        // Do whatever nonsense you'd like to do in init.
    }
    return self;
}

- (void)setupComicSlidePreview:(NSArray *)slidesImages
{
    slides = slidesImages;
    
    currentIndex = 0;
    
    self.currentSlideFrame = CGRectZero;
    
    self.viewSlides = [[UIView alloc] initWithFrame:CGRectZero];
    self.viewWhiteBorder = [[UIView alloc] initWithFrame:CGRectZero];
    
    wideSlideSize = CGSizeMake(self.view.frame.size.width + paddingX, WIDE_SLIDE_HEIGHT_CELL);
    normalSlideSize_big = CGSizeMake(self.view.frame.size.width+ paddingX,TALL_BIG_SLIDE_HEIGHT_CELL);
    normalSlideSize_small = CGSizeMake(self.view.frame.size.width/2 , TALL_SMALL_SLIDE_HEIGHT_CELL);
    
    [self createComicViews];
    [self prepareSlides];
    
    self.viewSlides.frame = CGRectMake(paddingX,0,self.currentSlideFrame.size.width + paddingX,totalHeight + paddingY);
    
    self.viewWhiteBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.viewSlides.frame) + paddingX + paddingX, totalHeight + paddingY);
    
    self.viewSlides.backgroundColor = [Global getColorForComicBookColorCode:_comicBookColorCode];
    
    [self.viewWhiteBorder addSubview:self.viewSlides];
    
    self.viewWhiteBorder.backgroundColor = [Global getColorForComicBookColorCode:_comicBookColorCode];
    
    [self.view addSubview:self.viewWhiteBorder];
    
    CGRect viewFrame = self.viewWhiteBorder.frame;
    
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(viewFrame));
    
    self.viewWhiteBorder.center = self.view.center;
    self.viewWhiteBorder.tag = 11111;
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.delegate didFrameChange:self withFrame:self.viewWhiteBorder.frame];
}

#pragma mark - ComicImage Layout methods
- (void)createComicViews
{
    comicImages = [[NSMutableArray alloc] init];
    
    NSLog(@"slides Array : %@",slides);
    
    for(Slides *slide in slides)
    {
        ComicImage *obj = [[ComicImage alloc] init];
        
        if( [slide.slideStatus isEqualToString:@"0"])
        {
            obj.comicImageType = WIDE;
        }
        else
        {
            obj.comicImageType = NORMAL;
        }
        
        if ([slide.slideType isEqualToString:@"0"]) {
            obj.comicBaseLayerType = GIF;
        } else {
            obj.comicBaseLayerType = STATICIMAGE;
        }
        
        obj.baseLayerURL = slide.slideImage;
        obj.enhancements = slide.enhancements;
        
        [comicImages addObject:obj];
    }
    
    
    
//    for (UIImage *img in slides)
//    {
//        ComicImage *obj = [[ComicImage alloc] init];
//        obj.image = img;
//        
//        if (img.size.width > img.size.height)
//        {
//            // wide
//            obj.comicImageType = WIDE;
//        }
//        else
//        {
//            // tall
//            obj.comicImageType = NORMAL;
//        }
//        
//        [comicImages addObject:obj];
//    }
}

-(void)prepareSlides
{
    
    [self addSlide:currentIndex];
    
    if ([self isNextSlideAvailble:currentIndex]) {
        [self prepareSlides];
    }
    
    //Add default Slide
}

-(void)addSlide:(int)indexValue
{
    if([comicImages count] == 0)
        return;
    
    if (indexValue == 0)
        self.currentSlideFrame = CGRectZero;
    
    if (((ComicImage*)comicImages[indexValue]).comicImageType == WIDE)
    {
        ComicImage* comicImage = (ComicImage*)comicImages[indexValue];
        [self.viewSlides addSubview:[self createWideSlide:comicImage]];
    }
    else if (((ComicImage*)comicImages[indexValue]).comicImageType == NORMAL &&
             [self isNextSlideAvailble:indexValue + 1]  &&
             ((ComicImage*)comicImages[indexValue + 1]).comicImageType == NORMAL)
    {
        
        ComicImage* comicImage1 = (ComicImage*)comicImages[indexValue];
        ComicImage* comicImage2 = (ComicImage*)comicImages[indexValue + 1];
        
        [self.viewSlides addSubview:[self createSplitSlide:comicImage1
                                                    image2:comicImage2]];
        
        currentIndex = currentIndex + 1;
    }
    else if (((ComicImage*)comicImages[indexValue]).comicImageType == NORMAL &&
             [self isNextSlideAvailble:indexValue + 1]  &&
             ((ComicImage*)comicImages[indexValue + 1]).comicImageType == WIDE)
    {
        
        ComicImage* comicImage = (ComicImage*)comicImages[indexValue];
        [self.viewSlides addSubview:[self createNormalSlide:comicImage]];
    }
    else if (((ComicImage*)comicImages[indexValue]).comicImageType == NORMAL)
    {
        
        ComicImage* comicImage = (ComicImage*)comicImages[indexValue];
        [self.viewSlides addSubview:[self createNormalSlide:comicImage]];
        
    }
    
    currentIndex = currentIndex + 1;
}


- (BOOL)isNextSlideAvailble:(int)indexValue
{
    if([comicImages count] > indexValue)
        return YES;
    
    return NO;
}

#pragma mark - ComicSlide Different Layout Methods
-(UIView*)createWideSlide :(ComicImage*)comicImage
{
    UIView* singleSlideContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.currentSlideFrame.origin.x,
                                                                                     self.currentSlideFrame.origin.y + paddingY,
                                                                                     wideSlideSize.width, wideSlideSize.height)];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, singleSlideContainerView.frame.size.width, singleSlideContainerView.frame.size.height)];
    [singleSlideContainerView addSubview:imgView];
 //   imgView.image = imgWideSilde;
    
    totalHeight = totalHeight + wideSlideSize.height + paddingY;
    
    self.currentSlideFrame = CGRectMake(self.currentSlideFrame.origin.x,
                                        (self.currentSlideFrame.origin.y + wideSlideSize.height + paddingY),
                                        wideSlideSize.width, wideSlideSize.height);
    
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:comicImage.baseLayerURL]
                     placeholderImage:GlobalObject.placeholder_comic
                              options:SDWebImageHighPriority
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {

                            }];
    
    
    [self setBorderForView:singleSlideContainerView];
    
    [self addEnhancements:comicImage.enhancements inView:singleSlideContainerView];
    
    singleSlideContainerView.clipsToBounds = YES;
    return singleSlideContainerView;
}

-(UIView*)createNormalSlide :(ComicImage *)comicImage {
    
    UIView* singleSlideContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.currentSlideFrame.origin.x,
                                                                         self.currentSlideFrame.origin.y + paddingY,
                                                                         normalSlideSize_big.width, normalSlideSize_big.height)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, singleSlideContainerView.frame.size.width, singleSlideContainerView.frame.size.height)];
    [singleSlideContainerView addSubview:imgView];
    
  //  imgView.image =imgWideSilde;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:comicImage.baseLayerURL]
               placeholderImage:GlobalObject.placeholder_comic
                        options:SDWebImageHighPriority
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          

                      }];

    [self setBorderForView:singleSlideContainerView];
    
    [self addEnhancements:comicImage.enhancements inView:singleSlideContainerView];
    
    totalHeight = totalHeight + normalSlideSize_big.height + paddingY;
    
    
    self.currentSlideFrame = CGRectMake(self.currentSlideFrame.origin.x,
                                        (self.currentSlideFrame.origin.y + normalSlideSize_big.height + paddingY),
                                        normalSlideSize_big.width, normalSlideSize_big.height);
    
    singleSlideContainerView.clipsToBounds = YES;
    return singleSlideContainerView;
}

-(UIView*)createSplitSlide :(ComicImage *)comicImage1 image2:(ComicImage *)comicImage2 {
    
    UIView* viewHolder = [[UIView alloc] initWithFrame:CGRectMake(self.currentSlideFrame.origin.x,
                                                                  self.currentSlideFrame.origin.y,
                                                                  normalSlideSize_big.width,
                                                                  normalSlideSize_small.height)];
    
    
    
    UIView *singleSlideContainerView1 = [[UIView alloc] initWithFrame:CGRectMake(0,paddingY,
                                                                                      normalSlideSize_small.width, normalSlideSize_small.height)];
    UIImageView* imgView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, normalSlideSize_small.width, normalSlideSize_small.height)];
    [singleSlideContainerView1 addSubview:imgView_1];
    
 //   imgView_1.image =imgWideSilde1;
    [imgView_1 sd_setImageWithURL:[NSURL URLWithString:comicImage1.baseLayerURL]
               placeholderImage:GlobalObject.placeholder_comic
                        options:SDWebImageHighPriority
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {


                      }];

    
    
    
    UIView *singleSlideContainerView2 = [[UIView alloc] initWithFrame:CGRectMake(normalSlideSize_small.width + paddingX,paddingY,
                                                                                 normalSlideSize_small.width, normalSlideSize_small.height)];
    UIImageView* imgView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, normalSlideSize_small.width, normalSlideSize_small.height)];
    [singleSlideContainerView2 addSubview:imgView_2];

    [imgView_2 sd_setImageWithURL:[NSURL URLWithString:comicImage2.baseLayerURL]
                 placeholderImage:GlobalObject.placeholder_comic
                          options:SDWebImageHighPriority
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            


                        }];

    
    [self setBorderForView:singleSlideContainerView1];
    [self setBorderForView:singleSlideContainerView2];
    
    [self addEnhancements:comicImage1.enhancements inView:singleSlideContainerView1];
    [self addEnhancements:comicImage2.enhancements inView:singleSlideContainerView2];
    
    singleSlideContainerView1.clipsToBounds = YES;
    singleSlideContainerView2.clipsToBounds = YES;
    
    [viewHolder addSubview:singleSlideContainerView1];
    [viewHolder addSubview:singleSlideContainerView2];
    
    totalHeight = totalHeight + normalSlideSize_small.height + paddingY;
    
    
    self.currentSlideFrame = CGRectMake(self.currentSlideFrame.origin.x,
                                        (self.currentSlideFrame.origin.y + viewHolder.frame.size.height + paddingY),
                                        wideSlideSize.width, wideSlideSize.height);
    
    return viewHolder;
}

- (void)addEnhancements:(NSArray <Enhancement *>*)enhancements inView:(UIView *)slideView {
    int countOfAudio;
    if (!enhancements || enhancements.count == 0) {
        return;
    }
    NSSortDescriptor *zIndexDescriptor = [[NSSortDescriptor alloc] initWithKey:@"zIndex" ascending:YES];
    NSArray *sortDescriptors = @[zIndexDescriptor];
    enhancements = [enhancements sortedArrayUsingDescriptors:sortDescriptors];
    
    for (Enhancement *enhance in enhancements)
    {
        if (![enhance.enhancementType isEqualToString:@"GIF"])
        {
            countOfAudio++;
        }
    }
//    self.audioUrlArray = [[NSMutableArray alloc] initWithCapacity:countOfAudio];
//    self.audioDurationSecondsArray = [[NSMutableArray alloc] initWithCapacity:countOfAudio];
//    self.downloadedAudioDataArray = [[NSMutableArray alloc] initWithCapacity:countOfAudio];
//    for (int i = 0; i < countOfAudio; i ++) {
//        [self.downloadedAudioDataArray addObject:[NSNull null]];
//    }
    for(Enhancement *enhancement in enhancements) {
        if ([enhancement.enhancementType isEqualToString:@"AUD"])
        {
            
//            [self.audioUrlArray addObject:[NSURL URLWithString:enhancement.enhancementFile]];
//            [self performSelectorInBackground:@selector(getTheAudioLength:) withObject:[NSNumber numberWithInteger:[slide.enhancements indexOfObject:enhancement]]];
//            [self configureAudioPlayer:[slide.enhancements indexOfObject:enhancement]];
//            CustomView *audioButton = [[CustomView alloc] init];
//            audioButton.tag = [slide.enhancements indexOfObject:enhancement];
//            //        [audioButton setFrame:CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], 32, 25)];
//            float xfactor = [AppDelegate application].dataManager.viewWidth/self.view.frame.size.width;
//            float yfactor = [AppDelegate application].dataManager.viewHeight/self.view.frame.size.height;
//            if(xfactor == 1 && yfactor == 1) {
//                xfactor = 0.75;
//                yfactor = 0.75;
//            }
//            float originX = xfactor * [enhancement.xPos floatValue];
//            float originY = yfactor * [enhancement.yPos floatValue];
//            float sizeX = xfactor * [enhancement.width floatValue];
//            float sizeY = yfactor * [enhancement.height floatValue];
//            
//            NSLog(@"%@", NSStringFromCGRect(CGRectMake(originX, originY, sizeX, sizeY)));
//            NSLog(@"%@", NSStringFromCGRect(CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], [enhancement.width floatValue], [enhancement.height floatValue])));
//            // originX and originY are currently middle points. So changing it to origin.
//            originX = originX - sizeX/2;
//            originY = originY - sizeY/2;
//            [audioButton setFrame:CGRectMake(originX, originY, sizeX + sizeX/2, sizeY + sizeY/2)];
//            //        [audioButton setBackgroundColor:[UIColor yellowColor]];
//            //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 25)];
//            //        imageView.image = [UIImage imageNamed:@"bubbleAudioPlay"];
//            //        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
//            //        [audioButton addSubview:imageView];
//            __weak __typeof(self)weakSelf = self;
//            __weak __typeof(audioButton)weakAudioButton = audioButton;
//            audioButton.playAudio = ^{
//                [weakSelf playAudio:weakAudioButton.tag];
//            };
//            audioButton.pauseAudio = ^{
//                [weakSelf pauseAudio];
//            };
//            [self.scrollView addSubview:audioButton];
        }
        else if ([enhancement.enhancementType isEqualToString:@"GIF"]) {
            YLImageView *animationImage = [[YLImageView alloc] init];
            //animationImage.tag = [arrOfEnhancements indexOfObject:enhancement];
            //        [audioButton setFrame:CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], 32, 25)];
            
            
            
            
            float xfactor = slideView.frame.size.width/[UIScreen mainScreen].bounds.size.width;
            float yfactor = slideView.frame.size.height/[UIScreen mainScreen].bounds.size.height;
            
            float originX = xfactor * [enhancement.xPos floatValue];
            float originY = yfactor * [enhancement.yPos floatValue];
            float sizeX = xfactor * [enhancement.width floatValue];
            float sizeY = yfactor * [enhancement.height floatValue];
            
            
            
            NSLog(@"%@", NSStringFromCGRect(CGRectMake(originX, originY, sizeX, sizeY)));
            NSLog(@"%@", NSStringFromCGRect(CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], [enhancement.width floatValue], [enhancement.height floatValue])));
            [animationImage setFrame:CGRectMake(originX, originY, sizeX , sizeY )];
            [animationImage sd_setImageWithURL:[NSURL URLWithString:enhancement.enhancementFile]];
            NSDictionary *objOn = @{
                                    @"Enhance":enhancement,
                                    @"subView":animationImage
                                    };
//            [self.objOfSubviews addObject:objOn];
//            animationImage.tag = 1001;
//            [self.scrollView addSubview:animationImage];
            [slideView addSubview:animationImage];
        }
        else
        {
            UIImageView *staticImage = [[UIImageView alloc] init];
            CGFloat myWidth = slideView.frame.size.width;
            CGFloat myHeight = slideView.frame.size.height;
            //            float xfactor = myWidth/[AppDelegate application].dataManager.viewWidth;
            //            float yfactor = myHeight/[AppDelegate application].dataManager.viewHeight;
            //
            //            float originX = xfactor * [enhancement.xPos floatValue];
            //            float originY = yfactor * [enhancement.yPos floatValue];
            //            float sizeX = xfactor * [enhancement.width floatValue];
            //            float sizeY = yfactor * [enhancement.height floatValue];
            
            
            
            //            NSLog(@"%@", NSStringFromCGRect(CGRectMake(originX, originY, sizeX, sizeY)));
            //            NSLog(@"%@", NSStringFromCGRect(CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], [enhancement.width floatValue], [enhancement.height floatValue])));
            [staticImage setFrame:CGRectMake(0, 0, myWidth , myHeight)];
            [staticImage sd_setImageWithURL:[NSURL URLWithString:enhancement.enhancementFile]];
            NSDictionary *objOn = @{
                                    @"Enhance":enhancement,
                                    @"subView":staticImage
                                    };
//            [self.objOfSubviews addObject:objOn];
//            staticImage.tag = 1005;
//            [self.scrollView addSubview:staticImage];
            [slideView addSubview:staticImage];
        }
    }
}



// ******************************************************************

- (void)setupComicBook
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil];
    
    comic = [sb instantiateViewControllerWithIdentifier:@"ComicBookVC"];
    comic.delegate = self;
    comic.Tag = 0;
    comic.isSlidesContainImages = NO;
    comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(viewComicBook.frame), CGRectGetHeight(viewComicBook.frame));
    
    [viewComicBook addSubview:comic.view];
    
    [comic setImages:comicImages];
    [comic setupBook];
}

- (void)setBorderForView:(UIView *)view {
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 3.f;
}

#pragma mark - BookChangeDelegate Methods
-(void)bookChanged:(int)Tag
{
    if(TagRecord!=Tag)
    {
        [comic ResetBook];
    }
    
    TagRecord=Tag;
}


@end
