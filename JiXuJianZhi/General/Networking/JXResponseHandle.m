//
//  JXResponseHandle.m
//  XMSport
//
//  Created by John on 2019/1/25.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import "JXResponseHandle.h"
#import "QLNetworkEnum.h"
#import "JXNetworkConsts.h"

@implementation JXResponseHandle

// responseDict统一处理 - 判断code字段
+ (BOOL)processRespDictCodeZero:(NSDictionary *)respDict
{
//    if (nil != [respDict objectForKey:@"code"] && ![[respDict objectForKey:@"code"] isEqual:[NSNull null]])
//    {
//        NSString *code = [respDict objectForKey:@"code"];
//        if ([code integerValue] == 200)
//        {
//            return YES;
//        }
//    }
    return YES;
}

+ (NSString *)netWorkErrorMsg:(NSDictionary *)dict andErrorType:(NSUInteger)errorType
{
    if (QLAPIManagerErrorTypeDefault == errorType)
    {
        return @"网络异常,请检查网络是否连接";
    }
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        return @"获取数据异常,请稍后再试";
    }
    
    // 登录token失效处理
    NSString *code = [NSString stringWithFormat:@"%@", dict[@"code"]];
    if (nil != code && ![code isEqual:[NSNull null]] && [code isEqualToString:kDJJCodeUserTokenInvalid])
        return @"";
    
    NSString *msg = [dict objectForKey:@"msg"];
    if (msg == nil)
    {
        switch (errorType) {
                // API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO
            case QLAPIManagerErrorTypeNoContent:
                msg = @"获取数据异常";
                break;
                // 请求参数错误，不会调用API，因为参数验证是在调用API之前做的
            case QLAPIManagerErrorTypeParamsError:
                msg = @"请求数据异常";
                break;
            case QLAPIManagerErrorTypeTimeout:
                msg = @"请求超时,请检查网络情况.";
                break;
            case QLAPIManagerErrorTypeNoNetWork:
                msg = @"网络异常,请检查网络是否连接";
                break;
            case QLAPIManagerErrorTypeSuccess:
                msg = @"请求成功";
                break;
            default:
                msg = @"请求异常,请稍后再试";
                break;
        }
    }
    return msg;
}

@end
