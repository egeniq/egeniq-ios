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

@property(nonatomic, copy) NSString *baseEntityName;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)usingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext 
                     executeBlock:(void(^)())executeBlock __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);

- (NSManagedObject *)insertNewObject;
- (NSManagedObject *)insertNewObjectWithData:(NSDictionary *)data;

- (NSUInteger)countWithPredicate:(NSPredicate *)predicate;

- (void)deleteObjectsWithPredicate:(NSPredicate *)predicate;

- (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate 
                              sortDescriptors:(NSArray *)sortDescriptors;

- (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate 
                                                      sortDescriptors:(NSArray *)sortDescriptors
                                                   sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                            cacheName:(NSString *)cacheName;

- (NSManagedObject *)findObjectWithPredicate:(NSPredicate *)predicate;

@end