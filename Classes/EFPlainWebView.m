//
//  EFPlainWebView.m
//  Egeniq
//
//  Created by Johan Kool on 18/4/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "EFPlainWebView.h"

@implementation EFPlainWebView

@synthesize backgroundColor = _backgroundColor;

- (void)hideImageViewsInView:(UIView*)view {
    for (UIView *subview in view.subviews) {
        // Hide image views, but keep scroll indicators visible (some trial and error showed those have size 7)
        if ([subview isKindOfClass:[UIImageView class]] && (subview.frame.size.width != 7.0f && subview.frame.size.height != 7.0f)) {
            subview.hidden = YES;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self hideImageViewsInView:self.scrollView];
    [super setBackgroundColor:self.backgroundColor];
}

- (void)dealloc {
    self.backgroundColor = nil;
    [super dealloc];
}

@end
