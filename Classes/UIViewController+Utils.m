//
//  UIViewController+Utils.m
//  Egeniq
//
//  Created by Ivo Jansch on 9/5/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

- (BOOL)isModal { 
    if ([self navigationController] == nil) {
        return YES;
    } else {
        NSArray *viewControllers = [[self navigationController] viewControllers];
        UIViewController *rootViewController = [viewControllers objectAtIndex:0];    
        return rootViewController == self;
    }
}

@end
