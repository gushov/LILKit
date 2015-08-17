//
//  LILFetchedResultsControllerDataSourceTests.m
//  LILKit
//
//  Created by August Hovland on 15/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <CoreData/CoreData.h>
#import "LILFetchedResultsControllerDataSource.h"

@interface LILFetchedResultsControllerDataSourceTests : XCTestCase

@end

@implementation LILFetchedResultsControllerDataSourceTests

- (void)testInit
{
    id tableViewMock = OCMStrictClassMock(UITableView.class);
    id fetchedResultsControlerMock = OCMStrictClassMock(NSFetchedResultsController.class);
    id sectionMock = OCMProtocolMock(@protocol(NSFetchedResultsSectionInfo));
    
    OCMExpect([tableViewMock setDataSource:[OCMArg isNotNil]]);
    OCMExpect([fetchedResultsControlerMock setDelegate:[OCMArg isNotNil]]);
    OCMExpect([fetchedResultsControlerMock performFetch:[OCMArg anyObjectRef]]);
    OCMExpect([tableViewMock reloadData]);
    
    OCMStub([fetchedResultsControlerMock sections])
        .andReturn([NSArray arrayWithObject:sectionMock]);
    
    OCMStub([sectionMock numberOfObjects])
        .andReturn(4);
    
    LILFetchedResultsControllerDataSource *dataSource =
        [[LILFetchedResultsControllerDataSource alloc] initWithTableView:tableViewMock];
    
    dataSource.fetchedResultsController = fetchedResultsControlerMock;
    
    [dataSource numberOfSectionsInTableView:tableViewMock];
    NSInteger numberOfRows = [dataSource tableView:tableViewMock numberOfRowsInSection:0];
    
    XCTAssertEqual(numberOfRows, 4);
    
    OCMVerifyAll(tableViewMock);
    OCMVerifyAll(fetchedResultsControlerMock);
}

- (void)testUpdateFetchedResultsController
{
    id tableViewMock = OCMClassMock(UITableView.class);
    id fetchedResultsControlerMock = OCMClassMock(NSFetchedResultsController.class);
    
    OCMExpect([tableViewMock beginUpdates]);
    OCMExpect([tableViewMock endUpdates]);
    OCMExpect([tableViewMock moveRowAtIndexPath:[OCMArg any] toIndexPath:[OCMArg any]]);
    
    LILFetchedResultsControllerDataSource *dataSource =
        [[LILFetchedResultsControllerDataSource alloc] initWithTableView:tableViewMock];
    
    dataSource.fetchedResultsController = fetchedResultsControlerMock;
    
    [dataSource controllerWillChangeContent:fetchedResultsControlerMock];
    
    [dataSource controller:fetchedResultsControlerMock
           didChangeObject:@{}
               atIndexPath:[NSIndexPath indexPathWithIndex:2]
             forChangeType:NSFetchedResultsChangeMove
              newIndexPath:[NSIndexPath indexPathWithIndex:4]];
    
    [dataSource controllerDidChangeContent:fetchedResultsControlerMock];
    
    OCMVerifyAll(tableViewMock);
    OCMVerifyAll(fetchedResultsControlerMock);
}

- (void)testUpdateTableView
{
    id tableViewMock = OCMClassMock(UITableView.class);
    id fetchedResultsControlerMock = OCMClassMock(NSFetchedResultsController.class);
    id dataSourceDelegateMock =
        OCMProtocolMock(@protocol(LILFetchedResultsControllerDataSourceDelegate));
    id cellMock = OCMClassMock(UITableViewCell.class);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:0];
    NSString *object = @"Yo";
    
    OCMStub([fetchedResultsControlerMock objectAtIndexPath:indexPath]).andReturn(object);
    OCMStub([dataSourceDelegateMock cellWithObject:object]).andReturn(cellMock);
    
    LILFetchedResultsControllerDataSource *dataSource =
        [[LILFetchedResultsControllerDataSource alloc] initWithTableView:tableViewMock];
    
    dataSource.fetchedResultsController = fetchedResultsControlerMock;
    dataSource.delegate = dataSourceDelegateMock;
    
    XCTAssertEqualObjects(cellMock,
                          [dataSource tableView:tableViewMock cellForRowAtIndexPath:indexPath]);
}

@end
