//
//  EFEntityGateway.m
//  Egeniq
//
//  Created by Peter Verhage on 09-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFEntityGateway.h"

@implementation EFEntityGateway

@synthesize entityName=entityName_;
@synthesize managedObjectContext=managedObjectContext_;

+ (id)entityGatewayWithEntityName:(NSString *)entityName    
                managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [[[self alloc] initWithEntityName:entityName
                        managedObjectContext:managedObjectContext] autorelease];
}

- (id)initWithEntityName:(NSString *)entityName 
        managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (self != nil) {
        self.entityName = entityName;
        self.managedObjectContext = managedObjectContext;
    }
    
    return self;
}

- (EFEntityGateway *)gatewayWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [[self class] entityGatewayWithEntityName:self.entityName managedObjectContext:managedObjectContext];
}

#ifdef __BLOCKS__
- (void)usingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext 
                     executeBlock:(void(^)())executeBlock {
    NSManagedObjectContext *oldContext = self.managedObjectContext;
    self.managedObjectContext = managedObjectContext;
    executeBlock();
    self.managedObjectContext = oldContext;
}
#endif

- (NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];    
}

- (NSManagedObject *)insertNewObject {
    return [self insertNewObjectForEntityForName:self.entityName];
}


- (NSManagedObject *)insertNewObjectWithData:(NSDictionary *)data {
    return [self insertNewObjectWithData:data 
                     parentAttributeName:nil 
                   childrenAttributeName:nil 
              discriminatorAttributeName:nil];
}

- (NSManagedObject *)insertNewObjectWithData:(NSDictionary *)data 
                         parentAttributeName:(NSString *)parentAttributeName
                       childrenAttributeName:(NSString *)childrenAttributeName
                  discriminatorAttributeName:(NSString *)discriminatorAttributeName {
	NSMutableDictionary *mutableData = [NSMutableDictionary dictionaryWithDictionary:data];
	
    NSString *entityName = self.entityName;
	if (discriminatorAttributeName != nil && [mutableData objectForKey:discriminatorAttributeName] != nil) {
		entityName = [mutableData objectForKey:discriminatorAttributeName];
	}
	
	NSArray *children = nil;
	if (parentAttributeName != nil && childrenAttributeName != nil && [mutableData objectForKey:childrenAttributeName] != nil) {
		children = [mutableData objectForKey:childrenAttributeName];
		[mutableData removeObjectForKey:childrenAttributeName];
	}
	
	NSManagedObject *object = [self insertNewObjectForEntityForName:entityName];
	[object setValuesForKeysWithDictionary:mutableData];	
	
	if (children != nil) {
		for (NSDictionary *childData in children) {
			NSMutableDictionary *mutableChildData = [NSMutableDictionary dictionaryWithDictionary:childData];
			[mutableChildData setObject:object forKey:parentAttributeName];
            [self insertNewObjectWithData:mutableChildData 
                      parentAttributeName:parentAttributeName 
                    childrenAttributeName:childrenAttributeName 
               discriminatorAttributeName:discriminatorAttributeName];            
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

- (void)deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

- (void)deleteObjectsWithPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:nil];
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *objects = [managedObjectContext_ executeFetchRequest:request error:&error]; 
    
    for (NSManagedObject *object in objects) {
        [self deleteObject:object];
    }    
}

- (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate 
                              sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
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

- (NSManagedObject *)findObjectWithPredicate:(NSPredicate *)predicate {
    return [self findObjectWithPredicate:predicate sortDescriptors:nil];
}

- (NSManagedObject *)findObjectWithPredicate:(NSPredicate *)predicate
                             sortDescriptors:(NSArray *)sortDescriptors {
    NSArray *result = [self findObjectsWithPredicate:predicate sortDescriptors:sortDescriptors limit:1 offset:0];
	if ([result count] > 0) {
		return [result objectAtIndex:0];
	} else {
		return nil;
	}    
}

- (NSArray *)findObjectsWithPredicate:(NSPredicate *)predicate 
                      sortDescriptors:(NSArray *)sortDescriptors {
    return [self findObjectsWithPredicate:predicate sortDescriptors:sortDescriptors limit:-1 offset:0];
}

- (NSArray *)findObjectsWithPredicate:(NSPredicate *)predicate 
                      sortDescriptors:(NSArray *)sortDescriptors 
                                limit:(NSInteger)limit
                               offset:(NSInteger)offset {
    NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];
    
    if (limit >= 0) {
        [request setFetchLimit:limit];
        [request setFetchOffset:offset];
    }
    
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
	
	if (result != nil && [result count] > 0) {
		return result;
	} else {
		return [NSArray array];
	}    
}

#if TARGET_OS_IPHONE
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
#endif

- (void)dealloc {
    self.managedObjectContext = nil;
    self.entityName = nil;
    [super dealloc];
}

@end