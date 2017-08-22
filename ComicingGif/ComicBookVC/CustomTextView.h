
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
	#define NSTextAlignment UITextAlignment
#endif

@class CustomTextView;
@class TextViewInternal;

@protocol CustomTextViewDelegate

@optional
- (BOOL)growingTextViewShouldBeginEditing:(CustomTextView *)growingTextView;
- (BOOL)growingTextViewShouldEndEditing:(CustomTextView *)growingTextView;

- (void)growingTextViewDidBeginEditing:(CustomTextView *)growingTextView;
- (void)growingTextViewDidEndEditing:(CustomTextView *)growingTextView;

- (BOOL)growingTextView:(CustomTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)growingTextViewDidChange:(CustomTextView *)growingTextView;

- (void)growingTextView:(CustomTextView *)growingTextView willChangeHeight:(float)height;
- (void)growingTextView:(CustomTextView *)growingTextView didChangeHeight:(float)height;

- (void)growingTextViewDidChangeSelection:(CustomTextView *)growingTextView;
- (BOOL)growingTextViewShouldReturn:(CustomTextView *)growingTextView;
@end

@interface CustomTextView : UIView <UITextViewDelegate> {
	TextViewInternal *internalTextView;	
	
	int minHeight;
	int maxHeight;
	
	//class properties
	int maxNumberOfLines;
	int minNumberOfLines;
	
	BOOL animateHeightChange;
    NSTimeInterval animationDuration;
	
	//uitextview properties
	NSObject <CustomTextViewDelegate> *__unsafe_unretained delegate;
	NSTextAlignment textAlignment;
	NSRange selectedRange;
	BOOL editable;
	UIDataDetectorTypes dataDetectorTypes;
	UIReturnKeyType returnKeyType;
	UIKeyboardType keyboardType;
    
    UIEdgeInsets contentInset;
}

//real class properties
@property int maxNumberOfLines;
@property int minNumberOfLines;
@property (nonatomic) int maxHeight;
@property (nonatomic) int minHeight;
@property BOOL animateHeightChange;
@property NSTimeInterval animationDuration;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UITextView *internalTextView;	


//uitextview properties
@property(unsafe_unretained) NSObject<CustomTextViewDelegate> *delegate;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIFont *font;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic) NSTextAlignment textAlignment;    // default is NSTextAlignmentLeft
@property(nonatomic) NSRange selectedRange;            // only ranges of length 0 are supported
@property(nonatomic,getter=isEditable) BOOL editable;
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_0);
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) UIKeyboardType keyboardType;
@property (assign) UIEdgeInsets contentInset;
@property (nonatomic) BOOL isScrollable;
@property(nonatomic) BOOL enablesReturnKeyAutomatically;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
- (id)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer;
#endif

//uitextview methods
//need others? use .internalTextView
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)isFirstResponder;

- (BOOL)hasText;
- (void)scrollRangeToVisible:(NSRange)range;

// call to force a height change (e.g. after you change max/min lines)
- (void)refreshHeight;

@end
