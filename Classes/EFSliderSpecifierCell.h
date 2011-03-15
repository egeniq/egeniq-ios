//
//  EFSliderSpecifierCell.h
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@interface EFSliderSpecifierCell : EFSpecifierCell {
	UISlider *valueField_;
}

@property(nonatomic, assign) float minimumValue;
@property(nonatomic, assign) float maximumValue;

@property(nonatomic, assign) float floatValue;

@end
