//
//  EFDayTests.m
//  Egeniq
//
//  Created by Johan Kool on 18/4/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(EFDayTests)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

SPEC_END