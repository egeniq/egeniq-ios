//
//  EFKeyChain.h
//  Egeniq
//
//  Created by Ivo Jansch on 8/22/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EFError.h"

//typedef enum {
    // TODO: error codes not yet defined, all errors are EFUnknownError for now.
    // EFKeyChain...Error = EFKeyChainErrorMinimum
//} EFKeyChainError;

@interface EFKeyChain : NSObject

+ (id)init;
+ (id)keyChain;

- (BOOL)storeUserId:(NSString *)userId
           password:(NSString *)password 
     forServiceName:(NSString *)serviceName 
     updateExisting:(BOOL)updateExisting 
              error:(NSError **)error;

- (NSString *)passwordForUserId:(NSString *)userId 
                    serviceName:(NSString *)serviceName 
                          error:(NSError **)error;

- (BOOL)deleteItemForUserId:(NSString *)userId 
                  serviceName:(NSString *)serviceName 
                        error:(NSError **) error;

@end
