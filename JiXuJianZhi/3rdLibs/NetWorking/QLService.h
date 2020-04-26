//
//  AXService.h
//  RTNetworking
//
//  Created by Jccc on 2017-09-15.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLURLResponse.h"

// 所有QLService的派生类都要符合这个protocol
@protocol QLServiceProtocol <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, readonly) NSString *offlineApiVersion;
@property (nonatomic, readonly) NSString *onlineApiVersion;

@property (nonatomic, readonly) NSString *onlinePublicKey;
@property (nonatomic, readonly) NSString *offlinePublicKey;

@property (nonatomic, readonly) NSString *onlinePrivateKey;
@property (nonatomic, readonly) NSString *offlinePrivateKey;

@optional

// 为某些Service需要拼凑额外字段到URL处，参数会放入HttpBody里面，入参（requestParams）可能会参与签名
- (NSDictionary *)extraHttpBodyParmasWithRequestParams:(NSDictionary *)requestParams;

// 为某些Service需要拼凑额外的HTTP Header
- (NSDictionary *)extraHttpHeadParmasWithMethodName:(NSString *)method requestParams:(NSDictionary *)requestParams;

- (NSString *)urlGeneratingRuleByMethodName:(NSString *)method;

// 提供拦截器集中处理Service错误问题，比如token失效要抛通知等
- (BOOL)shouldCallBackByFailedOnCallingAPI:(QLURLResponse *)response;

@end

@interface QLService : NSObject

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
@property (nonatomic, strong, readonly) NSString *apiVersion;
@property (nonatomic, strong, readonly) NSString *publicKey;
@property (nonatomic, strong, readonly) NSString *privateKey;

@property (nonatomic, weak, readonly) id<QLServiceProtocol> child;

/* 
 * 因为考虑到每家公司的拼凑逻辑都有或多或少不同，
 * 如有的公司为http://abc.com/v2/api/login或者http://v2.abc.com/api/login
 * 所以将默认的方式，有versioin时，则为http://abc.com/v2/api/login
 * 否则，则为http://abc.com/v2/api/login
*/
- (NSString *)urlGeneratingRuleByMethodName:(NSString *)method;

@end
