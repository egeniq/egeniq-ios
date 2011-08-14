//
//  EFQueue.h
//  Egeniq
//
//  Created by Ivo Jansch on 8/27/10.
//  Copyright (c) 2010 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFQueue;

typedef enum {
	EFQueuePriorityMax=0,
	EFQueuePriorityHigh,
	EFQueuePriorityNormal,
	EFQueuePriorityLow,
	EFQueuePriorityMin
} EFQueuePriority;

typedef void (^EFQueueableCompletionBlock)();

@protocol EFQueueable <NSObject>

- (void)startWithCompletionHandler:(EFQueueableCompletionBlock)completionHandler;

@end

@protocol EFQueueDelegate <NSObject>

@optional
- (void)queue:(EFQueue *)queue didStartQueueable:(id<EFQueueable>)queueable;
- (void)queue:(EFQueue *)queue didFinishQueueable:(id<EFQueueable>)queueable;

@end

@interface EFQueue : NSObject {

}

@property (nonatomic, assign) NSUInteger concurrency;
@property (nonatomic, assign) id<EFQueueDelegate> delegate;

- (id)initWithConcurrency:(NSUInteger)concurrency;

- (NSUInteger)activeCount;
- (NSUInteger)count;

- (void)clear;
- (void)addQueueable:(id<EFQueueable>)queueable;
- (void)addQueueable:(id<EFQueueable>)queueable withPriority:(EFQueuePriority)priority;

- (void)start;

@end