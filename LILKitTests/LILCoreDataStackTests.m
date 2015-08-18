//
//  LILCoreDataStackTests.m
//  LILKit
//
//  Created by August Hovland on 18/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LILCoreDataStack.h"
#import <OCMock/OCMock.h>

@interface LILCoreDataStackTests : XCTestCase

@end

@implementation LILCoreDataStackTests

- (void)testInit
{
    id contextMock = OCMStrictClassMock(NSManagedObjectContext.class);
    id coordinatorMock = OCMStrictClassMock(NSPersistentStoreCoordinator.class);
    id storeMock = OCMClassMock(NSPersistentStore.class);
    
    OCMExpect([contextMock setPersistentStoreCoordinator:coordinatorMock]);
    OCMStub([contextMock persistentStoreCoordinator]).andReturn(coordinatorMock);
    OCMStub([coordinatorMock addPersistentStoreWithType:[OCMArg any]
                                          configuration:[OCMArg any]
                                                    URL:[OCMArg any]
                                                options:[OCMArg any]
                                                  error:[OCMArg anyObjectRef]]).andReturn(storeMock);
    OCMExpect([contextMock setUndoManager:[OCMArg any]]);
    
    [LILCoreDataStack stackWithManagedObjectContext:contextMock
                         persistentStoreCoordinator:coordinatorMock databaseName:@"db.sqlite"];
    
    
    OCMVerifyAll(contextMock);
    OCMVerifyAll(coordinatorMock);
}

- (void)testSaveContext
{
    id contextMock = OCMClassMock(NSManagedObjectContext.class);
    id coordinatorMock = OCMClassMock(NSPersistentStoreCoordinator.class);
    id storeMock = OCMClassMock(NSPersistentStore.class);
    
    OCMStub([contextMock persistentStoreCoordinator]).andReturn(coordinatorMock);
    OCMStub([coordinatorMock addPersistentStoreWithType:[OCMArg any]
                                          configuration:[OCMArg any]
                                                    URL:[OCMArg any]
                                                options:[OCMArg any]
                                                  error:[OCMArg anyObjectRef]]).andReturn(storeMock);
    
    OCMExpect([contextMock hasChanges]).andReturn(YES);
    OCMExpect([contextMock save:[OCMArg anyObjectRef]]).andReturn(YES);
    
    LILCoreDataStack *stack =
        [LILCoreDataStack stackWithManagedObjectContext:contextMock
                             persistentStoreCoordinator:coordinatorMock databaseName:@"db.sqlite"];
    
    [stack saveContext];
    
    
    OCMVerifyAll(contextMock);
    OCMVerifyAll(coordinatorMock);
}

@end
