//
//  AXURLResponse.m
//  RTNetworking
//
//  Created by Jccc on 2017-09-18.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import "QLURLResponse.h"
#import "NSObject+QLNetworkingMethods.h"
#import "NSURLRequest+QLNetworkingMethods.h"

@interface QLURLResponse ()

@property (nonatomic, assign, readwrite)    QLURLResponseStatus status;
@property (nonatomic, copy, readwrite)      NSString *contentString;
@property (nonatomic, copy, readwrite)      id content;
@property (nonatomic, copy, readwrite)      NSURLRequest *request;
@property (nonatomic, assign, readwrite)    NSInteger requestId;
@property (nonatomic, copy, readwrite)      NSData *responseData;
@property (nonatomic, assign, readwrite)    BOOL isCache;
@property (nonatomic, strong, readwrite)    NSError *error;

@end

@implementation QLURLResponse

#pragma mark - Life cycle

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(QLURLResponseStatus)status
{
    if (self = [super init])
    {
        self.contentString  = responseString;
        self.content        = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.status         = status;
        self.requestId      = [requestId integerValue];
        self.request        = request;
        self.responseData   = responseData;
        self.requestParams  = request.requestParams;
        self.isCache        = NO;
        self.error          = nil;
    }
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{
    if (self = [super init])
    {
        self.contentString  = [responseString QL_defaultValue:@""];
        self.status         = [self responseStatusWithError:error];
        self.requestId      = [requestId integerValue];
        self.request        = request;
        self.responseData   = responseData;
        self.requestParams  = request.requestParams;
        self.isCache        = NO;
        self.error          = error;
        if (responseData)
        {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }
        else
        {
            self.content = nil;
        }
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        self.contentString  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status         = [self responseStatusWithError:nil];
        self.requestId      = 0;
        self.request        = nil;
        self.responseData   = [data copy];
        self.content        = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache        = YES;
    }
    return self;
}

#pragma mark - Private methods

- (QLURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error)
    {
        QLURLResponseStatus result = QLURLResponseStatusErrorNoNetwork;
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = QLURLResponseStatusErrorTimeout;
        }
        return result;
    }
    else
    {
        return QLURLResponseStatusSuccess;
    }
}

@end
