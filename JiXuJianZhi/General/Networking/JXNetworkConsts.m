//
//  XMNetworkConsts.m
//  XMSport
//
//  Created by John on 2019/1/25.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import "JXNetworkConsts.h"

NSString *const kJXBasicServiceKey = @"XMBasicServiceKey";

NSString *const kDJJCodeUserTokenInvalid = @"700";

// Base Url.
/**
 * 测试环境: 0
 * 正式环境: 1
 * 预发环境: 2
 */
#if DEBUG_SERVICE == 0
NSString *const kJXBaseServerUrl = @"http://mock-api.com/onwXMjKN.mock";
//NSString *const kJXSubVersionUrl = @"v3";


#elif DEBUG_SERVICE == 1
NSString *const kJXBaseServerUrl = @"http://mock-api.com/onwXMjKN.mock";
//NSString *const kJXSubVersionUrl = @"v3";


#endif

// App key.
#if DEBUG_SERVICE == 0
BOOL const kDJJServiceIsOnline       = NO;
#else
BOOL const kDJJServiceIsOnline       = YES;
#endif

//NSString *const kDJJNetworkingParamsKey = @"params";
NSString *const kDJJNetworkingParamsKey = @"";
