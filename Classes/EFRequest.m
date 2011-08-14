//
//  Downloader.m
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "EFRequest.h"

@interface EFRequest ()

@property (nonatomic, assign, getter=isLoading) BOOL isLoading;

@property (nonatomic, retain) NSMutableURLRequest *request;

@property (nonatomic, copy) EFRequestCompletionBlock completionHandler;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSURLResponse *incomingResponse;
@property (nonatomic, retain) NSMutableData *incomingData;

@end

@implementation EFRequest

@synthesize URL=URL_;
@synthesize preProcessHandler=preProcessHandler_;
@synthesize resultHandler=resultHandler_;

@synthesize timeoutInterval=timeoutInterval_;
@synthesize allowSelfSignedSSLCertificate=allowSelfSignedSSLCertificate_;

@synthesize isLoading=isLoading_;

@synthesize request=request_;

@synthesize completionHandler=completionHandler_;
@synthesize connection=connection_;
@synthesize incomingResponse=incomingResponse_;
@synthesize incomingData=incomingData_;

#pragma mark -
#pragma mark Initialization

+ (id)requestWithURL:(NSURL *)URL {
    return [[[self alloc] initWithURL:URL] autorelease];
}

+ (id)requestWithURL:(NSURL *)URL 
   preProcessHandler:(EFRequestPreProcessBlock)preProcessHandler 
       resultHandler:(EFRequestResultBlock)resultHandler {
    return [[[self alloc] initWithURL:URL 
                    preProcessHandler:preProcessHandler 
                        resultHandler:resultHandler] autorelease];
}

- (id)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL preProcessHandler:nil resultHandler:nil];
}

- (id)initWithURL:(NSURL *)URL 
preProcessHandler:(EFRequestPreProcessBlock)preProcessHandler 
    resultHandler:(EFRequestResultBlock)resultHandler {
    self = [super init];
    if (self != nil) {
        self.URL = URL;
        self.preProcessHandler = preProcessHandler;
        self.resultHandler = resultHandler;
        
        self.request = [NSMutableURLRequest requestWithURL:URL];
        self.timeoutInterval = 30.0;
    }
    
    return self;
}

#pragma mark -
#pragma mark Setters and getters

- (NSString *)HTTPMethod {
    return self.request.HTTPMethod;
}

- (void)setHTTPMethod:(NSString *)method {
    self.request.HTTPMethod = method;
}

- (NSDictionary *)allHTTPHeaderFields {
    return self.request.allHTTPHeaderFields;
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return [self.request valueForHTTPHeaderField:field];
}

- (void)setAllHTTPHeaderFields:(NSDictionary *)headerFields {
    [self.request setAllHTTPHeaderFields:headerFields];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.request setValue:value forHTTPHeaderField:field];
}

- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.request addValue:value forHTTPHeaderField:field];
}

- (NSData *)HTTPBody {
    return self.request.HTTPBody;
}

- (void)setHTTPBody:(NSData *)body {
    self.request.HTTPBody = body;
}

- (void)setAllHTTPPostFields:(NSDictionary *)postFields {
    self.request.HTTPBody = [NSData data];
    for (NSString *field in [postFields keyEnumerator]) {
        [self addValue:[postFields valueForKey:field] forHTTPPostField:field];
    }
}

- (void)addValue:(NSData *)value forHTTPPostField:(NSString *)field {
    NSMutableData *body = [NSMutableData dataWithData:self.HTTPBody];
    
    if ([body length] > 0) {
        [body appendData:[@"&" dataUsingEncoding:NSUTF8StringEncoding]];            
    }
    
    [body appendData:[field dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"=" dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:value];
    
    self.HTTPBody = body;
}

#pragma mark -
#pragma mark Actions

- (void)startWithCompletionHandler:(EFRequestCompletionBlock)completionHandler {
    self.isLoading = YES;
    
    self.completionHandler = completionHandler;
    
	self.incomingData = nil;
    self.incomingResponse = nil;
    
    self.request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    self.request.timeoutInterval = self.timeoutInterval;
    self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
}

- (void)start {
    [self startWithCompletionHandler:nil];
}

- (void)cancel {
    self.isLoading = NO;    
    
	[self.connection cancel];
	self.connection = nil;
    
	self.incomingData = nil;
    self.incomingResponse = nil;
    
    self.completionHandler = nil;
}

- (void)processResponse:(NSURLResponse *)response data:(NSData *)data {
    if (self.preProcessHandler != nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^() {
            NSError *error = nil;
            id result = self.preProcessHandler(response, data, &error);
            dispatch_async(dispatch_get_main_queue(), ^() {
                self.resultHandler(response, result, error);
            });
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^() {
            self.resultHandler(response, data, nil);
        });
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // The following might look a bit weird, but NSURLConnection calls didReceiveResponse at the
    // start of a new response, e.g. when the data still needs to be loaded. This means in a 
    // multipart result request we only have both the response and data if either didReceiveResponse
    // is called for a subsequent response or connectionDidFinishLoading is called.
    if (self.incomingResponse != nil) {
        [self processResponse:self.incomingResponse data:self.incomingData];
    }

    self.incomingResponse = response;
    self.incomingData = [NSMutableData dataWithLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.isLoading = NO;    
    
    if (self.incomingResponse != nil) {
        [self processResponse:self.incomingResponse data:self.incomingData];
    }
    
    self.incomingResponse = nil;
    self.incomingData = nil;
    self.connection = nil;
    
    if (self.completionHandler != nil) {
        self.completionHandler();
        self.completionHandler = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.isLoading = NO;    
    
    self.incomingResponse = nil;
    self.incomingData = nil;
    self.connection = nil;
    
    if (self.resultHandler != nil) {
        self.resultHandler(nil, nil, error);
    }
    
    if (self.completionHandler != nil) {
        self.completionHandler();
        self.completionHandler = nil;
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *) space {
    if ([[space authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        return self.allowSelfSignedSSLCertificate; // result doesn't matter for properly signed certs
    } else {
        return NO;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] &&
        self.allowSelfSignedSSLCertificate) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
}

#pragma mark -
#pragma mark Clean up

- (void)dealloc {
    self.completionHandler = nil;
    self.resultHandler = nil;
    self.preProcessHandler = nil;
    
	[self.connection cancel];
	self.connection = nil;
    
	self.incomingData = nil;
    self.incomingResponse = nil;
    
    self.request = nil;
    self.URL = nil;

	[super dealloc];
}

@end