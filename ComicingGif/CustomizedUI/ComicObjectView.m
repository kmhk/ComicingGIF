//
//  ComicObjectView.m
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ComicObjectView.h"
#import "ObjectHeader.h"


@interface ComicObjectView()
@end


// MARK: -
@implementation ComicObjectView

- (id)initWithComicObject:(BaseObject *)obj {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	self.comicObject = obj;
	
	if (obj.objType == ObjectBaseImage) {
		[self createBaseImageView];
		
	} else if (obj.objType == ObjectSticker) {
		[self createStickerView];
		
	} else if (obj.objType == ObjectBubble) {
		[self createBubbleView];
		
	} else if (obj.objType == ObjectCaption) {
		[self createCaptionView];
		
	} else if (obj.objType == ObjectPen) {
		[self createPenView];
	}
	
	return self;
}


// MARK: - priviate create methods
- (void)createBaseImageView {
	
}

- (void)createStickerView {
	
}

- (void)createBubbleView {
	
}

- (void)createCaptionView {
	
}

- (void)createPenView {
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


// MARK: - touch event implementations



@end
