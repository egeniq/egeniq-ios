//
//  EFDataManager.h
//  Egeniq
//
//  Created by Peter Verhage on 31-01-12.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EFDataManager : NSObject

@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;

/**
 * Initialize data manager with given model name.
 */
- (id)initWithModelName:(NSString *)modelName;

@end
