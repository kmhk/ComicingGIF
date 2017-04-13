//
//  UIImageView+Downloader.m
//  ComicApp
//
//  Created by Ramesh on 22/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "UIImageView+Downloader.h"

@implementation UIImageView (Downloader)


#pragma image Download

- (void)downloadImageWithURL:(NSURL *)url
            placeHolderImage:(UIImage*)placeholder
             completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    self.image = placeholder;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

@end
