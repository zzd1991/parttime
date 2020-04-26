//
//  NSString+QLNetworkingMethods.h
//  QLNetworking
//
//  Created by Zhong Junchi on 2017/9/20.
//  Copyright © 2017年 yuntu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QLNetworkingMethods)

- (NSString *)QL_md5;

+ (NSString *)QL_dictToString:(NSDictionary *)parameters;

+ (NSData *)QL_toJSONData:(id)theData;

+ (BOOL)QL_judgeStringValid:(NSString *)string;

@end
