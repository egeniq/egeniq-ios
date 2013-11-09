//
//  EFSettingsButton.m
//  Egeniq
//
//  Created by Thijs Damen on 11/4/13.
//  Copyright (c) 2013 Egeniq. All rights reserved.
//

#import "EFSettingsButton.h"
#import <QuartzCore/QuartzCore.h>

@interface EFSettingsButton ()

@property (nonatomic, strong) CALayer *topBorder;
@property (nonatomic, strong) CALayer *bottomBorder;

@end

@implementation EFSettingsButton

+ (id)button {
    return [EFSettingsButton buttonWithType:UIButtonTypeSystem];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.topBorder = [CALayer layer];
        self.bottomBorder = [CALayer layer];
        self.borderColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f].CGColor;
        
        [self setBorderVisible:YES];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isBorderVisible) {
        self.topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
        self.bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1.0f, self.frame.size.width, 1.0f);
    }
}

- (void)setBorderVisible:(BOOL)borderVisible {
    _borderVisible = borderVisible;
    if (borderVisible) {
        [self.layer addSublayer:self.topBorder];
        [self.layer addSublayer:self.bottomBorder];
    } else {
        [self.topBorder removeFromSuperlayer];
        [self.bottomBorder removeFromSuperlayer];
    }
    [self setNeedsDisplay];
}

- (void)setBorderColor:(CGColorRef)borderColor {
    _borderColor = borderColor;
    self.topBorder.backgroundColor = self.borderColor;
    self.bottomBorder.backgroundColor = self.borderColor;
    [self setNeedsDisplay];
}

- (void)dealloc {
    [_topBorder release];
    [_bottomBorder release];
    
    [super dealloc];
}

@end
