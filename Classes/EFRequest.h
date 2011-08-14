//
//  EFRequest.h
//  Egeniq
//
//  Created by Peter Verhage on 14-08-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFQueue.h"

typedef id (^EFRequestPreProcessBlock)(NSURLResponse *response, NSData *data, NSError **error);
typedef void (^EFRequestResultBlock)(NSURLResponse *response, id result, NSError *error);
typedef void (^EFRequestCompletionBlock)();

@interface EFRequest : NSObject <EFQueueable> {
    
}

@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, copy) EFRequestPreProcessBlock preProcessHandler;
@property (nonatomic, copy) EFRequestResultBlock resultHandler;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) BOOL allowSelfSignedSSLCertificate;
 
@property (nonatomic, assign, readonly, getter=isLoading) BOOL isLoading;

+ (id)request;
+ (id)requestWithURL:(NSURL *)URL;
+ (id)requestWithURL:(NSURL *)URL
   preProcessHandler:(EFRequestPreProcessBlock)preProcessHandler
       resultHandler:(EFRequestResultBlock)resultHandler;

- (id)init;
- (id)initWithURL:(NSURL *)URL;
- (id)initWithURL:(NSURL *)URL
preProcessHandler:(EFRequestPreProcessBlock)preProcessHandler
    resultHandler:(EFRequestResultBlock)resultHandler;

- (NSString *)HTTPMethod;
- (void)setHTTPMethod:(NSString *)method;

- (NSDictionary *)allHTTPHeaderFields;
- (NSString *)valueForHTTPHeaderField:(NSString *)field;
- (void)setAllHTTPHeaderFields:(NSDictionary *)headerFields;
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

- (NSData *)HTTPBody;
- (void)setHTTPBody:(NSData *)body;
- (void)setAllHTTPPostFields:(NSDictionary *)postFields;
- (void)addValue:(NSData *)value forHTTPPostField:(NSString *)field;

- (void)startWithCompletionHandler:(EFRequestCompletionBlock)completionHandler;
- (void)start;
- (void)cancel;

@end