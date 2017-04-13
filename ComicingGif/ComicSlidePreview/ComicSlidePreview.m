//
//  ComicSlidePreview.m
//  ComicBook
//
//  Created by ADNAN THATHIYA on 17/07/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "ComicSlidePreview.h"
#import "ComicBookVC.h"
#import "AppConstants.h"
#import "ComicImage.h"


@interface ComicSlidePreview()<BookChangeDelegate>
{
    int TagRecord;
    ComicBookVC *comic;
    CGSize wideSlideSize;
    CGSize normalSlideSize_big;
    CGSize normalSlideSize_small;
    int currentIndex;
}

//@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *view3Slide;
@property (weak, nonatomic) IBOutlet UIView *view2Slide;
@property (weak, nonatomic) IBOutlet UIView *view1Slide;
@property (weak, nonatomic) IBOutlet UIView *view4Slide;
@property (weak, nonatomic) IBOutlet UIView *viewComic;

//3SlideImageViews
@property (weak, nonatomic) IBOutlet UIImageView *imgv3Slide1;
@property (weak, nonatomic) IBOutlet UIImageView *imgv3Slide2;
@property (weak, nonatomic) IBOutlet UIImageView *imgv3Slide3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTrailingbackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBottom3Slide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constWidth3Slide;

//2SlideImageViews
@property (weak, nonatomic) IBOutlet UIImageView *imgv2Slide1;
@property (weak, nonatomic) IBOutlet UIImageView *imgv2Slide2;

//1SlideImageViews
@property (weak, nonatomic) IBOutlet UIImageView *imgv1Slide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constHeight1Slide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constWidth1Slide;

//4SlideImageViews
@property (weak, nonatomic) IBOutlet UIImageView *imgv4Slide1;
@property (weak, nonatomic) IBOutlet UIImageView *imgv4Slide2;
@property (weak, nonatomic) IBOutlet UIImageView *imgv4Slide3;
@property (weak, nonatomic) IBOutlet UIImageView *imgv4Slide4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constWidth4Slides;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constHeight4Slides;

// Morethan 4 Slides
@property (weak, nonatomic) IBOutlet UIView *viewComicBook;


@property (strong, nonatomic) NSArray *slides;

// New ComicImage Layout
@property (strong, nonatomic) NSMutableArray *comicImages;
@property(nonatomic,assign) CGRect currentSlideFrame;
@property (nonatomic, strong) UIView * viewSlides;

@property (nonatomic) CGFloat totalHeight;
@property (nonatomic) CGFloat paddingX;
@property (nonatomic) CGFloat paddingY;

@property (nonatomic) NSInteger borderWidth;

@end

@implementation ComicSlidePreview

@synthesize view3Slide, view2Slide, slides, view1Slide, view4Slide;
@synthesize imgv3Slide1, imgv3Slide2, imgv3Slide3;
@synthesize imgv2Slide1, imgv2Slide2;
@synthesize imgv1Slide;
@synthesize imgv4Slide1, imgv4Slide2, imgv4Slide3, imgv4Slide4;
@synthesize viewComicBook;
@synthesize constWidth4Slides, constHeight4Slides;
@synthesize constWidth1Slide, constHeight1Slide, comicImages, viewSlides, paddingX,paddingY, totalHeight, borderWidth;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:@"ComicSlidePreview" bundle:nil];
    if (self)
    {
        self.view.frame = frame;
       
        paddingX = 8;
        paddingY = 6;
        borderWidth = 2;
        // Do whatever nonsense you'd like to do in init.
    }
    return self;
//    
//    self = [super initWithFrame:frame];
//    
//    if(self)
//    {
//        //Load from xib
//        [[NSBundle mainBundle] loadNibNamed:@"ComicSlidePreview" owner:self options:nil];
//        self.view.frame = self.frame;
//        [self addSubview:self.view];
//        
//        [self setup];
//    }
//    
//    return self;
}


- (void)setup
{
    [self hideAllPreviewViews];
}

