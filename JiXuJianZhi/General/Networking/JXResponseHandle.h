//
//  JXResponseHandle.h
//  XMSport
//
//  Created by John on 2019/1/25.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXResponseHandle : NSObject

#pragma mark - 校验数据
+ (BOOL)processRespDictCodeZero:(NSDictionary *)respDict;

#pragma mark - 错误处理
+ (NSString *)netWorkErrorMsg:(NSDictionary *)dict andErrorType:(NSUInteger)errorType;

@end
