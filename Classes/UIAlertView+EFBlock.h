//
//  UIAlertView+EFBlock.h
//  Egeniq
//
//  Created by Peter Verhage on 11-06-11.
//  Copyright 2011 Egeniq. All rights reserved.
//


// NOTE: to use this category you will need the -ObjC and -all_load linker flags!

#import <UIKit/UIKit.h>

@interface UIAlertView (EFBlock) <UIAlertViewDelegate> 

typedef void (^DismissBlock)(int buttonIndex);

- (void)showWithOnDismiss:(DismissBlock)onDismiss;

@end
