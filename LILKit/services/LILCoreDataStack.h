//
//  LILCoreDataStack.h
//  LILKit
//
//  Created by August Hovland on 17/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext, NSPersistentStoreCoordinator, RACSignal;

@interface LILCoreDataStack : NSObject

/**
 *  Main mananged object context
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/**
 *  Returns RACSignal with main managed object context
 *
 *  @param managedObjectContext       NSManagedObjectContext to build the stack around
 *  @param persistentStoreCoordinator NSPersistenStoreCoordinator for the given context
 *  @param databaseName               Name of the database
 *
 *  @return RACSignal
 */
+ (RACSignal *)stackWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                  persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
                                databaseName:(NSString *)databaseName;

/**
 *  Returns RACSignal with a private managed object context
 *
 *  @return RACSignal
 */
- (RACSignal *)privateManagedObjectContext;

/**
 *  Save the current context
 */
- (RACSignal *)saveContext;

@end
