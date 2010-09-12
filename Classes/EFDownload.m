//
//  Downloader.m
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "EFDownload.h"


@implementation EFDownload

@synthesize delegate;
@synthesize data;
@synthesize targetPath;

- (id) initWithURL: (NSURL *)anUrl {
    
    self = [super init];
    
    url = [anUrl copy];
    
    payload = nil;
    
    return self;
}

- (void) start {
    
    [data release];
    data = [[NSMutableData alloc] init];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    [connection release];
    [request release];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
    
    [data appendData:newData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (targetPath!=nil) {
        
        // Save the download to target path.
        if (![data writeToFile:targetPath atomically:YES]) {
            NSLog(@"Couldn't write file to %@", targetPath);
            // todo graceful error handling, notify delegate.
        }    
            
        
    }
    
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(downloadDidFinishLoading:)]) {
        [delegate downloadDidFinishLoading:self];
    }
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(download:didFailWithError:)]) {
        [delegate download:self didFailWithError:error];
    }
    
}

- (void) addPayload: (id)object forKey: (NSString *)key {
    
    if (payload==nil) {
        
        payload = [[NSMutableDictionary alloc] initWithCapacity:1];
        
    }
    [payload setObject:object forKey:key];
    
    
}
- (id) getPayloadForKey: (NSString *)key {
    
    if (payload!=nil) {
        
        return [payload objectForKey: key];
        
    }
    return nil;
    
}



- (void) dealloc {
    
    delegate = nil;
    
    if (payload!=nil) {
        
        [payload release]; payload=nil;
        
    }
    
    if (targetPath!=nil) {
        
        [targetPath release]; targetPath=nil;
    }
    
    [data release];
    
    [url release];
    
    [super dealloc];
    
    
}


@end
