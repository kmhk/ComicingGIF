//
//  ProfilePicView.m
//  ComicApp
//
//  Created by Ramesh on 10/12/15.
//  Copyright © 2015 Ramesh. All rights reserved.
//

#import "ProfilePicView.h"

@implementation ProfilePicView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"ProfilePicView" owner:self options:nil];
        self.view.frame = self.frame;
        [self addSubview:self.view];
        
        [self configView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //Load from xib
        [[NSBundle mainBundle] loadNibNamed:@"ProfilePicView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self configView];
        [self bindData];
    }
    return self;
}


#pragma Methods

-(void)configView{
    
    [self setTextFont];
    
}

-(void)setTextFont{
    
    [self.headText setFont:[UIFont  fontWithName:@"Myriad Roman" size:28]];
    self.headText.text = @"Take a Selfie and \n Cut out your Profile Pic";
}

-(void)bindData{
    [self bindProfilePic];
}

-(void)bindProfilePic{
    [self.imgSelectedImage setImage:[UIImage imageNamed:@"selectedImage.png"]];
}

#pragma Events

- (IBAction)btnDoneClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getProfilePicRequest)])
    {
        [self.delegate getProfilePicRequest];
    }
}

- (IBAction)btnCamClick:(id)sender {
}
- (IBAction)btnBackClick:(id)sender {
}
- (IBAction)btnUpLoadClick:(id)sender {
}
- (IBAction)btnCloseClick:(id)sender {
}

@end
