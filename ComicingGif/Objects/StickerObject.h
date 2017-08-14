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
@property (nonatomic) NSURL *stickerURL;

// create sticker/animationGIF with resource ID. if flag is YES, anmation GIF. otherwise sticker.
- (id)initWithResourceID:(NSString *)ID isGif:(BOOL)flag;

// create sticker/animationGIF with url string. if flag is YES, anmation GIF. otherwise sticker.
- (id)initWithURL:(NSString *)urlString isGif:(BOOL)flag;

@end
