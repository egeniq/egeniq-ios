//
//  EFDay.m
//  Egeniq
//
//  Created by Ivo Jansch on 8/13/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFDay.h"

@implementation EFDay

@synthesize day=day_;
@synthesize month=month_;
@synthesize year=year_;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    EFDay *copy = [[EFDay alloc] init];
    copy.day = self.day;
    copy.month = self.month;
    copy.year = self.year;
    return copy;
}

+ (id)day {    
    return [EFDay dayWithDate:[NSDate date]];
}

+ (id)dayWithDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSDateComponents *components = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    return [EFDay dayWithDay:components.day month:components.month year:components.year];  
}

+ (id)dayWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    EFDay *aDay = [[[EFDay alloc] init] autorelease];
    aDay.day = day;
    aDay.month = month;
    aDay.year = year;
    
    return aDay;
    
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%4d-%2d-%2d", (int)self.year, (int)self.month, (int)self.day];
}

- (NSDate *)dateValue {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
        
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:self.day];
    [components setMonth:self.month];
    [components setYear:self.year];
    
    NSDate *result = [cal dateFromComponents:components];
    
    [components release];
    
    return result;
}

- (NSString *)description {
    return [self stringValue];
}

- (BOOL)isEqualToDay:(EFDay *)other {
    return (self.year == other.year &&
           self.month == other.month &&
           self.day == other.day);
}


- (void)dealloc {    
    [super dealloc];
}

@end
