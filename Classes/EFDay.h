//
//  EFDay.h
//  Egeniq
//
//  Created by Ivo Jansch on 8/13/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

// Implements a date with no time component (just a day, month and year)
@interface EFDay : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;

// Create an EFDay matching today's date (according to the default timezone)
+ (id) day;
+ (id) dayWithDay: (NSInteger)day month: (NSInteger)month year: (NSInteger)year;

// Return a yyyy-mm-dd string
- (NSString *)stringValue;
- (NSString *)description;

@end
