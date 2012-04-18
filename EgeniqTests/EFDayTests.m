//
//  EFDayTests.m
//  Egeniq
//
//  Created by Johan Kool on 18/4/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "Kiwi.h"

#import "EFDay.h"

SPEC_BEGIN(EFDayTests)

describe(@"The EFDay class", ^{
    
    __block EFDay *day = nil;
    
    beforeEach(^{
        day = [EFDay day];
    });
    
    afterEach(^{
        day = nil;
    });
    
    context(@"when first created", ^{
        
        it(@"has a valid day", ^{
            [[theValue(day.day) should] beBetween:theValue(1) and:theValue(31)];
        });
        
        it(@"has a valid month", ^{
            [[theValue(day.month) should] beBetween:theValue(1) and:theValue(12)];
        });
        
        it(@"has a valid year", ^{
            [[theValue(day.year) should] beBetween:theValue(2012) and:theValue(2112)]; // This test is valid for the next century!
        });
        
        it(@"is today", ^{
            [[day should] equal:[EFDay dayWithDate:[NSDate date]]];
        });
        
    });
    
    context(@"on my birthday", ^{
        
        beforeEach(^{
            day = [EFDay dayWithDay:21 month:8 year:1979];
        });
        
        afterEach(^{
            day = nil;
        });
        
        it(@"has a valid stringValue", ^{
            [[[day stringValue] should] equal:@"1979-08-21"];
        });
        
    });
    
});

SPEC_END