//
//  EFDateFactory.m
//  Egeniq
//
//  Created by Ivo Jansch on 8/13/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFDateFactory.h"

@implementation EFDateFactory

+ (NSDate *)now {
    return [NSDate date];
}

+ (EFDay *)today {
    return [EFDay day];
}

@end
