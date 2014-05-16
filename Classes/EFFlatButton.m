//
//  EFFlatButton.m
//  Egeniq
//
//  Created by Johan Kool on 19/6/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "EFFlatButton.h"

@interface EFFlatButton ()

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *disabledBackgroundColor;

@end

@implementation EFFlatButton

- (UIColor *)backgroundColorForState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            return self.normalBackgroundColor;
            break;
        case UIControlStateHighlighted:
            return self.highlightedBackgroundColor;
            break;
        case UIControlStateSelected:
            return self.selectedBackgroundColor;
            break;
        case UIControlStateDisabled:
            return self.disabledBackgroundColor;
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            self.normalBackgroundColor = backgroundColor;
            break;
        case UIControlStateHighlighted:
            self.highlightedBackgroundColor = backgroundColor;
            break;
        case UIControlStateSelected:
            self.selectedBackgroundColor = backgroundColor;
            break;
        case UIControlStateDisabled:
            self.disabledBackgroundColor = backgroundColor;
            break;
        default:
            break;
    }
    [self updateBackgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateBackgroundColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateBackgroundColor];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateBackgroundColor];
}

- (void)updateBackgroundColor {
    switch (self.state) {
        case UIControlStateNormal:
            self.backgroundColor = self.normalBackgroundColor;
            break;
        case UIControlStateHighlighted:
            self.backgroundColor = self.highlightedBackgroundColor;
            break;
        case UIControlStateSelected:
            self.backgroundColor = self.selectedBackgroundColor;
            break;
        case UIControlStateDisabled:
            self.backgroundColor = self.disabledBackgroundColor;
            break;
        default:
            break;
    }
}

@end
