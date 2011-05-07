//
//  Downloader.m
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "EFDownload.h"

@interface EFDownload ()

@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSURLResponse *response;

@property (nonatomic, copy) EFDownloadResponseBlock responseHandler;
@property (nonatomic, copy) EFDownloadCompletionBlock completionHandler;

@property (nonatomic, retain) NSMutableDictionary *payload;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *incomingData;

@end

@implementation EFDownload

@synthesize tag=tag_;
@synthesize delegate=delegate_;
@synthesize url=url_;
@synthesize targetPath=targetPath_;
@synthesize timeoutInterval=timeoutInterval_;
@synthesize allowSelfSignedSSLCertificate=allowSelfSignedSSLCertificate_;

@synthesize data=data_;
@synthesize response=response_;

@synthesize responseHandler=responseHandler_;
@synthesize completionHandler=completionHandler_;

@synthesize payload=payload_;
@synthesize connection=connection_;
@synthesize incomingData=incomingData_;

- (id)initWithURL:(NSURL *)url {
	self = [super init];
    if (self != nil) {
        self.url = url;
        self.timeoutInterval = 30.0;
        self.payload = [NSMutableDictionary dictionary];
    }
    
	return self;
}

- (void)start {
	self.incomingData = nil;
    self.data = nil;
    self.response = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
	self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

- (void)startWithCompletionHandler:(EFDownloadCompletionBlock)completionHandler {
    self.completionHandler = completionHandler;
    [self start];    
}

- (void)startWithResponseHandler:(EFDownloadResponseBlock)responseHandler completionHandler:(EFDownloadCompletionBlock)completionHandler {
    self.responseHandler = responseHandler;
    self.completionHandler = completionHandler;
    [self start];
}

- (void)cancel {
	[self.connection cancel];
	self.connection = nil;
	self.incomingData = nil;
    self.data = nil;
    self.response = nil;
    self.responseHandler = nil;
    self.completionHandler = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.incomingData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = self.incomingData;
    self.incomingData = [NSMutableData dataWithLength:0];
    
	if (self.response != nil && [self.delegate respondsToSelector:@selector(download:didReceiveResponse:data:)]) {
		[self.delegate download:self didReceiveResponse:self.response data:self.data];
	} 
    
    if (self.response != nil && self.responseHandler != nil) {
        self.responseHandler(self.response, self.data);
    }
    
    self.response = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.data = self.incomingData;
    self.connection = nil;
    self.incomingData = nil;

	if ([self.delegate respondsToSelector:@selector(download:didReceiveResponse:data:)]) {
		[self.delegate download:self didReceiveResponse:self.response data:self.data];
	} 

    if (self.responseHandler != nil) {
        self.responseHandler(self.response, self.data);
    }    
    
	if (self.targetPath != nil) {
		// Save the download to target path.
		if (![self.data writeToFile:self.targetPath atomically:YES]) {
			NSLog(@"Couldn't write file to %@", self.targetPath); // TODO: graceful error handling, notify delegate.
		}
	}

	if ([self.delegate respondsToSelector:@selector(downloadDidFinishLoading:)]) {
		[self.delegate downloadDidFinishLoading:self];
	}
    
    if (self.completionHandler != nil) {
        self.completionHandler(self.response, self.data, nil);
    }
    
    self.responseHandler = nil;
    self.completionHandler = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.connection = nil;
    self.incomingData = nil;
    self.data = nil;
    self.response = nil;
	
	if ([self.delegate respondsToSelector:@selector(download:didFailWithError:)]) {
		[self.delegate download:self didFailWithError:error];
	}
    
    if (self.completionHandler != nil) {
        self.completionHandler(nil, nil, error);
    }
    
    self.responseHandler = nil;
    self.completionHandler = nil;
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

- (void)addPayload:(id)payload forKey:(NSString *)key {
	[self.payload setObject:payload forKey:key];
}

- (id)getPayloadForKey:(NSString *)key {
    return [self.payload objectForKey:key];
}

- (void)dealloc {
    self.delegate = nil;
    self.responseHandler = nil;
    self.completionHandler = nil;
    [self.connection cancel];
    self.connection = nil;
    self.incomingData = nil;
    self.data = nil;
    self.response = nil;
    self.payload = nil;
    self.targetPath = nil;
    self.url = nil;
	[super dealloc];
}

@end