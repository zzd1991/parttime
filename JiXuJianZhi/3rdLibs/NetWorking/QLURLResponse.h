//
//  AXURLResponse.h
//  RTNetworking
//
//  Created by Jccc on 2017-09-18.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLNetworkEnum.h"

@interface QLURLResponse : NSObject

@property (nonatomic, assign, readonly) QLURLResponseStatus status;
@property (nonatomic, copy, readonly)   NSString *contentString;
@property (nonatomic, copy, readonly)   id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly)   NSURLRequest *request;
@property (nonatomic, copy, readonly)   NSData *responseData;
@property (nonatomic, copy)             NSDictionary *requestParams;
@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                status:(QLURLResponseStatus)status;

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                 error:(NSError *)error;

// 使用initWithData的response，它的isCache是YES，上面两个函数生成的response的isCache是NO
- (instancetype)initWithData:(NSData *)data;

@end