- (void)setupComicSlidePreview:(NSArray *)slidesImages
{
    [self setup];
    slides = slidesImages;
    
// ******************** old code *****************
//    if (slides.count == 1)
//    {
//        [self setup1SlideComicPreview];
//    }
//    else if (slides.count == 2)
//    {
//        [self setup2SlideComicPreview];
//    }
//    else if (slides.count == 3)
//    {
//        [self setup3SlideComicPreview];
//    }
//    else if (slides.count == 4)
//    {
//        [self setup4SlideComicPreview];
//    }
//    else
//    {
//        [self setupComicBook];
//    }
// 
//    self.viewComicLayout.hidden = YES;
    
//*****************************************************************************
    
    currentIndex = 0;
  
    self.currentSlideFrame = CGRectZero;

    self.viewSlides = [[UIView alloc] initWithFrame:CGRectZero];
    self.viewWhiteBorder = [[UIView alloc] initWithFrame:CGRectZero];
    
    wideSlideSize = CGSizeMake(self.view.frame.size.width - 20 + paddingX, WIDE_SLIDE_HEIGHT);
    normalSlideSize_big = CGSizeMake(self.view.frame.size.width- 20 + paddingX,TALL_BIG_SLIDE_HEIGHT);
    normalSlideSize_small = CGSizeMake(self.view.frame.size.width/2 - 10, TALL_SMALL_SLIDE_HEIGHT);
    
    [self createComicImages];
    
    [self prepareSlides];
 
    self.viewSlides.frame = CGRectMake(paddingX,0,self.currentSlideFrame.size.width + paddingX,totalHeight + paddingY);
    
    self.bookBackground = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, self.currentSlideFrame.size.width + paddingX + paddingX + paddingX + 10, totalHeight + paddingY + paddingY + paddingY + paddingY / 3 + paddingY / 2)];
    
    self.bookBackground.image = [UIImage imageNamed:@"3slideImageBackground"];
    
    self.viewWhiteBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.viewSlides.frame) + paddingX + paddingX, totalHeight + paddingY);
    
    
    [self.viewWhiteBorder addSubview:self.bookBackground];
    [self.viewWhiteBorder addSubview:self.viewSlides];
    
    self.viewWhiteBorder.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.viewWhiteBorder];
    
    CGRect viewFrame = self.viewWhiteBorder.frame;

    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(viewFrame));
    
    self.viewWhiteBorder.center = self.view.center;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.delegate didFrameChange:self withFrame:self.viewWhiteBorder.frame];
}

#pragma mark - ComicImage Layout methods
- (void)createComicImages
{
    comicImages = [[NSMutableArray alloc] init];
    
    for (UIImage *img in slides)
    {
        ComicImage *obj = [[ComicImage alloc] init];
        obj.image = img;
        
        if (img.size.width > img.size.height)
        {
            // wide
            obj.comicImageType = WIDE;
        }
        else
        {
            // tall
            obj.comicImageType = NORMAL;
        }
    
        [comicImages addObject:obj];
    }
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
        [self.viewSlides addSubview:[self createWideSlide:comicImage.image]];
    }
    else if (((ComicImage*)comicImages[indexValue]).comicImageType == NORMAL &&
              [self isNextSlideAvailble:indexValue + 1]  &&
              ((ComicImage*)comicImages[indexValue + 1]).comicImageType == NORMAL)
    {
        
        ComicImage* comicImage1 = (ComicImage*)comicImages[indexValue];
        ComicImage* comicImage2 = (ComicImage*)comicImages[indexValue + 1];
        
        [self.viewSlides addSubview:[self createSplitSlide:comicImage1.image
                                                    image2:comicImage2.image]];
        
        currentIndex = currentIndex + 1;
    }
    else if (((ComicImage*)comicImages[indexValue]).comicImageType == NORMAL &&
              [self isNextSlideAvailble:indexValue + 1]  &&
              ((ComicImage*)comicImages[indexValue + 1]).comicImageType == WIDE)
    {
        
        ComicImage* comicImage = (ComicImage*)comicImages[indexValue];
        [self.viewSlides addSubview:[self createNormalSlide:comicImage.image]];
    }
    else if (((ComicImage*)comicImages[indexValue]).comicImageType == NORMAL)
    {
        
        ComicImage* comicImage = (ComicImage*)comicImages[indexValue];
        [self.viewSlides addSubview:[self createNormalSlide:comicImage.image]];
        
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
-(UIImageView*)createWideSlide :(UIImage*)imgWideSilde{
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.currentSlideFrame.origin.x,
                                                                         self.currentSlideFrame.origin.y + paddingY,
                                                                         wideSlideSize.width, wideSlideSize.height)];
    imgView.image =imgWideSilde;
    
    totalHeight = totalHeight + wideSlideSize.height + paddingY;
    
    self.currentSlideFrame = CGRectMake(self.currentSlideFrame.origin.x,
                                        (self.currentSlideFrame.origin.y + wideSlideSize.height + paddingY),
                                        wideSlideSize.width, wideSlideSize.height);
    
    imgView.layer.borderColor = [UIColor blackColor].CGColor;
    imgView.layer.borderWidth = borderWidth;
    
    return imgView;
}

