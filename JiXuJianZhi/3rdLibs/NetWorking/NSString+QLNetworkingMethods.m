//
//  NSString+QLNetworkingMethods.m
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/20.
//  Copyright © 2017年 yuntu. All rights reserved.
//

#import "NSString+QLNetworkingMethods.h"
#include <CommonCrypto/CommonDigest.h>
#import "NSObject+QLNetworkingMethods.h"

@implementation NSString (QLNetworkingMethods)

- (NSString *)QL_md5
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}

+ (NSString *)QL_dictToString:(NSDictionary *)parameters
{
    NSString *parametersString = nil;
    if ([parameters count])
    {
        NSData *jsonData = [NSString QL_toJSONData:parameters];
        if (jsonData)
        {
            parametersString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        else
        {
            parametersString = @"";
        }
    }
    else
    {
        parametersString = @"";
    }
    
//    parametersString = [parametersString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [parametersString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

+ (NSData *)QL_toJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length] > 0 && error == nil)
    {
        return jsonData;
    }
    return nil;
}

+ (BOOL)QL_judgeStringValid:(NSString *)string
{
    if (string && string != nil)
    {
        if ([string isKindOfClass:[NSNull class]])
        {
            return NO;
        }
        if ([string isKindOfClass:[NSString class]])
        {
            if ([string isEqualToString:@"<null>"] ||
                [string isEqualToString:@"(null)"])
            {
                return NO;
            }
        }
        
        NSString *tempStr = [NSString stringWithFormat:@"%@", string];
        if ([tempStr length] > 0)
        {
            return YES;
        }
    }
    
    return NO;
}

@end
