//
//  GroupItem.m
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "GroupItem.h"

@implementation GroupItem

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"GroupItem" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
