//
//  EFServiceContainer-Protected.h
//  Egeniq
//
//  Copyright (c) 2011 Egeniq. All rights reserved.
//

#import "EFServiceContainer.h"

/**
 * Protected EFServiceContainer interface for subclasses. Manages the storage and retrieval of services for the subclass.
 */
@interface EFServiceContainer ()

/**
 * Retrieve a service with a particular key.
 * Returns nil if no service has been registered for this key.
 */
- (id)serviceForKey:(NSUInteger)serviceKey;

/**
 * Retrieves a service with a particular key.
 * If no service has been previously registered for this key, registers the result of initializer as the service for the key.
 * Returns nil if no service has been registered for this key.
 */
- (id)serviceForKey:(NSUInteger)serviceKey initializer:(id (^)(void))initializer;

/**
 * Register a service with a particular key.
 */
- (void)setService:(id)service forKey:(NSUInteger)serviceKey;

@end
