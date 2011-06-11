//
//  UIAlertView+EFBlock.m
//  Egeniq
//
//  Created by Peter Verhage on 11-06-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "UIAlertView+EFBlock.h"

static DismissBlock onDismiss_;

@implementation UIAlertView (EFBlock)

- (void)showWithOnDismiss:(DismissBlock)onDismiss {
    onDismiss_ = [onDismiss copy];
    self.delegate = self;
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    onDismiss_(buttonIndex);
    [onDismiss_ release];
    onDismiss_ = nil;
}

@end
