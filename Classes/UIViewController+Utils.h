//
//  UIViewController+Utils.h
//  Egeniq
//
//  Created by Ivo Jansch on 9/5/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils) 

/**
 * Determine if a viewController is part of a navigation stack 
 * (non-modal) or if it is loaded as a modal popup. This helps
 * generic viewcontroller determine if they should close with
 * popViewController or dismissModalViewController.
 */
- (BOOL)isModal;

/**
 * Returns if the view of the receiver is visible (in between -viewDidAppear: and -viewDidDisappear: messages).
 */
@property (nonatomic, readonly, getter = isViewVisible) BOOL viewVisible;

@end
