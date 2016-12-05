//
//  NSString(ATTMd5).m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "NSString+ATTMd5.h"

#import <CommonCrypto/CommonDigest.h>


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


#pragma mark - Implementation

@implementation NSString (ATTMd5)


- (NSString *)md5String {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t) strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]]; //%02X for capital letters
    }
    return output;
}

@end
