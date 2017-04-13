//
//  UIImageView+Downloader.h
//  ComicApp
//
//  Created by Ramesh on 22/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Downloader)

- (void)downloadImageWithURL:(NSURL *)url
            placeHolderImage:(UIImage*)placeholder
             completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end
