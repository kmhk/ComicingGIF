//
//  StickerObject.h
//  ComicingGif
//
//  Created by Com on 31/03/2017.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

@interface StickerObject : BaseObject

// sticker or gif resource name
@property (nonatomic) NSString *resourceName;

// create sticker/animationGIF with source name. if flag is YES, anmation GIF. otherwise sticker.
- (id)initWithResourceID:(NSString *)name isGif:(BOOL)flag;

@end
