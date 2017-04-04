//
//  BaseObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <stdlib.h>


typedef enum {
	ObjectBaseImage		= 0x10,	// object type for background GIF/Image
	ObjectAnimateGIF,			// object type for animation GIF
	ObjectSticker,				// object type for sticker
	ObjectBubble,				// object type for bubble
	ObjectCaption,				// object type for caption
	ObjectPen					// object type for pen
} ComicObjectType;


// MARK: -
@interface BaseObject : NSObject

@property (nonatomic) ComicObjectType objType;

@property (nonatomic) CGRect frame;		// frame of object to show on the view
@property (nonatomic) CGFloat angle;	// rotated radian angle of object. default is 0


// create base object by type and parameter sender
+ (BaseObject *)comicObjectWith:(ComicObjectType)type userInfo:(id)sender;

- (NSDictionary *)dictForObject;
- (BaseObject *)initFromDict:(NSDictionary *)dict;

@end