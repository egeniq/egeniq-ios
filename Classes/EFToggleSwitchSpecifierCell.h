//
//  SwitchTableViewCell.h
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@interface EFToggleSwitchSpecifierCell : EFSpecifierCell {
	UISwitch *valueField_;
}

@property(nonatomic, copy) id trueValue;
@property(nonatomic, copy) id falseValue;

@end
