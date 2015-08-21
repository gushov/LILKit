//
//  LILCoreDataStack.m
//  LILKit
//
//  Created by August Hovland on 17/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILCoreDataStack.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <CoreData/CoreData.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LILCoreDataStack ()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readwrite) NSString *databaseName;
@end

@implementation LILCoreDataStack

+ (RACSignal *)stackWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                  persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
                                databaseName:(NSString *)databaseName
{
    LILCoreDataStack *stack = [[self alloc] initWithManagedObjectContext:managedObjectContext
                                              persistentStoreCoordinator:persistentStoreCoordinator
                                                            databaseName:databaseName];
    
    return [stack setupManagedObjectContext];
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
        persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
                      databaseName:(NSString *)databaseName
{
    if (!self) return nil;
    self = [super init];
    
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    _managedObjectContext = managedObjectContext;
    _databaseName = databaseName;
    
    return self;
}

- (RACSignal *)saveContext
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            [subscriber sendError:error];
        }
        
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)privateManagedObjectContext
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSManagedObjectContext *privateManagedObjectContext =
            [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
        [privateManagedObjectContext setParentContext:self.managedObjectContext];
        [subscriber sendNext:privateManagedObjectContext];
        
        NSError *error = nil;
        if ([privateManagedObjectContext hasChanges] && [privateManagedObjectContext save:&error]) {
            [subscriber sendError:error];
        }
        
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)setupManagedObjectContext
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSError* error;
        NSPersistentStoreCoordinator *coordinator =
            self.managedObjectContext.persistentStoreCoordinator;
        
        NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                             configuration:nil
                                                                       URL:self.storeURL
                                                                   options:nil
                                                                     error:&error];
        
        if (!store) {
            [subscriber sendError:error];
        }
        else {
            self.managedObjectContext.undoManager = [NSUndoManager new];
            [subscriber sendNext:self];
        }
        
        [subscriber sendCompleted];
        return nil;
    }];
}

- (NSURL*)storeURL
{
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL];
    
    return [documentsDirectory URLByAppendingPathComponent:self.databaseName];
}

@end
