//
//  EFAsynchronousDataSource-Protected.h
//  Egeniq
//
//  Created by Ivo Jansch on 8/14/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFAsynchronousDataSource.h"

typedef id(^EFAsynchronousDataSourceProcessBlock)(NSData *);

@interface EFAsynchronousDataSource () 

/**
 Fetch the contents of a URL, process it in the background (processData), 
 and consume it on the foreground (onComplete)
*/
- (void)fetchUrl:(NSURL *)url processData:(EFAsynchronousDataSourceProcessBlock)processBlock onComplete:(EFAsynchronousDataSourceCompleteBlock)completeBlock;

@end