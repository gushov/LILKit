//
//  LILMutableArrayDataSourceTests.m
//  LILKit
//
//  Created by August Hovland on 12/09/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "LILMutableArrayDataSource.h"

@interface LILMutableArrayDataSourceTests : XCTestCase

@end

@implementation LILMutableArrayDataSourceTests

- (void)testInit
{
    id tableViewMock = OCMStrictClassMock(UITableView.class);
    
    OCMExpect([tableViewMock setDataSource:[OCMArg isNotNil]]);
    OCMExpect([tableViewMock reloadData]);
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:@"One", @"Two", @"Shoe", nil];
    
    LILMutableArrayDataSource *dataSource =
        [[LILMutableArrayDataSource alloc] initWithTableView:tableViewMock];
    
    dataSource.mutableArray = mutableArray;
    
    NSInteger numberOfRows = [dataSource tableView:tableViewMock numberOfRowsInSection:0];
    
    XCTAssertEqual(numberOfRows, 3);
    
    OCMVerifyAll(tableViewMock);
}

- (void)testUpdateTableView
{
    id tableViewMock = OCMClassMock(UITableView.class);
    
    id dataSourceDelegateMock = OCMProtocolMock(@protocol(LILDataSourceDelegate));
    id cellMock = OCMClassMock(UITableViewCell.class);
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:@"One", @"Two", @"Shoe", nil];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    OCMStub([dataSourceDelegateMock cellWithObject:@"One"]).andReturn(cellMock);
    
    LILMutableArrayDataSource *dataSource =
        [[LILMutableArrayDataSource alloc] initWithTableView:tableViewMock];
    
    dataSource.mutableArray = mutableArray;
    dataSource.delegate = dataSourceDelegateMock;
    
    XCTAssertEqualObjects(cellMock,
                          [dataSource tableView:tableViewMock cellForRowAtIndexPath:indexPath]);
}

@end
