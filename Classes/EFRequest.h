//
//  EFRequest.h
//  Egeniq
//
//  Created by Peter Verhage on 14-08-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFQueue.h"
#import "EFError.h"

typedef id (^EFRequestPreProcessBlock)(NSURLResponse *response, NSData *data, NSError **error);
typedef void (^EFRequestResultBlock)(NSURLResponse *response, id result, NSError *error);
typedef void (^EFRequestCompletionBlock)();

// Errorcode definition. Note that EFRequest does not set these error codes, but
// result and completion blocks can use them to communicate certain error conditions
// in standard ways.
typedef enum {
    EFRequestUnknownError = EFRequestErrorMinimum,
    EFRequestUnreachabelError
} EFRequestErrorCodes;

@interface EFRequest : NSObject <EFQueueable> {
    
}

@property (nonatomic, retain) NSURL *URL;

/**
 * The pre-process handler can be implemented to process/convert data
 * in a background thread and make its result available for the result
 * handler. If no pre-process handler has been set, the result handler
 * will simply receive the raw response data. With a pre-process handler
 * set the result handler will receive the pre-processed value. If
 * during the pre-processing an error occurs the pre-process handler
 * should set the error out parameter accordingly and should return nil.
 *
 * The pre-process handler is executed on a background thread.
 */
@property (nonatomic, copy) EFRequestPreProcessBlock preProcessHandler;

/**
 * The result handler will get access to the (possibly) pre-processed
 * response result data. It can take action accordingly. The result
 * handler will be called multiple times for multi-part request. The
 * handler can check the status of the requests isFinished property to
 * check if subsequent responses might follow. 
 *
 * The result handler is executed on the main thread.
 */
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