//
//  NSObject+QLNetworkingMethods.m
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/20.
//  Copyright © 2017年 yuntu. All rights reserved.
//

#import "NSObject+QLNetworkingMethods.h"

@implementation NSObject (QLNetworkingMethods)

- (id)QL_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self QL_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)QL_isEmptyObject
{
    if ([self isEqual:[NSNull null]])
    {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]])
    {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]])
    {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]])
    {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
