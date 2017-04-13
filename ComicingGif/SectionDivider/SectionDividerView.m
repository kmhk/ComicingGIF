//
//  SectionDividerView.m
//  ComicApp
//
//  Created by Ramesh on 22/11/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "SectionDividerView.h"

@implementation SectionDividerView

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
        [[NSBundle mainBundle] loadNibNamed:@"SectionDividerView" owner:self options:nil];
        
        [self addSubview:self.view];
        [self configView];
    }
    return self;
}

-(void)configView{
//
//    CGRect viewRect = self.view.frame;
//    viewRect.size.width = [[UIScreen mainScreen] bounds].size.width;
//    self.view.frame = viewRect;
    
    [self.view setBackgroundColor:[UIColor colorWithHexStr:@"B4E4F5"]];
}


#pragma InitMethods

-(id)initWithHeaderText:(NSString*)headText{
    sectionText = headText;
    return [self initWithFrame:self.frame];
}

@end
