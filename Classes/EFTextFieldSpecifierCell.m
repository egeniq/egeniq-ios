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

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier]) != nil) {
		self.detailTextLabel.text = @"";
		
		valueField = [[UITextField alloc] init];
		valueField.delegate = self;
		valueField.returnKeyType = UIReturnKeyDone;	
		valueField.enabled = NO;
		
		[self.contentView addSubview:valueField];
		
		self.value = @"";
    }
	
    return self;
}

- (UIKeyboardType)keyboardType {
	return valueField.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
	valueField.keyboardType = keyboardType;
}

- (UITextAutocorrectionType)autocorrectionType {
	return valueField.autocorrectionType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType {
	valueField.autocorrectionType = autocorrectionType;
}

- (UITextAutocapitalizationType)autocapitalizationType {
	return valueField.autocapitalizationType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
	valueField.autocapitalizationType = autocapitalizationType;
}

- (BOOL)secureTextEntry {
	return valueField.secureTextEntry;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
	valueField.secureTextEntry = secureTextEntry;
}

- (NSString *)value {
	return valueField.text;
}

- (void)setValue:(NSString *)value {
	valueField.text = value;
	[self setNeedsLayout];	
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

- (void)dealloc {
    [super dealloc];
	
	[valueField release];
	valueField = nil;
}

@end