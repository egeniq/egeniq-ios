//
//  SwitchTableViewCell.h
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@class EFToggleSwitchSpecifierCell;

@protocol EFToggleSwitchSpecifierCellDelegate <NSObject>
@optional
- (void)toggleSwitchSpecifierCellDidChangeState:(EFToggleSwitchSpecifierCell *)toggleSwitchSpecifierCell;
@end

@interface EFToggleSwitchSpecifierCell : EFSpecifierCell {
	UISwitch *valueField_;
}

@property(nonatomic, assign) id<EFToggleSwitchSpecifierCellDelegate> delegate;
@property(nonatomic, copy) id trueValue;
@property(nonatomic, copy) id falseValue;

@end
