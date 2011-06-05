//
//  SwitchTableViewCell.m
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFToggleSwitchSpecifierCell.h"

@implementation EFToggleSwitchSpecifierCell

@synthesize delegate=delegate_;
@synthesize trueValue=trueValue_;
@synthesize falseValue=falseValue_;

- (id)initWithName:(NSString *)name {
    if ((self = [super initWithName:name]) != nil) {
		self.detailTextLabel.text = @"";
		
		valueField_ = [[UISwitch alloc] init];	
        valueField_.enabled = self.isEditable;
        [valueField_ addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
		[self.contentView addSubview:valueField_];

		self.trueValue = [[[NSNumber alloc] initWithBool:YES] autorelease];
		self.falseValue = [[[NSNumber alloc] initWithBool:NO] autorelease];		
		self.value = self.falseValue;
    }
	
    return self;
}

- (void)valueChanged {
	if ([self.delegate respondsToSelector:@selector(toggleSwitchSpecifierCellDidChangeState:)]) {	
		[self.delegate toggleSwitchSpecifierCellDidChangeState:self];
	}      
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];
    valueField_.enabled = editable;
}

- (id)value {
	return valueField_.on ? self.trueValue : self.falseValue;
}

- (void)setValue:(id)value {
	valueField_.on = [value isEqual:self.trueValue];
	[self setNeedsLayout];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect valueFrame = valueField_.frame;
	valueFrame.origin.x = self.contentView.frame.size.width - valueFrame.size.width - 10.0;
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
	self.trueValue = nil;
	self.falseValue = nil;
	self.value = nil;
	
	[valueField_ release];
	valueField_ = nil;
	
    [super dealloc];
}

@end