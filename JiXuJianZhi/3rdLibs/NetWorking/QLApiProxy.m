//
//  AXApiProxy.m
//  RTNetworking
//
//  Created by Jccc on 2017-09-12.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "QLApiProxy.h"
#import "QLServiceFactory.h"
#import "QLRequestGenerator.h"
#import "QLLogger.h"
#import "NSURLRequest+QLNetworkingMethods.h"

static NSString * const kAXApiProxyDispatchItemKeyCallbackSuccess   = @"kAXApiProxyDispatchItemCallbackSuccess";
static NSString * const kAXApiProxyDispatchItemKeyCallbackFail      = @"kAXApiProxyDispatchItemCallbackFail";

@interface QLApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

//AFNetworking stuff
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation QLApiProxy

#pragma mark - Life cycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QLApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[QLApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public methods

// GET
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest *request = [[QLRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

// POST
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest *request = [[QLRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

// PUT
- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest *request = [[QLRequestGenerator sharedInstance] generatePutRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

// DELETE
- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest *request = [[QLRequestGenerator sharedInstance] generateDeleteRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

// UPLOAD
- (NSInteger)callUPLOADWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName data:(id)data mimeType:(id)mimeType fileName:(id)fileName success:(AXCallback)success fail:(AXCallback)fail {
    NSURLRequest *request = [[QLRequestGenerator sharedInstance] generateUploadRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName data:data mimeType:mimeType fileName:fileName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList)
    {
        [self cancelRequestWithRequestID:requestId];
    }
}

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(AXCallback)success fail:(AXCallback)fail
{
    QLDebugLog(@"\n==================================\n\nRequest Start: \n\n %@\n\n==================================", request.URL);
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error)
        {
            [QLLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:request
                                         error:error];
            QLURLResponse *QLResponse = [[QLURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
            fail?fail(QLResponse):nil;
        }
        else
        {
            // 检查http response是否成立。
            [QLLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:request
                                         error:NULL];
            QLURLResponse *QLResponse = [[QLURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:QLURLResponseStatusSuccess];
            success?success(QLResponse):nil;
        }
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

#pragma mark - getters

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

@end
