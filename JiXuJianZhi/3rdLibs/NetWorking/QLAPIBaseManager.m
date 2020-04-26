//
//  AJKBaseManager.m
//  Jccc
//
//  Created by Jccc on 13-12-2.
//  Copyright (c) 2013年 Yuntu inc. All rights reserved.
//

#import "QLAPIBaseManager.h"
#import "QLNetworking.h"
#import "QLCache.h"
#import "QLLogger.h"
#import <AFNetworking/AFNetworking.h>


#define AXCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
    __weak typeof(self) weakSelf = self;                                                        \
        REQUEST_ID = [[QLApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(QLURLResponse *response) {                                         \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf successedOnCallingAPI:response];                                            \
    } fail:^(QLURLResponse *response) {                                                         \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf failedOnCallingAPI:response withErrorType:QLAPIManagerErrorTypeDefault];    \
    }];                                                                                         \
    [self.requestIdList addObject:@(REQUEST_ID)];                                                   \
}

@interface QLAPIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) QLAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) QLCache *cache;

@end

@implementation QLAPIBaseManager

#pragma mark - Life cycle

- (instancetype)init
{
    if (self = [super init])
    {
        _delegate       = nil;
        _validator      = nil;
        _paramSource    = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage   = nil;
        _errorType = QLAPIManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(QLAPIManager)])
        {
            self.child = (id <QLAPIManager>)self;
        }
        else
        {
            self.child = (id <QLAPIManager>)self;
            NSException *exception = [[NSException alloc] initWithName:@"QLAPIBaseManager提示" reason:[NSString stringWithFormat:@"%@没有遵循QLAPIManager协议",self.child] userInfo:nil];
            @throw exception;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - Public methods

- (void)cancelAllRequests
{
    [[QLApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[QLApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(id<QLAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)])
    {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    }
    else
    {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

- (id)fetchFailedRequstMsg:(id<QLAPIManagerDataReformer>)reformer {
    
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:failedReform:)])
    {
        resultData = [reformer manager:self failedReform:self.fetchedRawData];
    }
    else
    {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

#pragma mark - calling api

- (NSInteger)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId  = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    
    if ([self shouldCallAPIWithParams:apiParams])
    {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams])
        {
            if ([self.child shouldLoadFromNative])
            {
                [self loadDataFromNative];
            }
            
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams])
            {
                return 0;
            }
            
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
            // 实际的网络请求
            if ([self isReachable])
            {
                self.isLoading = YES;
                
                if ([self.child respondsToSelector:@selector(timeOutSecond)])
                {
                    [QLNetworkingConfigurationManager sharedInstance].apiNetworkingTimeoutSeconds = self.child.timeOutSecond;
                }
                
                switch (self.child.requestType)
                {
                    case QLAPIManagerRequestTypeGet:
                        AXCallAPI(GET, requestId);
                        break;
                    case QLAPIManagerRequestTypePost:
                        AXCallAPI(POST, requestId);
                        break;
                    case QLAPIManagerRequestTypePut:
                        AXCallAPI(PUT, requestId);
                        break;
                    case QLAPIManagerRequestTypeDelete:
                        AXCallAPI(DELETE, requestId);
                        break;
                    case QLAPIManagerRequestTypeUpload:
                        requestId = [self callUploadAPI:apiParams requestId:requestId];
                        break;
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kQLAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
            }
            else
            {
                [self failedOnCallingAPI:nil withErrorType:QLAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        }
        else
        {
            [self failedOnCallingAPI:nil withErrorType:QLAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

- (NSInteger)callUploadAPI:(NSDictionary *)apiParams requestId:(NSInteger)requestId {
    if (![self valideUploadParams]) {
        [self failedOnCallingAPI:nil withErrorType:QLAPIManagerErrorTypeParamsError];
        return requestId;
    }
    __weak typeof(self) weakSelf = self;
    requestId = [[QLApiProxy sharedInstance] callUPLOADWithParams:apiParams
                                                serviceIdentifier:self.child.serviceType
                                                       methodName:self.child.methodName
                                                             data:[self.paramSource dataForUploadApi:self]
                                                         mimeType:[self.child requestMimeType]
                                                         fileName:[self.child fileName]
                                                          success:^(QLURLResponse *response) {
                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                                              [strongSelf successedOnCallingAPI:response];
                                                          } fail:^(QLURLResponse *response) {
                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                                              [strongSelf failedOnCallingAPI:response withErrorType:QLAPIManagerErrorTypeDefault];
                                                          }];
    [self.requestIdList addObject:@(requestId)];
    return requestId;
}

/**
 检验文件上传的额外参数
 需要在validator的isCorrectWithParamsData中进行校验返回具体缺失的参数
 此处只检验是否存在，返回参数错误

 @return 上传参数是否完整
 */
- (BOOL)valideUploadParams {
    id fileData = nil;
    if ([self.paramSource respondsToSelector:@selector(dataForUploadApi:)]) {
        fileData = [self.paramSource dataForUploadApi:self];
    }
    NSString *mimeType = nil;
    if ([self.child respondsToSelector:@selector(requestMimeType)]) {
        mimeType = [self.child requestMimeType];
    }
    NSString *fileName = nil;
    if ([self.child respondsToSelector:@selector(fileName)]) {
        fileName = [self.child fileName];
    }
    if (fileData && mimeType && fileName) {
        return YES;
    }
    return NO;
}

#pragma mark - api callbacks

- (void)successedOnCallingAPI:(QLURLResponse *)response
{
    self.isLoading = NO;
    self.response  = response;
    
    if ([self.child shouldLoadFromNative])
    {
        if (response.isCache == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:[self.child methodName]];
        }
    }
    
    if (response.content)
    {
        self.fetchedRawData = [response.content copy];
    }
    else
    {
        self.fetchedRawData = [response.responseData copy];
    }
    
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content])
    {
        if ([self shouldCache] && !response.isCache)
        {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }
        
        if ([self beforePerformSuccessWithResponse:response])
        {
            if ([self.child shouldLoadFromNative])
            {
                if (response.isCache == YES)
                {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.isNativeDataEmpty)
                {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
            }
            else
            {
                [self.delegate managerCallAPIDidSuccess:self];
            }
        }
        [self afterPerformSuccessWithResponse:response];
    }
    else
    {
        [self failedOnCallingAPI:response withErrorType:QLAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(QLURLResponse *)response withErrorType:(QLAPIManagerErrorType)errorType
{
    NSString *serviceIdentifier = self.child.serviceType;
    QLService *service = [[QLServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    self.isLoading = NO;
    self.response = response;
    BOOL needCallBack = YES;
    
    if ([service.child respondsToSelector:@selector(shouldCallBackByFailedOnCallingAPI:)]) {
        needCallBack = [service.child shouldCallBackByFailedOnCallingAPI:response];
    }
    
    //由service决定是否结束回调
    if (!needCallBack) {
        return;
    }
    
    //继续错误的处理
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    
    if (response.content)
    {
        self.fetchedRawData = [response.content copy];
    }
    else
    {
        self.fetchedRawData = [response.responseData copy];
    }
    
    if ([self beforePerformFailWithResponse:response]) {
        [self.delegate managerCallAPIDidFailed:self];
    }
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor

/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 */
- (BOOL)beforePerformSuccessWithResponse:(QLURLResponse *)response
{
    BOOL result = YES;
    
    self.errorType = QLAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)])
    {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(QLURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)])
    {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(QLURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)])
    {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(QLURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)])
    {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)])
    {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    }
    else
    {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)])
    {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - method for child

- (void)cleanData
{
    [self.cache clean];
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = QLAPIManagerErrorTypeDefault;
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP)
    {
        return params;
    }
    else
    {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (BOOL)shouldCache
{
    return [QLNetworkingConfigurationManager sharedInstance].shouldCache;
}

#pragma mark - private methods

- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList)
    {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove)
    {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) return NO;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        QLURLResponse *response = [[QLURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [QLLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[QLServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
        [strongSelf successedOnCallingAPI:response];
    });
    return YES;
}

- (void)loadDataFromNative
{
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:self.child.methodName] options:0 error:NULL];

    if (result)
    {
        self.isNativeDataEmpty = NO;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            QLURLResponse *response = [[QLURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:NULL]];
            [strongSelf successedOnCallingAPI:response];
        });
    }
    else
    {
        self.isNativeDataEmpty = YES;
    }
}

#pragma mark - getters and setters

- (QLCache *)cache
{
    if (_cache == nil) {
        _cache = [QLCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [QLNetworkingConfigurationManager sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = QLAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (BOOL)shouldLoadFromNative
{
    return NO;
}

@end
