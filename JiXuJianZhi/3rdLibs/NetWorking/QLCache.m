//
//  QLCache.m
//  RTNetworking
//
//  Created by Jccc on 2017-09-26.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import "QLCache.h"
#import "NSDictionary+QLNetworkingMethods.h"
#import "QLNetworkingConfigurationManager.h"

@interface QLCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation QLCache

#pragma mark - Life cycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QLCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[QLCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public method

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key
{
    QLCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key
{
    QLCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[QLCachedObject alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

- (void)clean
{
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    return [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams QL_urlParamsStringSignature:NO]];
}

#pragma mark - getters

- (NSCache *)cache
{
    if (_cache == nil)
    {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = [QLNetworkingConfigurationManager sharedInstance].cacheCountLimit;
    }
    return _cache;
}

@end
