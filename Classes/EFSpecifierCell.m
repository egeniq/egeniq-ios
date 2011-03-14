//
//  EFSpecifierCell.m
//  AxisControl
//
//  Created by Peter Verhage on 24-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@implementation EFSpecifierCell

- (id)initWithName:(NSString *)name {
	if ((self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:name]) != nil) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return self;
}

- (BOOL)showDetailsOnSelect {
    return NO;
}

- (UIViewController *)detailsViewController {
    return nil;
}

- (NSString *)name {
    return self.reuseIdentifier;
}

- (NSString *)title {
	return self.textLabel.text;
}

- (void)setTitle:(NSString *)title {
	self.textLabel.text = title;
}

- (id)value {
    return nil;
}

- (void)setValue:(id)value {
    
}

@end
