//
//  NSMutableAttributedString+Convenience.m
//  RTLNieuws365
//
//  Created by Johan Kool on 13/9/2011.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "NSMutableAttributedString+Convenience.h"

#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (Convenience)

- (void)applyAttributesFontName:(NSString *)fontName size:(CGFloat)pointSize bold:(BOOL)bold italic:(BOOL)italic {
    [self applyAttributesFontName:fontName size:pointSize bold:bold italic:italic toRange:NSMakeRange(0, [self length])];
}

- (void)applyAttributesFontName:(NSString *)fontName size:(CGFloat)pointSize bold:(BOOL)bold italic:(BOOL)italic toRange:(NSRange)range {
    CTFontSymbolicTraits symbolicTraits = (bold ? kCTFontBoldTrait : 0) | (italic ? kCTFontItalicTrait : 0);
    NSDictionary *fontTraits = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:symbolicTraits] forKey:(NSString *)kCTFontSymbolicTrait];
    NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontFamilyNameAttribute, fontTraits, kCTFontTraitsAttribute, nil];

    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)fontAttributes);
    if (!descriptor) return;
    
    CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, pointSize, NULL);
    CFRelease(descriptor);
    if (!font) return;

    [self removeAttribute:(NSString *)kCTFontAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString *)kCTFontAttributeName value:(id)font range:range];
    CFRelease(font);
}

- (void)applyAttributesColor:(UIColor *)color {
    [self applyAttributesColor:color toRange:NSMakeRange(0, [self length])];
}

- (void)applyAttributesColor:(UIColor *)color toRange:(NSRange)range {
    [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
}

@end
