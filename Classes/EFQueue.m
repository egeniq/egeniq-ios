//
//  EFQueue.m
//  Egeniq
//
//  Created by Ivo Jansch on 8/27/10.
//  Copyright (c) 2010 Egeniq. All rights reserved.
//

#import "EFQueue.h"

@interface EFQueue ()

@property (nonatomic, retain) NSMutableArray *queues;
@property (nonatomic, assign, getter=isActive) BOOL active;
@property (assign) NSUInteger activeCount; // atomic

@end

@implementation EFQueue

@synthesize concurrency=concurrency_;
@synthesize delegate=delegate_;

@synthesize queues=queues_;
@synthesize active=active_;
@synthesize activeCount=activeCount_;

- (id)initWithConcurrency:(NSUInteger)concurrency {
	self = [super init];
    if (self != nil) {
        self.concurrency = concurrency;
        
        self.queues = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < [self.queues count]; i++) {
            NSMutableArray *queue = [NSMutableArray arrayWithCapacity:10];
            [self.queues addObject:queue];
        }
        
        self.active = NO;
        self.activeCount = 0;
    }

	return self;
}

- (NSUInteger)count {
	NSUInteger sum = 0;
	for (NSMutableArray *queue in self.queues) {
		sum += [queue count];
	}
    
	return sum;
}

- (void)startQueueable:(id<EFQueueable>)queueable {
    self.activeCount++;
    
    [queueable startWithCompletionHandler:^() {
        self.activeCount--;
        
        if ([self.delegate respondsToSelector:@selector(queue:didFinishQueueable:)]) {
            [self.delegate queue:self didStartQueueable:queueable];
        }
        
        [queueable release];                    
    }];
    
    if ([self.delegate respondsToSelector:@selector(queue:didStartQueueable:)]) {
        [self.delegate queue:self didStartQueueable:queueable];
    }    
}

- (void)processQueue {
    if (!self.isActive) {
        return;
    }
    
    // TODO: First check max prio downloads, which run in isolation.

    if ([self activeCount] >= self.concurrency) {
        return;
    }
    
    NSMutableArray *firstInLine = nil;
    
    // Find highest priority queue that has items to download.
    for (int i = 0; i < 5 && firstInLine == nil; i++) {
        NSMutableArray *queue = [self.queues objectAtIndex:i];
        if ([queue count] > 0) {
            firstInLine = queue;
        }
    }

    if (firstInLine != nil && [firstInLine count] > 0) {
        id<EFQueueable> queueable = [[firstInLine objectAtIndex:0] retain];
        [firstInLine removeObjectAtIndex:0];
        [self startQueueable:queueable];
    }
}

- (void)start {
	if (self.isActive) {
        return;
    }
	
    self.active = YES;
	[self processQueue];
}

- (void)clear {
    for (NSMutableArray *queue in self.queues) {
        [queue removeAllObjects];
    }
}

- (NSMutableArray *)queueForPriority:(EFQueuePriority)priority {
	return [self.queues objectAtIndex:priority];
}

- (void)addQueueable:(id<EFQueueable>)queueable {
	[self addQueueable:queueable withPriority:EFQueuePriorityNormal];
}

- (void)addQueueable:(id<EFQueueable>)queueable withPriority:(EFQueuePriority)priority {
	NSMutableArray *queue = [self queueForPriority:priority];
	[queue addObject:queueable];
	[self processQueue];
}

- (void)dealloc {
	self.queues = nil;
	[super dealloc];
}

@end