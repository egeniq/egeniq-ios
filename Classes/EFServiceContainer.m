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

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here
        self.services = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    return self;
}

- (id)serviceForKey:(NSUInteger)serviceKey {
    @synchronized(self) {
        return [self.services objectForKey:@(serviceKey)];
    }
}

- (id)serviceForKey:(NSUInteger)serviceKey initializer:(id (^)(void))initializer {
    @synchronized(self) {
        id service = [self.services objectForKey:@(serviceKey)];
        
        if (service == nil && initializer != nil) {
            service = initializer();
            
            if (service != nil) {
                [self setService:service forKey:serviceKey];
            }
        }
        
        return service;
    }
}

- (void)setService:(id)service forKey:(NSUInteger)serviceKey {
    @synchronized(self) {
        [self.services setObject:service forKey:@(serviceKey)];
    }
}

- (void)dealloc {
    self.services = nil;
    [super dealloc];
}

@end
