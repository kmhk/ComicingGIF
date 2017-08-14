//
//  CBPreviewHeaderCell.h
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBBaseTableViewCell.h"

@protocol CBPreviewHeaderDelegate <NSObject>

- (void)holdGesture:(UIView *)view;
- (void)tapGesture:(UIView *)view;
- (void)textUpdated:(NSString *)text;

@end

@interface CBPreviewHeaderCell : CBBaseTableViewCell
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIButton *horizontalAddButton;
@property (weak, nonatomic) IBOutlet UIButton *verticalAddButton;
@property (weak, nonatomic) IBOutlet UIButton *rainbowColorCircleButton;

@property(strong, nonatomic) IBOutlet UIButton *gestureButton;
@property(assign, nonatomic) id<CBPreviewHeaderDelegate> delegate;

@property (strong, nonatomic) NSString *fontName;

- (void)initialSetup;
- (void)setFontWithName:(NSString *)fontName;

@end
