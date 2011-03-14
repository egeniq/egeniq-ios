//
//  EFNumberFieldSpecifierCell.h
//  Egeniq
//
//  Created by Peter Verhage on 12-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@class EFNumberFieldSpecifierCell;

@protocol EFNumberFieldSpecifierDelegate <NSObject>
@optional
- (void)numberFieldSpecifierCellDidBeginEditing:(EFNumberFieldSpecifierCell *)numberFieldSpecifierCell;
- (void)numberFieldSpecifierCellDidEndEditing:(EFNumberFieldSpecifierCell *)numberFieldSpecifierCell;
@end


// TODO: currently we only support integer numbers using the default number pad keyboard type;
//       add support for the UIKeyboardTypeDecimalPad and let the user set a number format

@interface EFNumberFieldSpecifierCell : EFSpecifierCell <UITextFieldDelegate> {
	UITextField *valueField;
}

@property(nonatomic, copy) NSNumber *numberValue;

@property(nonatomic, assign) id<EFNumberFieldSpecifierDelegate> delegate;

@end
