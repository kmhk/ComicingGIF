//
//  GlideCell.m
//  ComicMakingPage
//
//  Created by ADNAN THATHIYA on 09/01/16.
//  Copyright © 2016 ADNAN THATHIYA. All rights reserved.
//

#import "GlideCell.h"

@implementation GlideCell

@synthesize comicPage,imgvComic;

- (void)setComicPage:(ComicPage *)comicPageInfo
{
    comicPage = comicPageInfo;
    
//    imgvComic.image = [UIImage imageWithData:comicPage.printScreen];
}

@end
