//
//  EFDIContainer.m
//  Egeniq
//
//  Created by Ivo Jansch on 8/15/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFServiceContainer.h"


@interface EFServiceContainer() 

@property (nonatomic, retain) NSMutableDictionary *services;

@end

@implementation EFServiceContainer

@synthesize services=services_;

- (id) serviceForKey:(NSUInteger)serviceKey {
    return [self.services objectForKey:[NSNumber numberWithInt:serviceKey]];
}

- (void) setService:(id)service forKey:(NSUInteger)serviceKey {
    [self.services setObject:service forKey:[NSNumber numberWithInt:serviceKey]];
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.services = dictionary;
        [dictionary release];
    }
    
    return self;
}

- (void)dealloc {
    self.services = nil;
    [super dealloc];
}

@end
