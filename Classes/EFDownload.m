//
//  Downloader.m
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "EFDownload.h"

@interface EFDownload ()

@property (nonatomic, retain) NSMutableDictionary *payload;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *incomingData;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSURLResponse *response;

@end

@implementation EFDownload

@synthesize delegate=delegate_;
@synthesize incomingData=incomingData_;
@synthesize data=data_;
@synthesize response=response_;
@synthesize targetPath=targetPath_;
@synthesize url=url_;
@synthesize timeoutInterval=timeoutInterval_;
@synthesize tag=tag_;
@synthesize allowSelfSignedSSLCertificate=allowSelfSignedSSLCertificate_;
@synthesize payload=payload_;
@synthesize connection=connection_;

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

- (void)cancel {
	[self.connection cancel];
	self.connection = nil;
	self.incomingData = nil;
    self.data = nil;
    self.response = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.incomingData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = self.incomingData;
    self.incomingData = [NSMutableData dataWithLength:0];
    
	if (self.response != nil && self.delegate != nil && [self.delegate respondsToSelector:@selector(download:didReceiveDownload:response:)]) {
		[self.delegate download:self didReceiveDownload:self.data response:self.response];
	} 
    
    self.response = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connection = nil;
    
    self.data = self.incomingData;
    self.incomingData = nil;

	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(download:didReceiveDownload:response:)]) {
		[self.delegate download:self didReceiveDownload:self.data response:self.response];
	} 
    
	if (self.targetPath != nil) {
		// Save the download to target path.
		if (![self.data writeToFile:self.targetPath atomically:YES]) {
			NSLog(@"Couldn't write file to %@", self.targetPath); // TODO: graceful error handling, notify delegate.
		}
	}

	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(downloadDidFinishLoading:)]) {
		[self.delegate downloadDidFinishLoading:self];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.connection = nil;
    self.incomingData = nil;
    self.data = nil;
    self.response = nil;
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(download:didFailWithError:)]) {
		[self.delegate download:self didFailWithError:error];
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

- (void)addPayload:(id)payload forKey:(NSString *)key {
	[self.payload setObject:payload forKey:key];
}

- (id)getPayloadForKey:(NSString *)key {
    return [self.payload objectForKey:key];
}

- (void)dealloc {
    self.delegate = nil;
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