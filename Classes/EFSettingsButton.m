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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.topBorder = [CALayer layer];
        self.topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
        [self.layer addSublayer:self.topBorder];
        
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1.0f, self.frame.size.width, 1.0f);
        [self.layer addSublayer:self.bottomBorder];
        
        self.borderVisible = YES;
        self.borderColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f].CGColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isBorderVisible) {
        if (self.topBorder) {
            self.topBorder.backgroundColor = self.borderColor;
            self.topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
        }
        
        if (self.bottomBorder) {
            self.bottomBorder.backgroundColor = self.borderColor;
            self.bottomBorder.frame =CGRectMake(0.0f, self.frame.size.height - 1.0f, self.frame.size.width, 1.0f);
        }
    } else {
        if (self.topBorder) {
            [self.topBorder removeFromSuperlayer];
        }
        
        if (self.bottomBorder) {
            [self.bottomBorder removeFromSuperlayer];
        }
    }

}

- (void)setBorderVisible:(BOOL)borderVisible {
    _borderVisible = borderVisible;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(CGColorRef)borderColor {
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)dealloc {
    [_topBorder release];
    [_bottomBorder release];
    
    [super dealloc];
}

@end
