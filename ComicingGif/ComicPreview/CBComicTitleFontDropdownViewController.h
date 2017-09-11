//
//  CBComicTitleFontDropdownViewController.h
//  ComicBook
//
//  Created by Amit on 13/01/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBBaseViewController.h"

@protocol TitleFontDelegate <NSObject>

- (void)getSelectedFontName:(NSString *)fontName andTitle:(NSString *)title;

@end

@interface CBComicTitleFontDropdownViewController : CBBaseViewController

@property(weak, nonatomic) id<TitleFontDelegate> delegate;
@property(strong, nonatomic) NSString *titleText;

@end
