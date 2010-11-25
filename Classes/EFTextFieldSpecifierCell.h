//
//  TextFieldTableViewCell.h
//  AxisControl
//
//  Created by Peter C. Verhage on 05-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@interface EFTextFieldSpecifierCell : EFSpecifierCell <UITextFieldDelegate> {
	UITextField *valueField;
}

@property(nonatomic, assign) UIKeyboardType keyboardType;
@property(nonatomic, assign) UITextAutocorrectionType autocorrectionType;
@property(nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic, assign) BOOL secureTextEntry;

@property(nonatomic, copy) NSString *value;

@end