//
//  EFAlertView.h
//
//  Created by Allen Ding on 10/25/11.
//  Copyright (c) 2011 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EFAlertViewBlock)(UIAlertView *alertView);

/**
 * Inspired by iOS Recipes #9.
 */
@interface EFAlertView : UIAlertView

#pragma mark -
#pragma mark Initialization

// Confirm/cancel alert view. Designated initializer.
- (id)initWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmBlock:(EFAlertViewBlock)confirmBlock cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(EFAlertViewBlock)cancelBlock;

// Informational alert view.
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle block:(EFAlertViewBlock)block;

#pragma mark -
#pragma mark Showing

// Confirm/cancel.
+ (void)showWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmBlock:(EFAlertViewBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(EFAlertViewBlock)cancelBlock;
// Info with customizable button.
+ (void)showWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle block:(EFAlertViewBlock)block;
// Localized OK button.
+ (void)showWithTitle:(NSString *)title message:(NSString *)message block:(EFAlertViewBlock)block;

@end
