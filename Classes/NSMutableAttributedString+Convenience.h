//
//  NSMutableAttributedString+Convenience.h
//  RTLNieuws365
//
//  Created by Johan Kool on 13/9/2011.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Convenience)

- (void)applyAttributesFontName:(NSString *)fontName size:(CGFloat)pointSize bold:(BOOL)bold italic:(BOOL)italic;
- (void)applyAttributesFontName:(NSString *)fontName size:(CGFloat)pointSize bold:(BOOL)bold italic:(BOOL)italic toRange:(NSRange)range;

- (void)applyAttributesColor:(UIColor *)color;
- (void)applyAttributesColor:(UIColor *)color toRange:(NSRange)range;

@end
