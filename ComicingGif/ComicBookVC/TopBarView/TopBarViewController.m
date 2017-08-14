//
//  TopBarViewController.m
//  CurlDemo
//
//  Created by Vishnu Vardhan PV on 02/02/16.
//  Copyright © 2016 Vishnu Vardhan PV. All rights reserved.
//

#import "TopBarViewController.h"
#import "AppConstants.h"
#import "NSLayoutConstraint+Multiplier.h"

@interface TopBarViewController()<UITextFieldDelegate>
{

    __weak IBOutlet UIButton *btn_home;
   
    __weak IBOutlet NSLayoutConstraint *const_LeadingHome;
}

@property (weak, nonatomic) IBOutlet UITextField *txtSearchFiled;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIImageView *topViewLogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comicBoyLeadingLeft;

@end

@implementation TopBarViewController

-(void)viewDidLoad{
    _txtSearchFiled.userInteractionEnabled = NO;
    if (IS_IPHONE_5) {
        self.comicBoyLeadingLeft.constant = 20;
    }
    
}
- (IBAction)tappedHomeButton:(id)sender {
    if(self.homeAction) {
        self.homeAction();
    }
}

- (IBAction)tappedContactButton:(id)sender {
    if(self.contactAction) {
        self.contactAction();
    }
}

- (IBAction)tappedMeButton:(id)sender {
    if(self.meAction) {
        self.meAction();
    }
}

- (IBAction)tappedSearchButton:(id)sender {
    if (self.searchAction) {
        self.searchAction();
    }
}

#pragma mark Search Methods

-(void)handleSearchControl:(BOOL)isActiveSearch{
    if (isActiveSearch) {
        [self.txtSearchFiled setText:@""];
        [self.btnSearch setUserInteractionEnabled:YES];
        [self.txtSearchFiled setHidden:NO];
        _txtSearchFiled.userInteractionEnabled = YES;
        [self.topViewLogo setHidden:YES];
        [self.txtSearchFiled becomeFirstResponder];
    }else{
        [self.btnSearch setUserInteractionEnabled:YES];
        [self.txtSearchFiled setHidden:YES];
        _txtSearchFiled.userInteractionEnabled = NO;
        [self.topViewLogo setHidden:NO];
        [self.txtSearchFiled resignFirstResponder];
        [self.btnSearch setHidden:YES];
    }
}


#pragma TextField Delegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtSearchFiled resignFirstResponder];
    [self doFriendsSearch:textField.text];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    //    [self handleSearchControl:NO];
    return NO;
}

#pragma mark search api

-(void)doFriendsSearch:(NSString*)searchText{
    if (self.searchUser) {
        self.searchUser(searchText);
    }
}
-(void)setIsHomeHidden:(BOOL)isHomeHidden
{
    _isHomeHidden = isHomeHidden;
    if (isHomeHidden)
    {
        CGFloat diff;
        if (IS_IPHONE_5)
        {
            diff = 3;
        }
        else if (IS_IPHONE_6)
        {
            diff = 7;
        }
        else if (IS_IPHONE_6P)
        {
            diff = 8;

        }
        else
        {
            diff = 5;

        }
        const_LeadingHome.constant = -7-btn_home.bounds.size.width-diff-6;
        btn_home.hidden = YES;
    }
    else
    {
        const_LeadingHome.constant = -7;
        btn_home.hidden = NO;
       
    }
    [self.view layoutIfNeeded];
}
@end
