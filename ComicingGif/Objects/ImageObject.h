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
// Image animation duration
@property (nonatomic) CFTimeInterval duratoin;
/// URL of image file
@property (nonatomic) NSURL *fileURL;
/// Init with image URL
- (id)initWithURL:(NSURL *)url;
@end
