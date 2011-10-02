//
//  EFDaySpec.m
//
//  Created by Allen Ding on 10/2/11.
//  Copyright (c) 2011 Egeniq. All rights reserved.
//

#import "Kiwi.h"
#import "EFDay.h"

SPEC_BEGIN(EFDaySpec)

describe(@"EFDay", ^{
    it(@"+day should return today's date components", ^{
        // When
        EFDay *day = [EFDay day];
        NSDate *date = [NSDate date];
        
        // Then
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
        [[theValue(day.day) should] equal:theValue(components.day)];
        [[theValue(day.month) should] equal:theValue(components.month)];
        [[theValue(day.year) should] equal:theValue(components.year)];
    });
    
    it(@"-stringValue should return the right format for double digit components", ^{
        // When
        EFDay *day = [EFDay dayWithDay:12 month:10 year:2011];
        
        // Then
        [[[day stringValue] should] equal:@"2011-10-12"];
    });
    
    it(@"-stringValue should return the right format for single digit components", ^{
        // When
        EFDay *day = [EFDay dayWithDay:4 month:10 year:2011];
        
        // Then
        [[[day stringValue] should] equal:@"2011-10- 4"]; // Really? - Allen
    });
});

SPEC_END
