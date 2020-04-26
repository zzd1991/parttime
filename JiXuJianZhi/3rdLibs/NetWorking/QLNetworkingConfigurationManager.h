//
//  QLNetworkingConfigurationManager.h
//  QLNetworking
//
//  Created by Corotata on 2017/4/10.
//  Copyright © 2017年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLNetworkingConfigurationManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign, readonly) BOOL isReachable;

@property (nonatomic, assign) BOOL shouldCache;
@property (nonatomic, assign) BOOL serviceIsOnline;
@property (nonatomic, assign) NSTimeInterval apiNetworkingTimeoutSeconds;
@property (nonatomic, assign) NSTimeInterval cacheOutdateTimeSeconds;
@property (nonatomic, assign) NSInteger cacheCountLimit;

//默认值为NO，当值为YES时，HTTP请求除了GET请求，其他的请求都会将参数放到HTTPBody中，如下所示
//request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
@property (nonatomic, assign) BOOL shouldSetParamsInHTTPBodyButGET;

- (void)resetTimeOutToDefault;

@end
