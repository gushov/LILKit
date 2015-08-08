//
//  LILRFC3339DateTransformer.m
//  LILKit
//
//  Created by August Hovland on 08/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILRFC3339DateTransformer.h"

NSString *const LILTransformerRFC3339ToDate = @"LILTransformerRFC3339ToDate";

@interface LILRFC3339DateTransformer ()
@property (nonatomic, strong) NSDateFormatter *RFC3339DateFormatter;
@end

@implementation LILRFC3339DateTransformer

+ (void)addToValueTransformers
{
    [NSValueTransformer setValueTransformer:[self new] forName:LILTransformerRFC3339ToDate];
}

+ (Class)transformedValueClass
{
    return [NSDate class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)RFC3339String
{
    return [self.RFC3339DateFormatter dateFromString:RFC3339String];
}

- (id)reverseTransformedValue:(id)date
{
    return [self.RFC3339DateFormatter stringFromDate:date];
}

- (NSDateFormatter *)RFC3339DateFormatter
{
    if (!_RFC3339DateFormatter) {
        
        _RFC3339DateFormatter = [NSDateFormatter new];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [_RFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [_RFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [_RFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    return _RFC3339DateFormatter;
}

@end
