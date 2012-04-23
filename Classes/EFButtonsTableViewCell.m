//
//  EFButtonsTableViewCell.m
//  Koolistov
//
//  Created by Johan Kool on 28-02-11.
//  Copyright 2011 Koolistov. All rights reserved.
//

#import "EFButtonsTableViewCell.h"

@interface EFButtonsTableViewCell ()

@property (readwrite) UITableViewStyle style;

@end

@implementation EFButtonsTableViewCell

@synthesize button1 = _button1;
@synthesize button2 = _button2;
@synthesize button3 = _button3;
@synthesize style = _style;

- (id)initWithStyle:(UITableViewStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        self.style = style;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        backView.backgroundColor = [UIColor clearColor];
        self.backgroundView = backView;
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSUInteger visibleCount = (self.button1 != nil) + (self.button2 != nil) + (self.button3 != nil);
    if (visibleCount == 0) {
        return;
    }
    
    CGFloat buttonWidth = 0.0f;
    CGFloat buttonHeight= 0.0f;
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    switch (self.style) {
        case UITableViewStylePlain:
            x = 10.0f;
            y = 4.0f;
            buttonWidth = (self.contentView.bounds.size.width - 20.0f - 8.0f * (visibleCount - 1)) / visibleCount;
            buttonHeight = self.contentView.bounds.size.height - 8.0f;            
            break;
        case UITableViewStyleGrouped:
        default:
            x = 0.0f;
            y = 0.0f;
            buttonWidth = (self.contentView.bounds.size.width - 8.0f * (visibleCount - 1)) / visibleCount;
            buttonHeight = self.contentView.bounds.size.height;
            break;
    }
    
    if (self.button1) {
        [self.contentView addSubview:self.button1];
        self.button1.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        x += 8.0f + buttonWidth;
    } 
    
    if (self.button2) {
        [self.contentView addSubview:self.button2];
        self.button2.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        x += 8.0f + buttonWidth;
    }
    
    if (self.button3) {
        [self.contentView addSubview:self.button3];
        self.button3.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [self.button1 removeFromSuperview];
    self.button1 = nil;
    [self.button2 removeFromSuperview];
    self.button2 = nil;
    [self.button3 removeFromSuperview];
    self.button3 = nil;
    [super prepareForReuse];
}

- (void)dealloc {
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    [super dealloc];
}

@end
