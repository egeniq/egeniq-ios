//
//  TextFieldTableViewCell.m
//  AxisControl
//
//  Created by Peter C. Verhage on 05-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFTextFieldSpecifierCell.h"

@implementation EFTextFieldSpecifierCell

@synthesize delegate=delegate_;

- (id)initWithName:(NSString *)name {
    if ((self = [super initWithName:name]) != nil) {
		self.detailTextLabel.text = @"";
		
		valueField_ = [[UITextField alloc] init];
		valueField_.delegate = self;
		valueField_.returnKeyType = UIReturnKeyDone;	
		valueField_.enabled = NO;
		
		[self.contentView addSubview:valueField_];
		
		self.value = @"";
    }
	
    return self;
}

- (UIKeyboardType)keyboardType {
	return valueField_.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    valueField_.keyboardType = keyboardType;
}

- (UITextAutocorrectionType)autocorrectionType {
	return valueField_.autocorrectionType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType {
    valueField_.autocorrectionType = autocorrectionType;
}

- (UITextAutocapitalizationType)autocapitalizationType {
	return valueField_.autocapitalizationType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
	valueField_.autocapitalizationType = autocapitalizationType;
}

- (BOOL)secureTextEntry {
	return valueField_.secureTextEntry;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
	valueField_.secureTextEntry = secureTextEntry;
}

- (UIFont *)valueFont {
    return self.detailTextLabel.font;
}

- (void)setValueFont:(UIFont *)valueFont {
    self.detailTextLabel.font = valueFont;
}

- (NSString *)stringValue {
    return valueField_.text;
}

- (void)setStringValue:(NSString *)stringValue {
    valueField_.text = stringValue;
	[self setNeedsLayout];	    
}

- (id)value {
	return self.stringValue;
}

- (void)setValue:(id)value {
	self.stringValue = (NSString *)value;
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
	if ([self.delegate respondsToSelector:@selector(textFieldSpecifierCellDidBeginEditing:)]) {
		[self.delegate textFieldSpecifierCellDidBeginEditing:self];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([self.delegate respondsToSelector:@selector(textFieldSpecifierCellDidEndEditing:)]) {	
		[self.delegate textFieldSpecifierCellDidEndEditing:self];
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