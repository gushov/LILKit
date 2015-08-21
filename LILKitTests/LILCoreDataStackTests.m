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
#import <CoreData/CoreData.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

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
    
    [[LILCoreDataStack
        stackWithManagedObjectContext:contextMock
        persistentStoreCoordinator:coordinatorMock
        databaseName:@"db.sqlite"]
        subscribeError:^(NSError *error) {
            XCTAssertNil(error);
        }
        completed:^{
            OCMVerifyAll(contextMock);
            OCMVerifyAll(coordinatorMock);
        }];
    
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
    
    [[LILCoreDataStack
        stackWithManagedObjectContext:contextMock
        persistentStoreCoordinator:coordinatorMock
        databaseName:@"db.sqlite"]
        subscribeNext:^(LILCoreDataStack *stack) {
            
            [[stack saveContext] subscribeError:^(NSError *error) {
                
                XCTAssertNil(error);
                OCMVerifyAll(contextMock);
                OCMVerifyAll(coordinatorMock);
            }];
        }
        error:^(NSError *error) {
            XCTAssertNil(error);
        }];
}

- (void)testPrivateManagedObjectContext
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
    
    [[LILCoreDataStack
        stackWithManagedObjectContext:contextMock
        persistentStoreCoordinator:coordinatorMock
        databaseName:@"db.sqlite"]
        subscribeNext:^(LILCoreDataStack *stack) {
            
            [[stack privateManagedObjectContext]
                subscribeNext:^(NSManagedObjectContext *context) {
                    OCMVerifyAll(contextMock);
                    OCMVerifyAll(coordinatorMock);
                }
                error:^(NSError *error) {
                    XCTAssertNil(error);
                }];
        }
        error:^(NSError *error) {
            XCTAssertNil(error);
        }];
}

@end
