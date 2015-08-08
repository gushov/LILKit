//
//  LILLogFormatter.m
//  LILKit
//
//  Created by August Hovland on 08/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILLogFormatter.h"
#import <libkern/OSAtomic.h>

@interface LILLogFormatter ()
{
    int atomicLoggerCount;
}
@property (nonatomic, strong) NSDateFormatter *threadUnsafeDateFormatter;
@end

@implementation LILLogFormatter

- (NSString *)stringFromDate:(NSDate *)date
{
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    
    static NSString *dateFormatString = @"yy-MM-dd HH:mm:ss.SSS";
    
    if (loggerCount <= 1) {
        
        // Single-threaded mode.
        if (self.threadUnsafeDateFormatter == nil) {
            
            self.threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [self.threadUnsafeDateFormatter setDateFormat:dateFormatString];
        }
        
        return [self.threadUnsafeDateFormatter stringFromDate:date];
    }
    else {
        
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        NSString *key = @"LILLogFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:dateFormatString];
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *queueName = logMessage->_queueLabel;
    NSString *dateAndTime = [self stringFromDate:(logMessage->_timestamp)];
    NSString *path = logMessage->_file;
    NSString *fileName = [path lastPathComponent];
    NSUInteger lineNumber = logMessage->_line;
    NSString *logMsg = logMessage->_message;
    
    queueName = [queueName stringByReplacingOccurrencesOfString:@" " withString:@""];
    logMsg = [logMsg stringByReplacingOccurrencesOfString:@"    " withString:@""];
    logMsg = [logMsg stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    return [NSString stringWithFormat:@"%@ %@:%lu(%@) %@",
            dateAndTime, fileName, (unsigned long)lineNumber, queueName, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger
{
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger
{
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end
