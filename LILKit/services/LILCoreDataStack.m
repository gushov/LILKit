//
//  LILCoreDataStack.m
//  LILKit
//
//  Created by August Hovland on 17/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILCoreDataStack.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface LILCoreDataStack ()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readwrite) NSString *databaseName;
@end

@implementation LILCoreDataStack

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
        persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
                      databaseName:(NSString *)databaseName
{
    self = [super init];
    if (!self) return nil;
    
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    _managedObjectContext = managedObjectContext;
    _databaseName = databaseName;
    
    [self setupManagedObjectContext];
    
    return self;
}

- (void)saveContext
{
    NSError *error = nil;
    
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        
        DDLogError(@"Unresolved error - %@", [error localizedDescription]);
        
#ifdef DEBUG
        abort();
#endif
    }
}

- (void)setupManagedObjectContext
{
    NSError* error;
    
    if (![self.managedObjectContext.persistentStoreCoordinator
          addPersistentStoreWithType:NSSQLiteStoreType
          configuration:nil
          URL:[self storeURL]
          options:nil
          error:&error]) {
        
        DDLogError(@"Adding persistent store failed with - %@", [error localizedDescription]);
        
#ifdef DEBUG
        abort();
#endif
    }
    
    self.managedObjectContext.undoManager = [NSUndoManager new];
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
