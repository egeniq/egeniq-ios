//
//  UILabel+VerticalAlignment.m
//  Egeniq
//
//  Created by Peter Verhage on 30-10-11.
//  Copyright (c) 2011 Egeniq. All rights reserved.
//
//  Based on http://stackoverflow.com/questions/1054558/how-do-i-vertically-align-text-within-a-uilabel
//

#import "UILabel+VerticalAlignment.h"

@implementation UILabel (VerticalAlignment)

- (void)setText:(NSString *)text verticalAlignment:(UILabelVerticalAlignment)verticalAlignment {
    self.text = text;
    
    if (verticalAlignment == UILabelVerticalAlignmentMiddle) {
        return; // default behavior
    }
    
    CGSize lineSize = [self.text sizeWithFont:self.font];
    CGFloat maxHeight = lineSize.height * self.numberOfLines;
    CGFloat maxWidth = self.frame.size.width;
    CGSize textSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(maxWidth, maxHeight) lineBreakMode:self.lineBreakMode];
    NSUInteger newLinesToPad = (maxHeight  - textSize.height) / lineSize.height;
    
    for (NSUInteger i = 0; i < newLinesToPad; i++) {
        if (verticalAlignment == UILabelVerticalAlignmentTop) {
            self.text = [self.text stringByAppendingString:@"\n "];
        } else {
            self.text = [NSString stringWithFormat:@" \n%@", self.text];            
        }
    }
}

@end