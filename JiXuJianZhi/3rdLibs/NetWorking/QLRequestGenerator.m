//
//  AXRequestGenerator.m
//  RTNetworking
//
//  Created by Jccc on 2017-09-14.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import "QLRequestGenerator.h"
#import "QLServiceFactory.h"
#import "NSDictionary+QLNetworkingMethods.h"
#import "NSString+QLNetworkingMethods.h"
#import "NSObject+QLNetworkingMethods.h"
#import <AFNetworking/AFNetworking.h>
#import "QLService.h"
#import "QLLogger.h"
#import "NSURLRequest+QLNetworkingMethods.h"
#import "QLNetworkingConfigurationManager.h"

#define kQLNetworkHTTPHeaderFieldContentType   @"Content-Type"

@interface QLRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation QLRequestGenerator

#pragma mark - Life cycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QLRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
       
        sharedInstance = [[QLRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self initialRequestGenerator];
    }
    return self;
}

- (void)initialRequestGenerator
{
    _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    _httpRequestSerializer.timeoutInterval = [QLNetworkingConfigurationManager sharedInstance].apiNetworkingTimeoutSeconds;
    _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
}

#pragma mark - Public methods

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"GET"];
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"POST"];
}

- (NSURLRequest *)generatePutRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"PUT"];
}

- (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"DELETE"];
}

- (NSURLRequest *)generateUploadRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                               requestParams:(NSDictionary *)requestParams
                                                  methodName:(NSString *)methodName
                                                        data:(id)data
                                                    mimeType:(id)mimeType
                                                    fileName:(id)fileName {
    // 超时
    self.httpRequestSerializer.timeoutInterval = [QLNetworkingConfigurationManager sharedInstance].apiNetworkingTimeoutSeconds;
    [[QLNetworkingConfigurationManager sharedInstance] resetTimeOutToDefault];
    
    QLService *service  = [[QLServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [service urlGeneratingRuleByMethodName:methodName];
    NSDictionary *totalRequestParams = [self totalRequestParamsByService:service requestParams:requestParams];
    NSMutableURLRequest *request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                    URLString:urlString
                                                                                   parameters:totalRequestParams
                                                                    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                                        if ([data isKindOfClass:[NSData class]])
                                                                        {
                                                                            [formData appendPartWithFileData:data
                                                                                                        name:fileName
                                                                                                    fileName:fileName
                                                                                                    mimeType:mimeType];
                                                                        }
                                                                        else if ([data isKindOfClass:[NSArray class]])
                                                                        {
                                                                            [data enumerateObjectsUsingBlock:^(NSData *singleData, NSUInteger index, BOOL * _Nonnull stop) {
                                                                                [formData appendPartWithFileData:singleData
                                                                                                            name:fileName[index]
                                                                                                        fileName:fileName[index]
                                                                                                        mimeType:mimeType[index]];
                                                                            }];
                                                                        }
                                                                    } error:nil];
    
    if ([service.child respondsToSelector:@selector(extraHttpHeadParmasWithMethodName: requestParams:)])
    {
        NSDictionary *dict = [service.child extraHttpHeadParmasWithMethodName:methodName requestParams:requestParams];
        if (dict)
        {
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                //文件上传需要使用Content-Type为multipart/form-data，这里防止Service中修改Content-Type
                if (![key isEqualToString:kQLNetworkHTTPHeaderFieldContentType]) {
                    [request setValue:obj forHTTPHeaderField:key];
                }
            }];
        }
    }
    request.requestParams = totalRequestParams;
    return request;
}

#pragma mark - Private method

- (NSURLRequest *)generateRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName requestWithMethod:(NSString *)method
{
    // 超时
    self.httpRequestSerializer.timeoutInterval = [QLNetworkingConfigurationManager sharedInstance].apiNetworkingTimeoutSeconds;
    [[QLNetworkingConfigurationManager sharedInstance] resetTimeOutToDefault];
    
    QLService *service  = [[QLServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [service urlGeneratingRuleByMethodName:methodName];
    
    NSDictionary *totalRequestParams = [self totalRequestParamsByService:service requestParams:requestParams];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:method URLString:urlString parameters:totalRequestParams error:NULL];
    if ([service.child respondsToSelector:@selector(extraHttpHeadParmasWithMethodName: requestParams:)])
    {
        NSDictionary *dict = [service.child extraHttpHeadParmasWithMethodName:methodName requestParams:requestParams];
        if (dict)
        {
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [request setValue:obj forHTTPHeaderField:key];
            }];
        }
    }
    if (![method isEqualToString:@"GET"] && [QLNetworkingConfigurationManager sharedInstance].shouldSetParamsInHTTPBodyButGET)
    {
        NSString *requestString;
        NSString *contentType = [request.allHTTPHeaderFields objectForKey:kQLNetworkHTTPHeaderFieldContentType];
        if (contentType && [contentType isEqualToString:@"application/x-www-form-urlencoded"])
        {
            requestString = AFQueryStringFromParameters(totalRequestParams);
        }
        else
        {
            requestString = [NSString QL_dictToString:totalRequestParams];
        }
        if ([NSString QL_judgeStringValid:requestString])
        {
            request.HTTPBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    request.requestParams = totalRequestParams;
    return request;
}

// 根据Service拼接额外参数
- (NSDictionary *)totalRequestParamsByService:(QLService *)service requestParams:(NSDictionary *)requestParams
{
    if ([service.child respondsToSelector:@selector(extraHttpBodyParmasWithRequestParams:)])
    {
        NSDictionary *extraParamsDict = [service.child extraHttpBodyParmasWithRequestParams:requestParams];
        if (extraParamsDict)
        {
            return [extraParamsDict copy];
        }
    }
    NSMutableDictionary *totalRequestParams = [NSMutableDictionary dictionaryWithDictionary:requestParams];
    return [totalRequestParams copy];
}

@end
