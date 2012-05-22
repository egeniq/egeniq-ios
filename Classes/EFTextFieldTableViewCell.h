//
//  EFTextFieldTableViewCell.h
//  Koolistov
//
//  Created by Johan Kool on 28-02-11.
//  Copyright 2011 Koolistov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFTextFieldTableViewCell;

@protocol EFTextFieldTableViewCellDelegate <NSObject>

@optional
- (BOOL)textFieldShouldBeginEditingInCell:(EFTextFieldTableViewCell *)textFieldCell;
- (void)textFieldDidBeginEditingInCell:(EFTextFieldTableViewCell *)textFieldCell;
- (BOOL)textFieldShouldReturnInCell:(EFTextFieldTableViewCell *)textFieldCell;
- (BOOL)textFieldShouldClearInCell:(EFTextFieldTableViewCell *)textFieldCell;
- (BOOL)textFieldShouldEndEditingInCell:(EFTextFieldTableViewCell *)textFieldCell;
- (void)textFieldDidEndEditingInCell:(EFTextFieldTableViewCell *)textFieldCell;
- (BOOL)textFieldInCell:(EFTextFieldTableViewCell *)textFieldCell shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

@interface EFTextFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, assign) id <EFTextFieldTableViewCellDelegate> delegate;
@property (nonatomic, retain, readonly) UILabel *label;
@property (nonatomic, retain, readonly) UITextField *textField;
@property (readonly) UITableViewCellStyle style;
@property CGFloat textFieldOffset;

@end


