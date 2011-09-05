//
//  EFSpecifierCell.h
//  AxisControl
//
//  Created by Peter Verhage on 24-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFSpecifierCell : UITableViewCell {

}

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, retain) UIFont *titleFont;
@property(nonatomic, copy) id value;
@property(nonatomic, readonly) BOOL showDetailsOnSelect;
@property(nonatomic, assign, getter=isEditable) BOOL editable;
@property(nonatomic, assign) CGFloat height;

- (id)initWithName:(NSString *)name;
- (UIViewController *)detailsViewController;
- (BOOL)shouldLoadValue;

@end
