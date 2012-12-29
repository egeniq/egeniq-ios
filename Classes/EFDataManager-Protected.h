//
//  EFDataManager-Protected.h
//  Egeniq
//
//  Created by Ivo Jansch on 29-12-12.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "EFDataManager.h"

/**
 * Extension.
 */
@interface EFDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSURL *persistentStoreURL;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, assign) NSManagedObjectContextConcurrencyType concurrencyType;

- (NSPersistentStore *)persistentStoreWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistenStoreCoordinator error:(NSError **)error;

@end
