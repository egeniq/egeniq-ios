//
//  EFPlainWebView.h
//  Egeniq
//
//  Created by Johan Kool on 18/4/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// This subclass of UIWebView hides the gray background effect when user scrolls beyond scrollable area
//
// WARNING: This is rather fragile approach that could fall apart if Apple implements internal things
// of UIWebView differently in the future. However, this also appears to be the only way to acheive this effect.
//

@interface EFPlainWebView : UIWebView

@property (nonatomic, retain) UIColor *backgroundColor;

@end
