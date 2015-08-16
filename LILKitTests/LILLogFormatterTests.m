//
//  LILLogFormatterTests.m
//  LILKit
//
//  Created by August Hovland on 15/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LILLogFormatter.h"

@interface LILLogFormatterTests : XCTestCase

@end

@implementation LILLogFormatterTests

- (void)testFormatLogMessage
{
    DDLogMessage *message =
        [[DDLogMessage alloc] initWithMessage:@"Uh oh"
                                        level:DDLogLevelError
                                         flag:DDLogFlagError
                                      context:1
                                         file:@"file.h"
                                     function:@"meltCheese"
                                         line:42
                                          tag:nil
                                      options:0
                                    timestamp:[NSDate dateWithTimeIntervalSince1970:111111111]];
    
    LILLogFormatter *logFormatter = [LILLogFormatter new];
    NSString *line = [logFormatter formatLogMessage:message];
    XCTAssertEqualObjects(@"73-07-10 01:11:51.000 file.h:42(com.apple.main-thread) Uh oh", line);
}

@end
