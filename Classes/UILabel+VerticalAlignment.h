//
//  UILabel+VerticalAlignment.h
//  Egeniq
//
//  Created by Peter Verhage on 30-10-11.
//  Copyright (c) 2011 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UILabelVerticalAlignmentTop    = 1,
    UILabelVerticalAlignmentMiddle = 2,
    UILabelVerticalAlignmentBottom = 3
} UILabelVerticalAlignment;

@interface UILabel (VerticalAlignment)

- (void)setText:(NSString *)text verticalAlignment:(UILabelVerticalAlignment)verticalAlignment;

@end
