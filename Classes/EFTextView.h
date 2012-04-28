//
//  EFTextView.h
//  Egeniq
//
//  Drop-in replacement for UITextView. Adds the ability to set a placeholder
//  text similar to UITextFields.
// 
//  Placeholder feature is based on this code from StackOverflow: 
//  http://stackoverflow.com/questions/1328638/placeholder-in-uitextview
//
//  Created by Ivo Jansch on 4/27/12.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFTextView : UITextView {
}
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

@end