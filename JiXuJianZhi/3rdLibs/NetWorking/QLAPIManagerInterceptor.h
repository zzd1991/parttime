//
//  QLAPIManagerInterceptor.h
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/19.
//  Copyright © 2017年 yuntu. All rights reserved.
//
/*
 QLAPIBaseManager的派生类必须符合这些protocal
 */

#import <Foundation/Foundation.h>

@class QLAPIBaseManager;
@protocol QLAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(QLAPIBaseManager *)manager beforePerformSuccessWithResponse:(QLURLResponse *)response;
- (void)manager:(QLAPIBaseManager *)manager afterPerformSuccessWithResponse:(QLURLResponse *)response;

- (BOOL)manager:(QLAPIBaseManager *)manager beforePerformFailWithResponse:(QLURLResponse *)response;
- (void)manager:(QLAPIBaseManager *)manager afterPerformFailWithResponse:(QLURLResponse *)response;

- (BOOL)manager:(QLAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(QLAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end
