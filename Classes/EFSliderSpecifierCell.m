//
//  SwitchTableViewCell.m
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSliderSpecifierCell.h"

@implementation EFSliderSpecifierCell

- (id)initWithName:(NSString *)name {
    if ((self = [super initWithName:name]) != nil) {
		self.textLabel.hidden = YES;
		self.detailTextLabel.hidden = YES;
		valueField_ = [[UISlider alloc] init];	
        valueField_.enabled = self.editable;
		[self.contentView addSubview:valueField_];
    }
	
    return self;
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];
    valueField_.enabled = editable;
}

- (float)minimumValue {
	return valueField_.minimumValue;
}

- (void)setMinimumValue:(float)value {
	valueField_.minimumValue = value;
	[self setNeedsLayout];
}

- (float)maximumValue {
	return valueField_.maximumValue;
}

- (void)setMaximumValue:(float)value {
	valueField_.maximumValue = value;
	[self setNeedsLayout];
}

- (float)floatValue {
    return valueField_.value;
}

- (void)setFloatValue:(float)value {
    valueField_.value = value;
    [self setNeedsLayout];
}

- (id)value {
    return [NSNumber numberWithFloat:self.floatValue];
}

- (void)setValue:(id)value {
    self.floatValue = [((NSNumber *)value) floatValue];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect valueFrame = valueField_.frame;
	valueFrame.size.width = self.contentView.frame.size.width - 20.0;
	valueFrame.origin.x = 10.0;
	valueFrame.origin.y = (self.contentView.frame.size.height - valueFrame.size.height) / 2;
	valueField_.frame = valueFrame;
}

- (BOOL)isFirstResponder {
    return [valueField_ isFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return [valueField_ canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder {
    return [valueField_ becomeFirstResponder];
}

- (BOOL)canResignFirstResponder {
    return [valueField_ canResignFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [valueField_ resignFirstResponder];
}

- (void)dealloc {
	[valueField_ release];
	valueField_ = nil;
	
    [super dealloc];
}

@end