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
    return [EFDay dayFromDate:[NSDate date]];
}

+ (id)dayFromDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSDateComponents *components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
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
    return [NSString stringWithFormat:@"%4d-%2d-%2d", self.year, self.month, self.day];
}

- (NSString *)description {
    return [self stringValue];
}

- (void)dealloc {    
    [super dealloc];
}

@end
