//
//  ImageObject.h
//  ComicingGif
//
//  Created by Sergii Gordiienko on 9/14/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "BaseObject.h"

@interface ImageObject : BaseObject
// Image frames
@property (nonatomic) NSArray <UIImage *> *frameImages;
// Scalled images for preview
@property (nonatomic) NSArray <UIImage *> *scalledFrameImages;
// Image animation duration
@property (nonatomic) CFTimeInterval duration;
/// URL of image file
@property (nonatomic) NSURL *fileURL;
/// Init with image URL
- (id)initWithURL:(NSURL *)url;
@end
