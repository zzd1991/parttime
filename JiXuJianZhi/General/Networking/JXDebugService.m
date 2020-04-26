//
//  JXDebugService.m
//  XMSport
//
//  Created by Fly John on 2019/2/21.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import "JXDebugService.h"
#import "JXNetworkConsts.h"
#import "JXRequestHandle.h"

@implementation JXDebugService

#pragma mark - QLServiceProtocal

- (BOOL)isOnline
{
    return kDJJServiceIsOnline;
}

- (NSString *)offlineApiBaseUrl
{
    return kJXBaseServerUrl;
}

- (NSString *)onlineApiBaseUrl
{
    return kJXBaseServerUrl;
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

// 为某些Service需要拼凑额外的HTTP Header（如 基础参数basicParams）
- (NSDictionary *)extraHttpHeadParmasWithMethodName:(NSString *)method requestParams:(NSDictionary *)requestParams
{
    NSDictionary *extraHeaderDict = @{@"Content-Type": @"application/json"};
    return extraHeaderDict;
}

- (NSDictionary *)extraHttpBodyParmasWithRequestParams:(NSDictionary *)requestParams
{
    NSDictionary *extraHeaderDict = [JXRequestHandle basicParamsBody:requestParams];
    return extraHeaderDict;
}

// 可以做一些统一的error code拦截， 如token失效
- (BOOL)shouldCallBackByFailedOnCallingAPI:(QLURLResponse *)response
{
    BOOL result = YES;
    NSString *code = [NSString stringWithFormat:@"%@", response.content[@"code"]];
    if ([code isEqualToString:kDJJCodeUserTokenInvalid])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:nil];
    }
    return result;
}

@end
