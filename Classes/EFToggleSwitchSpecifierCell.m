//
//  SwitchTableViewCell.m
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFToggleSwitchSpecifierCell.h"

@implementation EFToggleSwitchSpecifierCell

@synthesize trueValue=trueValue_, falseValue=falseValue_;

- (id)initWithName:(NSString *)name {
    if ((self = [super initWithName:name]) != nil) {
		self.detailTextLabel.text = @"";
		
		valueField = [[UISwitch alloc] init];	
		[self.contentView addSubview:valueField];

		self.trueValue = [[[NSNumber alloc] initWithBool:YES] autorelease];
		self.falseValue = [[[NSNumber alloc] initWithBool:NO] autorelease];		
		self.value = self.falseValue;
    }
	
    return self;
}

- (id)value {
	return valueField.on ? self.trueValue : self.falseValue;
}

- (void)setValue:(id)value {
	valueField.on = [value isEqual:self.trueValue];
	[self setNeedsLayout];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect valueFrame = valueField.frame;
	valueFrame.origin.x = self.contentView.frame.size.width - valueFrame.size.width - 10.0;
	valueFrame.origin.y = (self.contentView.frame.size.height - valueFrame.size.height) / 2;
	valueField.frame = valueFrame;
}

- (void)dealloc {
	self.trueValue = nil;
	self.falseValue = nil;
	self.value = nil;
	
	[valueField release];
	valueField = nil;
	
    [super dealloc];
}

@end