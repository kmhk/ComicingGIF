//
//  SubIndexpageCell.m
//  ComicBook
//
//  Created by Sanjay Thakkar on 17/09/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "SubIndexpageCell.h"
#import "Enhancement.h"
#import "AppDelegate.h"
#import "UIImage+GIF.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "UIImageView+WebCache.h"

@implementation SubIndexpageCell
-(void)setArrOfEnhancements:(NSMutableArray *)arrOfEnhancements
{
    NSMutableArray *arrOfEnhTemp = [[NSMutableArray alloc]init];
    self.arrOfAnimationStickers = [[NSMutableArray alloc]init];
    for (Enhancement *enhancement in arrOfEnhancements)
    {
        if ([enhancement.enhancementType isEqualToString:@"GIF"])
        {
            YLImageView *animationImage = [[YLImageView alloc] init];
            //animationImage.tag = [arrOfEnhancements indexOfObject:enhancement];
            //        [audioButton setFrame:CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], 32, 25)];
            CGFloat myWidth = self.img_MainImage.frame.size.width;
            CGFloat myHeight = self.img_MainImage.frame.size.height;
            float xfactor = myWidth/[AppDelegate application].dataManager.viewWidth;
            float yfactor = myHeight/[AppDelegate application].dataManager.viewHeight;
            
            float originX = xfactor * [enhancement.xPos floatValue];
            float originY = yfactor * [enhancement.yPos floatValue];
            float sizeX = xfactor * [enhancement.width floatValue];
            float sizeY = yfactor * [enhancement.height floatValue];
            
            
            
            NSLog(@"%@", NSStringFromCGRect(CGRectMake(originX, originY, sizeX, sizeY)));
            NSLog(@"%@", NSStringFromCGRect(CGRectMake([enhancement.xPos floatValue], [enhancement.yPos floatValue], [enhancement.width floatValue], [enhancement.height floatValue])));
            [animationImage setFrame:CGRectMake(originX, originY, sizeX , sizeY )];
            [animationImage sd_setImageWithURL:[NSURL URLWithString:enhancement.enhancementFile]];

           // animationImage.image = [YLGIFImage imageNamed:@"cat1Anim1.gif"];
            NSDictionary *objOn = @{
                                    @"Enhance":enhancement,
                                    @"subView":animationImage
                                    };
            [self.arrOfAnimationStickers addObject:objOn];
            animationImage.tag = 1001;
            [self addSubview:animationImage];
            //[arrOfEnhTemp addObject:enhancement];
        }
    }
    _arrOfEnhancements = arrOfEnhTemp;
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (NSDictionary *obj in self.arrOfAnimationStickers)
    {
        Enhancement *enhancement = [obj valueForKey:@"Enhance"];
        YLImageView *imgView = [obj valueForKey:@"subView"];
        CGFloat myWidth = self.frame.size.width;
        CGFloat myHeight = self.frame.size.height;
        float xfactor = myWidth/[AppDelegate application].dataManager.viewWidth;
        float yfactor = myHeight/[AppDelegate application].dataManager.viewHeight;
        
        float originX = xfactor * [enhancement.xPos floatValue];
        float originY = yfactor * [enhancement.yPos floatValue];
        float sizeX = xfactor * [enhancement.width floatValue];
        float sizeY = yfactor * [enhancement.height floatValue];
        [imgView setFrame:CGRectMake(originX, originY, sizeX , sizeY )];
    }
}
@end
