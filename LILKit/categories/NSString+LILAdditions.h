//
//  NSString+LILAdditions.h
//  LILKit
//
//  Created by August Hovland on 06/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NSString methods for MD5, SHA1, and base64 en/decoded XOR
 *
 *  based on https://github.com/thoughtbot/NSString-TBEncryption
 */
@interface NSString (LILAdditions)

/**
 *  Returns MD5 hash
 *
 *  @return MD5 hash of the NSString instance
 */
- (NSString *)lil_MD5String;

/**
 *  Returns SHA-1 hash
 *
 *  @return SHA-1 hash of the NSString instance
 */
- (NSString *)lil_SHA1String;

/**
 *  Returns base64 encoded XOR
 *
 *  @param secret NSString to XOR with instance
 *
 *  @return base64 encoded XOR of NSString instance
 */
- (NSString *)lil_encodedStringWithSecret:(NSString *)secret;

/**
 *  Returns base64 decoded XOR
 *
 *  @param secret NSString to XOR with instance
 *
 *  @return base64 decoded XOR of NSString instance
 */
- (NSString *)lil_decodedStringWithSecret:(NSString *)secret;

@end
