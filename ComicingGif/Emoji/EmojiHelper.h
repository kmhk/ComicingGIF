//
//  EmojiHelper.h
//  EmojiFun
//
//  Created by Sabatino Masala on 01/10/15.
//  Copyright © 2015 Sabatino Masala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyEmojiCategory.h"

@interface NSObject (UIKeyboardEmojiCategory)

//+ (NSInteger)numberOfCategories;
//+ (id)categoryForType:(NSInteger)type;
//+ (id)displayName:(int)arg1;
//- (void)setEmoji:(id)arg1;
//+ (id)computeEmojiFlagsSortedByLanguage;

@property (assign) long long categoryType;                                       //@synthesize categoryType=_categoryType - In the implementation block
@property (retain) NSArray * emoji;                                              //@synthesize emoji=_emoji - In the implementation block
@property (assign,nonatomic) long long lastVisibleFirstEmojiIndex;               //@synthesize lastVisibleFirstEmojiIndex=_lastVisibleFirstEmojiIndex - In the implementation block
@property (getter=name,nonatomic,readonly) NSString * name;
@property (getter=displaySymbol,readonly) NSString * displaySymbol;              //@synthesize displaySymbol=_displaySymbol - In the implementation block

+(id)localizedStringForKey:(id)arg1 ;
+(long long)numberOfCategories;
+(id)categoryForType:(long long)arg1 ;
+(id)displayName:(long long)arg1 ;
+(id)categories;
+(BOOL)emojiString:(id)arg1 inGroup:(unsigned*)arg2 withGroupCount:(int)arg3 ;
+(unsigned long long)hasVariantsForEmoji:(id)arg1 ;
+(id)flagEmojiCountryCodesCommon;
+(id)flagEmojiCountryCodesReadyToUse;
+(id)stringToRegionalIndicatorString:(id)arg1 ;
+(id)computeEmojiFlagsSortedByLanguage;
+(id)emojiRecentsFromPreferences;
+(id)loadPrecomputedEmojiFlagCategory;
-(void)dealloc;
-(NSArray *)emoji;
-(NSString *)name;
-(void)setEmoji:(NSArray *)arg1 ;
-(void)setLastVisibleFirstEmojiIndex:(long long)arg1 ;
-(long long)categoryType;
-(long long)lastVisibleFirstEmojiIndex;
-(void)setCategoryType:(long long)arg1 ;
-(void)releaseCategories;
-(NSString *)displaySymbol;

@end

@interface EmojiHelper : NSObject

+ (NSArray<MyEmojiCategory *> *)getEmoji;

@end
