//
//  AXRequestGenerator.h
//  RTNetworking
//
//  Created by Jccc on 2017-09-14.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//
/*** Request生成器 ***/

#import <Foundation/Foundation.h>

@interface QLRequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                            requestParams:(NSDictionary *)requestParams
                                               methodName:(NSString *)methodName;

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                             requestParams:(NSDictionary *)requestParams
                                                methodName:(NSString *)methodName;

- (NSURLRequest *)generatePutRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                            requestParams:(NSDictionary *)requestParams
                                               methodName:(NSString *)methodName;

- (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                               requestParams:(NSDictionary *)requestParams
                                                  methodName:(NSString *)methodName;

- (NSURLRequest *)generateUploadRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                               requestParams:(NSDictionary *)requestParams
                                                  methodName:(NSString *)methodName
                                                        data:(id)data
                                                    mimeType:(id)mimeType
                                                    fileName:(id)fileName;

@end
