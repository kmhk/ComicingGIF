//
//  CMCGroupCell.m
//  ComicApp
//
//  Created by ADNAN THATHIYA on 01/11/15.
//  Copyright (c) 2015 ADNAN THATHIYA. All rights reserved.
//

#import "CMCComicCell.h"
#import "CMCUser.h"

@interface CMCComicCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgvUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgvComic;


@end

@implementation CMCComicCell

@synthesize comic, imgvComic, imgvUser, lblDate, lblTime, lblUsername;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComic:(CMCComic *)comicInfo
{
    lblDate.numberOfLines = 1;
    lblDate.minimumScaleFactor = 1;
    lblDate.adjustsFontSizeToFitWidth = YES;
    
    comic = comicInfo;
    
    CMCUser *comicUser = comic.creator;
    
    imgvUser.image  = comicUser.imgProfile;
    imgvUser.layer.cornerRadius = CGRectGetHeight(imgvUser.frame) / 2;
    imgvUser.clipsToBounds = YES;
    
    lblUsername.text = comicUser.name;
    
    lblDate.text = comic.date;
    lblTime.text = comic.time;
    
    imgvComic.image = comic.imgComic;
}

@end