-(UIImageView*)createNormalSlide :(UIImage*)imgWideSilde{
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.currentSlideFrame.origin.x,
                                                                         self.currentSlideFrame.origin.y + paddingY,
                                                                         normalSlideSize_big.width, normalSlideSize_big.height)];
    imgView.image = imgWideSilde;
    
    totalHeight = totalHeight + normalSlideSize_big.height + paddingY;

    
    self.currentSlideFrame = CGRectMake(self.currentSlideFrame.origin.x,
                                        (self.currentSlideFrame.origin.y + normalSlideSize_big.height + paddingY),
                                        normalSlideSize_big.width, normalSlideSize_big.height);
    
    imgView.layer.borderColor = [UIColor blackColor].CGColor;
    imgView.layer.borderWidth = borderWidth;
    
    return imgView;
}

-(UIView*)createSplitSlide :(UIImage*)imgWideSilde1 image2:(UIImage*)imgWideSilde2{
    
    UIView* viewHolder = [[UIView alloc] initWithFrame:CGRectMake(self.currentSlideFrame.origin.x,
                                                                  self.currentSlideFrame.origin.y,
                                                                  normalSlideSize_big.width,
                                                                  normalSlideSize_small.height)];
    
    
    UIImageView* imgView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,paddingY,
                                                                           normalSlideSize_small.width, normalSlideSize_small.height)];
    
    
    imgView_1.image = imgWideSilde1;
    
    imgView_1.layer.borderColor = [UIColor blackColor].CGColor;
    imgView_1.layer.borderWidth = borderWidth;
    
    
    UIImageView* imgView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(normalSlideSize_small.width + paddingX,paddingY,
                                                                           normalSlideSize_small.width, normalSlideSize_small.height)];
    imgView_2.image =imgWideSilde2;
    
    imgView_2.layer.borderColor = [UIColor blackColor].CGColor;
    imgView_2.layer.borderWidth = borderWidth;
    
    
    [viewHolder addSubview:imgView_1];
    [viewHolder addSubview:imgView_2];
    
    totalHeight = totalHeight + normalSlideSize_small.height + paddingY;

    
    self.currentSlideFrame = CGRectMake(self.currentSlideFrame.origin.x,
                                        (self.currentSlideFrame.origin.y + viewHolder.frame.size.height + paddingY),
                                        wideSlideSize.width, wideSlideSize.height);
    return viewHolder;
}

// ******************************************************************
- (void)hideAllPreviewViews
{
    view3Slide.hidden = YES;
    view2Slide.hidden = YES;
    view1Slide.hidden = YES;
    view4Slide.hidden = YES;
    _viewComic.hidden = YES;
}

- (void)setup3SlideComicPreview
{
    if (IS_IPHONE_6P)
    {
        self.constTrailingbackground.constant = 0;
        self.constBottom3Slide.constant = 28;
        self.constWidth3Slide.constant = 0;

    }
    else if (IS_IPHONE_6)
    {
        self.constTrailingbackground.constant = 7;

        self.constBottom3Slide.constant = 25;
        self.constWidth3Slide.constant = -4;

    }
    else if (IS_IPHONE_5)
    {
        self.constBottom3Slide.constant = 22;
        self.constWidth3Slide.constant = -3;

    }
    else
    {
        self.constBottom3Slide.constant = 22;
        self.constWidth3Slide.constant = -3;
    }
    
    
    view3Slide.hidden = NO;
    
    imgv3Slide1.image = slides[0];
    imgv3Slide2.image = slides[1];
    imgv3Slide3.image = slides[2];
    
    imgv3Slide1.layer.borderColor = [UIColor blackColor].CGColor;
    imgv3Slide1.layer.borderWidth = 1.5;
    
    imgv3Slide2.layer.borderColor = [UIColor blackColor].CGColor;
    imgv3Slide2.layer.borderWidth = 1.5;
    
    imgv3Slide3.layer.borderColor = [UIColor blackColor].CGColor;
    imgv3Slide3.layer.borderWidth = 1.5;
    
    
}

