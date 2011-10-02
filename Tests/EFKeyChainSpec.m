//
//  EFKeyChainSpec.m
//
//  Created by Allen Ding on 10/2/11.
//  Copyright (c) 2011 Egeniq. All rights reserved.
//

#import "Kiwi.h"
#import "EFKeyChain.h"

SPEC_BEGIN(EFKeyChainSpec)

describe(@"EFKeyChain", ^{
    static NSString * const fakeServiceName = @"fake_service_beanstalk.com";
    
    beforeEach(^{
        // Remove items since the methods actually cause persistent changes. If delete does not work, then this doesn't
        // do much, but would cause anoter failure below to prompt us to take a closer look!
        EFKeyChain *keyChain = [EFKeyChain keyChain];
        [keyChain deleteItemForUserId:@"jack" serviceName:fakeServiceName error:NULL];
    });
    
    it(@"should exist", ^{
        [[EFKeyChain keyChain] shouldNotBeNil];
    });
    
    it(@"should store and retrieve items", ^{
        // Given
        EFKeyChain *keyChain = [EFKeyChain keyChain];
        
        // When
        [keyChain storeUserId:@"jack" password:@"jill" forServiceName:fakeServiceName updateExisting:NO error:NULL];
        
        // Then
        NSString *password = [keyChain passwordForUserId:@"jack" serviceName:fakeServiceName error:NULL];
        [[password should] equal:@"jill"];
    });
    
    it(@"update existing items", ^{
        // Given
        EFKeyChain *keyChain = [EFKeyChain keyChain];
        [keyChain storeUserId:@"jack" password:@"queso" forServiceName:fakeServiceName updateExisting:NO error:NULL];
        
        // When
        BOOL updateExisting = YES;
        [keyChain storeUserId:@"jack" password:@"nachos" forServiceName:fakeServiceName updateExisting:updateExisting error:NULL];
        
        // Then
        NSString *password = [keyChain passwordForUserId:@"jack" serviceName:fakeServiceName error:NULL];
        [[password should] equal:@"nachos"];
    });
    
    it(@"should remove items", ^{
        // Given
        EFKeyChain *keyChain = [EFKeyChain keyChain];
        [keyChain storeUserId:@"jack" password:@"magicbeans" forServiceName:fakeServiceName updateExisting:NO error:NULL];
        
        // When
        [keyChain deleteItemForUserId:@"jack" serviceName:fakeServiceName error:NULL];
        
        // Them
        NSString *password = [keyChain passwordForUserId:@"jack" serviceName:fakeServiceName error:NULL];
        [password shouldBeNil];
    });
});

SPEC_END
