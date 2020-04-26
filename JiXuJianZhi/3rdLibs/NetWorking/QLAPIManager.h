//
//  QLAPIManager.h
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/19.
//  Copyright © 2017年 yuntu. All rights reserved.
//
/*
 QLAPIBaseManager的派生类必须符合这些protocal
 */

#import <Foundation/Foundation.h>
#import "QLNetworkEnum.h"

@protocol QLAPIManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (QLAPIManagerRequestType)requestType;
- (BOOL)shouldCache;

// used for pagable API Managers mainly
@optional
- (NSInteger)timeOutSecond;
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;
- (BOOL)shouldLoadFromNative;

//图片上传的ApiManager中需要指定mineType 和 fileName
- (id)requestMimeType;
- (id)fileName;
@end
