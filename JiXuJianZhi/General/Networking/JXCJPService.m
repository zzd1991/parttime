//
//  JXCJPService.m
//  XMSport
//
//  Created by John on 2019/1/25.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import "JXCJPService.h"
#import "JXNetworkConsts.h"

static NSString *const kDJJCJServerOnlineUrl = @"http://auth.context.cn/cjService/service/api";

@implementation JXCJPService

#pragma mark - QLServiceProtocal

- (BOOL)isOnline
{
    return kDJJServiceIsOnline;
}

- (NSString *)offlineApiBaseUrl
{
    return kDJJCJServerOnlineUrl;
}

- (NSString *)onlineApiBaseUrl
{
    return kDJJCJServerOnlineUrl;
}

- (NSString *)offlineApiVersion
{
    return @"";
}

- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"";
}

- (NSString *)offlinePublicKey
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}

@end
