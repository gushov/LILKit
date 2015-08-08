//
//  LILUTCDateTransformerTests.m
//  LILKit
//
//  Created by August Hovland on 07/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LILUTCDateTransformer.h"

@interface LILUTCDateTransformerTests : XCTestCase

@end

@implementation LILUTCDateTransformerTests

- (void)setUp
{
    [super setUp];
    [LILUTCDateTransformer addToValueTransformers];
}

- (void)testUTCToDate
{
    NSValueTransformer *transformer =
        [NSValueTransformer valueTransformerForName:LILTransformerUTCToDate];
    
    XCTAssertEqualObjects([NSDate dateWithTimeIntervalSince1970:0], [transformer transformedValue:@0]);
    XCTAssertEqualObjects([NSDate dateWithTimeIntervalSince1970:1438941165.388], [transformer transformedValue:@1438941165388]);
}

- (void)testDateToUTC
{
    NSValueTransformer *transformer =
        [NSValueTransformer valueTransformerForName:LILTransformerUTCToDate];
    
    XCTAssertEqualObjects(@0, [transformer reverseTransformedValue:[NSDate dateWithTimeIntervalSince1970:0]]);
    XCTAssertEqualObjects(@1438941165388, [transformer reverseTransformedValue:[NSDate dateWithTimeIntervalSince1970:1438941165.388]]);
}

@end
