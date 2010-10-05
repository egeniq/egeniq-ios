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
    
    // create the queue of queues
    queues = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (int i=0;i<5;i++) {
        NSMutableArray* aQueue = [[NSMutableArray alloc] initWithCapacity:10];
        [queues addObject:aQueue];
        [aQueue release];
    }
    
    queueStarted = NO;
    
    return self;
    
    
}

- (NSUInteger) count {
    NSUInteger sum;
    for (NSMutableArray *queue in queues) {
        sum += [queue count];
    }
    return sum;
}

- (void) processQueue {
    
    if (queueStarted) {
        
        // @todo First check max prio downloads, which run in isolation.
        
        if (downloadsRunning < downloadConcurrency) {
            
            NSMutableArray* firstInLine = nil;
            // Find highest priority queue that has items to download.
            for (int i=0;i<5 && firstInLine == nil;i++) {
                NSMutableArray* aQueue = [queues objectAtIndex:i];
                if ([aQueue count]>0) {
                    firstInLine = aQueue;
                }
            }
        
            if (firstInLine != nil) {
            
                if ([firstInLine count]>0) {
                    
                    EFDownload* next = [[firstInLine objectAtIndex:0] retain];
                  
                    [firstInLine removeObjectAtIndex:0];
                    
                    downloadsRunning++;
                    [next start];
                    
                }
            }
        }
    }
    
}

- (void) start {
    if (!queueStarted) {
        queueStarted = YES;
        [self processQueue];
    }
}

- (void) clear {
    for (int i=0;i<5;i++) {
        NSMutableArray* queue = [queues objectAtIndex:i];
        [queue removeAllObjects];
    }
}

- (NSMutableArray *) queueForPriority: (EFDownloadPriority) priority {
    
    return [queues objectAtIndex:priority];   
}

- (void) addDownload: (EFDownload *)download {
    
    [self addDownload:download withPriority:EFDownloadPriorityNormal];
}


- (void) addDownload: (EFDownload *)download withPriority: (EFDownloadPriority) priority {
    
    [download setDelegate:self];
    
    NSMutableArray *queue = [self queueForPriority:priority];
    
    [queue addObject:download];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(queue:didQueueDownload:)]) {
        [delegate queue:self didQueueDownload:download];
    }
    
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
    [queues release];
    [super dealloc];
    
}


@end
