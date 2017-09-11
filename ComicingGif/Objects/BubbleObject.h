//
//  BubbleObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

extern NSString * const kBubbleURLKey;
extern NSString * const kBubbleUpperLeftURLKey;
extern NSString * const kBubbleUpperRightURLKey;
extern NSString * const kBubbleBottomLeftURLKey;
extern NSString * const kBubbleBottomRightURLKey;
extern NSString * const kBubbleSnapshotImageURLKey;
extern NSString * const kBubbleTypeKey;
extern NSString * const kBubbleDirectionKey;

@interface BubbleObject : BaseObject

typedef NS_ENUM(NSInteger, BubbleObjectDirection) {
    BubbleDirectionUpperLeft,
    BubbleDirectionUpperRight,
    BubbleDirectionBottomLeft,
    BubbleDirectionBottomRight
};

typedef NS_ENUM(NSInteger, BubbleObjectType) {
    BubbleTypeStar,
    BubbleTypeSleep,
    BubbleTypeThink,
    BubbleTypeScary,
    BubbleTypeHeart,
    BubbleTypeAngry
};

// bubble image resource name
@property (nonatomic) NSURL *bubbleURL;

@property (nonatomic, readonly) BubbleObjectType currentType;
@property (nonatomic, readonly) BubbleObjectDirection currentDirection;
@property (nonatomic, readonly) NSURL *bubbleUpperLeftURL;
@property (nonatomic, readonly) NSURL *bubbleUpperRightURL;
@property (nonatomic, readonly) NSURL *bubbleBottomLeftURL;
@property (nonatomic, readonly) NSURL *bubbleBottomRightURL;

@property (nonatomic) NSURL *bubbleSnapshotImageURL;

// bubble text
@property (nonatomic) NSString *text;

- (void)setResourceID:(NSString *)resourceID forDirection:(BubbleObjectDirection)direction;
- (void)switchBubbleURLToDirection:(BubbleObjectDirection)direction;
- (void)changeBubbleTypeTo:(BubbleObjectType)bubbleType;

// create bubble object with text and bubble image resource ID
- (id)initWithText:(NSString *)txt bubbleID:(NSString *)ID withDirection:(BubbleObjectDirection)direction;
- (id)initWithText:(NSString *)txt bubbleID:(NSString *)ID;

@end
