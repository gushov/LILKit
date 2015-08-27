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
@property (nonatomic, strong) id assemblyMock;
@property (nonatomic, strong) id contextMock;
@property (nonatomic, strong) id privateContextMock;
@property (nonatomic, strong) id coordinatorMock;
@property (nonatomic, strong) id storeMock;
@end

@implementation LILCoreDataStackTests

- (void)setUp
{
    [super setUp];
    
    self.assemblyMock = OCMProtocolMock(@protocol(LILCoreDataStackAssembly));
    self.contextMock = OCMClassMock(NSManagedObjectContext.class);
    self.privateContextMock = OCMClassMock(NSManagedObjectContext.class);
    self.coordinatorMock = OCMClassMock(NSPersistentStoreCoordinator.class);
    self.storeMock = OCMClassMock(NSPersistentStore.class);
    
    OCMStub([self.assemblyMock mainManagedObjectContext]).andReturn(self.contextMock);
    OCMStub([self.assemblyMock privateManagedObjectContext]).andReturn(self.privateContextMock);
    OCMStub([self.assemblyMock persistentStoreCoordinator]).andReturn(self.coordinatorMock);
    OCMStub([self.assemblyMock databaseName]).andReturn(@"lala.sqlite");
    OCMStub([self.contextMock persistentStoreCoordinator]).andReturn(self.coordinatorMock);
    OCMStub([self.coordinatorMock addPersistentStoreWithType:[OCMArg any]
                                               configuration:[OCMArg any]
                                                         URL:[OCMArg any]
                                                     options:[OCMArg any]
                                                       error:[OCMArg anyObjectRef]]).andReturn(self.storeMock);
}

- (void)tearDown
{
    self.assemblyMock = nil;
    self.contextMock = nil;
    self.coordinatorMock = nil;
    self.storeMock = nil;
    
    [super tearDown];
}

- (void)testInit
{
    OCMExpect([self.contextMock setPersistentStoreCoordinator:self.coordinatorMock]);
    OCMExpect([self.contextMock setUndoManager:[OCMArg any]]);
    
    [[LILCoreDataStack
        stackWithAssembly:self.assemblyMock]
        subscribeError:^(NSError *error) {
            XCTAssertNil(error);
        }
        completed:^{
            OCMVerifyAll(self.contextMock);
            OCMVerifyAll(self.coordinatorMock);
        }];
}

- (void)testSaveContext
{
    OCMExpect([self.contextMock hasChanges]).andReturn(YES);
    OCMExpect([self.contextMock save:[OCMArg anyObjectRef]]).andReturn(YES);
    
    [[LILCoreDataStack
        stackWithAssembly:self.assemblyMock]
        subscribeNext:^(LILCoreDataStack *stack) {
            
            [[stack saveContext] subscribeError:^(NSError *error) {
                
                XCTAssertNil(error);
                OCMVerifyAll(self.contextMock);
                OCMVerifyAll(self.coordinatorMock);
            }];
        }
        error:^(NSError *error) {
            XCTAssertNil(error);
        }];
}

- (void)testPrivateManagedObjectContext
{
    OCMExpect([self.privateContextMock hasChanges]).andReturn(YES);
    OCMExpect([self.privateContextMock save:[OCMArg anyObjectRef]]).andReturn(YES);
    
    [[LILCoreDataStack
        stackWithAssembly:self.assemblyMock]
        subscribeNext:^(LILCoreDataStack *stack) {
            
            [[stack privateManagedObjectContext]
                subscribeNext:^(NSManagedObjectContext *context) {
                    XCTAssertEqualObjects(self.privateContextMock, context);
                }
                error:^(NSError *error) {
                    XCTAssertNil(error);
                }
                completed:^{
                    OCMVerifyAll(self.privateContextMock);
                }];
        }
        error:^(NSError *error) {
            XCTAssertNil(error);
        }];
}

- (void)testAsynchronousRequest
{
    OCMExpect([self.privateContextMock hasChanges]).andReturn(YES);
    OCMExpect([self.privateContextMock save:[OCMArg anyObjectRef]]).andReturn(YES);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    id requestMock = OCMClassMock(NSFetchRequest.class);
    id asynchRequestMock = OCMClassMock(NSAsynchronousFetchRequest.class);
    id asynchResultMock = OCMClassMock(NSAsynchronousFetchResult.class);
    
    OCMStub([asynchResultMock finalResult]).andReturn(@[]);
    OCMStub([asynchRequestMock alloc]).andReturn(asynchRequestMock);
    
    OCMStub([asynchRequestMock initWithFetchRequest:[OCMArg any] completionBlock:[OCMArg any]])
        .andDo(^(NSInvocation *invocation) {
            void (^passedBlock)( NSArray * );
            [invocation getArgument:&passedBlock atIndex:3];
            passedBlock(asynchResultMock);
        });
    
    OCMStub([asynchRequestMock alloc]).andReturn(asynchRequestMock);
    
    [[LILCoreDataStack
        stackWithAssembly:self.assemblyMock]
        subscribeNext:^(LILCoreDataStack *stack) {
            
            [[stack asynchronousRequest:requestMock]
                subscribeNext:^(NSArray *results) {
                    XCTAssertEqualObjects(@[], results);
                }
                error:^(NSError *error) {
                    XCTAssertNil(error);
                }
                completed:^{
                    [expectation fulfill];
                }];
        }
        error:^(NSError *error) {
            XCTAssertNil(error);
        }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        OCMVerifyAll(requestMock);
        OCMVerifyAll(asynchRequestMock);
    }];
}

@end
