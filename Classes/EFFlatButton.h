//
//  EFFlatButton.h
//  Egeniq
//
//  Created by Johan Kool on 19/6/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFFlatButton : UIButton

- (UIColor *)backgroundColorForState:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
