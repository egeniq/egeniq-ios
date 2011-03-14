//
//  TextFieldTableViewCell.h
//  AxisControl
//
//  Created by Peter C. Verhage on 05-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@class EFTextFieldSpecifierCell;

@protocol EFTextFieldSpecifierDelegate <NSObject>
@optional
- (void)textFieldSpecifierCellDidBeginEditing:(EFTextFieldSpecifierCell *)textFieldSpecifierCell;
- (void)textFieldSpecifierCellDidEndEditing:(EFTextFieldSpecifierCell *)textFieldSpecifierCell;
@end

@interface EFTextFieldSpecifierCell : EFSpecifierCell <UITextFieldDelegate> {
	UITextField *valueField;
}

@property(nonatomic, copy) NSString *stringValue;

@property(nonatomic, assign) id<EFTextFieldSpecifierDelegate> delegate;
@property(nonatomic, assign) UIKeyboardType keyboardType;
@property(nonatomic, assign) UITextAutocorrectionType autocorrectionType;
@property(nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic, assign) BOOL secureTextEntry;


@end