- (void)setup2SlideComicPreview
{
    view2Slide.hidden = NO;

    imgv2Slide1.image = slides[0];
    imgv2Slide2.image = slides[1];
    
    imgv2Slide1.layer.borderColor = [UIColor blackColor].CGColor;
    imgv2Slide1.layer.borderWidth = 1.5;
    
    imgv2Slide2.layer.borderColor = [UIColor blackColor].CGColor;
    imgv2Slide2.layer.borderWidth = 1.5;

}

- (void)setup1SlideComicPreview
{
    if (IS_IPHONE_6P)
    {
        self.constWidth1Slide.constant = -2;
        constHeight1Slide.constant = 0;
    }
    else if (IS_IPHONE_6)
    {
        self.constWidth1Slide.constant = -9;
        constHeight1Slide.constant = -5;
    }
    else if (IS_IPHONE_5)
    {
        self.constWidth1Slide.constant = -9;
        constHeight1Slide.constant = -5;
    }
    else
    {
        self.constWidth1Slide.constant = -4;
        constHeight1Slide.constant = -3;
        
    }

    
    view1Slide.hidden = NO;
    
    imgv1Slide.image = slides[0];
    
    imgv1Slide.layer.borderColor = [UIColor blackColor].CGColor;
    imgv1Slide.layer.borderWidth = 1.5;

}

- (void)setup4SlideComicPreview
{
    if (IS_IPHONE_6P)
    {
        self.constWidth4Slides.constant = -2;
        constHeight4Slides.constant = 0;
    }
    else if (IS_IPHONE_6)
    {
        self.constWidth4Slides.constant = -3;
        constHeight4Slides.constant = -2;
    }
    else if (IS_IPHONE_5)
    {
        self.constWidth4Slides.constant = -4;
        constHeight4Slides.constant = -3;
    }
    else
    {
        self.constWidth4Slides.constant = -4;
        constHeight4Slides.constant = -3;

    }

    
    view4Slide.hidden = NO;
    
    imgv4Slide1.layer.borderColor = [UIColor blackColor].CGColor;
    imgv4Slide1.layer.borderWidth = 1.5;

    imgv4Slide2.layer.borderColor = [UIColor blackColor].CGColor;
    imgv4Slide2.layer.borderWidth = 1.5;
    
    imgv4Slide3.layer.borderColor = [UIColor blackColor].CGColor;
    imgv4Slide3.layer.borderWidth = 1.5;
    
    imgv4Slide4.layer.borderColor = [UIColor blackColor].CGColor;
    imgv4Slide4.layer.borderWidth = 1.5;
    
    imgv4Slide1.image = slides[0];
    imgv4Slide2.image = slides[1];
    imgv4Slide3.image = slides[2];
    imgv4Slide4.image = slides[3];
}

- (void)setupComicBook
{
    _viewComic.hidden = NO;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_MainPage" bundle:nil];

    comic = [sb instantiateViewControllerWithIdentifier:@"ComicBookVC"];
    comic.delegate = self;
    comic.Tag = 0;
    comic.isSlidesContainImages = YES;
    comic.view.frame = CGRectMake(0, 0, CGRectGetWidth(viewComicBook.frame), CGRectGetHeight(viewComicBook.frame));
    
    [viewComicBook addSubview:comic.view];
    
    // vishnu
//    NSMutableArray *slidesArray = [[NSMutableArray alloc] init];
  //  [slidesArray addObjectsFromArray:comicBook.slides];
    
    // To repeat the cover image again on index page as the first slide.
//    if(slides.count > 1)
//    {
//        [slidesArray insertObject:[slidesArray firstObject] atIndex:1];
//        
//        // Adding a sample slide to array to maintain the logic
//        Slides *slides = [Slides new];
//        [slidesArray insertObject:slides atIndex:1];
//        
//        // vishnuvardhan logic for the second page
//        if(6 < slidesArray.count)
//        {
//            [slidesArray insertObject:[slidesArray firstObject] atIndex:0];
//        }
//    }
    
    [comic setSlidesArray:slides];
    [comic setupBook];
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
