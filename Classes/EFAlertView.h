//
//  EFAlertView.h
//  
//
//  Created by Johan Kool on 29/8/2012.
//  Copyright (c) 2012 Koolistov Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EFAlertViewBlock)(UIAlertView *alertView);

/**
 
 Sample usage:
 
 EFAlertView *alert = [EFAlertView alertWithTitle:NSLocalizedString(@"Title", @"") message:NSLocalizedString(@"Message", @"") cancelButtonTitle:NSLocalizedString(@"Cancel", @"") cancelBlock:^{
     NSLog(@"Cancel");
 }];
 alert.alertViewStyle = UIAlertViewStylePlainTextInput;
 [alert addButtonWithTitle:NSLocalizedString(@"OK", @"") block:^(EFAlertView *alertView){
     NSLog(@"OK: %@", [alertView textFieldAtIndex:0].text);
 }];
 [alert show];
 
 */

@interface EFAlertView : UIAlertView

+ (EFAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(EFAlertViewBlock)cancelBlock;

+ (EFAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(EFAlertViewBlock)cancelBlock
             confirmButtonTitle:(NSString *)confirmButtonTitle
                   confirmBlock:(EFAlertViewBlock)confirmBlock;

- (NSInteger)addButtonWithTitle:(NSString *)title
                          block:(EFAlertViewBlock)block;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(EFAlertViewBlock)cancelBlock;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(EFAlertViewBlock)cancelBlock
   confirmButtonTitle:(NSString *)confirmButtonTitle
         confirmBlock:(EFAlertViewBlock)confirmBlock;

@end
