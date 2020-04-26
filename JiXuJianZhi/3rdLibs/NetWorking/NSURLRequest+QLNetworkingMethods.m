//
//  NSURLRequest+QLNetworkingMethods.m
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/20.
//  Copyright © 2017年 yuntu. All rights reserved.
//

#import "NSURLRequest+QLNetworkingMethods.h"
#import <objc/runtime.h>

static void *QLNetworkingRequestParams;

@implementation NSURLRequest (QLNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &QLNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &QLNetworkingRequestParams);
}

@end
