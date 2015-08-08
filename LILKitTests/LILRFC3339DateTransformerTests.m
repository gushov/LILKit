//
//  LILRFC3339DateTransformerTests.m
//  LILKit
//
//  Created by August Hovland on 08/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LILRFC3339DateTransformer.h"

@interface LILRFC3339DateTransformerTests : XCTestCase

@end

@implementation LILRFC3339DateTransformerTests

- (void)setUp
{
    [super setUp];
    [LILRFC3339DateTransformer addToValueTransformers];
}

- (void)testUTCToDate
{
    NSValueTransformer *transformer =
        [NSValueTransformer valueTransformerForName:LILTransformerRFC3339ToDate];
    
    XCTAssertEqualObjects([NSDate dateWithTimeIntervalSince1970:0], [transformer transformedValue:@"1970-01-01T00:00:00Z"]);
    XCTAssertEqualObjects([NSDate dateWithTimeIntervalSince1970:1438941165], [transformer transformedValue:@"2015-08-07T09:52:45Z"]);
}

- (void)testDateToUTC
{
    NSValueTransformer *transformer =
        [NSValueTransformer valueTransformerForName:LILTransformerRFC3339ToDate];
    
    XCTAssertEqualObjects(@"1970-01-01T00:00:00Z", [transformer reverseTransformedValue:[NSDate dateWithTimeIntervalSince1970:0]]);
    XCTAssertEqualObjects(@"2015-08-07T09:52:45Z", [transformer reverseTransformedValue:[NSDate dateWithTimeIntervalSince1970:1438941165]]);
}

@end
