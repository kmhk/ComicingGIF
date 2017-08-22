//
//  ComicImageCollectionCell.m
//  ComicApp
//
//  Created by Ramesh on 02/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "ComicImageCollectionCell.h"

@implementation ComicImageCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ComicImageCollectionCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

@end
