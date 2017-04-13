//
//  InstructionView.h
//  ComicBook
//
//  Created by ADNAN THATHIYA on 30/06/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kInstructionSlide1  @"slide1"
#define kInstructionSlide2  @"slide2"
#define kInstructionSlide3  @"slide3"
#define kInstructionSlide4  @"slide4"
#define kInstructionSlide5  @"slide5"
#define kInstructionSlide6  @"slide6"
#define kInstructionSlide7  @"slide7"
#define kInstructionSlide8  @"slide8"
#define kInstructionSlide9  @"slide9"
#define kInstructionSlide10  @"slide10"
#define kInstructionSlide11  @"slide11"
#define kInstructionSlide12  @"slide12"
#define kInstructionSlide12repeat  @"slide12-repeat"

#define kInstructionSlide13  @"slide13"
#define kInstructionSlide14  @"slide14"
#define kInstructionSlide15  @"slide15"
#define kInstructionSlide16  @"slide16"
#define kInstructionSlide16B  @"slide16B"

#define kInstructionSlideB  @"slideB"
#define kInstructionSlide2B @"slide2B"
#define kInstructionSlideC  @"slideC"
#define kInstructionSlideD  @"slideD"
#define kInstructionSlideE  @"slideE"
#define kInstructionSlideF  @"slideF"



#define kIsUserRegisterFirstTime @"isUserRegisterFirstTime"
#define kIsUserEnterFirstTimeGlideViewController @"kIsUserEnterFirstTimeGlideViewController"
#define kIsUserEnterSecondTimeGlideViewController @"kIsUserEnterFirstTimeGlideViewController"

#define kIsUserEnterFirstTimeComicMaking @"kIsUserEnterFirstTimeComicMaking"
#define kIsUserEnterSecondTimeComicMaking @"kIsUserEnterFirstTimeComicMaking"


typedef enum InstructionType
{
    InstructionBubbleType,
    InstructionBoxType,
    InstructionGIFType,
} InstructionType;


typedef enum SlideNumber
{
    SlideNumber1,
    SlideNumber2,
    SlideNumber3,
    SlideNumber4,
    SlideNumber5,
    SlideNumber6,
    SlideNumber7,
    SlideNumber8,
    SlideNumber9,
    SlideNumber10,
    SlideNumber11,
    SlideNumber12,
    SlideNumber13,
    SlideNumber14,
    SlideNumber15,
    SlideNumber16,
    SlideNumber16B,
    SlideNumberB,
    SlideNumber2B,
    SlideNumberC,
    SlideNumberD,
    SlideNumberE
    
} SlideNumber;



@class InstructionView;

@protocol InstructionViewDelegate <NSObject>

@optional

- (void)didCloseInstructionViewWith:(InstructionView *)view withClosedSlideNumber:(SlideNumber)number;

@end

@interface InstructionView : UIView

@property (nonatomic, assign) id<InstructionViewDelegate> delegate;

@property InstructionType type;
@property SlideNumber number;

- (void)showInstructionWithSlideNumber:(SlideNumber)number withType:(InstructionType)type;
- (void)setAllSlideUserDefaultsValueNO;
- (void)setTrueForSlide:(NSString *)number;
- (void)setFalseForSlide:(NSString *)number;

+ (BOOL)getBoolValueForSlide:(NSString *)number;
+ (void)setAllSlideUserDefaultsValueNO;
+ (void)setAllSlideUserDefaultsValueYES;

@end
