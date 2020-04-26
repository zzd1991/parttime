//
//  NSDictionary+QLNetworkingMethods.m
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/20.
//  Copyright © 2017年 yuntu. All rights reserved.
//

#import "NSDictionary+QLNetworkingMethods.h"
#import "NSArray+QLNetworkingMethods.h"

@implementation NSDictionary (QLNetworkingMethods)

/** 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
- (NSString *)QL_urlParamsStringSignature:(BOOL)isForSignature
{
    NSArray *sortedArray = [self QL_transformedUrlParamsArraySignature:isForSignature];
    return [sortedArray QL_paramsString];
}

/** 字典变json */
- (NSString *)QL_jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** 转义参数 */
- (NSArray *)QL_transformedUrlParamsArraySignature:(BOOL)isForSignature
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (![obj isKindOfClass:[NSString class]])
        {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        if (!isForSignature)
        {
            obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        }
        if ([obj length] > 0)
        {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

+ (NSDictionary *)QL_stringToDict:(NSString *)jsonString
{
    if (jsonString == nil) return nil;

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error)
    {
        return nil;
    }
    return dict;
}

@end
