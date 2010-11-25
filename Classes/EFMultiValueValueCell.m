//
//  MultiValueValueTableViewCell.m
//  AxisControl
//
//  Created by Peter Verhage on 18-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFMultiValueValueCell.h"


@implementation EFMultiValueValueCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
		isSelected = NO;
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
	
    return self;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	isSelected = NO;
}

- (void)layoutSubviews {
	self.textLabel.textColor = isSelected ? self.detailTextLabel.textColor : [UIColor blackColor];
	self.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;	
	[super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	isSelected = selected;
	[self setNeedsLayout];	
}

- (void)dealloc {
    [super dealloc];
}

@end
