//
//  CBPreviewHeaderCell.m
//  ComicBook
//
//  Created by Atul Khatri on 07/12/16.
//  Copyright © 2016 Providence. All rights reserved.
//

#import "CBPreviewHeaderCell.h"
#import "AppConstants.h"

@interface CBPreviewHeaderCell() <UITextViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation CBPreviewHeaderCell

- (void)initialSetup {
    self.titleTextView.delegate = self;
    self.titleTextView.returnKeyType = UIReturnKeyDone;
    [self addGesture];
}

- (void)setFontWithName:(NSString *)fontName {
    if (fontName.length == 0) {
        fontName = @"Comic Sans MS";
    }
    _fontName = fontName;
    
    float fontSize;
    if (IS_IPHONE_5) {
        fontSize = _titleTextView.text.length <= 8? 43: 20;
    } else if (IS_IPHONE_6) {
        fontSize = _titleTextView.text.length <= 8? 44: 25;
    } else if (IS_IPHONE_6P) {
        fontSize = _titleTextView.text.length <= 8? 48: 28;
    } else {
        fontSize = _titleTextView.text.length <= 8? 50: 30;
    }
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    [_titleTextView setFont:font];
}

- (void)addGesture {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(holdGesture:)];
    longPressGesture.delegate = self;
    [_gestureButton addGestureRecognizer:longPressGesture];}

- (void)holdGesture:(UILongPressGestureRecognizer *)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(holdGesture:)]) {
        [_delegate holdGesture:_titleTextView];
    }
}

- (IBAction)buttonTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tapGesture:)]) {
        _gestureButton.hidden = YES;
        [_titleTextView becomeFirstResponder];
        
        [_delegate tapGesture:_titleTextView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        _gestureButton.hidden = NO;
        [textView resignFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(textUpdated:)]) {
            [_delegate textUpdated:_titleTextView.text];
        }
        return NO;
    }
    
    if ([textView.text stringByReplacingCharactersInRange:range withString:text].length >= 29) {
        return NO;
    }
    [self setFontWithName:_fontName];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self setFontWithName:_fontName];
    [_titleTextView scrollRangeToVisible:NSMakeRange(0, _titleTextView.text.length)];
}

@end
