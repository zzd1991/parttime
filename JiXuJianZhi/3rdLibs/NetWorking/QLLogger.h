//
//  AXLogger.h
//  RTNetworking
//
//  Created by Jccc on 2017-09-6.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLService.h"
#import "QLLoggerConfiguration.h"
#import "QLURLResponse.h"

@interface QLLogger : NSObject

@property (nonatomic, strong, readonly) QLLoggerConfiguration *configParams;

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                        service:(QLService *)service
                  requestParams:(id)requestParams
                     httpMethod:(NSString *)httpMethod;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                  responseString:(NSString *)responseString
                         request:(NSURLRequest *)request
                           error:(NSError *)error;

+ (void)logDebugInfoWithCachedResponse:(QLURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(QLService *)service;

+ (instancetype)sharedInstance;
- (void)logWithActionCode:(NSString *)actionCode params:(NSDictionary *)params;

@end
