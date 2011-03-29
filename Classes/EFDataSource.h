//
//  ECCDataSource.h
//  Egeniq
//
//  Created by Peter Verhage on 09-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EFDataSource : NSObject {
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

#ifdef __BLOCKS__
- (void)usingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext 
                     executeBlock:(void(^)())executeBlock;
#endif

@end