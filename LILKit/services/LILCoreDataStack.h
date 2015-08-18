//
//  LILCoreDataStack.h
//  LILKit
//
//  Created by August Hovland on 17/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LILCoreDataStack : NSObject

/**
 *  Main mananged object context
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/**
 *  Factory method for LILCoreDataStack
 *
 *  @param managedObjectContext       NSManagedObjectContext to build the stack around
 *  @param persistentStoreCoordinator NSPersistenStoreCoordinator for the given context
 *  @param databaseName               Name of the database
 *
 *  @return LILCoreDataStackInstance
 */
+ (instancetype)stackWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                   persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
                                 databaseName:(NSString *)databaseName;

/**
 *  Default initializer for LILCoreDataStack
 *
 *  @param managedObjectContext       NSManagedObjectContext to build the stack around
 *  @param persistentStoreCoordinator NSPersistenStoreCoordinator for the given context
 *  @param databaseName               Name of the database
 *
 *  @return LILCoreDataStackInstance
 */
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                  persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
                                databaseName:(NSString *)databaseName;

/**
 *  Save the current context
 */
- (void) saveContext;

@end
