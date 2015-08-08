//
//  LILUTCDateTransformer.m
//  LILKit
//
//  Created by August Hovland on 06/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILUTCDateTransformer.h"

NSString *const LILTransformerUTCToDate = @"LILTransformerUTCToDate";
static double MILLISECONDS_PER_SECOND = 1000.0;

@implementation LILUTCDateTransformer

+ (void)addToValueTransformers
{
    [NSValueTransformer setValueTransformer:[self new] forName:LILTransformerUTCToDate];
}

+ (Class)transformedValueClass
{
    return [NSDate class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)UTCDate
{
    NSTimeInterval utcInterval = [UTCDate doubleValue] / MILLISECONDS_PER_SECOND;
    return [NSDate dateWithTimeIntervalSince1970:utcInterval];
}

- (id)reverseTransformedValue:(id)date
{
    double utc = [date timeIntervalSince1970] * MILLISECONDS_PER_SECOND;
    NSString *dateString = [NSString stringWithFormat:@"%.0f", utc];
    return [NSNumber numberWithDouble:[dateString doubleValue]];
}

@end
