//
//  EFNumberFieldSpecifierCell.m
//  Egeniq
//
//  Created by Peter Verhage on 12-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFNumberFieldSpecifierCell.h"

@implementation EFNumberFieldSpecifierCell

@synthesize delegate=delegate_;

- (id)initWithName:(NSString *)name {
    if ((self = [super initWithName:name]) != nil) {
		self.detailTextLabel.text = @"";
		
		valueField = [[UITextField alloc] init];
		valueField.delegate = self;
		valueField.returnKeyType = UIReturnKeyDone;	
        valueField.keyboardType = UIKeyboardTypeNumberPad;
		valueField.enabled = NO;
		
		[self.contentView addSubview:valueField];
		
		self.value = @"";
    }
	
    return self;
}

- (NSNumber *)numberValue {
    return [valueField.text length] == 0 ? nil : [NSNumber numberWithInt:[valueField.text intValue]];
}

- (void)setNumberValue:(NSNumber *)numberValue {
    valueField.text = numberValue == nil ? @"" : [numberValue description];
	[self setNeedsLayout];	    
}

- (id)value {
	return self.numberValue;
}

- (void)setValue:(id)value {
	self.numberValue = (NSNumber *)value;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	valueField.font = self.detailTextLabel.font;
	valueField.textColor = self.detailTextLabel.textColor;
	valueField.textAlignment = self.detailTextLabel.textAlignment;		
	
	CGRect valueFrame = CGRectZero;
	valueFrame.origin.x = self.textLabel.frame.size.width + self.textLabel.frame.origin.x + 6.0;
	valueFrame.origin.y = (self.contentView.frame.size.height - valueField.font.lineHeight) / 2;
	valueFrame.size.width = self.contentView.frame.size.width - valueFrame.origin.x - 15.0;
	valueFrame.size.height = valueField.font.lineHeight;
	valueField.frame = valueFrame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if (selected) {
		valueField.enabled = YES;		
		[valueField becomeFirstResponder];
	} else {
		[valueField resignFirstResponder];
		valueField.enabled = NO;			
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if ([self.delegate respondsToSelector:@selector(numberFieldSpecifierCellDidBeginEditing:)]) {
		[self.delegate numberFieldSpecifierCellDidBeginEditing:self];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([self.delegate respondsToSelector:@selector(numberFieldSpecifierCellDidEndEditing:)]) {	
		[self.delegate numberFieldSpecifierCellDidEndEditing:self];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [super dealloc];
	
	[valueField release];
	valueField = nil;
}


@end