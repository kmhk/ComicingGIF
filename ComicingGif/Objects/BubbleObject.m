//
//  BubbleObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BubbleObject.h"

NSString * const kBubbleURLKey              = @"bubbleURL";
NSString * const kBubbleUpperLeftURLKey     = @"bubbleUpperLeftURL";
NSString * const kBubbleUpperRightURLKey    = @"bubbleUpperRightURL";
NSString * const kBubbleBottomLeftURLKey    = @"bubbleBottomLeftURL";
NSString * const kBubbleBottomRightURLKey   = @"bubbleBottomRightURL";
NSString * const kBubbleSnapshotImageURLKey = @"bubbleSnapshotImageURL";
NSString * const kBubbleTypeKey             = @"bubbleType";
NSString * const kBubbleDirectionKey        = @"bubbleDirection";

@interface BubbleObject()
@end

// MARK: -
@implementation BubbleObject

- (id)initWithText:(NSString *)txt bubbleID:(NSString *)ID {
    return [self initWithText:txt bubbleID:ID withDirection:BubbleDirectionUpperLeft];
}

- (id)initWithText:(NSString *)txt bubbleID:(NSString *)ID withDirection:(BubbleObjectDirection)direction {
	self = [super init];
	if (self) {
		self.objType = ObjectBubble;
		self.text = txt;
        
		self.bubbleURL = [[NSBundle mainBundle] URLForResource:ID withExtension:@""];
        [self setResourceID:ID forDirection:direction];
        
        self.frame = [self restoreFrameSizeFromURL:self.bubbleURL];
        _currentDirection = direction;
        _bubbleSnapshotImageURL = [NSURL new];
	}
	
	return self;
}

- (BaseObject *)initFromDict:(NSDictionary *)dict {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSDictionary *baseDict = (NSDictionary *)dict[kBaseInfoKey];
    self.objType = (ComicObjectType)[baseDict[kTypeKey] integerValue];
    self.angle = [baseDict[kAngleKey] floatValue];
    self.scale = [baseDict[kScaleKey] floatValue];
    self.delayTimeInSeconds = [baseDict[kDelayTimeKey] floatValue];
    
    _text = dict[kTextKey];
    
    NSString *bubbleImageFileName = [[dict objectForKey:kBubbleURLKey] lastPathComponent];
    NSString *bubbleUpperLeftFileName = [[dict objectForKey:kBubbleUpperLeftURLKey] lastPathComponent];
    NSString *bubbleUpperRightFileName = [[dict objectForKey:kBubbleUpperRightURLKey] lastPathComponent];
    NSString *bubbleBottomLeftFileName = [[dict objectForKey:kBubbleBottomLeftURLKey] lastPathComponent];
    NSString *bubbleBottomRightFileName = [[dict objectForKey:kBubbleBottomRightURLKey] lastPathComponent];
    
    NSBundle *bundle = [NSBundle mainBundle];
    _bubbleURL = [bundle URLForResource:bubbleImageFileName withExtension:@""];
    _bubbleUpperLeftURL = [bundle URLForResource:bubbleUpperLeftFileName withExtension:@""];
    _bubbleUpperRightURL = [bundle URLForResource:bubbleUpperRightFileName withExtension:@""];
    _bubbleBottomLeftURL = [bundle URLForResource:bubbleBottomLeftFileName withExtension:@""];
    _bubbleBottomRightURL = [bundle URLForResource:bubbleBottomRightFileName withExtension:@""];    
    _bubbleSnapshotImageURL = [NSURL fileURLWithPath:dict[kBubbleSnapshotImageURLKey]];
    if (!_bubbleSnapshotImageURL) {
        _bubbleSnapshotImageURL = [NSURL new];
    }
    
    _currentType = (BubbleObjectType) [dict[kBubbleTypeKey] integerValue];
    _currentDirection = (BubbleObjectDirection) [dict[kBubbleDirectionKey] integerValue];
    
    //    self.frame = CGRectFromString(baseDict[kFrameKey]);
    CGRect rectWithOriginalImageSize = [self restoreFrameSizeFromURL:self.bubbleURL];
    CGRect savedFrameWithCorrectOrigins = CGRectFromString(baseDict[kFrameKey]);
    self.frame = CGRectMake(savedFrameWithCorrectOrigins.origin.x,
                            savedFrameWithCorrectOrigins.origin.y,
                            savedFrameWithCorrectOrigins.size.width,
                            savedFrameWithCorrectOrigins.size.height);
    
    return self;
}

- (NSDictionary *)dictForObject {
    NSDictionary *dict = [super dictForObject];
    return @{
             kBaseInfoKey: dict,
             kTextKey: _text,
             kBubbleURLKey: self.bubbleURL.absoluteString,
             kBubbleUpperLeftURLKey: self.bubbleUpperLeftURL.absoluteString,
             kBubbleUpperRightURLKey: self.bubbleUpperRightURL.absoluteString,
             kBubbleBottomLeftURLKey: self.bubbleBottomLeftURL.absoluteString,
             kBubbleBottomRightURLKey: self.bubbleBottomRightURL.absoluteString,
             kBubbleSnapshotImageURLKey: self.bubbleSnapshotImageURL.absoluteString,
             kBubbleTypeKey: @(_currentType),
             kBubbleDirectionKey: @(_currentDirection)
             };
}

- (void)changeBubbleTypeTo:(BubbleObjectType)bubbleType {
    if (self.currentType != bubbleType) {
        _currentType = bubbleType;
    }
}

- (void)switchBubbleURLToDirection:(BubbleObjectDirection)direction {
    NSURL *bubbleDirectionRelatedURL;
    switch (direction) {
        case BubbleDirectionUpperLeft:
            bubbleDirectionRelatedURL = _bubbleUpperLeftURL;
            break;
            
        case BubbleDirectionUpperRight:
            bubbleDirectionRelatedURL = _bubbleUpperRightURL;
            break;
            
        case BubbleDirectionBottomLeft:
            bubbleDirectionRelatedURL = _bubbleBottomLeftURL;
            break;
            
        case BubbleDirectionBottomRight:
            bubbleDirectionRelatedURL = _bubbleBottomRightURL;
            break;
    }
    if (bubbleDirectionRelatedURL) {
        self.bubbleURL = bubbleDirectionRelatedURL;
        _currentDirection = direction;
    }
}

- (void)setResourceID:(NSString *)resourceID forDirection:(BubbleObjectDirection)direction {
    if (!resourceID || resourceID.length == 0) {
        return;
    }
    
    NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:resourceID withExtension:@""];
    switch (direction) {
        case BubbleDirectionUpperLeft:
            _bubbleUpperLeftURL = resourceURL;
            break;
            
        case BubbleDirectionUpperRight:
            _bubbleUpperRightURL = resourceURL;
            break;
            
        case BubbleDirectionBottomLeft:
            _bubbleBottomLeftURL = resourceURL;
            break;
            
        case BubbleDirectionBottomRight:
            _bubbleBottomRightURL = resourceURL;
            break;
    }
}

- (CGRect)restoreFrameSizeFromURL:(NSURL *)bubbleURL {
    NSData *bubbdleImageData = [NSData dataWithContentsOfURL:bubbleURL];
    UIImage *bubbleImage = [UIImage imageWithData:bubbdleImageData];
    return CGRectMake(0, 0, bubbleImage.size.width / 2, bubbleImage.size.height /2);
}

@end
