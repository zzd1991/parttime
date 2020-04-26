//
//  JXRequestHandle.m
//  XMSport
//
//  Created by John on 2019/1/25.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import "JXRequestHandle.h"
#import "JXNetworkConsts.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>


@implementation JXRequestHandle

+ (NSDictionary *)basicParamsBody:(NSDictionary *)requestParams
{
//    NSMutableDictionary *basicParamsHeadDict = [NSMutableDictionary new];
//
//    NSString *appVerStr = MyShortVersionString ?: nil;
//    NSString *appClientStr = @"iphone";
//    NSNumber *timestampNum = [NSNumber numberWithInteger:(NSInteger)[[NSDate date] timeIntervalSince1970]];
//    NSString *tokenStr = nil;
    
//    if (XM_IsLogin)
//    {
//        tokenStr = My_CurrentToken;
//    }
    
    // 业务参数拼接
//    [basicParamsHeadDict SafetySetObject:tokenStr forKey:@"token"];
    
//    NSString *requestParamsStr = [NSString djj_dictToString:requestParams deleteSpace:NO];
//    [basicParamsHeadDict SafetySetObject:requestParamsStr forKey:kDJJNetworkingParamsKey];
        
    return requestParams;
}

@end
