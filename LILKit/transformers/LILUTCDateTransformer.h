//
//  LILUTCDateTransformer.h
//  LILKit
//
//  Created by August Hovland on 06/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const LILTransformerUTCToDate;

/**
 * NSValueTransformer for UTC NSNumber to NSDate transforms
 */
@interface LILUTCDateTransformer : NSValueTransformer

/**
 *  Sets transformer for name LILTransformerUTCToDate
 */
+ (void)addToValueTransformers;

@end
