//
//  HeaderView.m
//  ComicApp
//
//  Created by Ramesh on 26/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
        
        [self addSubview:self.view];
        
        self.view3Holder.layer.cornerRadius = self.view3Holder.frame.size.width/2;
        self.view3Holder.layer.masksToBounds = YES;
        
        self.view2Holder.layer.cornerRadius = self.view2Holder.frame.size.width/2;
        self.view3Holder.layer.masksToBounds = YES;
        
        self.view1Holder.layer.cornerRadius = self.view1Holder.frame.size.width/2;
        self.view1Holder.layer.masksToBounds = YES;
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
