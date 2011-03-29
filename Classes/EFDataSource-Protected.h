//
//  EFDataSource-Protected.h
//  Egeniq
//
//  Created by Peter Verhage on 29-03-11.
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

- (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate 
                                                      sortDescriptors:(NSArray *)sortDescriptors
                                                   sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                            cacheName:(NSString *)cacheName;

- (NSManagedObject *)findObjectWithPredicate:(NSPredicate *)predicate;

- (NSArray *)findObjectsWithPredicate:(NSPredicate *)predicate 
                      sortDescriptors:(NSArray *)sortDescriptors;

@end