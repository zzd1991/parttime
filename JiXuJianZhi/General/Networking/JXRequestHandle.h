//
//  JXRequestHandle.h
//  XMSport
//
//  Created by John on 2019/1/25.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXRequestHandle : NSObject

#pragma mark - header基础参数
+ (NSDictionary *)basicParamsBody:(NSDictionary *)requestParams;

@end
