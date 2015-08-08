//
//  LILNSStringAdditionsTests.m
//  LILKit
//
//  Created by August Hovland on 06/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+LILAdditions.h"

@interface LILNSStringAdditionsTests : XCTestCase

@end

@implementation LILNSStringAdditionsTests

- (void)testMD5String
{
    XCTAssertEqualObjects(@"95a68234cc4673bbd46f57578b402dcd", [@"Butter Sauces" lil_MD5String]);
    XCTAssertEqualObjects(@"c425035e2a934ef0124b790cb63dbc2f", [@"Kl@w hamm3r!" lil_MD5String]);
}

- (void)testSHA1String
{
    XCTAssertEqualObjects(@"5cee0663d1309de11956b0277aedf055f6de912f", [@"Butter Sauces" lil_SHA1String]);
    XCTAssertEqualObjects(@"3f022ffda75ff034bade95a7ad59fefbfd6f4cff", [@"Kl@w hamm3r!" lil_SHA1String]);
}

- (void)testEncodeString
{
    XCTAssertEqualObjects(@"UFBQ", [@"123" lil_encodedStringWithSecret:@"abc"]);
    XCTAssertEqualObjects(@"KkUAEFUVWjtRAQdVFA==", [@"Butter Sauces" lil_encodedStringWithSecret:@"h0td0gz"]);
    XCTAssertEqualObjects(@"I1w0ExAPGwVdRxYR", [@"Kl@w hamm3r!" lil_encodedStringWithSecret:@"h0td0gz"]);
}

- (void)testDecodeString
{
    XCTAssertEqualObjects(@"123", [@"UFBQ" lil_decodedStringWithSecret:@"abc"]);
    XCTAssertEqualObjects(@"Butter Sauces", [@"KkUAEFUVWjtRAQdVFA==" lil_decodedStringWithSecret:@"h0td0gz"]);
    XCTAssertEqualObjects(@"Kl@w hamm3r!", [@"I1w0ExAPGwVdRxYR" lil_decodedStringWithSecret:@"h0td0gz"]);
}

@end
