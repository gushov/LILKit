//
//  LILStringBoolTransformerTests.m
//  LILKit
//
//  Created by August Hovland on 23/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LILStringBoolTransformer.h"

@interface LILStringBoolTransformerTests : XCTestCase

@end

@implementation LILStringBoolTransformerTests

- (void)setUp
{
    [super setUp];
    [LILStringBoolTransformer addToValueTransformers];
}

- (void)testUTCToDate
{
    NSValueTransformer *transformer =
        [NSValueTransformer valueTransformerForName:LILTransformerStringToBool];
    
    XCTAssertEqualObjects(@1, [transformer transformedValue:@"Yes"]);
    XCTAssertEqualObjects(@0, [transformer transformedValue:@"No"]);
}

@end
