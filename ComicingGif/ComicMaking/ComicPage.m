//
//  ComicPage.m
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 09/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "ComicPage.h"
#import "ComicItem.h"

NSString* const slideTypeWide = @"wide";
NSString* const slideTypeTall = @"tall";

@implementation ComicPage

//@synthesize containerImage, subviews, subviewData, printScreen,timelineString;
@synthesize containerImagePath, subviews, subviewData,timelineString,printScreenPath,subviewTranformData,titleString, slideType,gifLayerPath;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        containerImagePath = [aDecoder decodeObjectForKey:@"containerImagePath"];
        printScreenPath = [aDecoder decodeObjectForKey:@"printScreenImagePath"];
        gifLayerPath = [aDecoder decodeObjectForKey:@"gifLayerPath"];
        subviews = [aDecoder decodeObjectForKey:@"subviews"];
        subviewData = [aDecoder decodeObjectForKey:@"subviewData"];
        subviewTranformData = [aDecoder decodeObjectForKey:@"subviewTranformData"];
        timelineString = [aDecoder decodeObjectForKey:@"timelineString"];
        titleString = [aDecoder decodeObjectForKey:@"titleString"];
        slideType = [aDecoder decodeObjectForKey:@"iswideslide"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:printScreenPath forKey:@"printScreenImagePath"];
    [aCoder encodeObject:gifLayerPath forKey:@"gifLayerPath"];
    [aCoder encodeObject:containerImagePath forKey:@"containerImagePath"];
    [aCoder encodeObject:subviews forKey:@"subviews"];
    [aCoder encodeObject:subviewData forKey:@"subviewData"];
    [aCoder encodeObject:subviewTranformData forKey:@"subviewTranformData"];
    [aCoder encodeObject:timelineString forKey:@"timelineString"];
    [aCoder encodeObject:titleString forKey:@"titleString"];
    [aCoder encodeObject:slideType forKey:@"iswideslide"];

}

- (void)initWithgif:(NSString *)strPath andSubViewArray : (NSMutableArray *) arrSubviews{
    gifLayerPath = strPath;
    NSMutableArray *arrTemp = [NSMutableArray new];
    arrTemp = [arrSubviews mutableCopy];
    [arrTemp removeObjectAtIndex:0];
   
    subviews = arrTemp;
    slideType = @"tall";
    if (arrSubviews.count>0) {
        slideType = [[[arrSubviews objectAtIndex:0] valueForKey:@"isTall"] boolValue]?@"tall":@"wide";
    }
}


@end
