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
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readwrite) NSString *databaseName;
@property (nonatomic, strong, readwrite) id<LILCoreDataStackAssembly> assembly;
@end

@implementation LILCoreDataStack

+ (RACSignal *)stackWithAssembly:(id<LILCoreDataStackAssembly>)assembly;
{
    LILCoreDataStack *stack = [[self alloc] initWithAssembly:assembly];
    return [stack setupManagedObjectContext];
}

- (id)initWithAssembly:(id<LILCoreDataStackAssembly>)assembly
{
    if (!self) return nil;
    self = [super init];
    
    _assembly = assembly;
    _managedObjectContext = assembly.mainManagedObjectContext;
    _managedObjectContext.persistentStoreCoordinator = assembly.persistentStoreCoordinator;
    _databaseName = assembly.databaseName;
    
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
            self.assembly.privateManagedObjectContext;
    
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
