//
//  LILRFC3339DateTransformer.h
//  LILKit
//
//  Created by August Hovland on 08/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const LILTransformerRFC3339ToDate;

/**
 * NSValueTransformer for RFC3339 NSString to NSDate transforms
 */
@interface LILRFC3339DateTransformer : NSValueTransformer

/**
 *  Sets transformer for name LILTransformerRFC3339ToDate
 */
+ (void)addToValueTransformers;

@end
