//
//  MultiValueTableViewCell.h
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@class EFMultiValueSpecifierCell;

@protocol EFMultiValueSpecifierCellDelegate <NSObject>
@optional
- (void)multiValueSpecifierCell:(EFMultiValueSpecifierCell *)multiValueSpecifierCell didSelectValueAtIndex:(NSUInteger)index;
@end

@interface EFMultiValueSpecifierCell : EFSpecifierCell <UITableViewDelegate, UITableViewDataSource> {
	NSObject *value_;
}

@property(nonatomic, assign) id<EFMultiValueSpecifierCellDelegate> delegate;
@property(nonatomic, retain) NSArray *values;
@property(nonatomic, retain) NSArray *titles;

@end
