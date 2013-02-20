//
//  EFAlertView.m
//
//
//  Created by Johan Kool on 29/8/2012.
//  Copyright (c) 2012 Koolistov Pte. Ltd. All rights reserved.
//

#import "EFAlertView.h"

@interface EFAlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *blocks;

@end

@implementation EFAlertView

+ (EFAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(EFAlertViewBlock)cancelBlock {
    return [self alertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock confirmButtonTitle:nil confirmBlock:nil];
}

+ (EFAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelBlock:(EFAlertViewBlock)cancelBlock
             confirmButtonTitle:(NSString *)confirmButtonTitle
                   confirmBlock:(EFAlertViewBlock)confirmBlock {
    EFAlertView *alertView = [[EFAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock];
    if (confirmButtonTitle) {
        [alertView addButtonWithTitle:confirmButtonTitle block:confirmBlock];
    }
    return alertView;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    EFAlertView *alertView = [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:nil];

    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *)) {
        [alertView addButtonWithTitle:arg];
    }
    va_end(args);

    return alertView;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(EFAlertViewBlock)cancelBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        self.blocks = [NSMutableArray array];
        if (cancelButtonTitle) {
            if (cancelBlock) {
                self.blocks[0] = [cancelBlock copy];
            } else {
                self.blocks[0] = [NSNull null];
            }
        }
    }
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title
                          block:(EFAlertViewBlock)block {
    NSUInteger buttonIndex = [super addButtonWithTitle:title];
    if (block) {
        self.blocks[buttonIndex] = [block copy];
    } else {
        self.blocks[buttonIndex] = [NSNull null];
    }
    return buttonIndex;
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    return [self addButtonWithTitle:title block:nil];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(EFAlertViewBlock)cancelBlock {
    EFAlertView *alertView = [self alertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock];
    [alertView show];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
          cancelBlock:(EFAlertViewBlock)cancelBlock
   confirmButtonTitle:(NSString *)confirmButtonTitle
         confirmBlock:(EFAlertViewBlock)confirmBlock {
    EFAlertView *alertView = [self alertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock confirmButtonTitle:confirmButtonTitle confirmBlock:confirmBlock];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    id blockOrNull = self.blocks[buttonIndex];
    if (blockOrNull != [NSNull null]) {
        EFAlertViewBlock block = (EFAlertViewBlock)blockOrNull;
        block(alertView);
    }
}

@end
