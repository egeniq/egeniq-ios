//
//  EFSpecifierCell.m
//  AxisControl
//
//  Created by Peter Verhage on 24-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

@implementation EFSpecifierCell

@synthesize editable=editable_;
@synthesize height=height_;

- (id)initWithName:(NSString *)name {
	if ((self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:name]) != nil) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.editable = YES;
        self.height = 44.0;
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

- (UIFont *)titleFont {
    return self.textLabel.font;
}

- (void)setTitleFont:(UIFont *)font {
    self.textLabel.font = font;
}

- (BOOL)shouldLoadValue {
    return YES;
}

- (id)value {
    return nil;
}

- (void)setValue:(id)value {

}

@end
