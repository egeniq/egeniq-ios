//
//  EFButtonsTableViewCell.h
//  Koolistov
//
//  Created by Johan Kool on 28-02-11.
//  Copyright 2011 Koolistov. All rights reserved.
//

#import <UIKit/UIKit.h>

// Supports up to 3 buttons. Add buttons by setting the button properties.

@interface EFButtonsTableViewCell : UITableViewCell

@property (nonatomic, retain) UIButton *button1;
@property (nonatomic, retain) UIButton *button2;
@property (nonatomic, retain) UIButton *button3;
@property (readonly) UITableViewStyle style;

- (id)initWithStyle:(UITableViewStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
