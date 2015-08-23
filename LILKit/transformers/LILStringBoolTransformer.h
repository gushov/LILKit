//
//  LILStringBoolTransformer.h
//  LILKit
//
//  Created by August Hovland on 23/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const LILTransformerStringToBool;

/**
 * NSValueTransformer for NSString to Bool transforms
 */
@interface LILStringBoolTransformer : NSValueTransformer

/**
 *  Sets transformer for name LILTransformerRFC3339ToDate
 */
+ (void)addToValueTransformers;

@end
