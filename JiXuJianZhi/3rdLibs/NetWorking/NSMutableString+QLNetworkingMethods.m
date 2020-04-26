//
//  NSMutableString+QLNetworkingMethods.m
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/20.
//  Copyright © 2017年 yuntu. All rights reserved.
//

#import "NSMutableString+QLNetworkingMethods.h"
#import "NSObject+QLNetworkingMethods.h"

@implementation NSMutableString (QLNetworkingMethods)

- (void)QL_appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] QL_defaultValue:@"\t\t\t\tN/A"]];
}

@end
