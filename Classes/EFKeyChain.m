//
//  EFKeyChain.m
//  Egeniq
//
//  Loosely inspired by https://github.com/ldandersen/scifihifi-iphone/blob/master/security/SFHFKeychainUtils.m
//  SFHFKeychainUtils is created by Buzz Andersen
//  Which in turn is based on work by Jonathan Wight, Jon Crosby, and Mike Malone.

//  Created by Ivo Jansch on 8/22/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFKeyChain.h"

#import <Security/Security.h>

@implementation EFKeyChain

+ (id)init {
    if (self = [super init]) {
    }
    return self;
}

+ (id)keyChain {
    EFKeyChain *keyChain = [[[self alloc] init] autorelease];
    return keyChain;
}
                                                        
- (NSString *)passwordForUserId:(NSString *)userId 
                    serviceName:(NSString *)serviceName 
                          error:(NSError **) error {
    
    if (!userId || !serviceName) {
        *error = [NSError errorWithDomain:EFErrorDomain code:EFInvalidParametersError userInfo: nil];
        return nil;
    }
    
    if (error != nil) {
        *error = nil;
    }
    
    // Set up a query dictionary with the base query attributes: item type (generic), userId, and service
    
    NSArray *keys = [NSArray arrayWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
    NSArray *objects = [NSArray arrayWithObjects: (NSString *) kSecClassGenericPassword, userId, serviceName, nil];
    
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).
    
    NSDictionary *attributeResult = NULL;
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
    OSStatus status = SecItemCopyMatching((CFDictionaryRef) attributeQuery, (CFTypeRef *) &attributeResult);
    
    [attributeResult release];
    [attributeQuery release];
    
    if (status != noErr) {
        // No existing item found--simply return nil for the password
        if (status != errSecItemNotFound) {
            //Only return an error if a real exception happened--not simply for "not found."
            // TODO: parse status
            *error = [NSError errorWithDomain: EFErrorDomain code: EFUnknownError userInfo: nil];
        }

        return nil;
    }
    
    // We have an existing item, now query for the password data associated with it.
    
    NSData *resultData = nil;
    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnData];

    status = SecItemCopyMatching((CFDictionaryRef) passwordQuery, (CFTypeRef *) &resultData);
    
    [resultData autorelease];
    [passwordQuery release];
    
    if (status != noErr) {
        if (status == errSecItemNotFound) {
            return nil;
        }
        else {
            // Something else went wrong. Simply return the normal Keychain API error code.
            *error = [NSError errorWithDomain:EFErrorDomain code:EFUnknownError userInfo: nil];
        }
        
        return nil;
    }
    
    NSString *password = nil;	
    
    if (resultData) {
        password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    else {
        if (error != nil) {
            *error = [NSError errorWithDomain:EFErrorDomain code: -1999 userInfo: nil];
        }
    }
    
    return [password autorelease];
}

- (BOOL) storeUserId:(NSString *)userId 
            password:(NSString *)password 
      forServiceName:(NSString *)serviceName 
      updateExisting:(BOOL)updateExisting 
               error:(NSError **)error {		
    if (!userId || !password || !serviceName) {
        *error = [NSError errorWithDomain:EFErrorDomain code: EFInvalidParametersError userInfo: nil];
        return NO;
    }
    
    // See if we already have a password entered for these credentials.
    NSError *getError = nil;
    NSString *existingPassword = [self passwordForUserId:userId serviceName:serviceName error:&getError];
        
    if (error != nil) {
        *error = nil;
    }
    
    OSStatus status = noErr;
    
    if (existingPassword) {
        // We have an existing, properly entered item with a password.
        // Update the existing item.

        if (![existingPassword isEqualToString:password] && updateExisting) {
            //Only update if we're allowed to update existing.  If not, simply do nothing.

            NSArray *keys = [NSArray arrayWithObjects: (NSString *) kSecClass, 
                             kSecAttrService, 
                             kSecAttrLabel, 
                             kSecAttrAccount, 
                             nil];
            
            NSArray *objects = [NSArray arrayWithObjects:(NSString *)kSecClassGenericPassword, 
                                serviceName,
                                serviceName,
                                userId,
                                nil];

            NSDictionary *query = [NSDictionary dictionaryWithObjects:objects forKeys:keys];			
            
            status = SecItemUpdate((CFDictionaryRef) query, 
                                   (CFDictionaryRef) [NSDictionary dictionaryWithObject: [password dataUsingEncoding: NSUTF8StringEncoding] 
                                                                                 forKey: (NSString *) kSecValueData]);
        }
    }
    else {
        // No existing entry (or an existing, improperly entered, and therefore now
        // deleted, entry).  Create a new entry.
        
        NSArray *keys = [NSArray arrayWithObjects: (NSString *) kSecClass, 
                          kSecAttrService, 
                          kSecAttrLabel, 
                          kSecAttrAccount, 
                          kSecValueData, 
                          nil];
        
        NSArray *objects = [NSArray arrayWithObjects: (NSString *) kSecClassGenericPassword, 
                             serviceName,
                             serviceName,
                             userId,
                             [password dataUsingEncoding: NSUTF8StringEncoding],
                             nil];
        
        NSDictionary *query = [NSDictionary dictionaryWithObjects:objects forKeys:keys];			
        
        status = SecItemAdd((CFDictionaryRef) query, NULL);
    }
    
    if (error != nil && status != noErr) {
        // Something went wrong with adding the new item. Return the Keychain error code.
        // todo: translate status to errorcode
        *error = [NSError errorWithDomain:EFErrorDomain code:EFUnknownError userInfo: nil];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)deleteItemForUserId:(NSString *)userId 
                serviceName:(NSString *)serviceName 
                      error:(NSError **) error {
    if (!userId || !serviceName) {
        *error = [NSError errorWithDomain:EFErrorDomain code:EFInvalidParametersError userInfo: nil];
        return NO;
    }
    
    if (error != nil) {
        *error = nil;
    }
    
    NSArray *keys = [NSArray arrayWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray *objects = [NSArray arrayWithObjects: (NSString *) kSecClassGenericPassword, userId, serviceName, kCFBooleanTrue, nil];
    
    NSDictionary *query = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
    
    OSStatus status = SecItemDelete((CFDictionaryRef) query);
    
    if (error != nil && status != noErr) {
        // todo translate status to errorcode
        *error = [NSError errorWithDomain:EFErrorDomain code:EFUnknownError userInfo: nil];		
        
        return NO;
    }

    return YES;
}

@end