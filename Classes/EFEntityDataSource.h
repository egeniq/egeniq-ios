//
//  ECCDataSource.h
//  Egeniq
//
//  Created by Peter Verhage on 09-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EFEntityDataSource : NSObject {
    
}

@property (nonatomic, copy) NSString *baseEntityName;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (id)entityDataSourceWithBaseEntityName:(NSString *)baseEntityName    
                    managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (id)initWithBaseEntityName:(NSString *)baseEntityName
        managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

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



#ifdef __BLOCKS__
- (void)usingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext 
                     executeBlock:(void(^)())executeBlock;
#endif

@end