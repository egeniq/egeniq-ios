//
//  EFDateFactory.h
//  Egeniq
//
//  Created by Ivo Jansch on 8/13/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFDay.h"

@interface EFDateFactory : NSObject

+ (NSDate *)now;
+ (EFDay *)today;

@end
