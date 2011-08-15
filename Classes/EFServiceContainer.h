//
//  EFDIContainer.h
//  Egeniq
//
//  Created by Ivo Jansch on 8/15/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFServiceContainer : NSObject

/**
 * Retrieve a service with a particular key.
 * Returns nil if no service has been registered for this key.
 */
- (id)serviceForKey:(NSUInteger)serviceKey;

/**
 * Register a service with a particular key.
 */
- (void)setService:(id)service forKey:(NSUInteger)serviceKey;

@end
