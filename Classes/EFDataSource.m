//
//  ECCDataSource.m
//  CameraControl
//
//  Created by Peter Verhage on 09-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFDataSource.h"

@implementation EFDataSource

@synthesize baseEntityName=baseEntityName_;
@synthesize managedObjectContext=managedObjectContext_;

- (void)usingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext 
                     executeBlock:(void(^)())executeBlock {
    NSManagedObjectContext *oldContext = self.managedObjectContext;
    self.managedObjectContext = managedObjectContext;
    executeBlock();
    self.managedObjectContext = oldContext;
}

- (NSManagedObject *)insertNewObject {
    return [NSEntityDescription insertNewObjectForEntityForName:self.baseEntityName inManagedObjectContext:self.managedObjectContext];    
}

- (NSManagedObject *)insertNewObjectWithData:(NSDictionary *)data {
	NSMutableDictionary *mutableData = [NSMutableDictionary dictionaryWithDictionary:data];
	
    NSString *type = self.baseEntityName;
	if ([mutableData objectForKey:@"type"] != nil) {
		type = [mutableData objectForKey:@"type"];
	}
	
	NSArray *children = nil;
	if ([mutableData objectForKey:@"children"] != nil) {
		children = [mutableData objectForKey:@"children"];
		[mutableData removeObjectForKey:@"children"];
	}
	
	NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:type inManagedObjectContext:self.managedObjectContext];
	[object setValuesForKeysWithDictionary:mutableData];	
	
	if (children != nil) {
		for (NSDictionary *childData in children) {
			NSMutableDictionary *mutableChildData = [NSMutableDictionary dictionaryWithDictionary:childData];
			[mutableChildData setObject:object forKey:@"parent"];
			[self insertNewObjectWithData:mutableChildData];
		}
	}
    
    return object;
}


- (NSUInteger)countWithPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:nil];
	NSError *error = nil;
	NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];	
	
	return count == NSNotFound ? 0 : count;    
}

- (void)deleteObjectsWithPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:nil];
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *objects = [managedObjectContext_ executeFetchRequest:request error:&error]; 
    [request release];
    
    for (NSManagedObject *object in objects) {
        [self.managedObjectContext deleteObject:object];
    }    
}

- (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate 
                              sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.baseEntityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    if (predicate != nil) {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDescriptors != nil && [sortDescriptors count] > 0) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }

    return [fetchRequest autorelease];
}
    
- (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate 
                                                      sortDescriptors:(NSArray *)sortDescriptors
                                                   sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                            cacheName:(NSString *)cacheName {
    NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																							   managedObjectContext:self.managedObjectContext
																								 sectionNameKeyPath:sectionNameKeyPath 
																										  cacheName:cacheName];
    
    return [fetchedResultsController autorelease];
} 

- (NSManagedObject *)findObjectWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:nil];
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];	
	
	if (result != nil && [result count] > 0) {
		return (NSManagedObject *)[result objectAtIndex:0];
	} else {
		return nil;
	}    
}

@end
