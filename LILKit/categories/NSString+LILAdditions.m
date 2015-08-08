//
//  NSString+LILAdditions.m
//  LILKit
//
//  Created by August Hovland on 06/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "NSString+LILAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LILAdditions)

- (NSString *)lil_MD5String
{
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    return [self lil_stringFromBuffer:md5Buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)lil_SHA1String
{
    const char *ptr = [self UTF8String];
    unsigned char sha1Buffer[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(ptr, (CC_LONG)strlen(ptr), sha1Buffer);
    
    return [self lil_stringFromBuffer:sha1Buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)lil_encodedStringWithSecret:(NSString *)secret
{
    NSData *data = [[self lil_XORStringWithSecret:secret] dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)lil_decodedStringWithSecret:(NSString *)secret
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [string lil_XORStringWithSecret:secret];
}

/**
 *  Returns an NSString from given char[] buffer
 *
 *  @param buffer char[] to create NSString with
 *  @param length Length of buffer param
 *
 *  @return NSString from buffer
 */
- (NSString *)lil_stringFromBuffer:(unsigned char[])buffer length:(int)length
{
    NSMutableString *output = [NSMutableString stringWithCapacity:length * 2];
    
    for (int i = 0; i < length; i++) {
        [output appendFormat:@"%02x", buffer[i]];
    }
    
    return [output copy];
}

/**
 *  Returns an NSString with the XOR characters of the instance and the secret
 *
 *  @param secret NSString to XOR with instance
 *
 *  @return XOR of the instance with the given secret
 */
- (NSString *)lil_XORStringWithSecret:(NSString *)secret
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    char *dataPtr = (char *)[data bytes];
    char *secretData = (char *)[[secret dataUsingEncoding:NSUTF8StringEncoding] bytes];
    char *secretPtr = secretData;
    NSUInteger secretIndex = 0;
    
    for (NSUInteger i = 0; i < data.length; i++) {
        
        *dataPtr = *dataPtr ^ *secretPtr;
        dataPtr++;
        secretPtr++;
        
        if (++secretIndex == secret.length) {
            secretIndex = 0;
            secretPtr = secretData;
        }
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
