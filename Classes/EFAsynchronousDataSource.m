//
//  EFAsynchronousDatasource.m
//  Egeniq
//
//  Created by Ivo Jansch on 8/14/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFAsynchronousDataSource-protected.h"

@implementation EFAsynchronousDataSource

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)fetchUrl:(NSURL *)url processData:(EFAsynchronousDataSourceProcessBlock)processBlock onComplete:(EFAsynchronousDataSourceCompleteBlock)completeBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        id processedData = processBlock(data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(processedData);
        });
    });
}


@end
