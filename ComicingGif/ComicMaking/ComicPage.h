//
//  ComicPage.h
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 09/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BkImageObject.h"

extern NSString* const slideTypeWide;
extern NSString* const slideTypeTall;

@interface ComicPage : NSObject <NSCoding>

@property (strong, nonatomic) NSString *printScreenPath;
@property (strong, nonatomic) NSString *containerImagePath;
@property (strong, nonatomic) NSString *gifLayerPath;
@property (strong, nonatomic, readonly) BkImageObject *baseImageObject;
@property (strong, nonatomic) NSMutableArray *subviews;
@property (strong, nonatomic) NSMutableArray *subviewData;
@property (strong, nonatomic) NSMutableArray *subviewTranformData;
@property (strong, nonatomic) NSString *timelineString;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *slideType;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

- (void)initWithgif:(BkImageObject *)bgImageObject
   andSubViewArray : (NSMutableArray *) arrSubviews;
@end
