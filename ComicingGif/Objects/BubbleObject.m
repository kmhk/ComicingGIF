//
//  BubbleObject.m
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BubbleObject.h"


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
    NSDictionary *baseDict = (NSDictionary *)dict[@"baseInfo"];
    self.objType = (ComicObjectType)[baseDict[@"type"] integerValue];
    self.angle = [baseDict[@"angle"] floatValue];
    self.scale = [baseDict[@"scale"] floatValue];
    self.delayTimeInSeconds = [baseDict[@"delayTime"] floatValue];
    
    _text = dict[@"text"];
    
    NSString *bubbleImageFileName = [[dict objectForKey:@"bubbleURL"] lastPathComponent];
    NSString *bubbleUpperLeftFileName = [[dict objectForKey:@"bubbleUpperLeftURL"] lastPathComponent];
    NSString *bubbleUpperRightFileName = [[dict objectForKey:@"bubbleUpperRightURL"] lastPathComponent];
    NSString *bubbleBottomLeftFileName = [[dict objectForKey:@"bubbleBottomLeftURL"] lastPathComponent];
    NSString *bubbleBottomRightFileName = [[dict objectForKey:@"bubbleBottomRightURL"] lastPathComponent];
    
    NSBundle *bundle = [NSBundle mainBundle];
    _bubbleURL = [bundle URLForResource:bubbleImageFileName withExtension:@""];
    _bubbleUpperLeftURL = [bundle URLForResource:bubbleUpperLeftFileName withExtension:@""];
    _bubbleUpperRightURL = [bundle URLForResource:bubbleUpperRightFileName withExtension:@""];
    _bubbleBottomLeftURL = [bundle URLForResource:bubbleBottomLeftFileName withExtension:@""];
    _bubbleBottomRightURL = [bundle URLForResource:bubbleBottomRightFileName withExtension:@""];    
    _bubbleSnapshotImageURL = [NSURL fileURLWithPath:dict[@"bubbleSnapshotImageURL"]];
    if (!_bubbleSnapshotImageURL) {
        _bubbleSnapshotImageURL = [NSURL new];
    }
    
    _currentType = (BubbleObjectType) [dict[@"bubbleType"] integerValue];
    _currentDirection = (BubbleObjectDirection) [dict[@"bubbleDirection"] integerValue];
    
    //    self.frame = CGRectFromString(baseDict[@"frame"]);
    CGRect rectWithOriginalImageSize = [self restoreFrameSizeFromURL:self.bubbleURL];
    CGRect savedFrameWithCorrectOrigins = CGRectFromString(baseDict[@"frame"]);
    self.frame = CGRectMake(savedFrameWithCorrectOrigins.origin.x,
                            savedFrameWithCorrectOrigins.origin.y,
                            rectWithOriginalImageSize.size.width,
                            rectWithOriginalImageSize.size.height);
    
    return self;
}

- (NSDictionary *)dictForObject {
    NSDictionary *dict = [super dictForObject];
    return @{
             @"baseInfo": dict,
             @"text": _text,
             @"bubbleURL": self.bubbleURL.absoluteString,
             @"bubbleUpperLeftURL": self.bubbleUpperLeftURL.absoluteString,
             @"bubbleUpperRightURL": self.bubbleUpperRightURL.absoluteString,
             @"bubbleBottomLeftURL": self.bubbleBottomLeftURL.absoluteString,
             @"bubbleBottomRightURL": self.bubbleBottomRightURL.absoluteString,
             @"bubbleSnapshotImageURL": self.bubbleSnapshotImageURL.absoluteString,
             @"bubbleType": @(_currentType),
             @"bubbleDirection": @(_currentDirection)
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
    return CGRectMake(0, 0, bubbleImage.size.width, bubbleImage.size.height);
}

@end
