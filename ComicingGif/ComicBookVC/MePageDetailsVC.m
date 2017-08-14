//
//  MePageDetailsVC.m
//  CurlDemo
//
//  Created by Subin Kurian on 11/10/15.
//  Copyright © 2015 Subin Kurian. All rights reserved.
//

#import "MePageDetailsVC.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "AppHelper.h"

@interface MePageDetailsVC ()
@property (weak, nonatomic) IBOutlet UISlider *thermostat_Slider;
@property (weak, nonatomic) IBOutlet UIImageView *innerThermo_ImageView;
@property (weak, nonatomic) IBOutlet UIView *thermostatView;
@property (weak, nonatomic) IBOutlet UIImageView *wow_ImageView;
@end

@implementation MePageDetailsVC

- (void)viewDidLoad {
    
    [[GoogleAnalytics sharedGoogleAnalytics] logScreenEvent:@"MePageDetails" Attributes:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.coverImg layer].borderColor=[UIColor whiteColor].CGColor;
    [self.coverImg layer].borderWidth=5;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:self.comicBook.coverImage]];
    
    [_innerThermo_ImageView setImage:[self CropImageFromTop:[UIImage imageNamed:@"innerThermo"] :140]];
    
    // slider
    // vertical slider
    CGAffineTransform sliderRotation = CGAffineTransformIdentity;
    sliderRotation = CGAffineTransformRotate(sliderRotation, -(M_PI / 2));
    _thermostat_Slider.transform = sliderRotation;
    // setting Value
    
    _thermostat_Slider.minimumValue = 0;
    _thermostat_Slider.maximumValue = 140;
    
    [_thermostat_Slider setThumbImage:[UIImage imageNamed:@"invisible"]
                             forState:UIControlStateNormal];
    [_thermostat_Slider setThumbImage:[UIImage imageNamed:@""]
                             forState:UIControlStateHighlighted];
    [_thermostat_Slider setMinimumTrackImage:[UIImage imageNamed:@"invisible"]
                                    forState:UIControlStateNormal];
    [_thermostat_Slider setMaximumTrackImage:[UIImage imageNamed:@"invisible"]
                                    forState:UIControlStateNormal];
    [_innerThermo_ImageView setImage:[self CropImageFromTop:[UIImage imageNamed:@"innerThermo"] :(140-130)]];
  
    

    [_thermostat_Slider setValue:130 animated:YES];
    
    
}
- (IBAction)sliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
   // [_wow_ImageView setFrame:CGRectMake(rectWow.origin.x - val, rectWow.origin.y - val, rectWow.size.width  + val, rectWow.size.height+ val )];
    

    // showing value with slider
    [_innerThermo_ImageView setImage:[self CropImageFromTop:[UIImage imageNamed:@"innerThermo"] :(140-val)]];
    

}
-(UIImage *) CropImageFromTop:(UIImage *)image :(NSInteger) vl
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, vl, image.size.width, image.size.height));
    UIImage *cropimage = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropimage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comicBook.comments count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    UIImageView*imageView=(UIImageView*)[cell viewWithTag:1];
    UILabel*labl=(UILabel*)[cell viewWithTag:2];

        imageView.layer.cornerRadius =  imageView.frame.size.width / 2;
        imageView.clipsToBounds = YES;
        imageView.layer.masksToBounds=YES;
        labl.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        return cell;
        
    }
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView*imageView=(UIImageView*)[cell viewWithTag:1];
    UILabel*labl=(UILabel*)[cell viewWithTag:2];
    
    CommentModel *commentModel = [self.comicBook.comments objectAtIndex:indexPath.row];
    [imageView sd_setImageWithURL:[NSURL URLWithString:commentModel.profilePic] placeholderImage:nil options:SDWebImageRetryFailed];
    labl.text = commentModel.commentText;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - statusbar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
@end
