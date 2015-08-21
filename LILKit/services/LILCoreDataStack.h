//
//  LILCoreDataStack.h
//  LILKit
//
//  Created by August Hovland on 17/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext, NSPersistentStoreCoordinator, NSManagedObjectModel, RACSignal;

@protocol LILCoreDataStackAssembly <NSObject>
- (NSManagedObjectContext *)mainManagedObjectContext;
- (NSManagedObjectContext *)privateManagedObjectContext;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSString *)databaseName;
@end

@interface LILCoreDataStack : NSObject

/**
 *  Main mananged object context
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/**
 *  Returns RACSignal with main managed object context
 *
 *  @param assembly LILCoreDataStackAssembly for the given context
 *
 *  @return RACSignal that passes LILCoreDataStack in subscribeNext
 */
+ (RACSignal *)stackWithAssembly:(id<LILCoreDataStackAssembly>)assembly;

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
