//
//  EFRichTextView.m
//  RTLNieuws365
//
//  Created by Johan Kool on 13/9/2011.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFRichTextView.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface EFRichTextInternalView : UIView 

@property(nonatomic, readonly, retain) CATextLayer *textLayer;
@property(copy) id string;
@property(retain) UIFont *font;
@property(retain) UIColor *foregroundColor;
@property(getter=isWrapped) BOOL wrapped;
@property(copy) NSString *truncationMode;
@property(copy) NSString *alignmentMode;

- (CGSize)frameSize;

@end

@implementation EFRichTextInternalView

+ (Class)layerClass {
    return [CATextLayer class];
}

- (CATextLayer *)textLayer {
    return (CATextLayer *)self.layer;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.bounds = self.bounds;
    // In anticipation of the iPad 3: UIKit normally takes care of setting the right scale
    // Note that this assumes we'll be shown on the main screen!
    self.textLayer.contentsScale = [[UIScreen mainScreen] scale];
}

// These properties simply pass on the values to the text layer, adjusting where needed
- (id)string {
    return self.textLayer.string;
}

- (void)setString:(id)string {
    self.textLayer.string = string;
}

- (UIFont *)font {
    return [UIFont fontWithName:self.textLayer.font size:self.textLayer.fontSize];
}

- (void)setFont:(UIFont *)font {
    self.textLayer.fontSize = font.pointSize;
    self.textLayer.font = font.fontName;
}

- (UIColor *)foregroundColor {
    return [UIColor colorWithCGColor:self.textLayer.foregroundColor];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    self.textLayer.foregroundColor = foregroundColor.CGColor;
}

- (BOOL)isWrapped {
    return self.textLayer.wrapped;
}

- (void)setWrapped:(BOOL)wrapped {
    self.textLayer.wrapped = wrapped;
}

- (NSString *)truncationMode {
    return self.textLayer.truncationMode;
}

- (void)setTruncationMode:(NSString *)truncationMode {
    self.textLayer.truncationMode = truncationMode;
}

- (NSString *)alignmentMode {
    return self.textLayer.alignmentMode;
}

- (void)setAlignmentMode:(NSString *)alignmentMode {
    self.textLayer.alignmentMode = alignmentMode;
}

// Measures the height needed for a given width using Core Text
- (CGSize)frameSize {
    NSAttributedString *string = self.string;
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGFloat width = self.layer.bounds.size.width;
    
    CFIndex offset = 0, length;
    CGFloat y = 0;
    do {
        length = CTTypesetterSuggestLineBreak(typesetter, offset, width);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(offset, length));
        
        CGFloat ascent, descent, leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        CFRelease(line);
        
        offset += length;
        y += ascent + descent + leading;
    } while (offset < [string length]);
    
    CFRelease(typesetter);
    
    return CGSizeMake(width, ceil(y));
}

- (void)dealloc {
    self.string = nil;
    self.font = nil;
    self.foregroundColor = nil;
    self.truncationMode = nil;
    self.alignmentMode = nil;

    [super dealloc];
}

@end

@interface EFRichTextView  ()

@property(nonatomic, retain) EFRichTextInternalView *textView;

@end

@implementation EFRichTextView

@synthesize textView=textView_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textView.backgroundColor = [UIColor whiteColor];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView = [[[EFRichTextInternalView alloc] initWithFrame:self.bounds] autorelease];
    self.textView.backgroundColor = self.backgroundColor;
    [self addSubview:self.textView];
}

// These properties simply pass on the values to the text view
- (id)string {
    return self.textView.string;
}

- (void)setString:(id)string {
    self.textView.string = string;
    
    if (self.scrollEnabled) {
        CGSize textSize = [self.textView frameSize];
        self.textView.frame = CGRectMake(0, 0, textSize.width, textSize.height);
        
        self.contentSize = textSize;
        self.contentOffset = CGPointZero;
    } else {
        self.textView.frame = self.bounds;
        
        self.contentSize = self.bounds.size;
        self.contentOffset = CGPointZero;
    }
}

- (UIFont *)font {
    return self.textView.font;
}

- (void)setFont:(UIFont *)font {
    self.textView.font = font;
}
 
- (UIColor *)foregroundColor {
    return self.textView.foregroundColor;
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    self.textView.foregroundColor = foregroundColor;
}

- (BOOL)isWrapped {
    return self.textView.wrapped;
}

- (void)setWrapped:(BOOL)wrapped {
    self.textView.wrapped = wrapped;
}

- (NSString *)truncationMode {
    return self.textView.truncationMode;
}

- (void)setTruncationMode:(NSString *)truncationMode {
    self.textView.truncationMode = truncationMode;
}

- (NSString *)alignmentMode {
    return self.textView.alignmentMode;
}

- (void)setAlignmentMode:(NSString *)alignmentMode {
    self.textView.alignmentMode = alignmentMode;
}

// Measures the height needed for a given width using Core Text
- (CGSize)frameSize {
    return [self.textView frameSize];
}

- (void)dealloc {
    self.textView = nil;
    [super dealloc];
}

@end
