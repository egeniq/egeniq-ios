//
//  EFDIContainer.m
//  Egeniq
//
//  Created by Ivo Jansch on 8/15/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFServiceContainer-Protected.h"

@interface EFServiceContainer() 

@property (nonatomic, retain) NSMutableDictionary *services;

@end

@implementation EFServiceContainer

@synthesize services=services_;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here
        self.services = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    return self;
}

- (id)serviceForKey:(NSUInteger)serviceKey {
    return [self.services objectForKey:[NSNumber numberWithInt:serviceKey]];
}

- (id)serviceForKey:(NSUInteger)serviceKey initializer:(id (^)(void))initializer {
    id service = [self.services objectForKey:[NSNumber numberWithInt:serviceKey]];
    
    if (service == nil && initializer != nil) {
        service = initializer();
        
        if (service != nil) {
            [self setService:service forKey:serviceKey];
        }
    }
    
    return service;
}

- (void)setService:(id)service forKey:(NSUInteger)serviceKey {
    [self.services setObject:service forKey:[NSNumber numberWithInt:serviceKey]];
}

- (void)dealloc {
    self.services = nil;
    [super dealloc];
}

@end
