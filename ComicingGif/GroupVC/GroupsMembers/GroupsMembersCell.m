//
//  GroupSectionCell.m
//  ComicApp
//
//  Created by Ramesh on 24/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "GroupsMembersCell.h"

@implementation GroupsMembersCell

- (void)awakeFromNib {
    // Initialization code
    
    self.groupImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.groupImage.layer.cornerRadius= self.groupImage.frame.size.width/2;
    self.groupImage.layer.borderWidth=2.0;
    self.groupImage.layer.masksToBounds = YES;
    self.groupImage.layer.borderColor=[[UIColor clearColor] CGColor];
    
    self.btnAddMember.layer.backgroundColor=[[UIColor clearColor] CGColor];
//    self.btnAddMember.layer.cornerRadius= self.btnAddMember.frame.size.width/2;
//    self.btnAddMember.layer.borderWidth= 1.5;
//    self.btnAddMember.layer.masksToBounds = YES;
//    self.btnAddMember.layer.borderColor=[[UIColor blackColor] CGColor];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GroupsMembersCell" owner:self options:nil];
        
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
