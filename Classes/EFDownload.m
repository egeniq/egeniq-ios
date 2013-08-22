//
//  Downloader.m
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "EFDownload.h"

@interface EFDownload ()

@property (nonatomic, copy) EFDownloadCompletionBlock completionHandler;

@end

@implementation EFDownload

@synthesize request=request_;
@synthesize targetURL=targetURL_;
@synthesize preProcessHandler=preProcessHandler_;
@synthesize resultHandler=resultHandler_;

@synthesize completionHandler=completionHandler_;

#pragma mark -
#pragma mark Initialization

+ (id)download {
    return [[[self alloc] init] autorelease];
}

+ (id)downloadWithRequest:(EFRequest *)request 
                targetURL:(NSURL *)targetURL {
    return [[[self alloc] initWithRequest:request 
                                targetURL:targetURL] autorelease];
}

+ (id)downloadWithRequest:(EFRequest *)request 
                targetURL:(NSURL *)targetURL
        preProcessHandler:(EFDownloadPreProcessBlock)preProcessHandler
            resultHandler:(EFDownloadResultBlock)resultHandler {
    return [[[self alloc] initWithRequest:request 
                                targetURL:targetURL 
                        preProcessHandler:preProcessHandler 
                            resultHandler:resultHandler] autorelease];
}

- (id)init {
    return [self initWithRequest:nil targetURL:nil preProcessHandler:nil resultHandler:nil];
}

- (id)initWithRequest:(EFRequest *)request 
            targetURL:(NSURL *)targetURL {
    return [self initWithRequest:request targetURL:targetURL preProcessHandler:nil resultHandler:nil];    
}

- (id)initWithRequest:(EFRequest *)request 
            targetURL:(NSURL *)targetURL
    preProcessHandler:(EFDownloadPreProcessBlock)preProcessHandler
        resultHandler:(EFDownloadResultBlock)resultHandler {
    self = [super init];
    if (self != nil) {
        self.request = request;
        self.targetURL = targetURL;
        self.preProcessHandler = preProcessHandler;
        self.resultHandler = resultHandler;
    }
    
    return self;
}

#pragma mark -
#pragma mark Actions

- (void)startWithCompletionHandler:(EFDownloadCompletionBlock)completionHandler {
    if (self.preProcessHandler != nil) {
        self.request.preProcessHandler = ^NSData * (NSURLResponse *response, NSData *data, NSError **error) {
            return self.preProcessHandler(response, data, error);
        };
    }
    
    self.request.resultHandler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error == nil) {
            [data writeToURL:self.targetURL options:NSDataWritingAtomic error:&error];
        }
        
        if (self.resultHandler != nil && error == nil) {
            self.resultHandler(response, self.targetURL, nil);
        } else if (self.resultHandler != nil && error != nil) {
            self.resultHandler(nil, nil, error);
        }
    };
    
    [self.request startWithCompletionHandler:completionHandler];
}

- (void)start {
    [self startWithCompletionHandler:nil];
}

- (void)cancel {
    [self.request cancel];
}

- (void)setProgressHandler:(EFDownloadProgressBlock)progressHandler {
    self.request.progressHandler = progressHandler;
}

- (EFDownloadProgressBlock)progressHandler {
    return self.request.progressHandler;
}

#pragma mark -
#pragma mark Clean-up

- (void)dealloc {
    self.completionHandler = nil;
    self.resultHandler = nil;
    self.preProcessHandler = nil;
    
    [self.request cancel];
    self.request = nil;
    
    self.targetURL = nil;

	[super dealloc];
}

@end