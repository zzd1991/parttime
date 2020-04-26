//
//  AXApiProxy.h
//  RTNetworking
//
//  Created by Jccc on 2017-09-12.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLURLResponse.h"

typedef void(^AXCallback)(QLURLResponse *response);

@interface QLApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;

- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;

- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;

- (NSInteger)callUPLOADWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName data:(id)data mimeType:(id)mimeType fileName:(id)fileName success:(AXCallback)success fail:(AXCallback)fail;

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(AXCallback)success fail:(AXCallback)fail;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
