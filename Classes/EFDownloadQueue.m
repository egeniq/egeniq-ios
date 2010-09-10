//
//  EFDownloadQueue.m
//  iPortfolio
//
//  Created by Ivo Jansch on 8/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "EFDownloadQueue.h"


@implementation EFDownloadQueue

@synthesize delegate;

- (id)initWithConcurrency: (NSUInteger)concurrency {
    
    self = [super init];
    
    downloadConcurrency = concurrency; 
    downloadsRunning = 0;
    
    queue = [[NSMutableArray alloc] initWithCapacity:10];
    
    return self;
    
    
}

- (void) processQueue {
    
    if (downloadsRunning < downloadConcurrency) {
     
        if ([queue count]>0) {
            
            EFDownload* next = [[queue objectAtIndex:0] retain];
          
            [queue removeObjectAtIndex:0];
            
            downloadsRunning++;
            [next start];
            
        }
    }
    
}

- (void) addDownload: (EFDownload *)download {
    
    [download setDelegate:self];
    
    [queue addObject:download];
    
    [self processQueue];
    
}
                  
- (void) addPrioritizedDownload: (EFDownload *)download {
    
    [download setDelegate:self];
    
    [queue insertObject:download atIndex:0];
    
    [self processQueue];
    
}


- (void) downloadDidFinishLoading:(EFDownload *)download {
    
    downloadsRunning--;
    [self processQueue];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(queue:didFinishDownload:)]) {
        [delegate queue:self didFinishDownload:download];
    }
    
    // Now we can throw the download away.
    [download release];
    
}

- (void) download:(EFDownload *)download didFailWithError:(NSError *)error {
    
    NSLog(@"Queue download didFailWithError %@", error);
    downloadsRunning--;
    [self processQueue];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(queue:didFailDownload:withError:)]) {
        [delegate queue:self didFailDownload:download withError:error];
    }

    // Now we can throw the download away.
    [download release];
}


- (void)dealloc {
    [queue release];
    [super dealloc];
    
}


@end
