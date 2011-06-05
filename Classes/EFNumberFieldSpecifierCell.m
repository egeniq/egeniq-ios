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
		
		valueField_ = [[UITextField alloc] init];
		valueField_.delegate = self;
		valueField_.returnKeyType = UIReturnKeyDone;	
        valueField_.keyboardType = UIKeyboardTypeNumberPad;
		valueField_.enabled = NO;
		
		[self.contentView addSubview:valueField_];
		
		self.value = @"";
    }
	
    return self;
}

- (NSNumber *)numberValue {
    return [valueField_.text length] == 0 ? nil : [NSNumber numberWithInt:[valueField_.text intValue]];
}

- (void)setNumberValue:(NSNumber *)numberValue {
    valueField_.text = numberValue == nil ? @"" : [numberValue description];
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
	
	valueField_.font = self.detailTextLabel.font;
	valueField_.textColor = self.detailTextLabel.textColor;
	valueField_.textAlignment = self.detailTextLabel.textAlignment;		
	
	CGRect valueFrame = CGRectZero;
	valueFrame.origin.x = self.textLabel.frame.size.width + self.textLabel.frame.origin.x + 6.0;
	valueFrame.origin.y = (self.contentView.frame.size.height - valueField_.font.lineHeight) / 2;
	valueFrame.size.width = self.contentView.frame.size.width - valueFrame.origin.x - 15.0;
	valueFrame.size.height = valueField_.font.lineHeight;
	valueField_.frame = valueFrame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
    
    if (!self.isEditable) {
        return;
    }
    
	if (selected) {
		valueField_.enabled = YES;		
		[valueField_ becomeFirstResponder];
	} else {
		[valueField_ resignFirstResponder];
		valueField_.enabled = NO;			
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
    [super dealloc];
	
	[valueField_ release];
	valueField_ = nil;
}


@end