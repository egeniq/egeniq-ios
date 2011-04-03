//
//  EFDataSource-Protected.h
//  Egeniq
//
//  Created by Peter Verhage on 09-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFDataSource.h"

@interface EFDataSource () 

@property (nonatomic, copy) NSString *baseEntityName;

- (id)initWithBaseEntityName:(NSString *)baseEntityName;

- (NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName;
- (NSManagedObject *)insertNewObject;
- (NSManagedObject *)insertNewObjectWithData:(NSDictionary *)data;
- (NSManagedObject *)insertNewObjectWithData:(NSDictionary *)data 
                         parentAttributeName:(NSString *)parentAttributeName
                       childrenAttributeName:(NSString *)childrenAttributeName
                  discriminatorAttributeName:(NSString *)discriminatorAttributeName;

- (NSUInteger)countWithPredicate:(NSPredicate *)predicate;

- (void)deleteObjectsWithPredicate:(NSPredicate *)predicate;

- (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate 
                              sortDescriptors:(NSArray *)sortDescriptors;

- (NSManagedObject *)findObjectWithPredicate:(NSPredicate *)predicate;

- (NSManagedObject *)findObjectWithPredicate:(NSPredicate *)predicate
                             sortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *)findObjectsWithPredicate:(NSPredicate *)predicate 
                      sortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *)findObjectsWithPredicate:(NSPredicate *)predicate 
                      sortDescriptors:(NSArray *)sortDescriptors 
                                limit:(NSInteger)limit
                               offset:(NSInteger)offset;

#if TARGET_OS_IPHONE
- (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate 
                                                      sortDescriptors:(NSArray *)sortDescriptors
                                                   sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                            cacheName:(NSString *)cacheName;
#endif

@end