//
//  LILStringBoolTransformer.m
//  LILKit
//
//  Created by August Hovland on 23/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILStringBoolTransformer.h"

NSString *const LILTransformerStringToBool = @"LILTransformerStringToBool";

@implementation LILStringBoolTransformer

+ (void)addToValueTransformers
{
    [NSValueTransformer setValueTransformer:[self new] forName:LILTransformerStringToBool];
}

+ (Class)transformedValueClass
{
    return NSNumber.class;
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)boolString
{
    if ([boolString caseInsensitiveCompare:@"yes"] == NSOrderedSame) {
        return @1;
    }
    return @0;
}

- (id)reverseTransformedValue:(id)boolNumber
{
    if ([boolNumber integerValue] > 0) {
        return @"yes";
    }
    return @"no";
}

@end
