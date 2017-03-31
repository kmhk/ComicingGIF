//
//  BaseObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
	ObjectBaseImage		= 0,	// object type for background GIF/Image
	ObjectSticker,				// object type for sticker & animation GIF
	ObjectBubble,				// object type for bubble
	ObjectCaption,				// object type for caption
	ObjectPen					// object type for pen
} ComicObjectType;


// MARK: -
@interface BaseObject : NSObject

@property (nonatomic) ComicObjectType objType;

@property (nonatomic) CGRect frame;		// frame of object to show on the view
@property (nonatomic) CGFloat angle;	// rotated radian angle of object. default is 0

@end
