//
//  EFSettingsButton.h
//  Egeniq
//
//  Created by Thijs Damen on 11/4/13.
//  Copyright (c) 2013 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFSettingsButton : UIButton {
    
}

+ (id)button;

@property (nonatomic, assign, getter=isBorderVisible) BOOL borderVisible;
@property (nonatomic, assign) CGColorRef borderColor;

@end
