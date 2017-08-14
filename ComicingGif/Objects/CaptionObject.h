//
//  CaptionObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

@interface CaptionObject : BaseObject

typedef NS_ENUM(NSInteger, CaptionObjectType) {
    CaptionTypeDefault,
    CaptionTypeTextWithoutBackgroun,
    CaptionTypeYellowBox
};

@property (nonatomic) NSString *text;
@property (nonatomic) CaptionObjectType type;

- (id)initWithText:(NSString *)text captionType:(CaptionObjectType)captionType;
- (id)initWithText:(NSString *)text captionType:(CaptionObjectType)captionType andFrame:(CGRect)frame;

- (void)changeCaptionTypeTo:(CaptionObjectType)captionType;

@end
