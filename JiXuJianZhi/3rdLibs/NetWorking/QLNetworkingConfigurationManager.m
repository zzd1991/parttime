//
//  QLNetworkingConfigurationManager.m
//  QLNetworking
//
//  Created by Corotata on 2017/4/10.
//  Copyright © 2017年 Yuntu inc. All rights reserved.
//

#import "QLNetworkingConfigurationManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation QLNetworkingConfigurationManager

+ (instancetype)sharedInstance
{
    static QLNetworkingConfigurationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[QLNetworkingConfigurationManager alloc] init];
        sharedInstance.shouldCache = YES;
        sharedInstance.serviceIsOnline = NO;
        sharedInstance.apiNetworkingTimeoutSeconds = 20.0f;
        sharedInstance.cacheOutdateTimeSeconds = 300;
        sharedInstance.cacheCountLimit = 1000;
        sharedInstance.shouldSetParamsInHTTPBodyButGET = YES;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)
    {
        return YES;
    }
    else
    {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (void)resetTimeOutToDefault {
    self.apiNetworkingTimeoutSeconds = 20.0f;
}

@end
