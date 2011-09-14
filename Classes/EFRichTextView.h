//
//  EFRichTextView.h
//  RTLNieuws365
//
//  Created by Johan Kool on 13/9/2011.
//  Copyright 2011 Egeniq. All rights reserved.
//

// Simple view that holds a CATextLayer

#import <UIKit/UIKit.h>

@interface EFRichTextView : UIScrollView

/* The text to be rendered, should be either an NSString or an
 * NSAttributedString. Defaults to nil. */
@property(copy) id string;

/* The font to use. Defaults to the Helvetica font. Only
 * used when the `string' property is not an NSAttributedString. */
@property(retain) UIFont *font;

/* The color object used to draw the text. Defaults to opaque white.
 * Only used when the `string' property is not an NSAttributedString. */
@property(retain) UIColor *foregroundColor;

/* When true the string is wrapped to fit within the view bounds.
 * Defaults to false.*/
@property(getter=isWrapped) BOOL wrapped;

/* Describes how the string is truncated to fit within the layer
 * bounds. The possible options are `none', `start', `middle' and
 * `end'. Defaults to `none'. */
@property(copy) NSString *truncationMode;

/* Describes how individual lines of text are aligned within the layer
 * bounds. The possible options are `natural', `left', `right',
 * `center' and `justified'. Defaults to `natural'. */
@property(copy) NSString *alignmentMode;

- (CGSize)frameSize;

@end
