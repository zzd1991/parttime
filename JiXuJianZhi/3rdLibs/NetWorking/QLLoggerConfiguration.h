//
//  QLLogConfig.h
//  QLLogTrackCenter
//
//  Created by Softwind.Tang on 2017-09-15.
//  Copyright (c) 2014年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLLoggerConfiguration : NSObject

/** 渠道ID */
@property (nonatomic, strong) NSString *channelID;

/** app标志 */
@property (nonatomic, strong) NSString *appKey;

/** app名字 */
@property (nonatomic, strong) NSString *logAppName;

/** 服务名 */
@property (nonatomic, assign) NSString *serviceType;

/** 记录log用到的webapi方法名 */
@property (nonatomic, strong) NSString *sendLogMethod;

/** 记录action用到的webapi方法名 */
@property (nonatomic, strong) NSString *sendActionMethod;

/** 发送log时使用的key */
@property (nonatomic, strong) NSString *sendLogKey;

/** 发送Action记录时使用的key */
@property (nonatomic, strong) NSString *sendActionKey;

//- (void)configWithAppType:(QLAppType)appType;

@end
