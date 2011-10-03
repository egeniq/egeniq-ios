//
//  NSMutableAttributedString+ConvenienceSpec.m
//
//  Created by Allen Ding on 10/2/11.
//  Copyright (c) 2011 Egeniq. All rights reserved.
//

#import "Kiwi.h"
#import <CoreText/CoreText.h>
#import "NSMutableAttributedString+Convenience.h"

SPEC_BEGIN(NSMutableAttributedStringConvenienceSpec)

describe(@"NSMutableAttributedString", ^{
    describe(@"applyAttributesFontName:size:bold:italic:toRange:", ^{
        it(@"should apply all the given attributes", ^{
            // Given
            NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:@"Hello world"] autorelease];
            
            // When
            [string applyAttributesFontName:@"Helvetica" size:20.0 bold:YES italic:YES toRange:NSMakeRange(0, [string length])];
            
            // Then
            NSDictionary *attributes = [string attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, [string length])];
            CTFontRef font = (CTFontRef)[attributes objectForKey:(id)kCTFontAttributeName];
            NSDictionary *traits = [(id)CTFontCopyTraits(font) autorelease];
            id number = [traits objectForKey:(id)kCTFontSymbolicTrait];
            CTFontSymbolicTraits symbolicTraits = [number intValue];
            
            // Name
            NSString *name = [(id)CTFontCopyFamilyName(font) autorelease];
            [[name should] equal:@"Helvetica"];
            
            // Size
            CGFloat size = CTFontGetSize(font);
            [[theValue(size) should] equal:theValue(20.0)];
            
            // Bold
            [[theValue(symbolicTraits & kCTFontBoldTrait) should] equal:theValue(kCTFontBoldTrait)];
            
            // Italic
            [[theValue(symbolicTraits & kCTFontItalicTrait) should] equal:theValue(kCTFontItalicTrait)];
        });
        
        it(@"should apply attributes to the given range", ^{
            // Given
            NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:@"Hello world"] autorelease];
            NSUInteger appliedLength = [string length] - 1;
            
            // When
            [string applyAttributesFontName:@"Helvetica" size:20.0 bold:YES italic:YES toRange:NSMakeRange(0, appliedLength)];
            
            // Then
            NSRange range = { 0 };
            [string attributesAtIndex:0 longestEffectiveRange:&range inRange:NSMakeRange(0, [string length])];
            [[theValue(range.location) should] equal:theValue(0)];
            [[theValue(range.length) should] equal:theValue(appliedLength)];
        });
    });
});

SPEC_END
