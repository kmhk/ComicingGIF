//
//  ComicBookColorCBViewController.h
//  ComicBook
//
//  Created by Amit on 17/01/17.
//  Copyright © 2017 Providence. All rights reserved.
//

#import "CBBaseViewController.h"

@protocol ComicBookColorCBViewControllerDelegate <NSObject>

//- (void)getSelectedColor:(UIColor *)color;
- (void)getSelectedColor:(UIColor *)color andComicBackgroundImageName:(NSString *)backgroundImageName;

@end

@interface ComicBookColorCBViewController : CBBaseViewController

@property(assign, nonatomic) id<ComicBookColorCBViewControllerDelegate> delegate;

@property(assign, nonatomic) CGRect frameOfRainbowCircle;

@end
