//
//  AXServiceFactory.m
//  RTNetworking
//
//  Created by Jccc on 2017-09-12.
//  Copyright (c) 2017年 Yuntu inc. All rights reserved.
//

#import "QLServiceFactory.h"
#import "QLService.h"

@interface QLServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation QLServiceFactory

#pragma mark - Life cycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QLServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[QLServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

//多线程环境可能会引起崩溃，对dataSource加个同步锁
- (QLService<QLServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    @synchronized (self.dataSource) {

        NSAssert(self.dataSource, @"必须提供dataSource绑定并实现servicesKindsOfServiceFactory方法，否则无法正常使用Service模块");
        
        if (self.serviceStorage[identifier] == nil)
        {
            self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
        }
        
        return self.serviceStorage[identifier];
    }
}

#pragma mark - private methods

- (QLService<QLServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    NSAssert([self.dataSource respondsToSelector:@selector(servicesKindsOfServiceFactory)], @"请实现QLServiceFactoryDataSource的servicesKindsOfServiceFactory方法");
    
    if ([[self.dataSource servicesKindsOfServiceFactory]valueForKey:identifier])
    {
        NSString *classStr = [[self.dataSource servicesKindsOfServiceFactory]valueForKey:identifier];
        id service = [[NSClassFromString(classStr) alloc]init];
        NSAssert(service, [NSString stringWithFormat:@"无法创建service，请检查servicesKindsOfServiceFactory提供的数据是否正确"],service);
        NSAssert([service conformsToProtocol:@protocol(QLServiceProtocol)], @"你提供的Service没有遵循QLServiceProtocol");
        return service;
    }
    else
    {
        NSAssert(NO, @"servicesKindsOfServiceFactory中无法找不到相匹配identifier");
    }
    
    return nil;
}

#pragma mark - getters

- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil)
    {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

@end
