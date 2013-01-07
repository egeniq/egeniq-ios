//
//  EFAlertView.m
//
//  Created by Allen Ding on 10/25/11.
//  Copyright (c) 2011 Egeniq. All rights reserved.
//

#import "EFAlertView.h"

/**
 *
 */
@interface EFAlertView() <UIAlertViewDelegate>

#pragma mark -
#pragma mark Blocks

@property (nonatomic, copy) EFAlertViewBlock confirmBlock;
@property (nonatomic, copy) EFAlertViewBlock cancelBlock;
@property (nonatomic, copy) NSString *confirmButtonTitle;
@property (nonatomic, copy) NSString *cancelButtonTitle;

@end

/**
 *
 */
@implementation EFAlertView

@synthesize confirmBlock = confirmBlock_;
@synthesize cancelBlock = cancelBlock_;
@synthesize confirmButtonTitle = confirmButtonTitle_;
@synthesize cancelButtonTitle = cancelButtonTitle_;

#pragma mark -
#pragma mark Initialization

- (id)initWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmBlock:(EFAlertViewBlock)confirmBlock cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(EFAlertViewBlock)cancelBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
    
    if (self != nil) {
        self.confirmBlock = confirmBlock;
        self.cancelBlock = cancelBlock;
        self.confirmButtonTitle = confirmButtonTitle;
        self.cancelButtonTitle = cancelButtonTitle;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle block:(EFAlertViewBlock)block {
    return [self initWithTitle:title message:message confirmButtonTitle:nil confirmBlock:nil cancelButtonTitle:buttonTitle cancelBlock:block];
}

#pragma mark -
#pragma mark Showing

+ (void)showWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmBlock:(EFAlertViewBlock)confirmBlock cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(EFAlertViewBlock)cancelBlock {
    EFAlertView *alertView = [[[self alloc] initWithTitle:title message:message confirmButtonTitle:confirmButtonTitle confirmBlock:confirmBlock cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock] autorelease];
    [alertView show];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle block:(EFAlertViewBlock)block {
    [self showWithTitle:title message:message confirmButtonTitle:nil confirmBlock:nil cancelButtonTitle:buttonTitle cancelBlock:block];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message block:(EFAlertViewBlock)block {
    NSString *buttonTitle = NSLocalizedString(@"OK", @"OK");
    [self showWithTitle:title message:message buttonTitle:buttonTitle block:block];
}

#pragma mark -
#pragma mark Alert view delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:self.confirmButtonTitle] && self.confirmBlock != nil) {
        self.confirmBlock(alertView);
    } else if ([title isEqualToString:self.cancelButtonTitle] && self.cancelBlock != nil) {
        self.cancelBlock(alertView);
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    self.confirmBlock = nil;
    self.cancelBlock = nil;
    self.confirmButtonTitle = nil;
    self.cancelButtonTitle = nil;
    [super dealloc];
}

@end
