//
//  EFServiceContainerTest.m
//  Egeniq
//
//  Created by Johan Kool on 13/2/2014.
//  Copyright (c) 2014 Egeniq. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "EFServiceContainer.h"
#import "EFServiceContainer-Protected.h"

@interface MYTestContainer : EFServiceContainer

@property (nonatomic, strong) NSObject *testService;

@end

@implementation MYTestContainer

- (NSObject *)testService {
    return [self serviceForKey:1 initializer:^id{
        return [[[NSObject alloc] init] autorelease];
    }];
}

@end

@interface EFServiceContainerTest : XCTestCase

@end

@implementation EFServiceContainerTest

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testClass {
    MYTestContainer *test = [MYTestContainer sharedInstance];
    XCTAssertTrue([test isKindOfClass:[MYTestContainer class]], @"Ensure correct class is instantiated");
}

@end
