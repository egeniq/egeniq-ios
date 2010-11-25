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

@property(nonatomic, copy) NSString *title;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
