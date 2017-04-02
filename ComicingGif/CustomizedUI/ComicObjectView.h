//
//  ComicObjectView.h
//  ComicingGif
//
//  Created by Com on 01/04/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseObject;


@interface ComicObjectView : UIView

@property (nonatomic) BaseObject *comicObject;


// create comic object view from obj
- (id)initWithComicObject:(BaseObject *)obj;

@end
